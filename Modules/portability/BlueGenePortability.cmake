##
## Portability check on Blue Gene Q environment

if(IS_DIRECTORY "/bgsys")
    set(BLUEGENE TRUE)
endif()


if(BLUEGENE)
# define library type to static on BGQ
set(COMPILE_LIBRARY_TYPE "STATIC")
else()

if(NOT COMPILE_LIBRARY_TYPE)
    set(COMPILE_LIBRARY_TYPE "SHARED")
endif()

endif()


# cmake > 3.0 add -Wl,-BDynamic for any linking argument
# which does not match the library pattern *.a
# this is annoying and cause the pkg_search_module _LIBRARIES to bug
# in case of static linking
# this macro fix this issue once for all 
macro(fix_bgq_static_linking INPUT_LIST OUTPUT_LIST )
        if("${CMAKE_VERSION}" VERSION_GREATER "3.0")

		set(LOCAL_LIST)

		LIST(APPEND LOCAL_LIST "-Wl,-Bstatic")
		LIST(APPEND LOCAL_LIST "${INPUT_LIST}")

		SET(${OUTPUT_LIST} ${LOCAL_LIST})
	else()
		set(${OUTPUT_LIST} "${INPUT_LIST}")

	endif()

endmacro()



