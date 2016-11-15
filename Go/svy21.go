package svy21

import "math"

// Ref: http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx

// WGS84 Datum
const (
	a = 6378137
	f = 1 / 298.257223563
)

// SVY21 Projection
// Fundamental point: Base 7 at Pierce Reservoir.
// Latitude: 1 22 02.9154 N, longitude: 103 49 31.9752 E (of Greenwich).
//
// Known Issue: Setting (oLat, oLon) to the exact coordinates specified above
// results in computation being slightly off. The values below give the most
// accurate representation of test data.
const (
	oLat = 1.366666   // origin's lat in degrees
	oLon = 103.833333 // origin's lon in degrees
	oN   = 38744.572  // false northing
	oE   = 28001.642  // false easting
	k    = 1.         // scale factor
)

var (
	b  = a * (1 - f)
	e2 = (2 * f) - (f * f)
	e4 = e2 * e2
	e6 = e4 * e2
	A0 = 1 - (e2 / 4.) - (3 * e4 / 64.) - (5 * e6 / 256.)
	A2 = (3 / 8.) * (e2 + (e4 / 4.) + (15 * e6 / 128.))
	A4 = (15 / 256.) * (e4 + (3 * e6 / 4.))
	A6 = 35 * e6 / 3072.
)

// Helper methods
func calcRho(sin2Lat float64) float64 {
	num := a * (1 - e2)
	denom := math.Pow(1-e2*sin2Lat, 1.5)
	return num / denom
}

func calcV(sin2Lat float64) float64 {
	poly := 1 - e2*sin2Lat
	return a / math.Sqrt(poly)
}

func calcM(lat float64) float64 {
	latR := lat * math.Pi / 180.
	return a * ((A0 * latR) - (A2 * math.Sin(2*latR)) + (A4 * math.Sin(4*latR)) - (A6 * math.Sin(6*latR)))
}

// Converts latitude and longitude to SVY21 northings and eastings
func ToSVY21(lat, lon float64) (N, E float64) {

	latR := lat * math.Pi / 180.
	sinLat := math.Sin(latR)
	sin2Lat := sinLat * sinLat
	cosLat := math.Cos(latR)
	cos2Lat := cosLat * cosLat
	cos3Lat := cos2Lat * cosLat
	cos4Lat := cos3Lat * cosLat
	cos5Lat := cos4Lat * cosLat
	cos6Lat := cos5Lat * cosLat
	cos7Lat := cos6Lat * cosLat

	rho := calcRho(sin2Lat)
	v := calcV(sin2Lat)
	psi := v / rho
	t := math.Tan(latR)
	w := (lon - oLon) * math.Pi / 180.

	M := calcM(lat)
	Mo := calcM(oLat)

	w2 := w * w
	w4 := w2 * w2
	w6 := w4 * w2
	w8 := w6 * w2

	psi2 := psi * psi
	psi3 := psi2 * psi
	psi4 := psi3 * psi

	t2 := t * t
	t4 := t2 * t2
	t6 := t4 * t2

	// Compute northings
	nTerm1 := w2 / 2. * v * sinLat * cosLat
	nTerm2 := w4 / 24. * v * sinLat * cos3Lat * (4*psi2 + psi - t2)
	nTerm3 := w6 / 720. * v * sinLat * cos5Lat * ((8*psi4)*(11-24*t2) - (28*psi3)*(1-6*t2) + psi2*(1-32*t2) - psi*2*t2 + t4)
	nTerm4 := w8 / 40320. * v * sinLat * cos7Lat * (1385 - 3111*t2 + 543*t4 - t6)
	N = oN + k*(M-Mo+nTerm1+nTerm2+nTerm3+nTerm4)

	// Compute eastings
	eTerm1 := w2 / 6. * cos2Lat * (psi - t2)
	eTerm2 := w4 / 120. * cos4Lat * ((4*psi3)*(1-6*t2) + psi2*(1+8*t2) - psi*2*t2 + t4)
	eTerm3 := w6 / 5040. * cos6Lat * (61 - 479*t2 + 179*t4 - t6)
	E = oE + k*v*w*cosLat*(1+eTerm1+eTerm2+eTerm3)

	return N, E
}

