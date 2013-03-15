using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SVY21
{
    /**
     * Ported from the Java implementation of SVY21.
     * 
     * This class provides methods to convert between SVY21 and the standard
     * Latitude/Longitude coordinate system.
     */
    public class Svy21
    {
        private const double RadRatio = Math.PI / 180;		// Ratio to convert degrees to radians.

        // Datum and Projection
        private const double A = 6378137;				// Semi-major axis of reference ellipsoid.
        private const double F = 1 / 298.257223563;	// Ellipsoidal flattening.
        private const double OLat = 1.366666;				// Origin latitude (degrees).
        private const double OLon = 103.833333;			// Origin longitude (degrees).
        private const double No = 38744.572;			// False Northing.
        private const double Eo = 28001.642;			// False Easting.
        private const double K = 1.0;					// Central meridian scale factor.

        // Computed Projection Constants
        // Naming convention: the trailing number is the power of the variable.

        // Semi-minor axis of reference ellipsoid.
        private const double B = A * (1 - F);
        // Squared eccentricity of reference ellipsoid.
        private const double E2 = (2 * F) - (F * F);
        private const double E4 = E2 * E2;
        private const double E6 = E4 * E2;
        private const double N = (A - B) / (A + B);
        private const double N2 = N * N;
        private const double N3 = N2 * N;
        private const double N4 = N2 * N2;
        private const double G = A * (1 - N) * (1 - N2) * (1 + (9 * N2 / 4) + (225 * N4 / 64)) * RadRatio;

        // Naming convention: A0..6 are terms in an expression, not powers.
        private const double A0 = 1 - (E2 / 4) - (3 * E4 / 64) - (5 * E6 / 256);
        private const double A2 = (3.0 / 8.0) * (E2 + (E4 / 4) + (15 * E6 / 128));
        private const double A4 = (15.0 / 256.0) * (E4 + (3 * E6 / 4));
        private const double A6 = 35 * E6 / 3072;

        private static double CalculateMeridianDistance(double latitude)
        {
            double latitudeRadian = latitude * RadRatio;
            double meridianDistance = A * ((A0 * latitudeRadian) - (A2 * Math.Sin(2 * latitudeRadian)) +
                                         (A4 * Math.Sin(4 * latitudeRadian)) - (A6 * Math.Sin(6 * latitudeRadian)));
            return meridianDistance;
        }

        // Calculates and returns the radius of curvature of the meridian.
        private static double CalculateRadiusOfCurvatureOfMeridian(double sinSquaredLatitude)
        {
            double numerator = A * (1 - E2);
            double denominator = Math.Pow(1 - E2 * sinSquaredLatitude, 3.0 / 2.0);
            double curvature = numerator / denominator;
            return curvature;
        }

        // Calculates and returns the radius of curvature in the prime vertical.
        private static double CalculateRadiusOfCurvatureInPrimeVertical(double sinSquaredLatitude)
        {
            double denominator = Math.Sqrt(1 - E2 * sinSquaredLatitude);
            double radius = A / denominator;
            return radius;
        }

        public static LatLongCoordinate ComputeLatitudeLongitude(double northing, double easting)
        {
            double Nprime = N - No;
            double Mo = CalculateMeridianDistance(OLat);
            double Mprime = Mo + (Nprime / K);
            double sigma = (Mprime / G) * RadRatio;

            // Naming convention: latPrimeT1..4 are terms in an expression, not powers.
            double latPrimeT1 = ((3 * N / 2) - (27 * N3 / 32)) * Math.Sin(2 * sigma);
            double latPrimeT2 = ((21 * N2 / 16) - (55 * N4 / 32)) * Math.Sin(4 * sigma);
            double latPrimeT3 = (151 * N3 / 96) * Math.Sin(6 * sigma);
            double latPrimeT4 = (1097 * N4 / 512) * Math.Sin(8 * sigma);
            double latPrime = sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4;

            // Naming convention: sin2LatPrime = "square of sin(latPrime)" = Math.pow(sin(latPrime), 2.0)
            double sinLatPrime = Math.Sin(latPrime);
            double sin2LatPrime = sinLatPrime * sinLatPrime;

            // Naming convention: the trailing number is the power of the variable.
            double rhoPrime = CalculateRadiusOfCurvatureOfMeridian(sin2LatPrime);
            double vPrime = CalculateRadiusOfCurvatureInPrimeVertical(sin2LatPrime);
            double psiPrime = vPrime / rhoPrime;
            double psiPrime2 = psiPrime * psiPrime;
            double psiPrime3 = psiPrime2 * psiPrime;
            double psiPrime4 = psiPrime3 * psiPrime;
            double tPrime = Math.Tan(latPrime);
            double tPrime2 = tPrime * tPrime;
            double tPrime4 = tPrime2 * tPrime2;
            double tPrime6 = tPrime4 * tPrime2;
            double Eprime = easting - Eo;
            double x = Eprime / (K * vPrime);
            double x2 = x * x;
            double x3 = x2 * x;
            double x5 = x3 * x2;
            double x7 = x5 * x2;

            // Compute Latitude
            // Naming convention: latTerm1..4 are terms in an expression, not powers.
            double latFactor = tPrime / (K * rhoPrime);
            double latTerm1 = latFactor * ((Eprime * x) / 2);
            double latTerm2 = latFactor * ((Eprime * x3) / 24) * ((-4 * psiPrime2 + (9 * psiPrime) * (1 - tPrime2) + (12 * tPrime2)));
            double latTerm3 = latFactor * ((Eprime * x5) / 720) * ((8 * psiPrime4) * (11 - 24 * tPrime2) - (12 * psiPrime3) * (21 - 71 * tPrime2) + (15 * psiPrime2) * (15 - 98 * tPrime2 + 15 * tPrime4) + (180 * psiPrime) * (5 * tPrime2 - 3 * tPrime4) + 360 * tPrime4);
            double latTerm4 = latFactor * ((Eprime * x7) / 40320) * (1385 - 3633 * tPrime2 + 4095 * tPrime4 + 1575 * tPrime6);
            double lat = latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4;

            // Compute Longitude
            // Naming convention: lonTerm1..4 are terms in an expression, not powers.
            double secLatPrime = 1.0 / Math.Cos(lat);
            double lonTerm1 = x * secLatPrime;
            double lonTerm2 = ((x3 * secLatPrime) / 6) * (psiPrime + 2 * tPrime2);
            double lonTerm3 = ((x5 * secLatPrime) / 120) * ((-4 * psiPrime3) * (1 - 6 * tPrime2) + psiPrime2 * (9 - 68 * tPrime2) + 72 * psiPrime * tPrime2 + 24 * tPrime4);
            double lonTerm4 = ((x7 * secLatPrime) / 5040) * (61 + 662 * tPrime2 + 1320 * tPrime4 + 720 * tPrime6);
            double lon = (OLon * RadRatio) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4;

            return new LatLongCoordinate(lat / RadRatio, lon / RadRatio);
        }

        public static LatLongCoordinate ComputeLatitudeLongitude(Svy21Coordinate coordinate)
        {
            throw new NotImplementedException();
        }

        public static Svy21Coordinate ComputeSvy21(double latitude, double longitude)
        {
            throw new NotImplementedException();
        }

        public static Svy21Coordinate ComputeSvy21(LatLongCoordinate coordinate)
        {
            throw new NotImplementedException();
        }
    }
}
