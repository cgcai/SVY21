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
	    private const double A		= 6378137;				// Semi-major axis of reference ellipsoid.
	    private const double F		= 1 / 298.257223563;	// Ellipsoidal flattening.
	    private const double OLat	= 1.366666;				// Origin latitude (degrees).
	    private const double OLon	= 103.833333;			// Origin longitude (degrees).
	    private const double No		= 38744.572;			// False Northing.
	    private const double Eo		= 28001.642;			// False Easting.
	    private const double K		= 1.0;					// Central meridian scale factor.
	
	    // Computed Projection Constants
	    // Naming convention: the trailing number is the power of the variable.
        
        // Semi-minor axis of reference ellipsoid.
        private const double B = A * (1 - F);
        // Squared eccentricity of reference ellipsoid.
	    private const double E2 = (2*F) - (F*F);									
        private const double E4 = E2*E2;
        private const double E6 = E4*E2;
        private const double N = (A - B) / (A + B);
        private const double N2 = N*N;
        private const double N3 = N2*N;
        private const double N4 = N2*N2;
        private const double G = A*(1 - N)*(1 - N2)*(1 + (9*N2/4) + (225*N4/64))*RadRatio;
	
	    // Naming convention: A0..6 are terms in an expression, not powers.
        private const double A0 = 1 - (E2/4) - (3*E4/64) - (5*E6/256);
        private const double A2 = (3.0 / 8.0) * (E2 + (E4 / 4) + (15 * E6 / 128));
        private const double A4 = (15.0/256.0)*(E4 + (3*E6/4));
        private const double A6 = 35*E6/3072;

        private static double CalculateMeridian(double latitude)
        {
            throw new NotImplementedException();
        }

        private static double CalculateRho(double sinSquaredLatitude)
        {
            throw new NotImplementedException();
        }

        private static double CalculateCurvature(double sinSquaredLatitude)
        {
            throw new NotImplementedException();
        }

        public static LatLongCoordinate ComputeLatitudeLongitude(double northing, double easting)
        {
            throw new NotImplementedException();
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