// Converts SVY21 northings and eastings to latitude and longitude
func ToLatLon(N, E float64) (lat, lon float64) {
	Nprime := N - oN;
	Mo := calcM(oLat);
	Mprime := Mo + (Nprime / k);
	n := (a - b) / (a + b);
	n2 := n * n;
	n3 := n2 * n;
	n4 := n2 * n2;
	G := a * (1 - n) * (1 - n2) * (1 + (9 * n2 / 4.) + (225 * n4 / 64.)) * (math.Pi / 180.);
	sigma := (Mprime * math.Pi) / (180 * G);

	latPrimeT1 := ((3 * n / 2.) - (27 * n3 / 32.)) * math.Sin(2 * sigma);
	latPrimeT2 := ((21 * n2 / 16.) - (55 * n4 / 32.)) * math.Sin(4 * sigma);
	latPrimeT3 := (151 * n3 / 96.) * math.Sin(6 * sigma);
	latPrimeT4 := (1097 * n4 / 512.) * math.Sin(8 * sigma);
	latPrime := sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4;

	sinLatPrime := math.Sin(latPrime);
	sin2LatPrime := sinLatPrime * sinLatPrime;

	rhoPrime := calcRho(sin2LatPrime);
	vPrime := calcV(sin2LatPrime);
	psiPrime := vPrime / rhoPrime;
	psiPrime2 := psiPrime * psiPrime;
	psiPrime3 := psiPrime2 * psiPrime;
	psiPrime4 := psiPrime3 * psiPrime;
	tPrime := math.Tan(latPrime);
	tPrime2 := tPrime * tPrime;
	tPrime4 := tPrime2 * tPrime2;
	tPrime6 := tPrime4 * tPrime2;
	Eprime := E - oE;
	x := Eprime / (k * vPrime);
	x2 := x * x;
	x3 := x2 * x;
	x5 := x3 * x2;
	x7 := x5 * x2;

	// Compute latitude
	latFactor := tPrime / (k * rhoPrime);
	latTerm1 := latFactor * ((Eprime * x) / 2.);
	latTerm2 := latFactor * ((Eprime * x3) / 24.) * ((-4 * psiPrime2) + (9 * psiPrime) * (1 - tPrime2) + (12 * tPrime2));
	latTerm3 := latFactor * ((Eprime * x5) / 720.) * ((8 * psiPrime4) * (11 - 24 * tPrime2) - (12 * psiPrime3) * (21 - 71 * tPrime2) + (15 * psiPrime2) * (15 - 98 * tPrime2 + 15 * tPrime4) + (180 * psiPrime) * (5 * tPrime2 - 3 * tPrime4) + 360 * tPrime4);
	latTerm4 := latFactor * ((Eprime * x7) / 40320.) * (1385 - 3633 * tPrime2 + 4095 * tPrime4 + 1575 * tPrime6);

	latRad := latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4;
	lat = latRad / (math.Pi / 180.);


	// Compute Longitude
	secLatPrime := 1.0 / math.Cos(latRad);
	lonTerm1 := x * secLatPrime;
	lonTerm2 := ((x3 * secLatPrime) / 6.) * (psiPrime + 2 * tPrime2);
	lonTerm3 := ((x5 * secLatPrime) / 120.) * ((-4 * psiPrime3) * (1 - 6 * tPrime2) + psiPrime2 * (9 - 68 * tPrime2) + 72 * psiPrime * tPrime2 + 24 * tPrime4);
	lonTerm4 := ((x7 * secLatPrime) / 5040.) * (61 + 662 * tPrime2 + 1320 * tPrime4 + 720 * tPrime6);

	lon = ((oLon * math.Pi / 180.) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4) / (math.Pi / 180.);

	return lat, lon
}
