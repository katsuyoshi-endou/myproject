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
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher("/view/error.jsp").forward( request, response );
	}
%>
<% Log.method( userinfo.getLogin_no(), "IN", "" ); %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD013Command" %>
<fw:init commandClass="<%= PHD013Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD013Command.KINOU_ID) %>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHREF_TITLE" ) );
	
	Map<Integer, VCstSheetActorAndRefDto> refererMap = AU.getSessionAttr( session, CsSessionKey.CS_REFERER_LIST );
	List<CsmSheetActorDto> refererMasterList = AU.getSessionAttr( session, CsSessionKey.CS_REFERER_MASTER_LIST );
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
</style>
</head>
<body id="lyca" data-vmid="VmSHVREF">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD013">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk"><div class="container">
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<button type="button" id="transRELOAD" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_TO_SHEET_BTN" ) %></button>
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
			<button id="btn_del_ref" type="button" class="btn btn-delete"><%= vm.gCL( "LSHREF_DEL_BTN" ) %></button>
			
			<div class="btn-group">
				<button type="button" class="btn dropdown-toggle" data-toggle="dropdown"><%= vm.gCL( "LSHREF_ADD_BTN" ) %> <span class="caret"></span></button>
				<ul class="dropdown-menu dropdown-menu-right">
				<% for (CsmSheetActorDto refMast : refererMasterList) { %>
					<li class="btn_add_ref" name="<%= refMast.getActorCd() %>"><a href="#"><%= refMast.getActorNm() %>の追加</a></li>
				<% } %>
				</ul>
			</div>
		</div>
	</div>

	<div id="refererlist" class="mod-table">
		<table class="stripe cellmiddle" style="width:50%; margin:0 auto;">
			<tr>
				<th style="width: 7%;"><input type="checkbox" id="checkall" name="checkall"></th>
				<th style="width:25%;"><%= vm.gCL( "LSHREF_TH_1" ) %></th>
				<th><%= vm.gCL( "LSHREF_TH_3" ) %></th>
			</tr>
			<% for (Map.Entry<Integer, VCstSheetActorAndRefDto> entry : refererMap.entrySet()) { %>
			<tr>
				<td><input type="checkbox" name="cbox" value="<%= entry.getKey() %>"></td>
				<td><%= entry.getValue().getActorNm() %></td>
				<td><%= entry.getValue().getPersonName() %></td>
			</tr>
			<% } %>
		</table>
	</div><!-- /.mod-table -->

<input type="hidden" name="checkedValueArray" value="">
<input type="hidden" name="VHD012Mode" value="ADD_REF">
<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="actorCd" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
function getCheckedValueArray() {
	var list = new Array();
	$('input[name^="cbox"]:checked').each(function(){
		list.push( $(this).val() );
	});
	return list;
}

$(function(){
	 /**
	 ** Initialize
	**/
	<%-- Set Header Buttons --%>
	var hBtns = $('div.headerButtons button');
	$('#command .buttons p').append( hBtns );
	
	$('#msgArea').css('top', '30px');
	
	 /**
	 ** Event
	**/
	<%-- シート再表示 --%>
	$(document).on('click', '#transRELOAD', function(event){
		event.preventDefault();
		pageSubmit('/servlet/CsSheetServlet', 'RESTORE');
	});

	$(document).on('click', '#refererlist #checkall', function(){
		var afterStat = $(this).prop('checked');
		$('#refererlist :checkbox').prop('checked', afterStat);
	});
	$(document).on('click', '.btn_add_ref', function(){
		document.F001.actorCd.value = $(this).attr('name');
		pageSubmit('/view/sheet/VHD012_CsPersonSelect.jsp', 'INIT');
	});
	$(document).on('click', '#btn_del_ref', function(){
		var list = getCheckedValueArray();
		if (list.length == 0) {
			alert("<%= vm.gCL( "LSHREF_MSG_NOT_SEL" ) %>");
			return false;
		}
		var ans = confirm("<%= vm.gCL( "LSHREF_MSG_DEL" ) %>");
		if (!ans) { return false; }
		document.F001.checkedValueArray.value = list;
		pageSubmit('/servlet/CsActorServlet', 'DEL_REF');
	});
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
