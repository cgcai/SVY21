#include "svy21.h"
#include <math.h>

SVY21::SVY21(){
	// WGS84 Datum
	a = 6378137;
	f = 1.0 / 298.257223563;
	PI = atan(1.0)*4.0;

	// SVY21 Projection
	// Fundamental point: Base 7 at Pierce Resevoir.
	// Latitude: 1 22 02.9154 N, longitude: 103 49 31.9752 E (of Greenwich).

	// Known Issue: Setting (oLat, oLon) to the exact coordinates specified above
		// results in computation being slightly off. The values below give the most 
	// accurate represenation of test data.
	oLat = 1.366666;     // origin's lat in degrees
	oLon = 103.833333;   // origin's lon in degrees
	oN = 38744.572;      // false Northing
	oE = 28001.642;      // false Easting
	k = 1.0;				// scale factor

	//	Initialise
	b = a * (1.0 - f);
	e2 = (2.0 * f) - (f * f);
	e4 = e2 * e2;
	e6 = e4 * e2;
	A0 = 1.0 - (e2 / 4.0) - (3.0 * e4 / 64.0) - (5.0 * e6 / 256.0);
	A2 = (3.0 / 8.0) * (e2 + (e4 / 4.0) + (15.0 * e6 / 128.0));
	A4 = (15.0 / 256.0) * (e4 + (3.0 * e6 / 4.0));
	A6 = 35.0 * e6 / 3072.0;
}

//	Helper Methods
double SVY21::calcM(double lat){
	double latR = lat * PI / 180.0;
	return a * ((A0 * latR) - (A2 * sin(2 * latR)) + (A4 * sin(4 * latR)) - (A6 * sin(6 * latR)));
}
				
double SVY21::calcRho(double sin2Lat){
	double num = a * (1 - e2);
	double denom = pow(1 - e2 * sin2Lat, 3.0 / 2.0);
	return num / denom;
}

double SVY21::calcV(double sin2Lat){
	double poly = 1.0 - e2 * sin2Lat;
	return a / sqrt(poly);
}

//	LatLon to SVY21
void SVY21::latLonToSVY21(double lat, double lon, double *northing, double *easting){		
	//Returns a pair (N, E) representing Northings and Eastings in SVY21.

	double latR = lat * PI / 180;
	double sinLat = sin(latR);
	double sin2Lat = sinLat * sinLat;
	double cosLat = cos(latR);
	double cos2Lat = cosLat * cosLat;
	double cos3Lat = cos2Lat * cosLat;
	double cos4Lat = cos3Lat * cosLat;
	double cos5Lat = cos4Lat * cosLat;
	double cos6Lat = cos5Lat * cosLat;
	double cos7Lat = cos6Lat * cosLat;

	double rho = calcRho(sin2Lat);
	double v = calcV(sin2Lat);
	double psi = v / rho;
	double t = tan(latR);
	double w = (lon - oLon) * PI / 180.0;

	double M = calcM(lat);
	double Mo = calcM(oLat);

	double w2 = w * w;
	double w4 = w2 * w2;
	double w6 = w4 * w2;
	double w8 = w6 * w2;

	double psi2 = psi * psi;
	double psi3 = psi2 * psi;
	double psi4 = psi3 * psi;

	double t2 = t * t;
	double t4 = t2 * t2;
	double t6 = t4 * t2;

	//	Compute Northing
	double nTerm1 = w2 / 2.0 * v * sinLat * cosLat;
	double nTerm2 = w4 / 24.0 * v * sinLat * cos3Lat * (4.0 * psi2 + psi - t2);
	double nTerm3 = w6 / 720.0 * v * sinLat * cos5Lat * ((8.0 * psi4) * (11.0 - 24.0 * t2) - (28.0 * psi3) * (1.0 - 6.0 * t2) + psi2 * (1.0 - 32.0 * t2) - psi * 2.0 * t2 + t4);
	double nTerm4 = w8 / 40320.0 * v * sinLat * cos7Lat * (1385.0 - 3111.0 * t2 + 543.0 * t4 - t6);
	*northing = oN + k * (M - Mo + nTerm1 + nTerm2 + nTerm3 + nTerm4);

	//	Compute Easting
	double eTerm1 = w2 / 6.0 * cos2Lat * (psi - t2);
	double eTerm2 = w4 / 120.0 * cos4Lat * ((4.0 * psi3) * (1.0 - 6.0 * t2) + psi2 * (1.0 + 8.0 * t2) - psi * 2.0 * t2 + t4);
	double eTerm3 = w6 / 5040.0 * cos6Lat * (61.0 - 479.0 * t2 + 179.0 * t4 - t6);
	*easting = oE + k * v * w * cosLat * (1.0 + eTerm1 + eTerm2 + eTerm3);
}

