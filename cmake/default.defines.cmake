set(MULTIBUILD ON)
#set(MULTIBUILD_USES_TERMINAL ON)

if(ASAN_UBNSAN_ENABLE)
  set(SANITIZE_COMPILE_OPTIONS -g -fsanitize=address,undefined)
  set(SANITIZE_LINK_LIBRARIES -Wl,-Bstatic,-lasan,-lubsan,-Bdynamic)
elseif(TSAN_ENABLE)
  set(SANITIZE_COMPILE_OPTIONS -g -fsanitize=thread)
  set(SANITIZE_LINK_LIBRARIES tsan)
endif()

if(MULTIBUILD)
  set(MULTIBUILD_TARGET_LIST
  "release|_|-DCMAKE_BUILD_TYPE=MinSizeRel"
  "debug|_|-DCMAKE_BUILD_TYPE=Debug"
  "asan_ubsan|_|-DCMAKE_BUILD_TYPE=Debug -DASAN_UBNSAN_ENABLE=ON"
  "tsan|_|-DCMAKE_BUILD_TYPE=Debug -DTSAN_ENABLE=ON"
  )
endif()
