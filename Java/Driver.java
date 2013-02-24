public class Driver {
	public static void main(String[] args) {
		// Initialization
		SVY21 cv = new SVY21();
		
		// Computing SVY21 from Lat/Lon
		double lat = 1.2949192688485278;
		double lon = 103.77367436885834;
		Pair<Double, Double> resultNE = cv.computeSVY21(lat, lon);
		System.out.println(resultNE);
		
		// Computing Lat/Lon from SVY21
		Pair<Double, Double> resultLatLon = cv.computeLatLon(resultNE.getFirst(), resultNE.getSecond());
		System.out.println(resultLatLon);
	}
}
