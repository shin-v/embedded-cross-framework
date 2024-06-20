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
set(${board_name}_DEFINES -D${BOARD_NAME_UPPERCASE} -D${${board_name}_CLASS} -D${${board_name}_CLASS}${${board_name}_MODULE} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY} -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}xx -D${${board_name}_CLASS}${${board_name}_MODULE}${${board_name}_FAMILY}${${board_name}_MODEL} -DESP_PLATFORM)

set(IDF_VERSION "v5.2.2")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
message(STATUS "Hello World! ${${board_name}_FIRMWARE_DIR}")

set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)
# set(${board_name}_BOARD_RTOS_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/freertos)
# set(${board_name}_BOARD_esp_driver_gpio_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio)
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
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_system/port/arch/xtensa/esp_ipc_isr_routines.S"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/event_groups.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/stream_buffer.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/port.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/portasm.S"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/xtensa_init.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/xtensa_overlay_os_hook.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/freertos_compatibility.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/idf_additions.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_system/freertos_hooks.c"
)

set(${board_name}_FREERTOS_INCDIRS
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/config/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions"
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
    "${${board_name}_DIR}/../include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/log/include"
)

set(${board_name}_HAL_SRCS
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/src/gpio.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/src/gpio_glitch_filter_ops.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/src/rtc_io.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support/spi_bus_lock.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/eri.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/xt_trax.c"
    # "${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support/esp_memory_utils.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_hw_support/esp_memory_utils.c"
    "${${board_name}_BOARD_COMPONENTS_DIR}/heap/heap_caps.c"
)

# right now if I try to compile, it will cause issues with heap.
# It is because I need to incldue all files of heap.
# I recognised, each component has its CMakeLists.txt
# So instead of trying to manually add them one by one, since they literally do idf_component_register(), I should probably override this macro (since we don't use esp-idf macros, rather, I make my own version of it)
# , which will automatically add srcs and include directories in the HAL_SRCS and HAL_INCDIR.

set(${board_name}_HAL_INCDIR 
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/deprecated"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/analog_comparator/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/dac/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/gpio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_gpio/gptimer/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_i2c/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/i2c/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_i2s/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_ledc/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_mcpwm/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_parlio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_pcnt/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_rmt/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_sdio/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_sdmmc/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_sdm/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_spi/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/spi_flash/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_tsens/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_touch_sens/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/touch_sensor/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/driver/twai/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_uart/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_driver_usb_serial_jtag/include"
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
    "${${board_name}_BOARD_COMPONENTS_DIR}/soc/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/newlib/platform_include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/heap"
    "${${board_name}_BOARD_COMPONENTS_DIR}/heap/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/hal/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/hal/esp32/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/app_trace/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/app_trace/port/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/hal/platform_port/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/esp_pm/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions/include"
    "${${board_name}_BOARD_COMPONENTS_DIR}/freertos/esp_additions"
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