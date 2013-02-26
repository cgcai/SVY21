import java.util.Map;

public class Demo {
	public static void main(String[] args) {
		// Initialization
		SVY21 svy = new SVY21();
		
		// Computing SVY21 from Lat/Lon
		double lat = 1.2949192688485278;
		double lon = 103.77367436885834;
		Map<String, Double> resultNE = svy.computeSVY21(lat, lon);
		System.out.println(resultNE);
		
		// Computing Lat/Lon from SVY21
		Map<String, Double> resultLatLon = svy.computeLatLon(resultNE.get(SVY21.northingKey()), resultNE.get(SVY21.eastingKey()));
		System.out.println(resultLatLon);
	}
}
