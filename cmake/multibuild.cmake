if(NOT MULTIBUILD_TARGET AND NOT MULTIBUILD_MAIN)
  if(NOT MULTIBUILD_PROJECT_NAME)
    set(MULTIBUILD_PROJECT_NAME ${CMAKE_PROJECT_NAME})
    message("MULTIBUILD_PROJECT_NAME:" ${CMAKE_PROJECT_NAME})
  endif()
else()
  set(MULTIBUILD OFF)
  return()
endif()

if(NOT MULTIBUILD_BINARY_DIR)
  set(MULTIBUILD_BINARY_DIR ${CMAKE_BINARY_DIR})
  message("Multibuild binary dir: ${MULTIBUILD_BINARY_DIR}")
endif()

if (MULTIBUILD)
  if(NOT MULTIBUILD_TARGET_LIST)
    set(MULTIBUILD_TARGET_LIST
#      "name||CMAKE_COMMAND or _||CMAKE_ARGS"
      "release||_||-DCMAKE_BUILD_TYPE=MinSizeRel"
      "san||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_CXX_FLAGS=-g -fsanitize=address,undefined"
    )
  endif()

  add_custom_target(${MULTIBUILD_PROJECT_NAME}-multibuild-main ALL)
  add_custom_target(${MULTIBUILD_PROJECT_NAME}-multibuild-all ALL)

  list(LENGTH MULTIBUILD_TARGET_LIST MULTIBUILD_TARGET_LIST_SIZE)
  message("Target count: " ${MULTIBUILD_TARGET_LIST_SIZE})
  if(NOT MULTIBUILD_USES_TERMINAL)
    include(ProcessorCount)
    ProcessorCount(PC)
    message("Processor count: " ${PC})
    math(EXPR PC "${PC} / ${MULTIBUILD_TARGET_LIST_SIZE}")
    if(NOT PC EQUAL 0)
      set(BUILD_FLAGS -j${PC})
    else()
      set(BUILD_FLAGS -j1)
    endif()
    message("Processor count for target: " ${PC})
  endif()
  include(ExternalProject)
  macro (target_setup target_name target_cmake_command target_cmake_args)
    if(NOT ${target_cmake_command} STREQUAL _)
      set(MULTIBUILD_CMAKE_COMMAND ${target_cmake_command})
    else()
      set(MULTIBUILD_CMAKE_COMMAND ${CMAKE_COMMAND})
    endif()
    if(NOT target_cmake_args STREQUAL _)
      foreach(T ${target_cmake_args})
        string (REPLACE "|" ";" A "${T}")
      endforeach()
     set(MULTIBUILD_CMAKE_ARGS ${A})
    endif()
    ExternalProject_Add(${MULTIBUILD_PROJECT_NAME}-${target_name}
      SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}"
      CMAKE_ARGS -DMULTIBUILD_TARGET=${target_name} ${MULTIBUILD_CMAKE_ARGS} -DMULTIBUILD_BINARY_DIR=${MULTIBUILD_BINARY_DIR}
      CMAKE_COMMAND ${MULTIBUILD_CMAKE_COMMAND}
      BUILD_COMMAND ${MULTIBUILD_CMAKE_COMMAND} --build . ${BUILD_FLAGS}
      INSTALL_COMMAND ""
      USES_TERMINAL_CONFIGURE ${MULTIBUILD_USES_TERMINAL}
      USES_TERMINAL_BUILD ${MULTIBUILD_USES_TERMINAL}
      BUILD_ALWAYS ON)
    set(CLEAN_DIRS "${CLEAN_DIRS}\;${CMAKE_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}-${target_name}-prefix")
    add_dependencies(${MULTIBUILD_PROJECT_NAME}-multibuild-all ${MULTIBUILD_PROJECT_NAME}-${target_name})
    add_dependencies(${MULTIBUILD_PROJECT_NAME}-${target_name} ${MULTIBUILD_PROJECT_NAME}-multibuild-main)
  endmacro()

  foreach(T ${MULTIBUILD_TARGET_LIST})
    message(${T})
    string (REPLACE "||" ";" A "${T}")
    target_setup(${A})
  endforeach()

  set(MULTIBUILD_MAIN ON)
  add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR} ${MULTIBUILD_PROJECT_NAME}-main)

  if(TARGET ${MULTIBUILD_PROJECT_NAME})
    set_target_properties(${MULTIBUILD_PROJECT_NAME} PROPERTIES ADDITIONAL_CLEAN_FILES ${CLEAN_DIRS}\;${MULTIBUILD_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME})
  endif()
endif()
