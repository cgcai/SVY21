#SVY21#
===
A **Free** and **Open Source** Library to convert between Lat/Lon, and SVY21.

##Usage##

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

##Equations##
This library makes use of the equations in the following page: [http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx](http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx)

##Credits##
Issac Low  
Camillus Gerard Cai  
Jonathon Ong  
Chua Wei Kuan  

Created during Hack & Roll '13 by [NUS Hackers](http://nushackers.org/)