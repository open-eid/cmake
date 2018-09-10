if( $ENV{BUILD_NUMBER} )
	set( BUILD_VER $ENV{BUILD_NUMBER} )
elseif(PROJECT_VERSION_TWEAK)
	set( BUILD_VER ${PROJECT_VERSION_TWEAK} )
else()
	set( BUILD_VER 0 )
endif()
if(NOT BUILD_DATE)
	string(TIMESTAMP BUILD_DATE "%d.%m.%Y")
endif()

set( VERSION ${PROJECT_VERSION}.${BUILD_VER} )
add_definitions(
	-DMAJOR_VER=${PROJECT_VERSION_MAJOR}
	-DMINOR_VER=${PROJECT_VERSION_MINOR}
	-DRELEASE_VER=${PROJECT_VERSION_PATCH}
	-DBUILD_VER=${BUILD_VER}
	-DVER_SUFFIX=\"$ENV{VER_SUFFIX}\"
	-DBUILD_DATE=\"${BUILD_DATE}\"
)

set(CMAKE_C_VISIBILITY_PRESET hidden) 
set(CMAKE_CXX_VISIBILITY_PRESET hidden) 
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set( MACOSX_BUNDLE_COPYRIGHT "(C) 2010-2018 Estonian Information System Authority" )
set( MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION} )
set( MACOSX_BUNDLE_BUNDLE_VERSION ${BUILD_VER} )
set( MACOSX_BUNDLE_ICON_FILE Icon.icns )
set( MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${PROJECT_VERSION} )
set( MACOSX_FRAMEWORK_BUNDLE_VERSION ${BUILD_VER} )
if( APPLE AND NOT IOS AND NOT CMAKE_OSX_DEPLOYMENT_TARGET )
	execute_process(COMMAND xcodebuild -version -sdk macosx SDKVersion
		OUTPUT_VARIABLE CMAKE_OSX_DEPLOYMENT_TARGET OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()
if( APPLE AND NOT CMAKE_OSX_SYSROOT )
	execute_process(COMMAND xcodebuild -version -sdk macosx Path
		OUTPUT_VARIABLE CMAKE_OSX_SYSROOT OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

macro( SET_APP_NAME OUTPUT NAME )
	set( ${OUTPUT} "${NAME}" )
	add_definitions( -DAPP=\"${NAME}\" )
	set( MACOSX_BUNDLE_BUNDLE_NAME ${NAME} )
	set( MACOSX_BUNDLE_GUI_IDENTIFIER "ee.ria.${NAME}" )
	if( APPLE )
		file( GLOB_RECURSE RESOURCE_FILES
			${CMAKE_CURRENT_SOURCE_DIR}/mac/Resources/*.icns
			${CMAKE_CURRENT_SOURCE_DIR}/mac/Resources/*.strings )
		foreach( _file ${RESOURCE_FILES} )
			get_filename_component( _file_dir ${_file} PATH )
			file( RELATIVE_PATH _file_dir ${CMAKE_CURRENT_SOURCE_DIR}/mac ${_file_dir} )
			set_source_files_properties( ${_file} PROPERTIES MACOSX_PACKAGE_LOCATION ${_file_dir} )
		endforeach( _file )
	endif( APPLE )
endmacro()

macro( add_manifest TARGET )
	if( WIN32 )
		add_custom_command(TARGET ${TARGET} POST_BUILD
			COMMAND mt -nologo -manifest "${CMAKE_MODULE_PATH}/win81.exe.manifest" -outputresource:"$<TARGET_FILE:${TARGET}>")
	endif()
endmacro()

macro( SET_ENV NAME DEF )
	if( DEFINED ENV{${NAME}} )
		set( ${NAME} $ENV{${NAME}} ${ARGN} )
	else()
		set( ${NAME} ${DEF} ${ARGN} )
	endif()
endmacro()
