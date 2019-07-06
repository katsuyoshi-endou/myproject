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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD014Command" %>
<fw:init commandClass="<%= PHD014Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD014Command.KINOU_ID) %>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHACT_TITLE" ) );
	
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	List<VCstSheetActorAndRefDto> actorList = AU.getSessionAttr( session, CsSessionKey.CS_ACTOR_LIST );
	List<String> holdActorList = AU.getSessionAttr( session, CsSessionKey.CS_HOLD_ACTOR_LIST );

	String selfSheetId = jsp.sheetInfo.getSheetId();

%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html onContextmenu="return false;">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
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
<body id="lyca" data-vmid="VmSHVACT">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD014">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk">
<%-- ================================================== Main Content Area ==================================================--%>
	
	<div class="navbarBtns">
		<div class="leftArea">
			<button type="button" id="transRELOAD" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_TO_SHEET_BTN" ) %></button>
		</div>
	</div>

	<div class="showcase-666">
		<div id="actorlist" class="mod-table">
			<table style="margin:0 auto;">
				<tr>
					<th><%= vm.gCL( "LSHACT_TH_1" ) %></th>
					<th><%= vm.gCL( "LSHACT_TH_3" ) %></th>
					<th style="width:15%;"></th>
					<th style="width:15%;"></th>
				</tr>
				<% for (int i = 0; i < actorList.size(); i++) { %>
				<%
					VCstSheetActorAndRefDto dto = actorList.get( i );
					String actorNm    = dto.getActorNm();
					String actorGuid  = dto.getGuid();
					String personName = dto.getPersonName();
					String actorCd    = dto.getActorCd();
				%>
				<tr data-idx="<%= i %>" data-actorcd="<%= actorCd %>" data-actorguid="<%= actorGuid %>">
					<td style="min-width: 150px;"><%= CsUtil.escapeForHTML( actorNm ) %><span class="reqd"><%= vm.gCL( "LSHFLP_REQUIRED" ) %></span></td>
					<td><%= CsUtil.escapeForHTML( personName ) %></td>
					<td><button type="button" class="btn btn_chg" data-actorCd="<%= actorCd %>" ><%= vm.gCL( "LSHACT_BTN_CHG" ) %></button></td>
					<td><button type="button" class="btn btn-delete btn_del" data-actorCd="<%= actorCd %>" ><%= vm.gCL( "LSHACT_BTN_DEL" ) %></button></td>
				</tr>
				<% } %>
			</table>
		</div><!-- /.mod-table -->
	</div><!-- /.container -->

<input type="hidden" name="actorCd" value="">
<input type="hidden" name="VHD012Mode" value="CHG_ACT">
<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>
var flowPtnJson = <%= SU.toJson( jsp.flowPtnList ) %>;
var flowPtnList = {};
_.each(flowPtnJson, function(fp){ return flowPtnList[fp.code] = fp; });

var loginId = '<%= loginId %>';
var currentFlowPtn = '<%= jsp.sheetInfo.getFlowPtn() %>';
$(function(){
	 /**
	 ** Initialize
	**/
	<%-- Set Header Buttons --%>
	var hBtns = $('div.headerButtons button');
	$('#command .buttons p').append( hBtns );
	
	refreshRequiredState( currentFlowPtn );
	refreshChgBtnState( loginId );
	
	 /**
	 ** Event
	**/
	<%-- シート再表示 --%>
	$(document).on('click', '#transRELOAD', function(event){
		event.preventDefault();
		pageSubmit('/servlet/CsSheetServlet', 'RESTORE');
	});

	$(document).on('click', '#actorlist .btn_chg', function(){
		document.F001.actorCd.value = $(this).attr('data-actorCd');
		pageSubmit('/view/sheet/VHD012_CsPersonSelect.jsp', 'INIT');
	});

	$(document).on('click', '#actorlist .btn_del', function(){
		var actorCd   = $(this).closest('[data-actorcd]').attr('data-actorcd');
		var actorGuid = $(this).closest('[data-actorguid]').attr('data-actorguid');
		if (actorGuid === "") {
			alert("<%= vm.gCL( "LSHACT_MSG_NOT_SEL" ) %>");
			return false;
		}
		var ans = confirm("<%= vm.gCL( "LSHACT_MSG_DEL" ) %>");
		if (!ans) { return false; }
		document.F001.actorCd.value = actorCd;
		pageSubmit('/servlet/CsActorServlet', 'DEL_ACT');
	});

});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
