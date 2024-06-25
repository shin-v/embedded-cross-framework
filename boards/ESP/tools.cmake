set(IDF_VERSION "v5.2.2")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)

# Overriding the idf functions to tailor to our needs
function(idf_build_get_property var property)
    set(val "")
    if(property STREQUAL "IDF_TARGET")
        set(val ${board_name}_TARGET)
    endif()
    set(${var} ${val})
endfunction()

function(idf_component_register)
    
endfunction()

function(target_link_libraries)
endfunction()

# Processing the components from esp-idf
macro(process_component_requirements)
    foreach(component ${${project_name}_COMPONENT_REQUIREMENTS})
        set(${project_name}_${component}_cmake "${${board_name}_BOARD_COMPONENTS_DIR}/${component}/CMakeLists.txt")
        if(EXISTS ${${project_name}_${component}_cmake})
            include(${${project_name}_${component}_cmake})
        else()
            message(WARNING "Component '${component}' not found at ${${${board_name}_BOARD_COMPONENTS_DIR}/${component}}")
        endif()
    endforeach()
endmacro()

