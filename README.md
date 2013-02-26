SVY21
=====
A **Free** and **Open Source** Library to convert between Lat/Lon, and SVY21.

##Usage##
###Python###
The Python script is a ready-to-use converter. Run with `python -i SVY21.py`.

    # Initialization
    >>> cv = SVY21()
    
    # Computing SVY21 from Lat/Lon
    >>> (lat, lon) = (1.2949192688485278, 103.77367436885834)
    >>> (N, E) = cv.computeSVY21(lat, lon)
    >>> (N, E)
    (30811.26429645264, 21362.157043860374)
    
    # Computing Lat/Lon from SVY21
    >>> (lat, lon) = cv.computeLatLon(N, E)
    >>> (lat, lon)
    (1.2949192688483109, 103.77367436887495)
    
###Java###
The Java class may be embedded in other projects. Feel free to specify your own package details.

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
		
###Javascript###

		// Initialization
		var cv = new SVY21();

		// Computing SVY21 from Lat/Lon
		var lat = 1.2949192688485278;
		var lon = 103.77367436885834;
		var result = cv.computeSVY21(lat, lon);
		console.log(result)

		// Computing Lat/Lon from SVY21
		var resultLatLon = cv.computeLatLon(result.N, result.E);
		console.log(resultLatLon);

    
##Testing##
The "Protected Areas And Protected Places Act" found [here](http://statutes.agc.gov.sg/aol/search/display/view.w3p;page=0;query=Id%3A%223ed25f04-0465-4eda-b05f-c0c7334e8840%22%20Status%3Ainforce;rec=0;whole=yes) lists some SVY21 points that correspond to vertices of hard-to-miss plots of land in Singapore.

You can try converting some of the Northing, Easting coordinates to Latitude and Longitude, and viewing the plot of land on [Google Maps](https://maps.google.com.sg/) to verify their accuracy.

###Precision###
Like all floating-point computations, converting back and forth between Lat/Lon and SVY21 will cause the loss of precision. 

In the Python example above, note that the input Lat/Lon and output Lat/Lon are very slightly different. Repeating the process a few more times will compound this difference.

The useful precision of the output also depends on the precision of the inputs.

##Known Issues##
1. Setting the origin's latitude and longitude, represented by `oLat` and `oLon` respectively, to the official SVY21 datum specified [here](http://statutes.agc.gov.sg/aol/search/display/view.w3p;page=0;query=DocId%3A%22f3625be0-89ba-4db2-85bf-303d62771de8%22%20Status%3Ainforce%20Depth%3A0;rec=0) results in computation being a bit off for the above sample points. However, the rounded values of `(1.366666, 103.833333)` give accurate results.

##Mathematics##
This library makes use of the equations in the following page:  
[Transverse Mercator Transformation Formulae](http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx)

##Future Direction##
1. **Code quality**. This library was developed during a Hackathon, and needs to be brought up to production standard.
2. A few parties have expressed interest in **JavaScript** support.
3. Automated and/or more comprehensive **tests**.
4. **Other languages**. 

##Acknowledgements##
Isaac Low  
Jonathan Ong  
Chua Wei Kuan  

Created during Hack & Roll '13 by [NUS Hackers](http://nushackers.org/)