# Find all directories grouped by their parent directory
macro(find_grouped_directories group_basedir dir_basename_list)
    file(GLOB top_level RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir} ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir}/*)
    foreach(top_level_category ${top_level})
        file(GLOB sub_dirs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir}/${top_level_category} ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir}/${top_level_category}/*)
        foreach(sub_dir ${sub_dirs})
            if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir}/${top_level_category}/${sub_dir})
                set(${group_basedir}_${sub_dir}_DIR ${CMAKE_CURRENT_SOURCE_DIR}/${group_basedir}/${top_level_category}/${sub_dir})
                set(${group_basedir}_${sub_dir}_CATEGORY ${top_level_category})
                list(APPEND ${dir_basename_list} ${sub_dir})
            endif()
        endforeach()
    endforeach()
    list(REMOVE_DUPLICATES ${dir_basename_list})
endmacro()

# Find all projects
macro(find_projects project_list)
    find_grouped_directories(projects ${project_list})
endmacro()

# Find all boards
macro(find_boards board_list)
    find_grouped_directories(boards ${board_list})
endmacro()

# Find firmware
macro(find_firmware firmware_list)
    find_grouped_directories(firmware ${firmware_list})
endmacro()

# Check or set the BOARD variable against/to supported boards
macro(check_boards valid_boards)
    if(NOT BOARDS OR BOARDS STREQUAL "ALL_BOARDS")
        set(BOARDS ${valid_boards})
    else()
        if (NOT BOARDS MATCHES ${valid_boards})
            message(FATAL_ERROR "Board(s) ${BOARDS} not supported by ${PROJECT}")
        endif()
    endif()
endmacro()

# Build the given projects for the given boards.
macro(build_projects_for_boards projects boards valid_projects)
    foreach(project ${projects})
        cmake_path(GET project FILENAME project_name)
        if(IS_ABSOLUTE ${project})
            set(${project_name}_DIR ${project})
            include(${project}/project.cmake)
        elseif(project MATCHES ${valid_projects})
            set(${project_name}_DIR ${projects_${project_name}_DIR})
            set(${project_name}_CATEGORY ${projects_${project_name}_CATEGORY})
            include(${${project_name}_DIR}/project.cmake)
        else()
            message(FATAL_ERROR "Project ${project} not in supported projects: ${valid_projects}")
        endif()
        set(${project_name}_VERSION
            ${${project_name}_VERSION_MAJOR}.${${project_name}_VERSION_MINOR}.${${project_name}_VERSION_PATCH})
        set(${project_name}_VERSION_STRING
            "${${project_name}_VERSION_MAJOR}.${${project_name}_VERSION_MINOR}.${${project_name}_VERSION_PATCH}")
        foreach(board ${boards})
            cmake_path(GET board FILENAME board_name)
            message(STATUS "Building project ${project_name} for board ${board_name}")
            if(IS_ABSOLUTE ${board})
                set(${board_name}_DIR ${board})
                include(${board}/board.cmake)
            # else check if board.cmake file exists in the board directory
            elseif(EXISTS ${boards_${board}_DIR}/board.cmake)
                set(${board_name}_DIR ${boards_${board}_DIR})
                include(${boards_${board}_DIR}/board.cmake)
            else()
                message(FATAL_ERROR "Board ${board} not found.")
            endif()
            if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/boards/${board}/include)
                list(APPEND ${board}_INCDIR ${CMAKE_CURRENT_SOURCE_DIR}/boards/${board}/include)
            endif()
            if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/boards/${board}/libs)
                list(APPEND ${board}_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/boards/${board}/libs)
            endif()
        endforeach()
        build_project_for_boards(${project} ${boards})
    endforeach()
endmacro()

# Build the project for the given boards
macro(build_project_for_boards project boards)
    foreach(board ${boards})
        cmake_path(GET board FILENAME board_name)
        set(subproject ${project}_${board_name})
        set(executable ${subproject}.elf)
        if (${board} IN_LIST ${project}_BOARDS OR NOT ${project}_BOARDS)
            build_subproject_for_board(${project} ${board} ${subproject} ${executable})
        else()
            message(STATUS "Project ${project} does not support board ${board} (supported boards: ${${project}_BOARDS})")
        endif()
    endforeach()
endmacro()

# Build the subproject for the given board
macro(build_subproject_for_board project board subproject executable)
    add_executable(${executable} ${${board}_SOURCES} ${${project}_SOURCES} ${${subproject}_SOURCES})
    target_include_directories(${executable} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${OS_INCDIR}
        ${DRIVER_INCDIR}
        ${${board}_INCDIR}
        ${${project}_INCDIR}
        ${${subproject}_INCDIR}
    )

    target_link_libraries(${executable} PRIVATE
        ${TOOLCHAIN_LIBS}
        ${OS_LIBS}
        ${DRIVER_LIBS}
        ${${board}_LIBS}
        ${${project}_LIBS}
        ${${subproject}_LIBS}
    )

    # Create hex, bin, and s-records
    add_custom_command(TARGET ${executable} POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${executable}> ${executable}.hex
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${executable}> ${executable}.bin
        COMMAND ${CMAKE_OBJCOPY} -Osrec --srec-len=64 $<TARGET_FILE:${executable}> ${executable}.s19
    )

    # Print the binary size
    add_custom_command(TARGET ${executable} POST_BUILD
        COMMAND ${CMAKE_SIZE} ${executable}
    )

    # Install the binary on the board
    if(INSTALL_SCRIPT)
        if(INSTALL_SCRIPT_ARGS)
            install(CODE "execute_process(COMMAND ${INSTALL_SCRIPT} ${INSTALL_SCRIPT_ARGS} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        else()
            install(CODE "execute_process(COMMAND ${INSTALL_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        endif()
    elseif(${${subproject}_INSTALL_SCRIPT})
        if(${${subproject}_INSTALL_SCRIPT_ARGS})
            install(CODE "execute_process(COMMAND ${${subproject}_INSTALL_SCRIPT} ${${subproject}_INSTALL_SCRIPT_ARGS} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        else()
            install(CODE "execute_process(COMMAND ${${subproject}_INSTALL_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        endif()
    elseif(${${project}_INSTALL_SCRIPT})
        if(${${project}_INSTALL_SCRIPT_ARGS})
            install(CODE "execute_process(COMMAND ${${project}_INSTALL_SCRIPT} ${${project}_INSTALL_SCRIPT_ARGS} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        else()
            install(CODE "execute_process(COMMAND ${${project}_INSTALL_SCRIPT} ${CMAKE_CURRENT_BINARY_DIR}/${executable}.bin)")
        endif()
    endif(INSTALL_SCRIPT)
endmacro(build_subproject_for_board)
