set(IDF_VERSION "v5.2.2")
set(${board_name}_FIRMWARE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/firmware/espressif/esp-idf-${IDF_VERSION})
set(${board_name}_BOARD_COMPONENTS_DIR ${${board_name}_FIRMWARE_DIR}/components)

# EVERYTHING almost works.
# Todo: solve "idf::vfs".
#   esp_driver_uart/CMakeLists.txt:23
# After that, Todo:
#   sdkconfig.h. Place it in build files...?

# Function to parse sdkconfig.h and set variables for CMakeLists.txt of the loading components
function(parse_sdkconfig_h sdkconfig_h_path)
    if(EXISTS ${sdkconfig_h_path})
        file(STRINGS ${sdkconfig_h_path} sdkconfig_contents)
        foreach(line ${sdkconfig_contents})
            if(line MATCHES "^#define[ \t]+(CONFIG_[^ \t]+)[ \t]+(.+)$")
                set(${CMAKE_MATCH_1} ${CMAKE_MATCH_2} CACHE INTERNAL "")
            endif()
        endforeach()
    endif()
endfunction()
parse_sdkconfig_h("${${board_name}_DIR}/../include/sdkconfig.h")

function(idf_component_get_property var component property)
    message(STATUS "-- idf_component_get_property is called! ${var}, ${component}, ${property}")
endfunction()
function(idf_component_set_property component property val)
    message(STATUS "-- idf_component_set_property is called! ${component}, ${property}, ${val}")
endfunction()
function(esptool_py_custom_target target_name flasher_filename dependencies)
    # Supposedly, the function creates custom flash targets for ESP-IDF, setting up commands and dependencies for flashing firmware to a device, with optional support for encrypted flashing in development mode.
    message(STATUS "-- esptool_py_custom_target is called! ${target_name}, ${flasher_filename}, ${dependencies}")
endfunction()
function(esptool_py_flash_target_image target_name image_name offset image)
    # Supposedly, this optional "ALWAYS_PLAINTEXT" parameter allows flashing unencrypted images in development mode when flash encryption is enabled, but is ignored if secure flash encryption development mode is not set.
    message(STATUS "-- esptool_py_flash_target_image is called! ${target_name}, ${image_name}, ${offset}, ${image}")
endfunction()
function(esptool_py_flash_target target_name main_args sub_args)
endfunction()
function(partition_table_get_partition_info result get_part_info_args part_info)
endfunction()
# Imported from esp_idf utilities.cmake: line 190-195
function(add_prefix var prefix)
    foreach(elm ${ARGN})
        list(APPEND newlist "${prefix}${elm}")
    endforeach()
    set(${var} "${newlist}" PARENT_SCOPE)
endfunction()
function(idf_component_optional_requires req_type)
endfunction()
# Imported from esp_idf utilities.cmake: line 206-225
function(fail_at_build_time target_name message_line0)
    idf_build_get_property(idf_path IDF_PATH)
    set(message_lines COMMAND ${CMAKE_COMMAND} -E echo "${message_line0}")
    foreach(message_line ${ARGN})
        set(message_lines ${message_lines} COMMAND ${CMAKE_COMMAND} -E echo "${message_line}")
    endforeach()
    # Generate a timestamp file that gets included. When deleted on build, this forces CMake
    # to rerun.
    string(RANDOM filename)
    set(filename "${CMAKE_CURRENT_BINARY_DIR}/${filename}.cmake")
    file(WRITE "${filename}" "")
    include("${filename}")
    set(fail_message "Failing the build (see errors on lines above)")
    add_custom_target(${target_name} ALL
        ${message_lines}
        COMMAND ${CMAKE_COMMAND} -E remove "${filename}"
        COMMAND ${CMAKE_COMMAND} -E env FAIL_MESSAGE=${fail_message}
                ${CMAKE_COMMAND} -P ${idf_path}/tools/cmake/scripts/fail.cmake
        VERBATIM)
