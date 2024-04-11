#cs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Name..................: ADSystemInfo_UDF
    Description...........: Active Directory SysInfo
    Documentation.........: https://ss64.com/vb/syntax-userinfo.html
    Author................: exorcistas@github.com
    Modified..............: 2020-02-26
    Version...............: v1.0
#ce ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#include-once

#Region GLOBAL_VARS
    Global Const $_ADSI_LDAP_URL = "LDAP://"
    Global Const $_ADSI_ORG_UNITS = "OU=@OU1"       ;-- Organizational Unit: replace "@OUs" with relevant values, separated with commas
    Global Const $_ADSI_DOM_COMPONENTS = "DC=@DC1"  ;-- Domain Component: replace "@DCs" with relevant values, separated with commas
    Global Const $_ADSI_USER_OBJ = "CN=@USERID" & "," & $_ADSI_ORG_UNITS & "," & $_ADSI_DOM_COMPONENTS

    Global Const $_ADSI_USER_DISPLAYNAME = "displayName"
    Global Const $_ADSI_USER_FIRSTNAME = "givenName"
    Global Const $_ADSI_USER_SURNAME = "sn"
    Global Const $_ADSI_USER_EMAIL = "mail"
    Global Const $_ADSI_USER_MANAGER_OBJ = "manager"
#EndRegion GLOBAL_VARS

#Region FUNCTIONS_LIST
#cs	===================================================================================================================================
    _ADSI_GetUserInfo($_sArgument, $_sUserId = @UserName)
#ce	===================================================================================================================================
#EndRegion FUNCTIONS_LIST

#Region FUNCTIONS
    #cs #FUNCTION# ====================================================================================================================
		Name...............: _ADSI_GetUserInfo($_sArgument, $_sUserId = @UserName)
		Description .......: List user information from Active Directory
		Syntax.............: see documentation; recommended to use declared global vars
		Return values .....: Success:	string of requested user info from AD
		                     Failure:	False; @error/@extended
		Author ............: exorcistas@github.com
		Modified...........: 2020-02-26
	#ce ===============================================================================================================================
    Func _ADSI_GetUserInfo($_sArgument, $_sUserId = @UserName)
        Local $_oADSI = ObjCreate("ADSystemInfo")
            If NOT IsObj($_oADSI) Then Return SetError(1, 0, False)
        If StringLen($_sUserId) <> 6 Then SetError(2, 1, False)
        If StringLen($_sArgument) = 0 Then SetError(2, 2, False)

        Local $_sUserObj = StringReplace($_ADSI_USER_OBJ, "@USERID", $_sUserId)
        $_sUserObj = ObjGet($_ADSI_LDAP_URL & $_sUserObj)
            If NOT IsObj($_sUserObj) Then Return SetError(3, 0, False)

        Local $_sUserInfo = $_sUserObj.Get($_sArgument)
        $_oADSI = ""    ;-- destroy object

        Return $_sUserInfo
    EndFunc
#EndRegion FUNCTIONS
