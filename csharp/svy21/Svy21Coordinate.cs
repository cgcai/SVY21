namespace SVY21
{
    public class Svy21Coordinate
    {
        public override int GetHashCode()
        {
            unchecked
            {
                return (Easting.GetHashCode()*397) ^ Northing.GetHashCode();
            }
        }

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

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((Svy21Coordinate) obj);
        }

        protected bool Equals(Svy21Coordinate other)
        {
            return Easting.Equals(other.Easting) && Northing.Equals(other.Northing);
        }

        public override string ToString()
        {
            return "Svy21Coordinate [Northing=" + Northing + ", Easting=" + Easting + "]";
        }
    }
}
