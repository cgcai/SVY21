// Ref: http://www.linz.govt.nz/geodetic/conversion-coordinates/projection-conversions/transverse-mercator-preliminary-computations/index.aspx

// WGS84 Datum
import 'dart:math';

const double a = 6378137;
const double f = 1 / 298.257223563;

// SVY21 Projection
// Fundamental point: Base 7 at Pierce Reservoir.
// Latitude: 1 22 02.9154 N, longitude: 103 49 31.9752 E (of Greenwich).

// Known Issue: Setting (oLat, oLon) to the exact coordinates specified above
// results in computation being slightly off. The values below give the most
// accurate representation of test data.
const oLat = 1.366666; // origin's lat in degrees
const oLon = 103.833333; // origin's lon in degrees
const oN = 38744.572; // false Northing
const oE = 28001.642; // false Easting
const k = 1; // scale factor

// intermediates
const b = a * (1 - f);
const e2 = (2 * f) - (f * f);
const e4 = e2 * e2;
const e6 = e4 * e2;
const A0 = 1 - (e2 / 4) - (3 * e4 / 64) - (5 * e6 / 256);
const A2 = (3.0 / 8.0) * (e2 + (e4 / 4) + (15 * e6 / 128));
const A4 = (15.0 / 256.0) * (e4 + (3 * e6 / 4));
const A6 = 35 * e6 / 3072;

///Returns a pair (N, E) representing Northings and Eastings in SVY21.
(double, double) computeSVY21(double lat, double lon) {
  var latR = lat * pi / 180;
  var sinLat = sin(latR);
  var sin2Lat = sinLat * sinLat;
  var cosLat = cos(latR);
  var cos2Lat = cosLat * cosLat;
  var cos3Lat = cos2Lat * cosLat;
  var cos4Lat = cos3Lat * cosLat;
  var cos5Lat = cos4Lat * cosLat;
  var cos6Lat = cos5Lat * cosLat;
  var cos7Lat = cos6Lat * cosLat;

  var rho = calcRho(sin2Lat);
  var v = calcV(sin2Lat);
  var psi = v / rho;
  var t = tan(latR);
  var w = (lon - oLon) * pi / 180;

  var M = calcM(lat);
  var Mo = calcM(oLat);

  var w2 = w * w;
  var w4 = w2 * w2;
  var w6 = w4 * w2;
  var w8 = w6 * w2;

  var psi2 = psi * psi;
  var psi3 = psi2 * psi;
  var psi4 = psi3 * psi;

  var t2 = t * t;
  var t4 = t2 * t2;
  var t6 = t4 * t2;

  // Compute Northing
  var nTerm1 = w2 / 2 * v * sinLat * cosLat;
  var nTerm2 = w4 / 24 * v * sinLat * cos3Lat * (4 * psi2 + psi - t2);
  var nTerm3 = w6 /
      720 *
      v *
      sinLat *
      cos5Lat *
      ((8 * psi4) * (11 - 24 * t2) -
          (28 * psi3) * (1 - 6 * t2) +
          psi2 * (1 - 32 * t2) -
          psi * 2 * t2 +
          t4);
  var nTerm4 =
      w8 / 40320 * v * sinLat * cos7Lat * (1385 - 3111 * t2 + 543 * t4 - t6);
  var N = oN + k * (M - Mo + nTerm1 + nTerm2 + nTerm3 + nTerm4);

  // Compute Easting
  var eTerm1 = w2 / 6 * cos2Lat * (psi - t2);
  var eTerm2 = w4 /
      120 *
      cos4Lat *
      ((4 * psi3) * (1 - 6 * t2) + psi2 * (1 + 8 * t2) - psi * 2 * t2 + t4);
  var eTerm3 = w6 / 5040 * cos6Lat * (61 - 479 * t2 + 179 * t4 - t6);
  var E = oE + k * v * w * cosLat * (1 + eTerm1 + eTerm2 + eTerm3);

  return (N, E);
}

calcM(lat) {
  var latR = lat * pi / 180;
  return a *
      ((A0 * latR) -
          (A2 * sin(2 * latR)) +
          (A4 * sin(4 * latR)) -
          (A6 * sin(6 * latR)));
}