endfunction()
#Imported from esp_idf utilities.cmake: line 328-341
# Utility to generate file and have the output automatically added to cleaned files.
function(file_generate output)
    cmake_parse_arguments(_ "" "INPUT;CONTENT" "" ${ARGN})

    if(__INPUT)
        file(GENERATE OUTPUT "${output}" INPUT "${__INPUT}")
    elseif(__CONTENT)
        file(GENERATE OUTPUT "${output}" CONTENT "${__CONTENT}")
    else()
        message(FATAL_ERROR "Content to generate not specified.")
    endif()

    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        APPEND PROPERTY ADDITIONAL_CLEAN_FILES "${output}")
endfunction()

# Imported from esp_idf project_include.cmake in partition_table component: line 44-71
function(partition_table_add_check_size_target target_name)
    # result binary_path partition_type partition_subtype
    set(args BINARY_PATH PARTITION_TYPE PARTITION_SUBTYPE)
    set(multi_args DEPENDS)
    cmake_parse_arguments(CMD "" "${args}" "${multi_args}" ${ARGN})

    idf_build_get_property(python PYTHON)
    idf_build_get_property(table_bin PARTITION_TABLE_BIN_PATH)
    if(CMD_PARTITION_SUBTYPE)
        set(subtype_arg --subtype ${CMD_PARTITION_SUBTYPE})
    else()
        set(subtype_arg)
    endif()
    set(command ${python} ${PARTITION_TABLE_CHECK_SIZES_TOOL_PATH}
        --offset ${PARTITION_TABLE_OFFSET}
        partition --type ${CMD_PARTITION_TYPE} ${subtype_arg}
        ${table_bin} ${CMD_BINARY_PATH})

    add_custom_target(${target_name} COMMAND ${command} DEPENDS ${CMD_DEPENDS} partition_table_bin)
endfunction()

# This function adds binary data into the built target
# Adapted from target_add_binary_data of esp-idf to match our needs
function(target_add_binary_data target embed_file embed_type)
    cmake_parse_arguments(_ "" "RENAME_TO" "DEPENDS" ${ARGN})

    if(NOT IS_ABSOLUTE "${embed_file}")
        set(component_path "${${board_name}_BOARD_COMPONENTS_DIR}/${target}")
        set(embed_file "${component_path}/${embed_file}")
    endif()

    get_filename_component(embed_file "${embed_file}" ABSOLUTE)
    get_filename_component(name "${embed_file}" NAME)
    # ask help from supervisor
    set(build_dir "${CMAKE_CURRENT_SOURCE_DIR}/.build/xtensa-esp32-elf-gcc-debug")
    set(embed_srcfile "${build_dir}/${name}.S")

    set(rename_to_arg)
    if(__RENAME_TO)
        set(rename_to_arg -D "VARIABLE_BASENAME=${__RENAME_TO}")
    endif()

    add_custom_command(OUTPUT "${embed_srcfile}"
        COMMAND "${CMAKE_COMMAND}"
        -D "DATA_FILE=${embed_file}"
        -D "SOURCE_FILE=${embed_srcfile}"
        ${rename_to_arg}
        -D "FILE_TYPE=${embed_type}"
        -P "${${board_name}_FIRMWARE_DIR}/tools/cmake/scripts/data_file_embed_asm.cmake" 
        MAIN_DEPENDENCY "${embed_file}"
        DEPENDS "${${board_name}_FIRMWARE_DIR}/tools/cmake/scripts/data_file_embed_asm.cmake" ${__DEPENDS}
        WORKING_DIRECTORY "${build_dir}"
        VERBATIM        
    )

    set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" APPEND PROPERTY ADDITIONAL_CLEAN_FILES "${embed_srcfile}")
    target_sources("${target}" PRIVATE "${embed_srcfile}")

endfunction()

# adds linker script with -L search path and -T for INCLUDE directives to be used to include other linker scripts in the same directory
# adapted from target_linker_script of esp-idf to match our needs
function(target_linker_script target deptype scriptfile)
    set(abs_script "${${board_name}_BOARD_COMPONENTS_DIR}/${target}/${scriptfile}")
    message(STATUS "Adding Linker Script ${abs_script}")
    get_filename_component(search_dir "${abs_script}" DIRECTORY)
    get_filename_component(scriptname "${abs_script}" NAME)
    target_link_directories(${target} ${deptype} ${search_dir})
    target_link_options(${target} ${deptype} "SHELL:-T ${scriptname}")
    set_property(TARGET ${target} APPEND PROPERTY LINK_DEPENDS ${abs_script})
