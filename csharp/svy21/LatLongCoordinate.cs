using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SVY21
{
    public class LatLongCoordinate
    {
        public double Latitude { get; set; }
        public double Longitude { get; set; }

        public LatLongCoordinate(double latitude, double longitude)
        {
            Latitude = latitude;
            Longitude = longitude;
        }

        public Svy21Coordinate ToSvy21()
        {
            return Svy21.ComputeSvy21(this);
        }
    }
}
