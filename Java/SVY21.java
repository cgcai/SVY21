public class SVY21 {
	// Ref: http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx

	private final static double radRatio = Math.PI / 180;

	// Datum and Projection
	final double a		= 6378137;
	final double f		= 1 / 298.257223563;
	final double oLat	= 1.367476;				// degrees
	final double oLon	= 103.825549;			// degrees
	final double No		= 38744.572;
	final double Eo		= 28001.642;
	final double k		= 1;

	// Projection Constants
	double b;
	double e2, e4, e6;	
	double A0, A2, A4, A6;

	public SVY21() {
		b = a * (1 - f);

		e2 = (2 * f) - (f * f);
		e4 = e2 * e2;
		e6 = e4 * e2;

		A0 = 1 - (e2 / 4) - (3 * e4 / 64) - (5 * e6 / 256);
		A2 = (3. / 8.) * (e2 + (e4 / 4) + (15 * e6 / 128));
		A4 = (15. / 256.) * (e4 + (3 * e6 / 4));
		A6 = 35 * e6 / 3072;
	}

	public Pair<Double, Double> computeSVY21(double lat, double lon) {
		double latR = lat * radRatio;
		double sinLat = Math.sin(latR);
		double sin2Lat = sinLat * sinLat;
		double cosLat = Math.cos(latR);
		double cos2Lat = cosLat * cosLat;
		double cos3Lat = cos2Lat * cosLat;
		double cos4Lat = cos3Lat * cosLat;
		double cos5Lat = cos3Lat * cos2Lat;
		double cos6Lat = cos5Lat * cosLat;
		double cos7Lat = cos5Lat * cos2Lat;

		double rho = calcRho(sin2Lat);
		double v = calcV(sin2Lat);
		double psi = v / rho;
		double t = Math.tan(latR);
		double w = (lon - oLon) * radRatio;

		double M = calcM(lat);
		double Mo = calcM(oLat);

		double w2 = w * w;
		double w4 = w2 * w2;
		double w6 = w4 * w2;
		double w8 = w6 * w2;

		double psi2 = psi * psi;
		double psi3 = psi2 * psi;
		double psi4 = psi2 * psi2;

		double t2 = t * t;
		double t4 = t2 * t2;
		double t6 = t4 * t2;

		// Compute Northing.
		double nTerm1 = w2 / 2 * v * sinLat * cosLat;
		double nTerm2 = w4 / 24 * v * sinLat * cos3Lat * (4 * psi2 + psi - t2);
		double nTerm3 = w6 / 720 * v * sinLat * cos5Lat * ((8 * psi4) * (11 - 24 * t2) - (28 * psi3) * (1 - 6 * t2) + psi2 * (1 - 32 * t2) - psi * 2 * t2 + t4);
		double nTerm4 = w8 / 40320 * v * sinLat * cos7Lat * (1385 - 3111 * t2 + 543 * t4 - t6);
		double N = No + k * (M - Mo + nTerm1 + nTerm2 + nTerm3 + nTerm4);

		// Compute Easting.
		double eTerm1 = w2 / 6 * cos2Lat * (psi - t2);
		double eTerm2 = w4 / 120 * cos4Lat * ((4 * psi3) * (1 - 6 * t2) + psi2 * (1 + 8 * t2) - psi * 2 * t2 + t4);
		double eTerm3 = w6 / 5040 * cos6Lat * (61 - 479 * t2 + 179 * t4 - t6);
		double E = Eo + k * v * w * cosLat * (1 + eTerm1 + eTerm2 + eTerm3);

		return new Pair<Double, Double>(N, E);
	}

	private double calcM(double lat) {
		double latR = lat * radRatio;
		double m = a * ((A0 * latR) - (A2 * Math.sin(2 * latR)) + (A4 * Math.sin(4 * latR)) - (A6 * Math.sin(6 * latR)));
		return m;
	}

	private double calcRho(double sin2Lat) {
		double num = a * (1 - e2);
		double denom = Math.pow(1 - e2 * sin2Lat, 3. / 2.);
		double rho = num / denom;
		return rho;
	}

	private double calcV(double sin2Lat) {
		double poly = 1 - e2 * sin2Lat;
		double v = a / Math.sqrt(poly);
		return v;
	}

	public Pair<Double, Double> computeLatLon(double N, double E) {
		double Nprime = N - No;
		double Mo = calcM(oLat);
		double Mprime = Mo + (Nprime / k);
		double n = (a - b) / (a + b);
		double n2 = n * n;
		double n3 = n2 * n;
		double n4 = n2 * n2;
		double G = a * (1 - n) * (1 - n2) * (1 + (9 * n2 / 4) + (225 * n4 / 64)) * radRatio;
		double sigma = (Mprime / G) * radRatio;

		double latPrimeT1 = ((3 * n / 2) - (27 * n3 / 32)) * Math.sin(2 * sigma);
		double latPrimeT2 = ((21 * n2 / 16) - (55 * n4 / 32)) * Math.sin(4 * sigma);
		double latPrimeT3 = (151 * n3 / 96) * Math.sin(6 * sigma);
		double latPrimeT4 = (1097 * n4 / 512) * Math.sin(8 * sigma);
		double latPrime = sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4;

		double sinLatPrime = Math.sin(latPrime);
		double sin2LatPrime = sinLatPrime * sinLatPrime;

		double rhoPrime = calcRho(sin2LatPrime);
		double vPrime = calcV(sin2LatPrime);
		double psiPrime = vPrime / rhoPrime;
		double psiPrime2 = psiPrime * psiPrime;
		double psiPrime3 = psiPrime2 * psiPrime;
		double psiPrime4 = psiPrime3 * psiPrime;
		double tPrime = Math.tan(latPrime);
		double tPrime2 = tPrime * tPrime;
		double tPrime4 = tPrime2 * tPrime2;
		double tPrime6 = tPrime4 * tPrime2;
		double Eprime = E - Eo;
		double x = Eprime / (k * vPrime);
		double x2 = x * x;
		double x3 = x2 * x;
		double x5 = x3 * x2;
		double x7 = x5 * x2;

		// Compute Latitude
		double latFactor = tPrime / (k * rhoPrime);
		double latTerm1 = latFactor * ((Eprime * x) / 2);
		double latTerm2 = latFactor * ((Eprime * x3) / 24) * ((-4 * psiPrime2) + (9 * psiPrime) * (1 - tPrime2) + (12 * tPrime2));
		double latTerm3 = latFactor * ((Eprime * x5) / 720) * ((8 * psiPrime4) * (11 - 24 * tPrime2) - (12 * psiPrime3) * (21 - 71 * tPrime2) + (15 * psiPrime2) * (15 - 98 * tPrime2 + 15 * tPrime4) + (180 * psiPrime) * (5 * tPrime2 - 3 * tPrime4) + 360 * tPrime4);
		double latTerm4 = latFactor * ((Eprime * x7) / 40320) * (1385 - 3633 * tPrime2 + 4095 * tPrime4 + 1575 * tPrime6);
		double lat = latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4;

		// Compute Longitude
		double secLatPrime = 1. / Math.cos(lat);
		double lonTerm1 = x * secLatPrime;
		double lonTerm2 = ((x3 * secLatPrime) / 6) * (psiPrime + 2 * tPrime2);
		double lonTerm3 = ((x5 * secLatPrime) / 120) * ((-4 * psiPrime3) * (1 - 6 * tPrime2) + psiPrime2 * (9 - 68 * tPrime2) + 72 * psiPrime * tPrime2 + 24 * tPrime4);
		double lonTerm4 = ((x7 * secLatPrime) / 5040) * (61 + 662 * tPrime2 + 1320 * tPrime4 + 720 * tPrime6);
		double lon = (oLon * radRatio) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4;

		return new Pair<Double, Double>(lat / radRatio, lon / radRatio);
	}
}
