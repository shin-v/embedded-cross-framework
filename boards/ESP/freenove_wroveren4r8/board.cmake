#
# The freenove_wroveren4r8 board configuration
#
string(TOUPPER ${board_name} BOARD_NAME_UPPERCASE)
set(${board_name}_CLASS "ESP32")
set(${board_name}_MODULE "WROVER")
set(${board_name}_FAMILY "E")
set(${board_name}_MODEL "N4R8")
set(${board_name}_CPUNAME "XTENSA_32BIT_LX6")
set(${board_name}_CPU "XTENSA_CPU_32BIT_LX6")
set(${board_name}_DEFINES -D${BOARD_NAME_UPPERCASE} -D${${board_name}_CLASS} -D${${board_name}_CLASS}${${board_name}_MODULE} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}xx -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}${${board_name}_MODEL})

set(IDF_VERSION "v5.0.1")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
message(STATUS "Hello World! ${${board_name}_FIRMWARE_DIR}")

set(${board_name}_BOARD_RTOS_DIR ${${board_name}_FIRMWARE_DIR}/components/freertos)
set(${board_name}_BOARD_DRIVER_DIR ${${board_name}_FIRMWARE_DIR}/components/driver)

# Work In Progress
# TODO: Add components manually, instead of using CMakeLists.txt (because it uses esp-idf macros)
include(${${board_name}_BOARD_RTOS_DIR}/CMakeLists.txt)
include(${${board_name}_BOARD_DRIVER_DIR}/CMakeLists.txt)

##set(IDF_VERSION "v5.0.1")
##include(${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION}/tools/cmake/project.cmake)

## Work In Progress
##set(${board_name}_CFLAGS ${ARM_CPU_CORTEX_M3_FLAGS} ${ARM_CPU_CORTEX_THUMB_INTERWORK_FLAGS} ${ARM_CPU_ABI_SOFT_FLOAT_FLAGS} -ffunction-sections -fdata-sections -fno-common -fmessage-length=0)
##set(${board_name}_LDFLAGS ${ARM_CPU_CORTEX_M3_FLAGS} ${ARM_CPU_CORTEX_THUMB_INTERWORK_FLAGS} ${ARM_CPU_ABI_SOFT_FLOAT_FLAGS} ${TOOLCHAIN_LINKER_FLAG} ${TOOLCHAIN_LINKER_PREFIX}--gc-sections ${TOOLCHAIN_LINKER_EXTRA_LDFLAGS})
##set(${board_name}_LIBDIR ${TOOLCHAIN_LIBDIR} ${TOOLCHAIN_LIBGCC_DIR})

## Work In Progress
## set(include_dirs
##    "${original_driver_dir}/i2c/include/driver"
##    "${original_driver_dir}/spi/include/driver"
##    "${original_driver_dir}/gpio/include/driver"
##    "${original_driver_dir}/rmt/include/driver"
##    "${original_driver_dir}/usb_serial_jtag/include/driver"
##    "${original_driver_dir}/i2c/include"
##    "${original_driver_dir}/spi/include"
##    "${original_driver_dir}/gpio/include"
##    "${original_driver_dir}/rmt/include"
##    "${original_driver_dir}/usb_serial_jtag/include"
##    "${CMAKE_CURRENT_SOURCE_DIR}/../hal/include")

