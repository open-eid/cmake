# - Find XML-Security-C
# Find the XML-Security-C includes and library
#
#  XmlSecurityC_INCLUDE_DIR - Where to find xsec include sub-directory.
#  XmlSecurityC_LIBRARIES   - List of libraries when using XML-Security-C.
#  XmlSecurityC_FOUND       - True if XML-Security-C found.

unset(XmlSecurityC_REQUIRED)
if(XmlSecurityC_FIND_REQUIRED)
  set(XmlSecurityC_REQUIRED REQUIRED)
endif()
find_package(XercesC ${XmlSecurityC_REQUIRED})
find_package(OpenSSL ${XmlSecurityC_REQUIRED})
find_package(XalanC)
unset(XmlSecurityC_REQUIRED)

find_path(XmlSecurityC_INCLUDE_DIR xsec/framework/XSECVersion.hpp)
find_library(XmlSecurityC_LIBRARY_RELEASE NAMES xml-security-c xsec_1 xsec_2 DOC "Xml-Security-C++ libraries (release)")
find_library(XmlSecurityC_LIBRARY_DEBUG NAMES xml-security-c xsec_1D xsec_2D DOC "Xml-Security-C++ libraries (debug)")
include(SelectLibraryConfigurations)
select_library_configurations(XmlSecurityC)
mark_as_advanced(XmlSecurityC_INCLUDE_DIR XmlSecurityC_LIBRARY_RELEASE XmlSecurityC_LIBRARY_DEBUG)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(XmlSecurityC DEFAULT_MSG XmlSecurityC_LIBRARY XmlSecurityC_INCLUDE_DIR XalanC_FOUND XercesC_FOUND OPENSSL_FOUND)

if(XmlSecurityC_FOUND)
  set(XmlSecurityC_INCLUDE_DIRS ${XmlSecurityC_INCLUDE_DIR} ${XercesC_INCLUDE_DIR} ${OPENSSL_INCLUDE_DIR})
  set(XmlSecurityC_LIBRARIES ${XmlSecurityC_LIBRARY} ${XercesC_LIBRARY} ${OPENSSL_LIBRARIES})
  set(XmlSecurityC_DEPS XercesC::XercesC OpenSSL::SSL)

  if(XalanC_FOUND)
    list(INSERT XmlSecurityC_INCLUDE_DIRS 1 ${XalanC_INCLUDE_DIR})
    list(INSERT XmlSecurityC_LIBRARIES 1 ${XalanC_LIBRARY})
    list(INSERT XmlSecurityC_DEPS 0 XalanC::XalanC)

    find_library(XalanMSG_LIBRARY NAMES xalanMsg XalanMessages_1)
    list(INSERT XmlSecurityC_LIBRARIES 2 ${XalanMSG_LIBRARY})
    if(NOT TARGET XalanMSG::XalanMSG AND NOT ${BUILD_SHARED_LIBS})
      add_library(XalanMSG::XalanMSG UNKNOWN IMPORTED)
      set_target_properties(XalanMSG::XalanMSG PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${XalanMSG_LIBRARY}")
      list(INSERT XmlSecurityC_DEPS 1 XalanMSG::XalanMSG)
    endif()
  endif()

  if(NOT TARGET XmlSecurityC::XmlSecurityC)
    add_library(XmlSecurityC::XmlSecurityC UNKNOWN IMPORTED)
    set_target_properties(XmlSecurityC::XmlSecurityC PROPERTIES
      INTERFACE_LINK_LIBRARIES "${XmlSecurityC_DEPS}")
    if(XmlSecurityC_INCLUDE_DIRS)
      set_target_properties(XmlSecurityC::XmlSecurityC PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        INTERFACE_INCLUDE_DIRECTORIES "${XmlSecurityC_INCLUDE_DIRS}")
    endif()
    if(EXISTS "${XmlSecurityC_LIBRARY}")
      set_target_properties(XmlSecurityC::XmlSecurityC PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${XmlSecurityC_LIBRARY}")
    endif()
    if(EXISTS "${XmlSecurityC_LIBRARY_RELEASE}")
      set_property(TARGET XmlSecurityC::XmlSecurityC APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(XmlSecurityC::XmlSecurityC PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
        IMPORTED_LOCATION_RELEASE "${XmlSecurityC_LIBRARY_RELEASE}")
    endif()
    if(EXISTS "${XmlSecurityC_LIBRARY_DEBUG}")
      set_property(TARGET XmlSecurityC::XmlSecurityC APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(XmlSecurityC::XmlSecurityC PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
        IMPORTED_LOCATION_DEBUG "${XmlSecurityC_LIBRARY_DEBUG}")
    endif()
  endif()
endif()
