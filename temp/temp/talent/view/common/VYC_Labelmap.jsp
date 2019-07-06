<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.common.vm.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%
	Tray tray = new Tray( request, response );
	VmVCAAPP vm = new VmVCAAPP( tray );
%>
<%-- Contents ----------------------------------------------------------------------------------------------------------------%>
__labelMap = { "dummy": ""
	, "FW_MSG_TIMEOUT": "<%= vm.gCL("FW_MSG_TIMEOUT") %>"
	, "FW_MSG_LOGOUT_CFM": "<%= vm.gCL("FW_MSG_LOGOUT_CFM") %>"
	, "FW_MSG_DISMISS_CFM": "<%= vm.gCL("FW_MSG_DISMISS_CFM") %>"
	, "FW_MSG_SHIFTKEY_NG": "<%= vm.gCL("FW_MSG_SHIFTKEY_NG") %>"
	, "FW_MSG_TEXT_LEN_LIMIT": "<%= vm.gCL("FW_MSG_TEXT_LEN_LIMIT") %>"
	, "FW_MSG_TIMEOUT_POPALERT": "<%= vm.gCL("FW_MSG_TIMEOUT_POPALERT") %>"
	, "FW_MSG_TIMEOUT_POPALERT_DESC": "<%= vm.gCL("FW_MSG_TIMEOUT_POPALERT_DESC") %>"
	, "LTLSRL_INSTANT_SWITCH": "<%= vm.gCL("LTLSRL_INSTANT_SWITCH") %>"
	, "LTLSRL_INSTANT_ATTR01": "<%= vm.gCL("LTLSRL_INSTANT_ATTR01") %>"
	, "LTLSRL_INSTANT_ATTR02": "<%= vm.gCL("LTLSRL_INSTANT_ATTR02") %>"
	, "LTLSRL_INSTANT_ATTR03": "<%= vm.gCL("LTLSRL_INSTANT_ATTR03") %>"
	, "LTLSRL_INSTANT_ATTR04": "<%= vm.gCL("LTLSRL_INSTANT_ATTR04") %>"
};
