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

# FIXME
# set(${board_name}_CFLAGS ${ARM_CPU_CORTEX_M3_FLAGS} ${ARM_CPU_CORTEX_THUMB_INTERWORK_FLAGS} ${ARM_CPU_ABI_SOFT_FLOAT_FLAGS} -ffunction-sections -fdata-sections -fno-common -fmessage-length=0)

set(${board_name}_DEFINES -D${BOARD_NAME_UPPERCASE} -D${${board_name}_CLASS} -D${${board_name}_CLASS}${${board_name}_MODULE} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}xx -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}${${board_name}_MODEL} -DESP_PLATFORM)
set(${board_name}_TARGET "esp32")
set(${board_name}_TARGET_ARCH "xtensa")

include(${${board_name}_DIR}/../tools.cmake)
process_component_requirements()