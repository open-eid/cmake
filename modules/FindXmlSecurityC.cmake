# - Find XML-Security-C
# Find the XML-Security-C includes and library
#
#  XMLSECURITYC_INCLUDE_DIR - Where to find xsec include sub-directory.
#  XMLSECURITYC_LIBRARIES   - List of libraries when using XML-Security-C.
#  XMLSECURITYC_FOUND       - True if XML-Security-C found.


IF (XMLSECURITYC_INCLUDE_DIR)
  # Already in cache, be silent.
  SET(XMLSECURITYC_FIND_QUIETLY TRUE)
ENDIF (XMLSECURITYC_INCLUDE_DIR)

FIND_PATH(XALANC_INCLUDE_DIR xalanc/XalanTransformer/XalanTransformer.hpp PATH_SUFFIXES include HINTS ${CMAKE_INSTALL_PREFIX})
FIND_PATH(XMLSECURITYC_INCLUDE_DIR xsec/utils/XSECPlatformUtils.hpp PATH_SUFFIXES include HINTS ${CMAKE_INSTALL_PREFIX})

FIND_LIBRARY(XALANC_LIBRARY NAMES xalan-c xalan-C_1 PATH_SUFFIXES lib HINTS ${CMAKE_INSTALL_PREFIX})
FIND_LIBRARY(XALANMSG_LIBRARY NAMES xalanMsg XalanMessages_1 PATH_SUFFIXES lib HINTS ${CMAKE_INSTALL_PREFIX})
FIND_LIBRARY(XMLSECURITYC_LIBRARY NAMES xml-security-c xsec_1 PATH_SUFFIXES lib HINTS ${CMAKE_INSTALL_PREFIX})

# Handle the QUIETLY and REQUIRED arguments and set XMLSECURITYC_FOUND to
# TRUE if all listed variables are TRUE.
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(XmlSecurityC DEFAULT_MSG XMLSECURITYC_LIBRARY XMLSECURITYC_INCLUDE_DIR)

IF(XMLSECURITYC_FOUND)
  SET(XMLSECURITYC_INCLUDE_DIRS ${XMLSECURITYC_INCLUDE_DIR})
  SET(XMLSECURITYC_LIBRARIES ${XMLSECURITYC_LIBRARY})
  IF(XALANC_LIBRARY)
    LIST(APPEND XMLSECURITYC_INCLUDE_DIRS ${XALANC_INCLUDE_DIR})
    LIST(APPEND XMLSECURITYC_LIBRARIES ${XALANC_LIBRARY})
  ENDIF()
ELSE()
  SET(XMLSECURITYC_INCLUDE_DIRS)
  SET(XMLSECURITYC_LIBRARIES)
ENDIF()

MARK_AS_ADVANCED(XMLSECURITYC_LIBRARY XMLSECURITYC_INCLUDE_DIR XALANC_LIBRARY XALANC_INCLUDE_DIR XALANMSG_LIBRARY)
