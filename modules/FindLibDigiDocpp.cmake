# - Find LibDigiDocpp
# Find the native LibDigiDocpp includes and library
#
#  LIBDIGIDOCPP_INCLUDE_DIR - where to find Container.h, etc.
#  LIBDIGIDOCPP_LIBRARIES   - List of libraries when using LibDigiDocpp.
#  LIBDIGIDOCPP_FOUND       - True if LibDigiDocpp found.


find_path(LIBDIGIDOCPP_INCLUDE_DIR digidocpp/Container.h)
if(NOT LIBDIGIDOCPP_LIBRARY)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(ARCH x64)
	else()
		set(ARCH x86)
	endif()
	find_library(LIBDIGIDOCPP_LIBRARY_RELEASE NAMES digidocpp PATH_SUFFIXES ${ARCH})
	find_library(LIBDIGIDOCPP_LIBRARY_DEBUG NAMES digidocppd PATH_SUFFIXES ${ARCH})
	include(SelectLibraryConfigurations)
	select_library_configurations(LIBDIGIDOCPP)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibDigiDocpp
	DEFAULT_MSG LIBDIGIDOCPP_LIBRARY LIBDIGIDOCPP_INCLUDE_DIR)

mark_as_advanced(LIBDIGIDOCPP_LIBRARY LIBDIGIDOCPP_INCLUDE_DIR)
