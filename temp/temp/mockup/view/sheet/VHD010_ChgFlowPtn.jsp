<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
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
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "CURRENT_VID", "SHVFLP" );
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHFLP_TITLE" ) );
	
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	String exclusiveKey = jsp.exclusiveKey.getExclusiveKey().toString();
	
	String selfSheetId = jsp.sheetInfo.getSheetId();
	
	String sheettemplate  = AU.getSessionAttr( session, CsSessionKey.CS_SHEET_TEMPLATE );
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
<style type="text/css">
.reqd {
	display: none;
}
.required .reqd {
	display: inline-flex;
	margin-left: 5px;
}
.required .btn_del {
	display: none;
}
</style>
</head>
<body id="lyca" data-vmid="VmSHVFLP">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD010">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk"><div class="container-fluid">
<%-- ================================================== Main Content Area ==================================================--%>


<div class="pnl"><div class="pnl-body">

	<%-- シートID表示 --%>
	<div style="float:right;"><span class="hiddenSheetId"><%= selfSheetId %></span></div>


	<%-- フォームレイアウト --%>
	<div class="hyokasheet-header">
		<%-- ヘッダボタン --%>
		<jsp:include page="module/CsMd-HeaderBtns.jsp" flush="false" />
		
		<%-- 共通ヘッダ部品 --%>
		<jsp:include page="form/CsF-pkg_CommonHeader.jsp" flush="false" />
		
		<%-- シートステータス部品 --%>
		<jsp:include page="module/CsMd-StatusFlow.jsp" flush="false" />
	</div>


	<%-- C:/lysitheacareer/sheettemplate --%>
	<%= sheettemplate %>


	<div class="hyokasheetInner">
		<div class="sheet-section">
			
			<h3 class="titleGrayBelt"><%= vm.gCL( "LSHFLP_FORM_TITLE" ) %></h3>
			<jsp:include page="module/CsMd-FlowPtn.jsp" flush="false" />
			
		</div><!-- /sheet-section -->
	</div><!-- /hyokasheetInner -->

</div><!-- /.pnl-body --></div><!-- /.pnl -->


<%-- InPage Hidden Requests -----------------------------------------%>
<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">
<input type="hidden" name="sheetId" value="<%= selfSheetId %>">
<input type="hidden" name="exclusiveKey" value="<%= exclusiveKey %>">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
var writeFillList = [];
</script>
<%-- - - - - - - - Underscore.js Template Rendering Layer - - - - - - - ---%>
<jsp:include page="/view/sheet/CsTemplateDataBridge.jsp" flush="false" />
<script>
usTemplateRender('#us-template-layout-attr', '#us-template-rendering-attr', _data);
</script>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>

var flowPtnJson = <%= SU.toJson( jsp.flowPtnList ) %>;
var flowPtnList = {};
_.each(flowPtnJson, function(fp){ return flowPtnList[fp.code] = fp; });

var loginId = '<%= loginId %>';
var currentFlowPtn = '<%= jsp.sheetInfo.getFlowPtn() %>';
$(function(){
	$document = $(document);
	
	 /**
	 ** Initialize
	**/
	$('.csActionBtns').hide();
	drawStatusSummary('<%= jsp.sheetInfo.getStatusCd() %>', '<%= loginId %>', '<%= jsp.sheetInfo.getHoldGuid() %>');
	// Restore
	$('input[name="after_flowptn"][value="'+currentFlowPtn+'"]').prop('checked', true);
	
	refreshRequiredState( $('input[name="after_flowptn"]:checked').val() );
	refreshChgBtnState( loginId );
	
	
	 /**
	 ** Event
	**/
	<%-- シート再表示 --%>
	$document.on('click', '#transRELOAD', function(event){
		event.preventDefault();
		showSheet('/servlet/CsSheetServlet', 'RESTORE', '<%= selfSheetId %>');
	});
	<%-- フローパターン変更検知 --%>
	$document.on('click', 'input[name="after_flowptn"]', function(){
		refreshRequiredState( $('input[name="after_flowptn"]:checked').val() );
	});
	<%-- 変更ボタン サブウィンドウ --%>
	$document.on('click', '.btn_chg', function(){
		var $tr = $(this).closest('tr');
		makeRequestParameter( "actorIdx", $tr.data('idx') );
		makeRequestParameter( "actorCd", $tr.data('actorcd') );
		openSubWindow('/view/sheet/VHD012_CsActorSelect.jsp', 'INIT', 'select_actors', 1000, 800);
	});
	<%-- 削除ボタン --%>
	$document.on('click', '.btn_del', function(){
		var $tr = $(this).closest('tr');
		$tr.find('input.guid').val('');
		$tr.find('span.afterName').text('');
	});
	<%-- フローパターン変更適用 --%>
	$document.on('click', '#exec_flowptn', function(){
		if (checkBeforeSubmit()) {
			pageSubmit('/servlet/CsActorServlet', 'CHG_FLOWPTN');
		} else {
			alert("<%= vm.gCL( "LSHFLP_MSG_NOT_SEL" ) %>");
		}
	});
	
});

function applyNewActor(idx, arg) {
	$tr = $('#actorlist tr[data-idx="'+idx+'"]');
	$tr.find('input.guid').val( arg.guid );
	$tr.find('input.actorcd').val( arg.actorcd );
	$tr.find('span.afterName').text( arg.name );
}

function checkBeforeSubmit() {
	var result = true;
	$('#actorlist tr.required').each(function(){
		if (_.isEmpty( $(this).find('input.guid').val() )) {
			result = false;
			return false; // break
		}
	});
	return result;
}
</script>

<%-- CareerSheet Custom JavaScript -- C:/lysitheacareer/sheettemplate/PARTY_script.js ----------------------------------------%>
<script><%= templatescript %></script>

<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
