set(MULTIBUILD ON)
#set(MULTIBUILD_USES_TERMINAL ON)

if(MULTIBUILD)
  set(MULTIBUILD_TARGET_LIST
    "release||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_CXX_FLAGS=-DLS_NO_TRACE -DLS_NO_DEBUG"
    "release_shared||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_CXX_FLAGS=-DLS_NO_TRACE -DLS_NO_DEBUG|-DBUILD_SHARED_LIBS=ON"
    "debug||_||-DCMAKE_BUILD_TYPE=Debug"
    "san||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_CXX_FLAGS=-g -fsanitize=address,undefined"
    "tsan||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread"
  )
endif()
