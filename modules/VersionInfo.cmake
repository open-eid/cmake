if( $ENV{BUILD_NUMBER} )
	set( BUILD_VER $ENV{BUILD_NUMBER} )
elseif(PROJECT_VERSION_TWEAK)
	set( BUILD_VER ${PROJECT_VERSION_TWEAK} )
else()
	set( BUILD_VER 0 )
endif()

set( VERSION ${PROJECT_VERSION}.${BUILD_VER} )
add_definitions(
	-DMAJOR_VER=${PROJECT_VERSION_MAJOR}
	-DMINOR_VER=${PROJECT_VERSION_MINOR}
	-DRELEASE_VER=${PROJECT_VERSION_PATCH}
	-DBUILD_VER=${BUILD_VER}
)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
set(MACOSX_BUNDLE_COPYRIGHT "(C) 2010-2024 Estonian Information System Authority")
set( MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION} )
set( MACOSX_BUNDLE_BUNDLE_VERSION ${BUILD_VER} )
set( MACOSX_BUNDLE_ICON_FILE Icon.icns )

macro( SET_ENV NAME DEF )
	if( DEFINED ENV{${NAME}} )
		set( ${NAME} $ENV{${NAME}} ${ARGN} )
	else()
		set( ${NAME} ${DEF} ${ARGN} )
	endif()
endmacro()