endfunction()

# This function creates a custom target with the old target name
function(add_deprecated_target_alias old_target new_target)
    add_custom_target(${old_target}
        # The COMMAND argument uses CMake's command-line interface to echo an empty string
        # This is a trick to ensure the COMMENT is printed at the end of the target action
        COMMAND ${CMAKE_COMMAND} -E echo ""
        # COMMENT "Warning: command \"${old_target}\" is deprecated. Have you wanted to run \"${new_target}\" instead?"
    )
    add_dependencies(${old_target} ${new_target})
endfunction()



# Overriding the idf functions to tailor to our needs
function(idf_build_get_property var property)
    set(val "")
    if(property STREQUAL "IDF_TARGET")
        set(val ${${board_name}_TARGET})
    elseif(property STREQUAL "IDF_PATH")
        set(val ${${board_name}_FIRMWARE_DIR})
    endif()
    set(${var} ${val} PARENT_SCOPE)
endfunction()

# Register component
function(idf_component_register)
    set(options WHOLE_ARCHIVE)
    set(single_value KCONFIG KCONFIG_PROJBUILD)
    set(multi_value SRCS SRC_DIRS EXCLUDE_SRCS INCLUDE_DIRS PRIV_INCLUDE_DIRS LDFRAGMENTS REQUIRES PRIV_REQUIRES REQUIRED_IDF_TARGETS EMBED_FILES EMBED_TXTFILES)
    cmake_parse_arguments(arg "${options}" "${single_value}" "${multi_value}" ${ARGN})

    get_filename_component(component_dir ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
    get_filename_component(component_name ${component_dir} NAME)
    message(STATUS "Processing component: ${component_name}")

    if(NOT TARGET ${component_name})

        set(component_srcs "")
        set(component_incdirs "")
        set(component_priv_incdirs "")
        set(component_ldfragments "")
        set(component_lib_type STATIC)
    
        if(arg_SRCS)
            foreach(src IN LISTS arg_SRCS)  
                list(APPEND component_srcs "${component_dir}/${src}")
            endforeach()
        endif()

        if(arg_SRC_DIRS)
            foreach(src_dir IN LISTS arg_SRC_DIRS)
                file(GLOB_RECURSE dir_srcs "${component_dir}/${src_dir}/*.c" "${component_dir}/${src_dir}/*.S")
                list(APPEND component_srcs ${dir_srcs})
            endforeach()
        endif()

        if(arg_EXCLUDE_SRCS)
            foreach(exclude_src IN LISTS arg_EXCLUDE_SRCS)
                list(REMOVE_ITEM component_srcs "${component_dir}/${exclude_src}")
            endforeach()
        endif()

        if(arg_INCLUDE_DIRS)
            foreach(incdir IN LISTS arg_INCLUDE_DIRS)
                list(APPEND component_incdirs "${component_dir}/${incdir}")
            endforeach()
        endif()

        if(arg_PRIV_INCLUDE_DIRS)
            foreach(priv_incdir IN LISTS arg_PRIV_INCLUDE_DIRS)
                list(APPEND component_priv_incdirs "${component_dir}/${priv_incdir}")
            endforeach()
        endif()

        if(NOT component_srcs)
            set(component_lib_type INTERFACE)
        endif()

        add_library(${component_name} ${component_lib_type} ${component_srcs})
        if(component_lib_type STREQUAL "INTERFACE")
            target_include_directories(${component_name} INTERFACE
                ${component_incdirs}
                ${component_priv_incdirs}
                "${${board_name}_DIR}/../include"
            )
        elseif(component_lib_type STREQUAL "STATIC")
            target_include_directories(${component_name} PUBLIC ${component_incdirs} "${${board_name}_DIR}/../include")
            target_include_directories(${component_name} PRIVATE ${component_priv_incdirs})
        else()
            message(CRITICAL_ERROR "Component Library type for ${component_name} is invalid!")
        endif()
        
        if(arg_LDFRAGMENTS)
            foreach(fragment ${arg_LDFRAGMENTS})
                list(APPEND component_ldfragments "${component_dir}/${fragment}")
            endforeach()
            set_target_properties(${component_name} PROPERTIES LDFRAGMENTS "${component_ldfragments}")
        endif()

        get_property(pending_components GLOBAL PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS)
        if(arg_REQUIRES)
            foreach(req IN LISTS arg_REQUIRES)
                if(NOT TARGET ${req} AND NOT ${req} IN_LIST pending_components)
                    message(STATUS "Required component '${req}' not yet processed! Addind it to pending components list.")
                    set_property(GLOBAL APPEND PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS ${req})
                    list(APPEND pending_components ${req})
                endif()
                set_property(GLOBAL APPEND PROPERTY ${project_name}_${board_name}_PENDING_LINK_LIBRARIES ${component_name} PUBLIC ${req})
            endforeach()            
        endif()

        if(arg_PRIV_REQUIRES)
            foreach(priv_req IN LISTS arg_PRIV_REQUIRES)
                if(NOT TARGET ${priv_req} AND NOT ${priv_req} IN_LIST pending_components)
                    message(STATUS "Privately required component '${priv_req}' not yet processed! Addind it to pending components list.")
                    set_property(GLOBAL APPEND PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS ${priv_req})
                    list(APPEND pending_components ${priv_req})
                endif()
                set_property(GLOBAL APPEND PROPERTY ${project_name}_${board_name}_PENDING_LINK_LIBRARIES ${component_name} PRIVATE ${priv_req})
            endforeach()
        endif()

    endif()
    
    set_property(GLOBAL APPEND PROPERTY ${project_name}_${board_name}_LIBS ${component_name})
    set(COMPONENT_LIB ${component_name} PARENT_SCOPE)

endfunction()

set(${board_name}_unsupported_components
    mbedtls
    partition_table
    esptool_py
    esp_driver_uart
)

# Register component
function(register_component component_name)
    get_property(subproject_libs GLOBAL PROPERTY ${project_name}_${board_name}_LIBS)
    list(LENGTH subproject_libs subproject_libs_length)
    message(STATUS "Registering component: ${component_name}, Registered components: ${subproject_libs_length}")
    if(${component_name} IN_LIST ${board_name}_unsupported_components)
        message(STATUS "${component_name} is not supported by Embedded Cross Framework!\nThis component will be ignored.")
    else()
        set(${project_name}_${component_name}_cmake "${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/CMakeLists.txt")
        if(EXISTS ${${project_name}_${component_name}_cmake})
            set(IDF_TARGET ${${board_name}_TARGET} PARENT_SCOPE)
            add_subdirectory(${${board_name}_BOARD_COMPONENTS_DIR}/${component_name})
            unset(IDF_TARGET)
            # include(${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}/CMakeLists.txt)
        else()
            message(WARNING "-- Component '${component_name}' not found at ${${${board_name}_BOARD_COMPONENTS_DIR}/${component_name}}")
        endif()
    endif()
endfunction()

# Processing the components from esp-idf
function(process_component_requirements)
    set(pending_components "")
    set(pending_link_libraries "")
    list(APPEND pending_components ${${project_name}_COMPONENT_REQUIREMENTS})

    # We use GLOBAL property to resolve sub_directory scope not being able to share variables back to this scope
    set_property(GLOBAL PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS ${pending_components})
    set_property(GLOBAL PROPERTY ${project_name}_${board_name}_PENDING_LINK_LIBRARIES ${pending_link_libraries})
    set_property(GLOBAL PROPERTY ${project_name}_${board_name}_LIBS "")

    while(pending_components)
        list(GET pending_components 0 component)
        list(REMOVE_AT pending_components 0)
        set_property(GLOBAL PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS ${pending_components})
        register_component(${component})
        get_property(pending_components GLOBAL PROPERTY ${project_name}_${board_name}_PENDING_COMPONENTS)
    endwhile()

endfunction()