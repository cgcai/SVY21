//
//  Svy21.swift
//  Svy21
//
//  Convert from C# code, please refer to: https://github.com/cgcai/SVY21/blob/master/csharp/svy21/Svy21.cs
//
//  Created by Zhou Hao on 2/8/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import Foundation
import CoreLocation

struct Svy21Coordinate {

  var Northing: Double
  var Easting: Double
  
  public func ToLatLongCoordinate() -> CLLocationCoordinate2D {
    return Svy21.ComputeLatitudeLongitude(coordinate: self)
  }
}

class Svy21 {
  
  private static let RadRatio = Double.pi / 180 // Ratio to convert degrees to radians.
  
  // Datum and Projection
  private static let A: Double = 6378137             // Semi-major axis of reference ellipsoid.
  private static let F: Double = 1 / 298.257223563   // Ellipsoidal flattening.
  private static let OLat: Double = 1.366666         // Origin latitude (degrees).
  private static let OLon: Double = 103.833333       // Origin longitude (degrees).
  private static let No: Double = 38744.572          // False Northing.
  private static let Eo: Double = 28001.642          // False Easting.
  private static let K: Double = 1.0                 // Central meridian scale factor.
  
  // Computed Projection Constants
  // Naming convention: the trailing number is the power of the variable.
  
  // Semi-minor axis of reference ellipsoid.
  private static let B = A * (1 - F)
  // Squared eccentricity of reference ellipsoid.
  private static let E2 = (2 * F) - (F * F)
  private static let E4 = E2 * E2
  private static let E6 = E4 * E2
  private static let N = (A - B) / (A + B)
  private static let N2 = N * N
  private static let N3 = N2 * N
  private static let N4 = N2 * N2
  private static let G = A * (1 - N) * (1 - N2) * (1 + (9 * N2 / 4) + (225 * N4 / 64)) * RadRatio
  
  // Naming convention: A0..6 are terms in an expression, not powers.
  private static let A0 = 1 - (E2 / 4) - (3 * E4 / 64) - (5 * E6 / 256)
  private static let A2 = (3.0 / 8.0) * (E2 + (E4 / 4) + (15 * E6 / 128))
  private static let A4 = (15.0 / 256.0) * (E4 + (3 * E6 / 4))
  private static let A6 = 35 * E6 / 3072
  
  // Calculates and returns the meridian distance.
  // calcM in other implementations.
  private static func CalculateMeridianDistance(_ latitude: Double) -> Double {
    let latitudeRadian = latitude * RadRatio
    let meridianDistance = A * ((A0 * latitudeRadian) - (A2 * sin(2 * latitudeRadian)) + (A4 * sin(4 * latitudeRadian)) - (A6 * sin(6 * latitudeRadian)))
    return meridianDistance
  }
  
  // Calculates and returns the radius of curvature of the meridian.
  // calcRho in other implementations.
  private static func CalculateRadiusOfCurvatureOfMeridian(_ sinSquaredLatitude: Double) -> Double {
    
    let numerator = A * (1 - E2)
    let denominator = pow(1 - E2 * sinSquaredLatitude, 3.0 / 2.0)
    let curvature = numerator / denominator
    return curvature
  }
  
  // Calculates and returns the radius of curvature in the prime vertical.
  // calcV in other implementations.
  private static func CalculateRadiusOfCurvatureInPrimeVertical(_ sinSquaredLatitude: Double) -> Double {
    let denominator = sqrt(1 - E2 * sinSquaredLatitude)
    let radius = A / denominator
    return radius
  }
  
