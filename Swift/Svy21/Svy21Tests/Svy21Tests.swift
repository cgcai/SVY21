//
//  Svy21Tests.swift
//  Svy21Tests
//
//  Created by Zhou Hao on 5/8/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Svy21

class Svy21Tests: XCTestCase {
    
  private static let ToleranceLatLong: Double = 0.0000000001
  private static let ToleranceSvy21: Double = 0.001
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSvy21ToCoordinates() {
    var expected = CLLocationCoordinate2D(latitude: 1.366666, longitude: 103.833333)
    var actual = Svy21.ComputeLatitudeLongitude(northing: 38744.572, easting: 28001.642)
    
    XCTAssert(abs(expected.latitude - actual.latitude) < Svy21Tests.ToleranceLatLong)
    XCTAssert(abs(expected.longitude - actual.longitude) < Svy21Tests.ToleranceLatLong)
    
    // Corner of Ang Mo Kio 66kV Substation.
    expected = CLLocationCoordinate2D(latitude:1.3699278977737488, longitude:103.856950349764668)
    actual = Svy21.ComputeLatitudeLongitude(northing: 39105.269, easting: 30629.967)
    XCTAssert(abs(expected.latitude - actual.latitude) < Svy21Tests.ToleranceLatLong)
    XCTAssert(abs(expected.longitude - actual.longitude) < Svy21Tests.ToleranceLatLong)
    
    // Corner of Jurong Lake Canal 400kV Cable Bridge.
    expected = CLLocationCoordinate2D(latitude:1.3446255443241177, longitude:103.72794378041792)
    actual = Svy21.ComputeLatitudeLongitude(northing: 36307.704, easting: 16272.970)
    XCTAssert(abs(expected.latitude - actual.latitude) < Svy21Tests.ToleranceLatLong)
    XCTAssert(abs(expected.longitude - actual.longitude) < Svy21Tests.ToleranceLatLong)
    
    // Corner of Sembawang 66kV Substation.
    expected = CLLocationCoordinate2D(latitude:1.4520670518379692, longitude:103.83080332777138)
    actual = Svy21.ComputeLatitudeLongitude(northing: 48187.789, easting: 27720.130)
    XCTAssert(abs(expected.latitude - actual.latitude) < Svy21Tests.ToleranceLatLong)
    XCTAssert(abs(expected.longitude - actual.longitude) < Svy21Tests.ToleranceLatLong)
  }
  
  func testCoordinatesToSvy21() {
    
    // SVY21 Reference Point.
    var expected = Svy21Coordinate(Northing: 38744.572, Easting: 28001.642)
    var test = CLLocationCoordinate2D(latitude: 1.366666, longitude: 103.833333)
    var actual: Svy21Coordinate = Svy21.ComputeSvy21(coordinate: test)
    XCTAssert(abs(expected.Northing - actual.Northing) < Svy21Tests.ToleranceSvy21)
    XCTAssert(abs(expected.Easting - actual.Easting) < Svy21Tests.ToleranceSvy21)
    
    // Corner of Ang Mo Kio 66kV Substation.
    expected = Svy21Coordinate(Northing:39105.269, Easting:30629.967)
    test = CLLocationCoordinate2D(latitude:1.3699278977737488, longitude:103.85695034976466)
    actual = Svy21.ComputeSvy21(coordinate: test)
    XCTAssert(abs(expected.Northing - actual.Northing) < Svy21Tests.ToleranceSvy21)
    XCTAssert(abs(expected.Easting - actual.Easting) < Svy21Tests.ToleranceSvy21)
    
    // Corner of Jurong Lake Canal 400kV Cable Bridge.
    expected = Svy21Coordinate(Northing:36307.704, Easting:16272.970)
    test = CLLocationCoordinate2D(latitude:1.3446255443241177, longitude:103.72794378041792)
    actual = Svy21.ComputeSvy21(coordinate: test)
    XCTAssert(abs(expected.Northing - actual.Northing) < Svy21Tests.ToleranceSvy21)
    XCTAssert(abs(expected.Easting - actual.Easting) < Svy21Tests.ToleranceSvy21)
    
    // Corner of Sembawang 66kV Substation.
    expected = Svy21Coordinate(Northing:48187.789, Easting:27720.130)
    test = CLLocationCoordinate2D(latitude:1.4520670518379692, longitude:103.83080332777138)
    actual = Svy21.ComputeSvy21(coordinate: test)
    XCTAssert(abs(expected.Northing - actual.Northing) < Svy21Tests.ToleranceSvy21)
    XCTAssert(abs(expected.Easting - actual.Easting) < Svy21Tests.ToleranceSvy21)
    
  }
  
}
