cmake_minimum_required(VERSION 2.6)
project(svy21test)

################################
# GTest
################################
ADD_SUBDIRECTORY (gtest)
enable_testing()
include_directories(${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})

################################
# Unit Tests
################################
add_executable( svy21test svy21test.cpp ../svy21.cpp )
target_link_libraries(svy21test gtest)
add_test( svy21test svy21test )
