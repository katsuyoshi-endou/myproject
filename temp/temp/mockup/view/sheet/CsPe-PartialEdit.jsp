<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	final String loginId = userinfo.getLogin_no();
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher("/view/error.jsp").forward( request, response );
	}
%>
<% Log.method( userinfo.getLogin_no(), "IN", "" ); %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD010Command" %>
<fw:init commandClass="<%= PHD010Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD010Command.KINOU_ID) %>" />
<%@ page import="java.io.File" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	String exclusiveKey = jsp.exclusiveKey.getExclusiveKey().toString();
	
	String cspe        = AU.getRequestValue( request, "csPartialEdit" );
	String cspearg     = AU.getRequestValue( request, "csPartialEditArg" );
	
	String templateCspe   = AU.getSessionAttr( session, CsSessionKey.CS_SHEET_TEMPLATE_CSPE );
	String templatescript = AU.getSessionAttr( session, CsSessionKey.CS_SHEET_TEMPLATE_JS );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html onContextmenu="return false;">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.css" type="text/css" media="screen" />
</head>
<body id="lyca" onContextmenu="return false;" >
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD010">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div class="plate">
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<%-- 戻る(シート再表示) --%>
			<button type="button" id="transRELOAD" class="btn btn-back"><%= "戻る" %></button>
		</div>
		<div class="centerArea">
			<h1><%= vm.gCL("LHD010_TITLE_CSPE") %></h1>
		</div>
		<div class="rightArea">
			<%-- アクションボタン（保存のみ） --%>
			<% for (CsmSheetActionDto dto : jsp.actionList) { %>
			<%   if ("STAY".equals( dto.getActionCd() )) { %>
				<button type="button" id="btn_<%= dto.getActionCd() %>" class="btn btn-secondary <%= dto.getActionCd() %>"><%= dto.getActionNm() %></button>
			<%   } %>
			<% } %>
		</div>
	</div>


	<%-- シートID表示 --%>
	<div style="float:right;color:#fff;"><%= jsp.sheetInfo.getSheetId() %></div>

	<div class="hyokasheetInner">

		<div class="sheet-section">

			<%-- 部分編集 シートテンプレート --%>
			<div id="us-template-rendering"></div>

		</div><!-- /sheet-section -->

	</div><!-- /hyokasheetInner -->


<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">
<input type="hidden" name="sheetId" value="">
<input type="hidden" name="exclusiveKey" value="<%= exclusiveKey %>">
<input type="hidden" name="xlsharp" value="">
<input type="hidden" name="tabkeep" value="<%= SU.ntb( AU.getRequestValue( request, "tabkeep" ) ) %>">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.plate -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
<%------------------------------------------------------------------------------------------------------------------------------
	Underscore.js Template Engine
------------------------------------------------------------------------------------------------------------------------------%>
<%-- ========================================= Underscore.js Template Layout Layer =========================================--%>
<script id="us-template-layout" type="text/template">

<%= templateCspe %>

</script><%-- ================================/Underscore.js Template Layout Layer =========================================--%>
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
<%-- - - - - - - - - - - - - CSM_SHEET_LAYOUT_JS - - - - - - - - - - - - --%>
<% for (CsmSheetLayoutJsDto js : jsp.layoutJsList) { %>
	<%= js.getScript() %>
<% } %>
<%-- - - - - - - - - - - - - CSM_SHEET_LAYOUT_PD - - - - - - - - - - - - --%>
var cspd = { dummy: ''
<%
	for (String key : jsp.layoutPdList.keySet()) {
		List<PulldownMasterDto> list = jsp.layoutPdList.get( key );
%>
	, "<%= key %>": [ {}
	<% for (PulldownMasterDto pd : list) { %>
		, {value: '<%= pd.getPdValue() %>', text: '<%= pd.getPdText() %>'}
	<% } %>
	]
<% } %>
};
</script>
<%-- - - - - - - - Underscore.js Template Rendering Layer - - - - - - - ---%>
<jsp:include page="/view/sheet/CsTemplateDataBridge.jsp" flush="false" />
<script>
usTemplateRender('#us-template-layout', '#us-template-rendering', _data);
</script>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>
var fillMap = { dummy : ''
<%
	for (CsmSheetFillDto fillIdDto : jsp.fillIdMasterList) {
		String fKey = "Fill--" + fillIdDto.getFillId();
		String fVal = jsp.getFillContent( fillIdDto.getFillId() );
%>
	, '<%= fKey %>' : '<%= fVal %>'

<%
	}
%>
}
var readFillList = [
	<%= jsp.getMapKeysForJSArray( jsp.fillMaskMap, "read" ) %>
];
var writeFillList = [
	<%= jsp.getMapKeysForJSArray( jsp.fillMaskMap, "write" ) %>
];

var confMsgList = { dummy: ''
	<% for (CsmSheetActionDto dto : jsp.actionList) { %>
	<%   if ("STAY".equals( dto.getActionCd() )) { %>
	, <%= dto.getActionCd() %>: "<%= dto.getConfirmMsg() %>"
	<%   } %>
	<% } %>
};
function execSheetActionStay() {
	if (typeof customPartialEditCheck === "function") {
		if (!customPartialEditCheck( '<%= cspe %>', '<%= cspearg %>' )) {
			return false;
		}
	}
	if (!sheetBasicInputCheck()) {
		return false;
	}
	var confMsg = confMsgList['STAY'];
	if (confMsg != '') { if (!confirm(confMsg)) { return false; } }
	cspeCheckboxRequestHandler();
	pageSubmit( '/servlet/CsSheetActionServlet', 'STAY' );
}

__CSPE = '<%= cspe %>';

var __MsgMap = {};
__MsgMap["APP_MSG_PC_ONLY"] = '<%= vm.escj( vm.gCL( "APP_MSG_PC_ONLY" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_UPFILE_REQUIRED"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_UPFILE_REQUIRED" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_UPFILE_TOO_LARGE"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_UPFILE_TOO_LARGE" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_INT_100"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_INT_100" ) ) %>';

$(function(){
	$document = $(document);
	
	 /**
	 ** Initialize
	**/
	
	// Pulldowns
	_.each(cspd, function(data, key){
		_.each(data, function(obj, i){
			if (i > 0) {
				var optionElems = $('<option>', obj);
				$('select[data-pulldown="'+key+'"]').append(optionElems);
			}
		});
	});
	
	// Make Fills and Restore Values
	if (typeof fillMap === "undefined") {
	} else {
		makeFills();
	}
	
	 /**
	 ** Event
	**/
	/* Excelアップロード */
	$document.on('click', '.xlupload button', function(){
		openCsXluploadModal();
	});
	
	/* Action Button - STAY */
	$document.on('click', '#btn_STAY', function(){
		execSheetActionStay();
	});
	
	<%-- シート再表示 --%>
	$document.on('click', '#transRELOAD', function(event){
		event.preventDefault();
		showSheet('/servlet/CsSheetServlet', 'RESTORE', '<%= jsp.sheetInfo.getSheetId() %>');
	});
	
//	console.log("-- CsPe-PertialEdit done --");
});
</script>

<%-- CareerSheet Custom JavaScript -- C:/lysitheacareer/sheettemplate/PARTY_script.js ----------------------------------------%>
<script><%= templatescript %></script>

<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</body>
</html>
