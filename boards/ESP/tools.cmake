set(IDF_VERSION "v5.2.2")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)

set(${board_name}_INCDIR "${${board_name}_DIR}/../include")

# set(${board_name}_FREERTOS_SRCS "")
# set(${board_name}_FREERTOS_INCDIRS "")
# set(${board_name}_HAL_SRCS "")
# set(${board_name}_HAL_INCDIRS "")
# set(${board_name}_HAL_PRIVATE_INCDIRS "")
#    add_library(${board_name}_HAL STATIC ${${board_name}_HAL_SRCS})
#    target_compile_options(${board_name}_HAL PRIVATE ${${board_name}_CFLAGS})
#    target_compile_definitions(${board_name}_HAL PRIVATE ${${board_name}_DEFINES})
#    target_include_directories(${board_name}_HAL
#        PRIVATE ${${board_name}_HAL_PRIVATE_INCDIRS}
#        PUBLIC ${${board_name}_INCDIR}
#        ${${board_name}_HAL_INCDIRS}
#    )
#
#    set(${board_name}_LIBS
#        ${board_name}_HAL
#    )

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

    get_filename_component(component_dir ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
    get_filename_component(component_name ${CALLING_CMAKE_DIR} NAME)
    message(STATUS "Processing component: ${component_name}")

    # Don't do it for freertos. Manually include it
    if(NOT ${component_name} STREQUAL "freertos")
        set(component_srcs "")
        set(component_incdirs "")
        set(component_priv_incdirs "")

        foreach(src IN LISTS arg_SRCS)  
            list(APPEND component_srcs "${component_dir}/${src}" PARENT_SCOPE)
        endforeach()

        foreach(src_dir IN LISTS arg_SRC_DIRS)
            file(GLOB_RECURSE dir_srcs "${component_dir}/${src_dir}/*.c" "${component_dir}/${src_dir}/*.S")
            list(APPEND component_srcs ${dir_srcs})
        endforeach()

        foreach(exclude_src IN LISTS arg_EXCLUDE_SRCS)
            list(REMOVE_ITEM component_srcs "${component_dir}/${exclude_src}")
        endforeach()

        foreach(incdir IN LISTS arg_INCLUDE_DIRS)
            list(APPEND component_incdirs "${component_dir}/${incdir}")
        endforeach()

        foreach(priv_incdir IN LISTS arg_PRIV_INCLUDE_DIRS)
            list(APPEND component_priv_incdirs "${component_dir}/${priv_incdir}")
        endforeach()

        if(NOT TARGET ${component_name})
            add_library(${component_name} STATIC ${component_srcs})
            target_include_directories(${component_name} PUBLIC ${component_incdirs})
            target_include_directories(${component_name} PRIVATE ${component_priv_incdirs})
        endif()

        list(APPEND ${project_name}_component_libraries ${component_name})

        foreach(req IN LISTS arg_REQUIRES)
            if(NOT TARGET ${req})
                message(STATUS "Required component '${req}' not yet processed. Registering it now.")
                register_component(${req})
            endif()
            if(TARGET ${req})
                target_link_libraries(${component_name} PUBLIC ${req})
            else()
                message(WARNING "Failed to register required component '${req}' for '${component_name}'")
            endif()
        endforeach()

        foreach(priv_req IN LISTS arg_PRIV_REQUIRES)
            if(NOT TARGET ${priv_req})
                message(STATUS "Privately required component '${priv_req}' not yet processed. Registering it now.")
                register_component(${priv_req})
            endif()
            if(TARGET ${priv_req})
                target_link_libraries(${component_name} PRIVATE ${priv_req})
            else()
                message(WARNING "Failed to register privately required component '${priv_req}' for '${component_name}'")
            endif()
        endforeach()

        # W.I.P.
        # Do LDFRAGEMENTS
        # I need to understand linker scripts, then process it

    endif()
endfunction()

function(target_link_libraries)
endfunction()

function(idf_component_get_property)
endfunction()
function(idf_component_set_property)
endfunction()

macro(register_component component_name)
    set(${project_name}_${component_name}_cmake "${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/CMakeLists.txt")
        if(EXISTS ${${project_name}_${component_name}_cmake})
            include(${${project_name}_${component_name}_cmake})
        else()
            message(WARNING "Component '${component_name}' not found at ${${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}}")
        endif()
endmacro()

# Processing the components from esp-idf
macro(process_component_requirements)
    set(${project_name}_component_libraries "")
    foreach(component IN LISTS ${project_name}_COMPONENT_REQUIREMENTS)
        register_component(${component})
    endforeach()
    set(${board_name}_LIBS component_libraries)
endmacro()

