set(MULTIBUILD ON)
#set(MULTIBUILD_USES_TERMINAL ON)

if(MULTIBUILD)
  set(MULTIBUILD_TARGET_LIST
    "release||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_CXX_FLAGS=-DLS_NO_TRACE -DLS_NO_DEBUG"
    "release_shared||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_CXX_FLAGS=-DLS_NO_TRACE -DLS_NO_DEBUG|-DBUILD_SHARED_LIBS=ON"
    "release_shared_lto||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DBUILD_SHARED_LIBS=ON|-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
    "release_san_shared||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_C_FLAGS=-g -fsanitize=address,undefined -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_CXX_FLAGS=-g -fsanitize=address,undefined -DLS_NO_TRACE -DLS_NO_DEBUG|-DBUILD_SHARED_LIBS=ON"
    "release_tsan_shared||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_C_FLAGS=-g -fsanitize=thread -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread -DLS_NO_TRACE -DLS_NO_DEBUG|-DBUILD_SHARED_LIBS=ON"
    "debug||_||-DCMAKE_BUILD_TYPE=Debug"
    "debug_shared||_||-DCMAKE_BUILD_TYPE=Debug|-DBUILD_SHARED_LIBS=ON"
    "san||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_C_FLAGS=-g -fsanitize=address,undefined|-DCMAKE_CXX_FLAGS=-g -fsanitize=address,undefined"
    "tsan||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_C_FLAGS=-g -fsanitize=thread|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread"
    "san_shared||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_C_FLAGS=-g -fsanitize=address,undefined|-DCMAKE_CXX_FLAGS=-g -fsanitize=address,undefined|-DBUILD_SHARED_LIBS=ON"
    "tsan_shared||_||-DCMAKE_BUILD_TYPE=Debug|-DCMAKE_C_FLAGS=-g -fsanitize=thread|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread|-DBUILD_SHARED_LIBS=ON"
    "clang_san_shared||_||-DCMAKE_BUILD_TYPE=Release|-DCMAKE_C_FLAGS=-g -fsanitize=address|-DCMAKE_CXX_FLAGS=-g -fsanitize=address|-DCMAKE_C_COMPILER=clang|-DCMAKE_CXX_COMPILER=clang++|-DBUILD_SHARED_LIBS=ON"
    "clang_tsan_shared||_||-DCMAKE_BUILD_TYPE=Release|-DCMAKE_C_FLAGS=-g -fsanitize=thread|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread|-DCMAKE_C_COMPILER=clang|-DCMAKE_CXX_COMPILER=clang++|-DBUILD_SHARED_LIBS=ON"
    "clang_san_shared_lto||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_C_FLAGS=-g -fsanitize=address -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_CXX_FLAGS=-g -fsanitize=address -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_C_COMPILER=clang|-DCMAKE_CXX_COMPILER=clang++|-DBUILD_SHARED_LIBS=ON|-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
    "clang_tsan_shared_lto||_||-DCMAKE_BUILD_TYPE=MinSizeRel|-DCMAKE_C_FLAGS=-g -fsanitize=thread -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_CXX_FLAGS=-g -fsanitize=thread -DLS_NO_TRACE -DLS_NO_DEBUG|-DCMAKE_C_COMPILER=clang|-DCMAKE_CXX_COMPILER=clang++|-DBUILD_SHARED_LIBS=ON|-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
  )
endif()
