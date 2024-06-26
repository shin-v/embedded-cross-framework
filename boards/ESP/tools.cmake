set(IDF_VERSION "v5.2.2")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)

set(${board_name}_INCDIR "${${board_name}_DIR}/../include")

set(${board_name}_FREERTOS_SRCS "")
set(${board_name}_FREERTOS_INCDIRS "")
set(${board_name}_HAL_SRCS "")
set(${board_name}_HAL_INCDIRS "")
set(${board_name}_HAL_PRIVATE_INCDIRS "")


# Overriding the idf functions to tailor to our needs
function(idf_build_get_property var property)
    set(val "")
    if(property STREQUAL "IDF_TARGET")
        set(val ${board_name}_TARGET)
    endif()
    set(${var} ${val})
endfunction()

function(idf_component_register)
    set(options)
    set(single_value)
    set(multi_value SRCS SRC_DIRS EXCLUDE_SRCS INCLUDE_DIRS PRIV_INCLUDE_DIRS REQUIRES PRIV_REQUIRES EMBED_FILES EMBED_TXTFILES)
    cmake_parse_arguments(arg "${options}" "${single_value}" "${multi_value}" ${ARGN})
    # Don't do it for freertos. Manually include it

    # FIXME; component_name is not defined. This needs to be defines to find the absolute path
    # set(component_name "")

    foreach(src IN LISTS SRCS)  
        list(APPEND ${${board_name}_HAL_SRCS} "${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/${src}" PARENT_SCOPE)
    endforeach()

    foreach(incdirs IN LISTS INCLUDE_DIRS)
        list(APPEND ${${board_name}_HAL_INCDIRS} "${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/${incdirs}" PARENT_SCOPE)
    endforeach()

    foreach(priv_incdirs IN LISTS PRIV_INCLUDE_DIRS)
        list(APPEND ${${board_name}_HAL_PRIVATE_INCDIRS} "${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/${priv_incdirs}")
    endforeach()

endfunction()

function(target_link_libraries)
endfunction()

function(idf_component_get_property)
endfunction()
function(idf_component_set_property)
endfunction()

# Processing the components from esp-idf
macro(process_component_requirements)
    foreach(component IN LISTS ${${project_name}_COMPONENT_REQUIREMENTS})
        set(${project_name}_${component}_cmake "${${board_name}_BOARD_COMPONENTS_DIR}/${component}/CMakeLists.txt")
        if(EXISTS ${${project_name}_${component}_cmake})
            include(${${project_name}_${component}_cmake})
        else()
            message(WARNING "Component '${component}' not found at ${${${board_name}_BOARD_COMPONENTS_DIR}/${component}}")
        endif()
    endforeach()

    add_library(${board_name}_HAL STATIC ${${board_name}_HAL_SRCS})
    target_compile_options(${board_name}_HAL PRIVATE ${${board_name}_CFLAGS})
    target_compile_definitions(${board_name}_HAL PRIVATE ${${board_name}_DEFINES})
    target_include_directories(${board_name}_HAL
        PRIVATE ${${board_name}_HAL_PRIVATE_INCDIRS}
        PUBLIC ${${board_name}_INCDIR}
        ${${board_name}_HAL_INCDIRS}
    )

    set(${board_name}_LIBS
        ${board_name}_HAL
    )

endmacro()

