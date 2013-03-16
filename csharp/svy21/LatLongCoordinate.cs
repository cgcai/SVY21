namespace SVY21
{
    public class LatLongCoordinate
    {
        protected bool Equals(LatLongCoordinate other)
        {
            return Latitude.Equals(other.Latitude) && Longitude.Equals(other.Longitude);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return (Latitude.GetHashCode() * 397) ^ Longitude.GetHashCode();
            }
        }

        public double Latitude { get; set; }
        public double Longitude { get; set; }

        public LatLongCoordinate(double latitude, double longitude)
        {
            Latitude = latitude;
            Longitude = longitude;
        }

        public Svy21Coordinate ToSvy21Coordinate()
        {
            return Svy21.ComputeSvy21(this);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != GetType()) return false;
            return Equals((LatLongCoordinate)obj);
        }

        }
    }
}
