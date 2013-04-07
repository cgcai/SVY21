require 'test/unit'
require 'svy21'

class SVY21Test < Test::Unit::TestCase
  def test_constants
    rad_ratio = Math::PI / 180.0
    a = 6378137.0
    f = 1.0 / 298.257223563
    o_lat = 1.366666
    o_lng = 103.833333
    no = 38744.572
    eo = 28001.642
    k = 1.0
    
    assert_equal SVY21::RAD_RATIO, rad_ratio
    assert_equal SVY21::A, a
    assert_equal SVY21::F, f
    assert_equal SVY21::ORIGIN_LATITUDE, o_lat
    assert_equal SVY21::ORIGIN_LONGITUDE, o_lng
    assert_equal SVY21::FALSE_NORTHING, no
    assert_equal SVY21::FALSE_EASTING, eo
    assert_equal SVY21::K, k
    
    
    b = a * (1.0 - f)
    e2 = (2.0 * f) - (f * f)
    e4 = e2 * e2
    e6 = e4 * e2
    
    a0 = 1.0 - (e2 / 4.0) - (3.0 * e4 / 64.0) - (5.0 * e6 / 256.0)
    a2 = (3.0 / 8.0) * (e2 + (e4 / 4.0) + (15.0 * e6 / 128.0))
    a4 = (15.0 / 256.0) * (e4 + (3.0 * e6 / 4.0))
    a6 = 35.0 * e6 / 3072.0
    
    n = (a - b) / (a + b)
    n2 = n * n
    n3 = n2 * n
    n4 = n2 * n2
    
    g = a * (1.0 - n) * (1.0 - n2) * (1.0 + (9.0 * n2 / 4.0) + (225.0 * n4 / 64.0)) * rad_ratio;
    
    assert_equal SVY21::B, b
    assert_equal SVY21::E2, e2
    assert_equal SVY21::E4, e4
    assert_equal SVY21::E6, e6
    
    assert_equal SVY21::A0, a0
    assert_equal SVY21::A2, a2
    assert_equal SVY21::A4, a4
    assert_equal SVY21::A6, a6
    
    assert_equal SVY21::N, n
    assert_equal SVY21::N2, n2
    assert_equal SVY21::N3, n3
    assert_equal SVY21::N4, n4
    
    assert_equal SVY21::G, g
  end
  
  def test_svy21_to_lat_lon
    # 570 Ang Mo Kio Avenue 10
    lat_lon = SVY21.svy21_to_lat_lon(39105.269, 30629.967)
    assert_in_epsilon(lat_lon[0], 1.3699278977737488, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.85695034976467, 0.000001)
    
    # SVY21 Reference Point
    lat_lon = SVY21.svy21_to_lat_lon(38744.572, 28001.642)
    assert_in_epsilon(lat_lon[0], 1.366666, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.833333, 0.000001)
    
    # Corner of Ang Mo Kio 66kV Substation
    lat_lon = SVY21.svy21_to_lat_lon(39105.269, 30629.967)
    assert_in_epsilon(lat_lon[0], 1.3699278977737488, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.85695034976466, 0.000001)
    
    # Corner of Jurong Lake Canal 400kV Cable Bridge.
    lat_lon = SVY21.svy21_to_lat_lon(36307.704, 16272.970)
    assert_in_epsilon(lat_lon[0], 1.3446255443241177, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.72794378041792, 0.000001)
    
    # Corner of Sembawang 66kV Substation.
    lat_lon = SVY21.svy21_to_lat_lon(48187.789, 27720.130)
    assert_in_epsilon(lat_lon[0], 1.4520670518379692, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.83080332777138, 0.000001)
    
    # Calculation done in http://www.onemap.sg/api/help/HTMLSource/ConvertCords.aspx
    lat_lon = SVY21.svy21_to_lat_lon(28912.1833258747, 29535.0995308659)
    assert_in_epsilon(lat_lon[0], 1.2777459830532, 0.000001)
    assert_in_epsilon(lat_lon[1], 103.8471120197759, 0.000001)
  end
  
  def test_lat_lon_to_svy21
    # 570 Ang Mo Kio Avenue 10
    northing_easting = SVY21.lat_lon_to_svy21(1.3699278977737488, 103.85695034976467)
    assert_in_epsilon(northing_easting[0], 39105.269)
    assert_in_epsilon(northing_easting[1], 30629.967)
    
    # SVY21 Reference Point
    northing_easting = SVY21.lat_lon_to_svy21(1.366666, 103.833333)
    assert_in_epsilon(northing_easting[0], 38744.572)
    assert_in_epsilon(northing_easting[1], 28001.642)
    
    # Corner of Ang Mo Kio 66kV Substation
    northing_easting = SVY21.lat_lon_to_svy21(1.3699278977737488, 103.85695034976466)
    assert_in_epsilon(northing_easting[0], 39105.269)
    assert_in_epsilon(northing_easting[1], 30629.967)
    
    # Corner of Jurong Lake Canal 400kV Cable Bridge.
    northing_easting = SVY21.lat_lon_to_svy21(1.3446255443241177, 103.72794378041792)
    assert_in_epsilon(northing_easting[0], 36307.704)
    assert_in_epsilon(northing_easting[1], 16272.970)
    
    # Corner of Sembawang 66kV Substation.
    northing_easting = SVY21.lat_lon_to_svy21(1.4520670518379692, 103.83080332777138)
    assert_in_epsilon(northing_easting[0], 48187.789)
    assert_in_epsilon(northing_easting[1], 27720.130)
    
    # Calculation done in http://www.onemap.sg/api/help/HTMLSource/ConvertCords.aspx
    northing_easting = SVY21.lat_lon_to_svy21(1.2777459830532, 103.8471120197759)
    assert_in_epsilon(northing_easting[0], 28912.1833258747)
    assert_in_epsilon(northing_easting[1], 29535.0995308659)
  end
end