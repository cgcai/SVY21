//	SVY21 - LatLon conversion

// Ref: http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx

#ifndef SVY21_H
#define SVY21_H

class SVY21{

public:
	SVY21();
	//	lat and lon are inputs. They are converted to SVY21 and the results are stored in northing and easting.
	void latLonToSVY21(double lat, double lon, double *northing, double *easting);
	
	//	northing and easting are inputs. They are converted to SVY21 and the results are stored in lat and lon.
	void SVY21ToLatLon(double northing, double easting, double *lat, double *lon);

private:
	//	Helper methods
	double calcM(double lat);
	double calcRho(double sin2Lat);
	double calcV(double sin2Lat);

	double oLat;     		// origin's lat in degrees
	double oLon;   			// origin's lon in degrees
	double oN;      		// false Northing
	double oE;      		// false Easting
	double k;				// scale factor

	//	internal variables
	int a;
	double f;
	double PI;
	double b;
	double e2;
	double e4;
	double e6;
	double A0;
	double A2;
	double A4;
	double A6;
};

#endif//SVY21_H
