using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SVY21
{
    public class Svy21Coordinate
    {
        public double Easting { get; set; }
        public double Northing { get; set; }

        public Svy21Coordinate(double easting, double northing)
        {
            Easting = easting;
            Northing = northing;
        }

        public LatLongCoordinate ToLatLongCoordinate()
        {
            return Svy21.ComputeLatitudeLongitude(this);
        }
    }
}
