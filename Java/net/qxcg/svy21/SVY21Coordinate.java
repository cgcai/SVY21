package net.qxcg.svy21;

public class SVY21Coordinate {
	private double easting;
	private double northing;
	
	public SVY21Coordinate(double northing, double easting) {
		super();
		this.northing = northing;
		this.easting = easting;
	}
	
	public LatLonCoordinate asLatLon() {
		return SVY21.computeLatLon(this);
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SVY21Coordinate other = (SVY21Coordinate) obj;
		if (Double.doubleToLongBits(easting) != Double
				.doubleToLongBits(other.easting))
			return false;
		if (Double.doubleToLongBits(northing) != Double
				.doubleToLongBits(other.northing))
			return false;
		return true;
	}
	
	public double getEasting() {
		return easting;
	}
	
	public double getNorthing() {
		return northing;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		long temp;
		temp = Double.doubleToLongBits(easting);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		temp = Double.doubleToLongBits(northing);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		return result;
	}
	
	@Override
	public String toString() {
		return "SVY21Coordinate [northing=" + northing + ", easting=" + easting
				+ "]";
	}
}
