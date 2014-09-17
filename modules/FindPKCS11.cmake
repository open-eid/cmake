# - Find pkcs11
# Find the PKCS11 module
#
# PKCS11_MODULE			- pkcs11 module path and name
# PKCS11_MODULE_FOUND	- True if pkcs11 module found.

if( WIN32 )
	set( PKCS11_NAME esteid-pkcs11.dll opensc-pkcs11.dll )
else()
	set( PKCS11_NAME esteid-pkcs11.so opensc-pkcs11.so )
endif()

if( APPLE )
	find_library( PKCS11_MODULE NAMES ${PKCS11_NAME} HINTS /Library/EstonianIDCard/lib /Library/OpenSC/lib )
else()
	list( GET PKCS11_NAME 1 PKCS11_MODULE )
endif()

# handle the QUIETLY and REQUIRED arguments and set PKCS11_MODULE_FOUND to TRUE if 
# all listed variables are TRUE
include( FindPackageHandleStandardArgs )
FIND_PACKAGE_HANDLE_STANDARD_ARGS( PKCS11_Module DEFAULT_MSG PKCS11_MODULE )

MARK_AS_ADVANCED( PKCS11_MODULE )
