SVY21
=====
A **Free** and **Open Source** Library to convert between Lat/Lon, and SVY21.

#Usage##
##Python###

    # Initialization
    >>> cv = SVY21()
    
    # Computing SVY21 from Lat/Lon
    >>> (lat, lon) = (1.2949192688485278, 103.77367436885834)
    >>> (N, E) = cv.computeSVY21(lat, lon)
    >>> (N, E)
    (30721.679566556475, 22228.448562409914)
    
    # Computing Lat/Lon from SVY21
    >>> (lat, lon) = cv.computeLatLon(N, E)
    >>> (lat, lon)
    (1.2949192688483109, 103.77367436886927)
    
##Java###

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

##Equations#
This library makes use of the equations in the following page: [http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx](http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx)

##Acknowledgements#
Isaac Low  
Jonathan Ong  
Chua Wei Kuan  

Created during Hack & Roll '13 by [NUS Hackers](http://nushackers.org/)