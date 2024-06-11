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

set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)
# set(${board_name}_BOARD_RTOS_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/freertos)
# set(${board_name}_BOARD_DRIVER_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/driver)
# set(${board_name}_BOARD_CPU_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa)
# set(${board_name}_BOARD_LOG_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/log)
#set(${board_name}_BOARD_HWSUPPORT_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support)

set(${board_name}_FREERTOS_SRCS
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/heap_idf.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/app_startup.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/port_common.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/port_systick.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/list.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/queue.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/tasks.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/timers.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/croutine.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/event_groups.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/stream_buffer.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/port.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/portasm.S"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/xtensa_init.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/xtensa_overlay_os_hook.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/freertos_compatibility.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/idf_additions.c"
)

set(${board_name}_FREERTOS_INCDIRS
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_common/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_system/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/soc/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/deprecated_include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/newlib/platform_include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/heap/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_rom/include"
)

set(${board_name}_HAL_SRCS
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/gpio/gpio.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/gpio/gpio_glitch_filter_ops.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/gpio/rtc_io.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/spi/spi_bus_lock.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/eri.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/xt_trax.c"
)

set(${board_name}_HAL_INCDIR 
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/deprecated"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/analog_comparator/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/dac/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/gpio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/gptimer/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/i2c/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/i2s/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/ledc/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/mcpwm/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/parlio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/pcnt/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/rmt/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/sdio_slave/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/sdmmc/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/sigma_delta/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/spi/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/temperature_sensor/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/touch_sensor/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/wai/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/uart/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/usb_serial_jtag/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_common/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_system/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/xtensa/include"
    "${${board_name}_DIR}/../include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/log/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_rom/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/soc/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/deprecated_include"
)

add_library(${board_name}_HAL STATIC ${${board_name}_HAL_SRCS})
target_compile_options(${board_name}_HAL PRIVATE ${${board_name}_CFLAGS})
target_compile_definitions(${board_name}_HAL PRIVATE ${${board_name}_DEFINES})
target_include_directories(${board_name}_HAL
    PUBLIC ${${board_name}_HAL_INCDIR}
)

set(${board_name}_LIBS
    ${board_name}_HAL
)