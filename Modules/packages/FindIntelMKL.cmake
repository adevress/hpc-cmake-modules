#  find MKL Library
# -------------------------
#
# FindPackage file to find Intel MKL Library
#
# Created to overcome the limitations and problems MKL might have with dlopen, python and some compilers
#
# Contrary to the official FindMKL or "-mkl" intel option, this package use simple direct linking without# mkl_rt
#
# https://software.intel.com/en-us/articles/symbol-lookup-error-when-linking-intel-mkl-with-gcc-on-ubuntu
# https://github.com/BVLC/caffe/issues/3884
# https://answers.launchpad.net/dolfin/+question/205219
#
# INPUTS
#   MKL_ARCH_BACKEND    define the MKl backend to use : AVX(default), AVX2, AVX512 
#                       Check which instruction set your processor support
#                       
# OUTPUTS
#  MKL_DEFINITIONS      compiler flags for compiling with MKL
#  MKL_INCLUDE_DIRS     where to find hdf5.h
#  MKL_LIBRARIES        All libraries and dependencies for HDF5
#  MKL_FOUND        if false, do not try to use MKL
#
#


include(FindPackageHandleStandardArgs)

set(MKL_ARCH_BACKEND "AVX" CACHE STRING "define the MKl backend to use")


list(APPEND MKL_HELPER_LIBPATH 
    "${MKL_ROOT}/lib"
    "${MKL_ROOT}/lib/intel64/"
    "${MKL_ROOT}/lib64/intel64" 
)

find_path(MKL_INCLUDE_DIRS
  NAMES mkl.h
  PATHS ${MKL_ROOT}/include
)

find_library(MKL_CORE_LIBRARY
    NAMES mkl_core 
    PATHS ${MKL_HELPER_LIBPATH}
)

# 
# TODO : Need to be selected with an input switch
# if we want to select sequential, openmp, tbb, gnu thread, or intel thread
# select just sequential for now which satisfy the common use case
find_library(MKL_THREADING_LIBRARY
    NAMES mkl_sequential
    PATHS ${MKL_HELPER_LIBPATH}
)



#
# TODO: this need to have a switch to select the right library depending of 
# the compiler : Intel ICC, GCC or PGI
# For now we support only Intel ICC, if you use MKL you should have ICC anyway
#
find_library(MKL_LP_LIBRARY
    NAMES mkl_intel_lp64
    PATHS ${MKL_HELPER_LIBPATH}
)

#
# Default VML library -> AVX, if you want it differently set MKL_ARCH_BACKEND
# 
#
if(MKL_ARCH_BACKEND STREQUAL "AVX2")

    find_library(MKL_VML_LIBRARY
        NAMES mkl_vml_avx2
        PATHS ${MKL_HELPER_LIBPATH}
    )
elseif(MKL_ARCH_BACKEND STREQUAL "AVX512")

       find_library(MKL_VML_LIBRARY
        NAMES mkl_vml_avx512
        PATHS ${MKL_HELPER_LIBPATH}
    )
else()

    find_library(MKL_VML_LIBRARY
        NAMES mkl_vml_avx
        PATHS ${MKL_HELPER_LIBPATH}
    )
endif()

include(FindPackageHandleStandardArgs)

list(APPEND MKL_LIBRARIES
    ${MKL_CORE_LIBRARY}
    ${MKL_THREADING_LIBRARY}
    ${MKL_LP_LIBRARY}
    ${MKL_VML_LIBRARY}
)

set(MKL_LIBRARIES ${MKL_LIBRARIES})
set(MKL_INCLUDE_DIRS ${MKL_INCLUDE_DIR} )

find_package_handle_standard_args(MKL  DEFAULT_MSG MKL_INCLUDE_DIRS MKL_CORE_LIBRARY MKL_THREADING_LIBRARY MKL_LP_LIBRARY MKL_VML_LIBRARY )
mark_as_advanced(MKL_INCLUDE_DIRS MKL_LIBRARIES)

