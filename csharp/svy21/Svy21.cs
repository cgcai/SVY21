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
