set( MAJOR_VER 3 )
set( MINOR_VER 12 )
set( RELEASE_VER 0 )
set( BUILD_VER 0 )
if( $ENV{BUILD_NUMBER} )
	set( BUILD_VER $ENV{BUILD_NUMBER} )
endif()

if( WIN32 )
	execute_process( COMMAND "cmd.exe" "/C date /T" OUTPUT_VARIABLE BUILD_DATE )
	string( STRIP BUILD_DATE ${BUILD_DATE} )
	string( REGEX REPLACE ".*([0-3][0-9]).([0-1][0-9]).([0-9][0-9][0-9][0-9]).*" "\\1.\\2.\\3" BUILD_DATE ${BUILD_DATE} )
elseif( UNIX )
	execute_process( COMMAND "date" "+%d.%m.%Y" OUTPUT_VARIABLE BUILD_DATE OUTPUT_STRIP_TRAILING_WHITESPACE )
else()
	message( SEND_ERROR "date not implemented")
	set( BUILD_DATE "00.00.0000" )
endif()

set( VERSION ${MAJOR_VER}.${MINOR_VER}.${RELEASE_VER}.${BUILD_VER} )
add_definitions(
	-DMAJOR_VER=${MAJOR_VER}
	-DMINOR_VER=${MINOR_VER}
	-DRELEASE_VER=${RELEASE_VER}
	-DBUILD_VER=${BUILD_VER}
	-DVER_SUFFIX=\"$ENV{VER_SUFFIX}\"
	-DBUILD_DATE=\"${BUILD_DATE}\"
	-DDOMAINURL=\"ria.ee\"
	-DORG=\"RIA\"
)

set( MACOSX_BUNDLE_COPYRIGHT "(C) 2010-2015 Estonian Information System Authority" )
set( MACOSX_BUNDLE_SHORT_VERSION_STRING ${MAJOR_VER}.${MINOR_VER}.${RELEASE_VER} )
set( MACOSX_BUNDLE_BUNDLE_VERSION ${BUILD_VER} )
set( MACOSX_BUNDLE_ICON_FILE Icon.icns )
set( MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${MAJOR_VER}.${MINOR_VER}.${RELEASE_VER} )
set( MACOSX_FRAMEWORK_BUNDLE_VERSION ${BUILD_VER} )

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
			COMMAND mt -manifest "${CMAKE_MODULE_PATH}/win81.exe.manifest" -outputresource:"$<TARGET_FILE:${TARGET}>")
	endif()
endmacro()

macro( SET_EX NAME VAR DEF )
	if( "${VAR}" STREQUAL "" )
		set( ${NAME} ${DEF} ${ARGN} )
	else()
		set( ${NAME} ${VAR} ${ARGN} )
	endif()
endmacro()

if(CMAKE_COMPILER_IS_GNUCC OR __COMPILER_GNU)
	if(NOT DEFINED ENABLE_VISIBILITY)
		set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden") 
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden")
		#set( CMAKE_C_VISIBILITY_PRESET hidden )
		#set( CMAKE_CXX_VISIBILITY_PRESET hidden )
		#set( CMAKE_VISIBILITY_INLINES_HIDDEN 1 )
	endif()

	if(NOT DISABLE_CXX11)
		include(CheckCXXCompilerFlag)
		CHECK_CXX_COMPILER_FLAG(-std=c++11 C11)
		CHECK_CXX_COMPILER_FLAG(-std=c++0x C0X)
		if(C11)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
		elseif(C0X)
			set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
		endif()
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++0x")
	endif()
	if(APPLE)
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
	endif()
endif()
