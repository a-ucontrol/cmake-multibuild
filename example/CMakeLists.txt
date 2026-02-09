cmake_minimum_required(VERSION 3.23)

if(NOT FINAL_RELEASE)
  if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/defines.cmake")
    file(COPY_FILE "${CMAKE_CURRENT_LIST_DIR}/../cmake/default.defines.cmake" "${CMAKE_CURRENT_LIST_DIR}/defines.cmake")
  endif()
  include("${CMAKE_CURRENT_LIST_DIR}/defines.cmake")
else()
  include("${CMAKE_CURRENT_LIST_DIR}/../cmake/default.defines.cmake")
endif()

set(MULTIBUILD_PROJECT_NAME AsyncFw-multibuild)

if(NOT MULTIBUILD_VERSION)
  set(MULTIBUILD_VERSION 1.0)
endif()

project(${MULTIBUILD_PROJECT_NAME} VERSION ${MULTIBUILD_VERSION} LANGUAGES C CXX)

if(NOT MULTIBUILD_BINARY_DIR)
  set(MULTIBUILD_BINARY_DIR ${CMAKE_BINARY_DIR})
endif()

include("${CMAKE_CURRENT_LIST_DIR}/../cmake/multibuild.cmake")
if(MULTIBUILD)
  return()
endif()

add_custom_target(project-related-files SOURCES
    ../cmake/default.defines.cmake
  )

if(MULTIBUILD_TARGET)
  set(EXAMPLES_PATH ${MULTIBUILD_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}/${MULTIBUILD_TARGET}/example/)
  add_subdirectory(../AsyncFw ${MULTIBUILD_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}/${MULTIBUILD_TARGET})
elseif(MULTIBUILD_MAIN)
  add_subdirectory(../AsyncFw ${MULTIBUILD_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}/${MULTIBUILD_TARGET} EXCLUDE_FROM_ALL)
endif()

#set(PROJECT_SOURCES
#  main.cpp
#)

set(OUTPUT_DIR ${MULTIBUILD_BINARY_DIR}/multibuild-out)

if(MULTIBUILD_MAIN OR NOT MULTIBUILD_TARGET)
  add_custom_target(
    ${MULTIBUILD_PROJECT_NAME}-final ALL
    DEPENDS "${CMAKE_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}-final-completed" "${OUTPUT_DIR}/git-hash"
  )
  find_package(Git)
  add_custom_command(
    OUTPUT "${CMAKE_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}-final-completed"
    DEPENDS ${CORE_HEADERS} ${ONVIF_HEADERS} ${CONFIG_HEADERS} ${GUI_HEADERS} ${MEDIA_HEADERS} ${MISC_HEADERS}
    COMMAND ${CMAKE_COMMAND} -E echo "----- final -----"
    COMMAND ${CMAKE_COMMAND} -E touch "${CMAKE_BINARY_DIR}/${MULTIBUILD_PROJECT_NAME}-final-completed"
    COMMAND find ${OUTPUT_DIR}
  )
  add_custom_command(
    OUTPUT "${OUTPUT_DIR}/git-hash"
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD > "${OUTPUT_DIR}/git-hash"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
endif()

if(MULTIBUILD_MAIN)
  add_dependencies(${MULTIBUILD_PROJECT_NAME}-final ${MULTIBUILD_PROJECT_NAME}-multibuild-all)
#  add_custom_target(${MULTIBUILD_PROJECT_NAME} SOURCES ${PROJECT_SOURCES})
  return()
endif()


#add_executable(${MULTIBUILD_PROJECT_NAME} ${PROJECT_SOURCES})

if(MULTIBUILD_TARGET)
  set_target_properties(${MULTIBUILD_PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_DIR}/${MULTIBUILD_TARGET}"
    LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_DIR}/${MULTIBUILD_TARGET}"
    ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_DIR}/${MULTIBUILD_TARGET}"
    PREFIX ""
    IMPORT_PREFIX ""
  )
endif()
