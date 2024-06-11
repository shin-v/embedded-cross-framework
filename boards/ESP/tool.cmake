set(IDF_VERSION "v5.0.1")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
message(STATUS "Hello World! Preparing CMAKE for: ${board_name}!")

set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)
set(${board_name}_BOARD_HAL_DIR ${${board_name}_BOARD_COMPONENTS_DIR}/hal)

set(${board_name}_HAL_SRCS
    "${${board_name}_BOARD_HAL_DIR}/mpu_hal.c"
    "${${board_name}_BOARD_HAL_DIR}/efuse_hal.c"
    "${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/efuse_hal.c"
)

set(${board_name}_HAL_INCDIRS
    ${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/include
    ${${board_name}_BOARD_HAL_DIR}/include
    ${${board_name}_BOARD_HAL_DIR}/platform_port/include
    ${${board_name}_DIR}/../include
    ${${board_name}_BOARD_COMPONENTS_DIR}/soc/include
    ${${board_name}_BOARD_COMPONENTS_DIR}/soc/${${board_name}_TARGET}/include
    ${${board_name}_BOARD_COMPONENTS_DIR}/esp_common/include
    ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/include
)

if(${${board_name}_TARGET} STREQUAL "esp32")
    list(APPEND ${board_name}_HAL_INCDIRS ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/esp32/include)
endif()

if(${${board_name}_TARGET} STREQUAL "esp32s2")
    list(APPEND ${board_name}_HAL_INCDIRS ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/esp32s2/include)
endif()

if(${${board_name}_TARGET} STREQUAL "esp32s3")
    list(APPEND ${board_name}_HAL_INCDIRS ${${board_name}_BOARD_COMPONENTS_DIR}/xtensa/esp32s3/include)
endif()

if(NOT ${${board_name}_CONFIG_HAL_WDT_USE_ROM_IMPL})
    list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/wdt_hal_iram.c")
endif()

if(NOT ${${board_name}_CONFIG_APP_BUILD_TYPE_PURE_RAM_APP})
    list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/mmu_hal.c")
    if(${${board_name}_TARGET} STREQUAL "esp32")
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/esp32/cache_hal_esp32.c")
    else()
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/cache_hal.c")
    endif()
endif()

if(${${board_name}_CONFIG_SOC_LP_TIMER_SUPPORTED})
    list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/lp_timer_hal.c")
endif()

if(NOT ${${board_name}_BOOTLOADER_BUILD})
    list(APPEND ${board_name}_HAL_SRCS
        "${${board_name}_BOARD_HAL_DIR}/rtc_io_hal.c"
        "${${board_name}_BOARD_HAL_DIR}/gpio_hal.c"
        "${${board_name}_BOARD_HAL_DIR}/uart_hal.c"
        "${${board_name}_BOARD_HAL_DIR}/uart_hal_iram.c")

    if(NOT ${${board_name}_CONFIG_APP_BUILD_TYPE_PURE_RAM_APP})
        list(APPEND ${board_name}_HAL_SRCS
            "${${board_name}_BOARD_HAL_DIR}/spi_flash_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/spi_flash_hal_iram.c"
        )
        if(${${board_name}_CONFIG_SOC_FLASH_ENC_SUPPORTED})
            list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/spi_flash_encrypt_hal_iram.c")
        endif()
    endif()

    if(${${board_name}_CONFIG_SOC_CLK_TREE_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/clk_tree_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_SYSTIMER_SUPPORTED} AND NOT ${${board_name}_CONFIG_HAL_SYSTIMER_USE_ROM_IMPL})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/systimer_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_GPTIMER_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/timer_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_LEDC_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS 
            "${${board_name}_BOARD_HAL_DIR}/ledc_hal.c" 
            "${${board_name}_BOARD_HAL_DIR}/ledc_hal_iram.c"
        )
    endif()

    if(${${board_name}_CONFIG_SOC_I2C_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS 
            "${${board_name}_BOARD_HAL_DIR}/i2c_hal.c" 
            "${${board_name}_BOARD_HAL_DIR}/i2c_hal_iram.c"
        )
    endif()

    if(${${board_name}_CONFIG_SOC_RMT_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/rmt_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_PCNT_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/pcnt_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_MCPWM_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/mcpwm_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_TWAI_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS 
            "${${board_name}_BOARD_HAL_DIR}/twai_hal.c" 
            "${${board_name}_BOARD_HAL_DIR}/twai_hal_iram.c"
        )
    endif()

    if(${${board_name}_CONFIG_SOC_GDMA_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/gdma_hal_top.c")
    endif()

    if(${${board_name}_CONFIG_SOC_GDMA_SUPPORT_CRC})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/gdma_hal_crc_gen.c")
    endif()

    if(${${board_name}_CONFIG_SOC_AHB_GDMA_VERSION} EQUAL 1)
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/gdma_hal_ahb_v1.c")
    endif()

    if(${${board_name}_CONFIG_SOC_AHB_GDMA_VERSION} EQUAL 2)
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/gdma_hal_ahb_v2.c")
    endif()

    if(${${board_name}_CONFIG_SOC_AXI_GDMA_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/gdma_hal_axi.c")
    endif()

    if(${${board_name}_CONFIG_SOC_I2S_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/i2s_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_SDM_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/sdm_hal.c")
    endif()

    if(${${board_name}_CONFIG_ETH_USE_ESP32_EMAC})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/emac_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_ETM_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/etm_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_PARLIO_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/parlio_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_ADC_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/adc_hal_common.c" "adc_oneshot_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_ADC_DMA_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/adc_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_LCDCAM_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/lcd_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_ECC_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/ecc_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_ECDSA_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/ecdsa_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_MPI_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/mpi_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_SHA_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/sha_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_AES_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/aes_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_MODEM_CLOCK_IS_INDEPENDENT})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/modem_clock_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_PAU_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/pau_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_BOD_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/brownout_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_GPSPI_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS
                    "${${board_name}_BOARD_HAL_DIR}/spi_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/spi_hal_iram.c"
                    "${${board_name}_BOARD_HAL_DIR}/spi_slave_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/spi_slave_hal_iram.c")
    endif()

    if(${${board_name}_CONFIG_SOC_SPI_SUPPORT_SLAVE_HD_VER2})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/spi_slave_hd_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_GPSPI_SUPPORTED} AND NOT ${${board_name}_TARGET} STREQUAL "esp32")
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/spi_flash_hal_gpspi.c")
    endif()

    if(${${board_name}_CONFIG_SOC_SDIO_SLAVE_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/sdio_slave_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_PMU_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/${${board_name}_TARGET}/pmu_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_APM_SUPPORTED})
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/apm_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_HMAC_SUPPORTED} AND NOT ${${board_name}_TARGET} STREQUAL "esp32s2")
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/hmac_hal.c")
    endif()

    if(${${board_name}_CONFIG_SOC_DIG_SIGN_SUPPORTED} AND NOT ${${board_name}_TARGET} STREQUAL "esp32s2")
        list(APPEND ${board_name}_HAL_SRCS "${${board_name}_BOARD_HAL_DIR}/ds_hal.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32")
        list(APPEND ${board_name}_HAL_SRCS
            "${${board_name}_BOARD_HAL_DIR}/touch_sensor_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/esp32/touch_sensor_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/esp32/gpio_hal_workaround.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32s2")
        list(APPEND ${board_name}_HAL_SRCS
                    "${${board_name}_BOARD_HAL_DIR}/touch_sensor_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/usb_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/usb_phy_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/xt_wdt_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/esp32s2/cp_dma_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/esp32s2/touch_sensor_hal.c"
                    "${${board_name}_BOARD_HAL_DIR}/usb_dwc_hal.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32s3")
        list(APPEND ${board_name}_HAL_SRCS
            "${${board_name}_BOARD_HAL_DIR}/touch_sensor_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/usb_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/usb_phy_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/xt_wdt_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/esp32s3/touch_sensor_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/esp32s3/rtc_cntl_hal.c"
            "${${board_name}_BOARD_HAL_DIR}/usb_dwc_hal.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32c3")
        list(APPEND ${board_name}_HAL_SRCS
              "${${board_name}_BOARD_HAL_DIR}/xt_wdt_hal.c"
              "${${board_name}_BOARD_HAL_DIR}/esp32c3/rtc_cntl_hal.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32c2")
        list(APPEND ${board_name}_HAL_SRCS
              "${${board_name}_BOARD_HAL_DIR}/esp32c2/rtc_cntl_hal.c")
    endif()

    if(${${board_name}_TARGET} STREQUAL "esp32h2")
        list(REMOVE_ITEM ${board_name}_HAL_SRCS
                "${${board_name}_BOARD_HAL_DIR}/esp32h2/rtc_cntl_hal.c")
    endif()
endif()

add_library(${board_name}_HAL STATIC ${${board_name}_HAL_SRCS})
target_compile_options(${board_name}_HAL PRIVATE ${${board_name}_CFLAGS})
target_compile_definitions(${board_name}_HAL PRIVATE ${${board_name}_DEFINES})
target_include_directories(${board_name}_HAL
    PUBLIC ${${board_name}_HAL_INCDIRS}
)

set(${board_name}_LIBS ${board_name}_HAL)