  public static func ComputeLatitudeLongitude(northing: Double, easting: Double) -> CLLocationCoordinate2D {
    
    let Nprime: Double = northing - No
    let Mo = CalculateMeridianDistance(OLat)
    let Mprime = Mo + (Nprime / K)
    let sigma = (Mprime / G) * RadRatio
  
    // Naming convention: latPrimeT1..4 are terms in an expression, not powers.
    let latPrimeT1 = ((3 * N / 2) - (27 * N3 / 32)) * sin(2 * sigma)
    let latPrimeT2 = ((21 * N2 / 16) - (55 * N4 / 32)) * sin(4 * sigma)
    let latPrimeT3 = (151 * N3 / 96) * sin(6 * sigma)
    let latPrimeT4 = (1097 * N4 / 512) * sin(8 * sigma)
    let latPrime = sigma + latPrimeT1 + latPrimeT2 + latPrimeT3 + latPrimeT4
  
    // Naming convention: sin2LatPrime = "square of sin(latPrime)" = Math.pow(sin(latPrime), 2.0)
    let sinLatPrime = sin(latPrime)
    let sin2LatPrime = sinLatPrime * sinLatPrime
  
    // Naming convention: the trailing number is the power of the variable.
    let rhoPrime = CalculateRadiusOfCurvatureOfMeridian(sin2LatPrime)
    let vPrime = CalculateRadiusOfCurvatureInPrimeVertical(sin2LatPrime)
    let psiPrime = vPrime / rhoPrime
    let psiPrime2 = psiPrime * psiPrime
    let psiPrime3 = psiPrime2 * psiPrime
    let psiPrime4 = psiPrime3 * psiPrime
    let tPrime = tan(latPrime)
    let tPrime2 = tPrime * tPrime
    let tPrime4 = tPrime2 * tPrime2
    let tPrime6 = tPrime4 * tPrime2
    let Eprime = easting - Eo
    let x = Eprime / (K * vPrime)
    let x2 = x * x
    let x3 = x2 * x
    let x5 = x3 * x2
    let x7 = x5 * x2
  
    // Compute Latitude
    // Naming convention: latTerm1..4 are terms in an expression, not powers.
    let latFactor = tPrime / (K * rhoPrime)
    let latTerm1 = latFactor * ((Eprime * x) / 2)
    let latTerm2 = latFactor * ((Eprime * x3) / 24) * ((-4 * psiPrime2 + (9 * psiPrime) * (1 - tPrime2) + (12 * tPrime2)))
    let latTerm3 = latFactor * ((Eprime * x5) / 720) * ((8 * psiPrime4) * (11 - 24 * tPrime2) - (12 * psiPrime3) * (21 - 71 * tPrime2) + (15 * psiPrime2) * (15 - 98 * tPrime2 + 15 * tPrime4) + (180 * psiPrime) * (5 * tPrime2 - 3 * tPrime4) + 360 * tPrime4)
    let latTerm4 = latFactor * ((Eprime * x7) / 40320) * (1385 - 3633 * tPrime2 + 4095 * tPrime4 + 1575 * tPrime6)
    let lat = latPrime - latTerm1 + latTerm2 - latTerm3 + latTerm4
  
    // Compute Longitude
    // Naming convention: lonTerm1..4 are terms in an expression, not powers.
    let secLatPrime = 1.0 / cos(lat)
    let lonTerm1 = x * secLatPrime
    let lonTerm2 = ((x3 * secLatPrime) / 6) * (psiPrime + 2 * tPrime2);
    let lonTerm3 = ((x5 * secLatPrime) / 120) * ((-4 * psiPrime3) * (1 - 6 * tPrime2) + psiPrime2 * (9 - 68 * tPrime2) + 72 * psiPrime * tPrime2 + 24 * tPrime4)
    let lonTerm4 = ((x7 * secLatPrime) / 5040) * (61 + 662 * tPrime2 + 1320 * tPrime4 + 720 * tPrime6)
    let lon = (OLon * RadRatio) + lonTerm1 - lonTerm2 + lonTerm3 - lonTerm4
  
    return CLLocationCoordinate2D(latitude: lat / RadRatio, longitude: lon / RadRatio)
  }
  
  public static func ComputeLatitudeLongitude(coordinate: Svy21Coordinate) -> CLLocationCoordinate2D {
    return ComputeLatitudeLongitude(northing: coordinate.Northing, easting: coordinate.Easting)
  }
  
  public static func ComputeSvy21(latitude: Double, longitude: Double) -> Svy21Coordinate {
  
    // Naming convention: sin2Lat = "square of sin(lat)" = Math.pow(sin(lat), 2.0)
    let latR = latitude * RadRatio
    let sinLat = sin(latR)
    let sin2Lat = sinLat * sinLat
    let cosLat = cos(latR)
    let cos2Lat = cosLat * cosLat
    let cos3Lat = cos2Lat * cosLat
    let cos4Lat = cos3Lat * cosLat
    let cos5Lat = cos3Lat * cos2Lat
    let cos6Lat = cos5Lat * cosLat
    let cos7Lat = cos5Lat * cos2Lat
  
    let rho = CalculateRadiusOfCurvatureOfMeridian(sin2Lat)
    let v = CalculateRadiusOfCurvatureInPrimeVertical(sin2Lat)
    let psi = v / rho
    let t = tan(latR)
    let w = (longitude - OLon) * RadRatio
    let M = CalculateMeridianDistance(latitude)
    let Mo = CalculateMeridianDistance(OLat)
  
    // Naming convention: the trailing number is the power of the variable.
    let w2 = w * w
    let w4 = w2 * w2
    let w6 = w4 * w2
    let w8 = w6 * w2
    let psi2 = psi * psi
    let psi3 = psi2 * psi
    let psi4 = psi2 * psi2
    let t2 = t * t
    let t4 = t2 * t2
    let t6 = t4 * t2
  
    // Compute Northing.
    // Naming convention: nTerm1..4 are terms in an expression, not powers.
    let nTerm1 = w2 / 2 * v * sinLat * cosLat
    let nTerm2 = w4 / 24 * v * sinLat * cos3Lat * (4 * psi2 + psi - t2)
    let nTerm3 = w6 / 720 * v * sinLat * cos5Lat * ((8 * psi4) * (11 - 24 * t2) - (28 * psi3) * (1 - 6 * t2) + psi2 * (1 - 32 * t2) - psi * 2 * t2 + t4)
    let nTerm4 = w8 / 40320 * v * sinLat * cos7Lat * (1385 - 3111 * t2 + 543 * t4 - t6)
    let northing = No + K * (M - Mo + nTerm1 + nTerm2 + nTerm3 + nTerm4)
  
    // Compute Easting.
    // Naming convention: eTerm1..3 are terms in an expression, not powers.
    let eTerm1 = w2 / 6 * cos2Lat * (psi - t2)
    let eTerm2 = w4 / 120 * cos4Lat * ((4 * psi3) * (1 - 6 * t2) + psi2 * (1 + 8 * t2) - psi * 2 * t2 + t4)
    let eTerm3 = w6 / 5040 * cos6Lat * (61 - 479 * t2 + 179 * t4 - t6)
    let easting = Eo + K * v * w * cosLat * (1 + eTerm1 + eTerm2 + eTerm3)
    
    return Svy21Coordinate(Northing: northing, Easting: easting)
  }
  
  public static func ComputeSvy21(coordinate: CLLocationCoordinate2D) -> Svy21Coordinate {
    return ComputeSvy21(latitude: coordinate.latitude, longitude: coordinate.longitude)
  }

}