//	SVY21 to LatLon
void SVY21::SVY21ToLatLon(double northing, double easting, double *lat, double *lon){
	//	Returns a pair (lat, lon) representing Latitude and Longitude.

	double Nprime = northing - oN;
	double Mo = calcM(oLat);
	double Mprime = Mo + (Nprime / k);
	double n = (a - b) / (a + b);
	double n2 = n * n;
	double n3 = n2 * n;
	double n4 = n2 * n2;
	double G = a * (1.0 - n) * (1.0 - n2) * (1.0 + (9.0 * n2 / 4.0) + (225.0 * n4 / 64.0)) * (PI / 180.0);
	double sigma = (Mprime * PI) / (180.0 * G);

	double latPrimeT1 = ((3.0 * n / 2.0) - (27.0 * n3 / 32.0)) * sin(2.0 * sigma);
	double latPrimeT2 = ((21.0 * n2 / 16.0) - (55.0 * n4 / 32.0)) * sin(4.0 * sigma);
	double latPrimeT3 = (151.0 * n3 / 96.0) * sin(6.0 * sigma);
	double latPrimeT4 = (1097.0 * n4 / 512.0) * sin(8.0 * sigma);
	double latPrime = sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4;

	double sinLatPrime = sin(latPrime);
	double sin2LatPrime = sinLatPrime * sinLatPrime;

	double rhoPrime = calcRho(sin2LatPrime);
	double vPrime = calcV(sin2LatPrime);
	double psiPrime = vPrime / rhoPrime;
	double psiPrime2 = psiPrime * psiPrime;
	double psiPrime3 = psiPrime2 * psiPrime;
	double psiPrime4 = psiPrime3 * psiPrime;
	double tPrime = tan(latPrime);
	double tPrime2 = tPrime * tPrime;
	double tPrime4 = tPrime2 * tPrime2;
	double tPrime6 = tPrime4 * tPrime2;
	double Eprime = easting - oE;
	double x = Eprime / (k * vPrime);
	double x2 = x * x;
	double x3 = x2 * x;
	double x5 = x3 * x2;
	double x7 = x5 * x2;

	// Compute Latitude
	double latFactor = tPrime / (k * rhoPrime);
	double latTerm1 = latFactor * ((Eprime * x) / 2.0);
	double latTerm2 = latFactor * ((Eprime * x3) / 24.0) * ((-4.0 * psiPrime2) + (9.0 * psiPrime) * (1.0 - tPrime2) + (12.0 * tPrime2));
	double latTerm3 = latFactor * ((Eprime * x5) / 720.0) * ((8.0 * psiPrime4) * (11.0 - 24.0 * tPrime2) - (12.0 * psiPrime3) * (21.0 - 71.0 * tPrime2) + (15.0 * psiPrime2) * (15.0 - 98.0 * tPrime2 + 15.0 * tPrime4) + (180.0 * psiPrime) * (5.0 * tPrime2 - 3.0 * tPrime4) + 360.0 * tPrime4);
	double latTerm4 = latFactor * ((Eprime * x7) / 40320.0) * (1385.0 - 3633.0 * tPrime2 + 4095.0 * tPrime4 + 1575.0 * tPrime6);
	
	double latRad = latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4;
	*lat = latRad / (PI / 180.0);

	// Compute Longitude
	double secLatPrime = 1.0 / cos(latRad);
	double lonTerm1 = x * secLatPrime;
	double lonTerm2 = ((x3 * secLatPrime) / 6.0) * (psiPrime + 2.0 * tPrime2);
	double lonTerm3 = ((x5 * secLatPrime) / 120.0) * ((-4.0 * psiPrime3) * (1.0 - 6.0 * tPrime2) + psiPrime2 * (9.0 - 68.0 * tPrime2) + 72.0 * psiPrime * tPrime2 + 24.0 * tPrime4);
	double lonTerm4 = ((x7 * secLatPrime) / 5040.0) * (61.0 + 662.0 * tPrime2 + 1320.0 * tPrime4 + 720.0 * tPrime6);
	
	*lon = ((oLon * PI / 180.0) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4) / (PI / 180.0);
}
