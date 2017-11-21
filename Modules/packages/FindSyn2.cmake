find_library( SYN2_LIBRARY
  syn2
  PATHS ${SYN2_ROOT_DIR}/lib
)

find_path( SYN2_INCLUDE_DIR
  NAMES syn2/synapses_reader.hpp
  PATHS ${SYN2_ROOT_DIR}/include
)

if (SYN2_INCLUDE_DIR AND SYN2_LIBRARY)
   SET(SYN2_FOUND TRUE)
endif()

include(FindPackageHandleStandardArgs)

set(SYN2_LIBRARIES ${SYN2_LIBRARY} )
set(SYN2_INCLUDE_DIRS ${SYN2_INCLUDE_DIR} )

find_package_handle_standard_args(SYN2  DEFAULT_MSG SYN2_LIBRARIES SYN2_INCLUDE_DIRS)
mark_as_advanced(SYN2_INCLUDE_DIRS SYN2_LIBRARIES )

