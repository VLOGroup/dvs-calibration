project(dvs-calibration)
add_definitions("-fpermissive")
link_directories(/usr/local/lib/x86_64-linux-gnu/) # libcaer
add_executable(grabber grabber.cpp common.cpp)
target_link_libraries(grabber caer)
