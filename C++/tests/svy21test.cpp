#include "../svy21.h"
#include "gtest/gtest.h"

static const double ToleranceLatLon = 1e-10;
static const double ToleranceSvy21 = 1e-3;

TEST(Svy21Test, Svy21ToLatLon) {
	SVY21 svy21;
	double latlon[2];

	// SVY21 reference point.
	svy21.SVY21ToLatLon(38744.572, 28001.642, &latlon[0], &latlon[1]);
	ASSERT_NEAR(1.366666, latlon[0], ToleranceLatLon);
	ASSERT_NEAR(103.833333, latlon[1], ToleranceLatLon);

	// Corner of Ang Mo Kio 66kV Substation.
	svy21.SVY21ToLatLon(39105.269, 30629.967, &latlon[0], &latlon[1]);
	ASSERT_NEAR(1.3699278977737488, latlon[0], ToleranceLatLon);
	ASSERT_NEAR(103.856950349764668, latlon[1], ToleranceLatLon);

	// Corner of Jurong Lake Canal 400kV Cable Bridge.
	svy21.SVY21ToLatLon(36307.704, 16272.970, &latlon[0], &latlon[1]);
	ASSERT_NEAR(1.3446255443241177, latlon[0], ToleranceLatLon);
	ASSERT_NEAR(103.72794378041792, latlon[1], ToleranceLatLon);

	// Corner of Sembawang 66kV Substation.
	svy21.SVY21ToLatLon(48187.789, 27720.130, &latlon[0], &latlon[1]);
	ASSERT_NEAR(1.4520670518379692, latlon[0], ToleranceLatLon);
	ASSERT_NEAR(103.83080332777138, latlon[1], ToleranceLatLon);
}

TEST(Svy21Test, LatLonToSvy21) {
	SVY21 svy21;
	double northeast[2];

	// SVY21 Reference Point.
	svy21.latLonToSVY21(1.366666, 103.833333, &northeast[0], &northeast[1]);
	ASSERT_NEAR(38744.572, northeast[0], ToleranceSvy21);
	ASSERT_NEAR(28001.642, northeast[1], ToleranceSvy21);

	// Corner of Ang Mo Kio 66kV Substation.
	svy21.latLonToSVY21(1.3699278977737488, 103.85695034976466, &northeast[0], &northeast[1]);
	ASSERT_NEAR(39105.269, northeast[0], ToleranceSvy21);
	ASSERT_NEAR(30629.967, northeast[1], ToleranceSvy21);

	// Corner of Jurong Lake Canal 400kV Cable Bridge.
	svy21.latLonToSVY21(1.3446255443241177, 103.72794378041792, &northeast[0], &northeast[1]);
	ASSERT_NEAR(36307.704, northeast[0], ToleranceSvy21);
	ASSERT_NEAR(16272.970, northeast[1], ToleranceSvy21);

	// Corner of Sembawang 66kV Substation.
	svy21.latLonToSVY21(1.4520670518379692, 103.83080332777138, &northeast[0], &northeast[1]);
	ASSERT_NEAR(48187.789, northeast[0], ToleranceSvy21);
	ASSERT_NEAR(27720.130, northeast[1], ToleranceSvy21);
}

int main(int argc, char **argv) {
	::testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
