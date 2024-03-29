# - Find XSD
# Find XSD includes and executable
#
#  XSD_INCLUDE_DIR - Where to find xsd include sub-directory.
#  XSD_EXECUTABLE  - XSD compiler.

FIND_PATH(XSD_INCLUDE_DIR xsd/cxx/config.hxx PATH_SUFFIXES libxsd)
FIND_PROGRAM(XSD_EXECUTABLE NAMES xsdcxx xsdgen xsd)
if(XSD_EXECUTABLE)
  execute_process (COMMAND ${XSD_EXECUTABLE} "--version" OUTPUT_VARIABLE EXEC_OUT)
  string(REGEX REPLACE ".*compiler ([0-9]+)\\.([0-9]+)\\.([0-9]+).*" "\\1" XSD_VERSION_MAJOR ${EXEC_OUT})
  string(REGEX REPLACE ".*compiler ([0-9]+)\\.([0-9]+)\\.([0-9]+).*" "\\2" XSD_VERSION_MINOR ${EXEC_OUT})
  string(REGEX REPLACE ".*compiler ([0-9]+)\\.([0-9]+)\\.([0-9]+).*" "\\3" XSD_VERSION_PATCH ${EXEC_OUT})
  set(XSD_VERSION "${XSD_VERSION_MAJOR}.${XSD_VERSION_MINOR}.${XSD_VERSION_PATCH}")
  set(XSD_VERSION_COUNT 3)
endif()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(XSD REQUIRED_VARS XSD_EXECUTABLE XSD_INCLUDE_DIR VERSION_VAR XSD_VERSION)
MARK_AS_ADVANCED( XSD_EXECUTABLE XSD_INCLUDE_DIR )

macro( XSD_SCHEMA SOURCES HEADERS OUTPUT INPUT )
    get_filename_component( BASE "${INPUT}" NAME_WE )
    list( APPEND ${SOURCES} ${OUTPUT}/${BASE}.cxx )
    list( APPEND ${HEADERS} ${OUTPUT}/${BASE}.hxx )
    add_custom_command(
        OUTPUT ${OUTPUT}/${BASE}.cxx ${OUTPUT}/${BASE}.hxx
        COMMAND ${CMAKE_COMMAND} -E make_directory ${OUTPUT}
        COMMAND ${XSD_EXECUTABLE} cxx-tree
            --type-naming ucc
            --function-naming lcc
            --generate-serialization
            --suppress-assignment
            --std c++11
            --output-dir ${OUTPUT}
            ${ARGN}
            ${INPUT}
        DEPENDS ${INPUT}
    )
endmacro()
