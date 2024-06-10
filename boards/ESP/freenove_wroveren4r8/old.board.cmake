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
set(${board_name}_BOARD_RTOS_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/freertos)
set(${board_name}_BOARD_DRIVER_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/driver)
set(${board_name}_BOARD_CPU_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa)

set(${board_name}_FREERTOS_SRCS
    "${${board_name}_BOARD_RTOS_DIR}/heap_idf.c"
    "${${board_name}_BOARD_RTOS_DIR}/app_startup.c"
    "${${board_name}_BOARD_RTOS_DIR}/port_common.c"
    "${${board_name}_BOARD_RTOS_DIR}/port_systick.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/list.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/queue.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/tasks.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/timers.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/croutine.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/event_groups.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/stream_buffer.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/port.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/portasm.S"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/xtensa_init.c"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/xtensa_overlay_os_hook.c"
    "${${board_name}_BOARD_RTOS_DIR}/esp_additions/freertos_compatibility.c"
    "${${board_name}_BOARD_RTOS_DIR}/esp_additions/idf_additions.c"
)

set(${board_name}_FREERTOS_INCDIRS
    "${${board_name}_BOARD_RTOS_DIR}/config/include"
    "${${board_name}_BOARD_RTOS_DIR}/config/include/freertos"
    "${${board_name}_BOARD_RTOS_DIR}/config/xtensa/include"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/include/freertos"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/include"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/portable/xtensa/include/freertos"
    "${${board_name}_BOARD_RTOS_DIR}/esp_additions/include"
    "${${board_name}_BOARD_CPU_DIR}/include"
    "${${board_name}_BOARD_CPU_DIR}/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_common/include"
)

set(${board_name}_HAL_SRCS
    "${${board_name}_BOARD_DRIVER_DIR}/gpio/gpio.c"
    "${${board_name}_BOARD_DRIVER_DIR}/gpio/gpio_glitch_filter_ops.c"
    "${${board_name}_BOARD_DRIVER_DIR}/gpio/rtc_io.c"
    "${${board_name}_BOARD_DRIVER_DIR}/spi/spi_bus_lock.c"
    "${${board_name}_BOARD_CPU_DIR}/eri.c"
    "${${board_name}_BOARD_CPU_DIR}/xt_trax.c"
)

set(${board_name}_HAL_INCDIR 
    "${${board_name}_BOARD_DRIVER_DIR}/include"
    "${${board_name}_BOARD_DRIVER_DIR}/deprecated"
    "${${board_name}_BOARD_DRIVER_DIR}/analog_comparator/include"
    "${${board_name}_BOARD_DRIVER_DIR}/dac/include"
    "${${board_name}_BOARD_DRIVER_DIR}/gpio/include"
    "${${board_name}_BOARD_DRIVER_DIR}/gptimer/include"
    "${${board_name}_BOARD_DRIVER_DIR}/i2c/include"
    "${${board_name}_BOARD_DRIVER_DIR}/i2s/include"
    "${${board_name}_BOARD_DRIVER_DIR}/ledc/include"
    "${${board_name}_BOARD_DRIVER_DIR}/mcpwm/include"
    "${${board_name}_BOARD_DRIVER_DIR}/parlio/include"
    "${${board_name}_BOARD_DRIVER_DIR}/pcnt/include"
    "${${board_name}_BOARD_DRIVER_DIR}/rmt/include"
    "${${board_name}_BOARD_DRIVER_DIR}/sdio_slave/include"
    "${${board_name}_BOARD_DRIVER_DIR}/sdmmc/include"
    "${${board_name}_BOARD_DRIVER_DIR}/sigma_delta/include"
    "${${board_name}_BOARD_DRIVER_DIR}/spi/include"
    "${${board_name}_BOARD_DRIVER_DIR}/temperature_sensor/include"
    "${${board_name}_BOARD_DRIVER_DIR}/touch_sensor/include"
    "${${board_name}_BOARD_DRIVER_DIR}/wai/include"
    "${${board_name}_BOARD_DRIVER_DIR}/uart/include"
    "${${board_name}_BOARD_DRIVER_DIR}/usb_serial_jtag/include"
    "${${board_name}_BOARD_CPU_DIR}/esp32/include"
    "${${board_name}_BOARD_CPU_DIR}/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_common/include"
    "${${board_name}_BOARD_RTOS_DIR}/FreeRTOS-Kernel/include"
    "${${board_name}_BOARD_RTOS_DIR}/config/include/freertos"
    "${${project_name}_DIR}/include"
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