double calcRho(sin2Lat) {
  var num = a * (1 - e2);
  var denom = pow(1 - e2 * sin2Lat, 3.0 / 2.0);
  return num / denom;
}

double calcV(sin2Lat) {
  var poly = 1 - e2 * sin2Lat;
  return a / sqrt(poly);
}

(double, double) computeLatLon(N, E) {
  // Returns a pair (lat, lon) representing Latitude and Longitude.

  var Nprime = N - oN;
  var Mo = calcM(oLat);
  var Mprime = Mo + (Nprime / k);
  var n = (a - b) / (a + b);
  var n2 = n * n;
  var n3 = n2 * n;
  var n4 = n2 * n2;
  var G = a *
      (1 - n) *
      (1 - n2) *
      (1 + (9 * n2 / 4) + (225 * n4 / 64)) *
      (pi / 180);
  var sigma = (Mprime * pi) / (180.0 * G);

  var latPrimeT1 = ((3 * n / 2) - (27 * n3 / 32)) * sin(2 * sigma);
  var latPrimeT2 = ((21 * n2 / 16) - (55 * n4 / 32)) * sin(4 * sigma);
  var latPrimeT3 = (151 * n3 / 96) * sin(6 * sigma);
  var latPrimeT4 = (1097 * n4 / 512) * sin(8 * sigma);
  var latPrime = sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4;

  var sinLatPrime = sin(latPrime);
  var sin2LatPrime = sinLatPrime * sinLatPrime;

  var rhoPrime = calcRho(sin2LatPrime);
  var vPrime = calcV(sin2LatPrime);
  var psiPrime = vPrime / rhoPrime;
  var psiPrime2 = psiPrime * psiPrime;
  var psiPrime3 = psiPrime2 * psiPrime;
  var psiPrime4 = psiPrime3 * psiPrime;
  var tPrime = tan(latPrime);
  var tPrime2 = tPrime * tPrime;
  var tPrime4 = tPrime2 * tPrime2;
  var tPrime6 = tPrime4 * tPrime2;
  var Eprime = E - oE;
  var x = Eprime / (k * vPrime);
  var x2 = x * x;
  var x3 = x2 * x;
  var x5 = x3 * x2;
  var x7 = x5 * x2;

  // Compute Latitude
  var latFactor = tPrime / (k * rhoPrime);
  var latTerm1 = latFactor * ((Eprime * x) / 2);
  var latTerm2 = latFactor *
      ((Eprime * x3) / 24) *
      ((-4 * psiPrime2) + (9 * psiPrime) * (1 - tPrime2) + (12 * tPrime2));
  var latTerm3 = latFactor *
      ((Eprime * x5) / 720) *
      ((8 * psiPrime4) * (11 - 24 * tPrime2) -
          (12 * psiPrime3) * (21 - 71 * tPrime2) +
          (15 * psiPrime2) * (15 - 98 * tPrime2 + 15 * tPrime4) +
          (180 * psiPrime) * (5 * tPrime2 - 3 * tPrime4) +
          360 * tPrime4);
  var latTerm4 = latFactor *
      ((Eprime * x7) / 40320) *
      (1385 - 3633 * tPrime2 + 4095 * tPrime4 + 1575 * tPrime6);
  var lat = latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4;

  // Compute Longitude
  var secLatPrime = 1.0 / cos(lat);
  var lonTerm1 = x * secLatPrime;
  var lonTerm2 = ((x3 * secLatPrime) / 6) * (psiPrime + 2 * tPrime2);
  var lonTerm3 = ((x5 * secLatPrime) / 120) *
      ((-4 * psiPrime3) * (1 - 6 * tPrime2) +
          psiPrime2 * (9 - 68 * tPrime2) +
          72 * psiPrime * tPrime2 +
          24 * tPrime4);
  var lonTerm4 = ((x7 * secLatPrime) / 5040) *
      (61 + 662 * tPrime2 + 1320 * tPrime4 + 720 * tPrime6);
  var lon = (oLon * pi / 180) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4;

  return (lat / (pi / 180), lon / (pi / 180));
}
