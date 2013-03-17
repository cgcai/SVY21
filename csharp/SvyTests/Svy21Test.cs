using Microsoft.VisualStudio.TestTools.UnitTesting;
using SVY21;

namespace SvyTests
{
    [TestClass]
    public class Svy21Test
    {
        private const double ToleranceLatLong = 0.0000000001;
        private const double ToleranceSvy21 = 0.001;

        [TestMethod]
        public void Svy21ToLatLongTest()
        {
            LatLongCoordinate expected, actual;
            Svy21Coordinate test;
            
            // SVY21 reference point.
            expected = new LatLongCoordinate(1.366666, 103.833333);
            test = new Svy21Coordinate(38744.572, 28001.642);
            actual = Svy21.ComputeLatitudeLongitude(test);
            Assert.AreEqual(expected.Latitude, actual.Latitude, ToleranceLatLong);
            Assert.AreEqual(expected.Longitude, actual.Longitude, ToleranceLatLong);

            // Corner of Ang Mo Kio 66kV Substation.
            expected = new LatLongCoordinate(1.3699278977737488, 103.856950349764668);
            test = new Svy21Coordinate(39105.269, 30629.967);
            actual = Svy21.ComputeLatitudeLongitude(test);
            Assert.AreEqual(expected.Latitude, actual.Latitude, ToleranceLatLong);
            Assert.AreEqual(expected.Longitude, actual.Longitude, ToleranceLatLong);
            
            // Corner of Jurong Lake Canal 400kV Cable Bridge.
            expected = new LatLongCoordinate(1.3446255443241177, 103.72794378041792);
            test = new Svy21Coordinate(36307.704, 16272.970);
            actual = Svy21.ComputeLatitudeLongitude(test);
            Assert.AreEqual(expected.Latitude, actual.Latitude, ToleranceLatLong);
            Assert.AreEqual(expected.Longitude, actual.Longitude, ToleranceLatLong);

            // Corner of Sembawang 66kV Substation.
            expected = new LatLongCoordinate(1.4520670518379692, 103.83080332777138);
            test = new Svy21Coordinate(48187.789, 27720.130);
            actual = Svy21.ComputeLatitudeLongitude(test);
            Assert.AreEqual(expected.Latitude, actual.Latitude, ToleranceLatLong);
            Assert.AreEqual(expected.Longitude, actual.Longitude, ToleranceLatLong);
        }

        [TestMethod]
        public void LatLongToSvy21Test()
        {
            Svy21Coordinate expected, actual;
            LatLongCoordinate test;

            // SVY21 Reference Point.
            expected = new Svy21Coordinate(38744.572, 28001.642);
            test = new LatLongCoordinate(1.366666, 103.833333);
            actual = Svy21.ComputeSvy21(test);
            Assert.AreEqual(expected.Northing, actual.Northing, ToleranceSvy21);
            Assert.AreEqual(expected.Easting, actual.Easting, ToleranceSvy21);

            // Corner of Ang Mo Kio 66kV Substation.
            expected = new Svy21Coordinate(39105.269, 30629.967);
            test = new LatLongCoordinate(1.3699278977737488, 103.85695034976466);
            actual = Svy21.ComputeSvy21(test);
            Assert.AreEqual(expected.Northing, actual.Northing, ToleranceSvy21);
            Assert.AreEqual(expected.Easting, actual.Easting, ToleranceSvy21);

            // Corner of Jurong Lake Canal 400kV Cable Bridge.
            expected = new Svy21Coordinate(36307.704, 16272.970);
            test = new LatLongCoordinate(1.3446255443241177, 103.72794378041792);
            actual = Svy21.ComputeSvy21(test);
            Assert.AreEqual(expected.Northing, actual.Northing, ToleranceSvy21);
            Assert.AreEqual(expected.Easting, actual.Easting, ToleranceSvy21);

            // Corner of Sembawang 66kV Substation.
            expected = new Svy21Coordinate(48187.789, 27720.130);
            test = new LatLongCoordinate(1.4520670518379692, 103.83080332777138);
            actual = Svy21.ComputeSvy21(test);
            Assert.AreEqual(expected.Northing, actual.Northing, ToleranceSvy21);
            Assert.AreEqual(expected.Easting, actual.Easting, ToleranceSvy21);
        }
    }
}
