package svy21

import "testing"

const (
	ToleranceLatLon = 1e-10
	ToleranceSVY21  = 1e-3
)

/*
Go implementation of the python function of the same name for floating-point comparison
from https://code.google.com/codejam/faq.html#5-9

	def IsApproximatelyEqual(x, y, epsilon):
	  """Returns True iff y is within relative or absolute 'epsilon' of x.

	  By default, 'epsilon' is 1e-6.
	  """
	  # Check absolute precision.
	  if -epsilon <= x - y <= epsilon:
	    return True

	  # Is x or y too close to zero?
	  if -epsilon <= x <= epsilon or -epsilon <= y <= epsilon:
	    return False

	  # Check relative precision.
	  return (-epsilon <= (x - y) / x <= epsilon
	       or -epsilon <= (x - y) / y <= epsilon)
*/
func isApproximatelyEqual(x, y, tolerance float64) bool {
	// Check absolute precision.
	if -tolerance <= x-y && x-y <= tolerance {
		return true
	}

	// Is x or y too close to zero?
	if (-tolerance <= x && x <= tolerance) || (-tolerance <= y && y <= tolerance) {
		return false
	}

	// Check relative precision.
	return (-tolerance <= (x-y)/x && (x-y)/x <= tolerance) ||
		(-tolerance <= (x-y)/y && (x-y)/y <= tolerance)
}

func TestToLatLon(t *testing.T) {
	var N, E, lat, lon float64

	t.Run("SVY21 reference point", func(t *testing.T) {

		N = 38744.572
		E = 28001.642
		lat, lon = ToLatLon(N, E)
		if !isApproximatelyEqual(lat, 1.366666, ToleranceLatLon) ||
			!isApproximatelyEqual(lon, 103.833333, ToleranceLatLon) {
			t.Fail()
		}
	})

	t.Run("Corner of Ang Mo Kio 66kV Substation", func(t *testing.T) {

		N = 39105.269
		E = 30629.967
		lat, lon = ToLatLon(N, E)
		if !isApproximatelyEqual(lat, 1.3699278977737488, ToleranceLatLon) ||
			!isApproximatelyEqual(lon, 103.856950349764668, ToleranceLatLon) {
			t.Fail()
		}
	})

	t.Run("Corner of Jurong Lake Canal 400kV Cable Bridge", func(t *testing.T) {

		N = 36307.704
		E = 16272.970
		lat, lon = ToLatLon(N, E)
		if !isApproximatelyEqual(lat, 1.3446255443241177, ToleranceLatLon) ||
			!isApproximatelyEqual(lon, 103.72794378041792, ToleranceLatLon) {
			t.Fail()
		}
	})

	t.Run("Corner of Sembawang 66kV Substation", func(t *testing.T) {

		N = 48187.789
		E = 27720.130
		lat, lon = ToLatLon(N, E)
		if !isApproximatelyEqual(lat, 1.4520670518379692, ToleranceLatLon) ||
			!isApproximatelyEqual(lon, 103.83080332777138, ToleranceLatLon) {
			t.Fail()
		}
	})
}

func TestToSVY21(t *testing.T) {
	var N, E, lat, lon float64

	t.Run("SVY21 reference point", func(t *testing.T) {

		lat = 1.366666
		lon = 103.833333
		N, E = ToSVY21(lat, lon)
		if !isApproximatelyEqual(N, 38744.572, ToleranceSVY21) ||
			!isApproximatelyEqual(E, 28001.642, ToleranceSVY21) {
			t.Fail()
		}
	})

	t.Run("Corner of Ang Mo Kio 66kV Substation", func(t *testing.T) {

		lat = 1.3699278977737488
		lon = 103.85695034976466
		N, E = ToSVY21(lat, lon)
		if !isApproximatelyEqual(N, 39105.269, ToleranceSVY21) ||
			!isApproximatelyEqual(E, 30629.967, ToleranceSVY21) {
			t.Fail()
		}
	})

	t.Run("Corner of Jurong Lake Canal 400kV Cable Bridge", func(t *testing.T) {

		lat = 1.3446255443241177
		lon = 103.72794378041792
		N, E = ToSVY21(lat, lon)
		if !isApproximatelyEqual(N, 36307.704, ToleranceSVY21) ||
			!isApproximatelyEqual(E, 16272.970, ToleranceSVY21) {
			t.Fail()
		}
	})

	t.Run("Corner of Sembawang 66kV Substation", func(t *testing.T) {

		lat = 1.4520670518379692
		lon = 103.83080332777138
		N, E = ToSVY21(lat, lon)
		if !isApproximatelyEqual(N, 48187.789, ToleranceSVY21) ||
			!isApproximatelyEqual(E, 27720.130, ToleranceSVY21) {
			t.Fail()
		}
	})
}
