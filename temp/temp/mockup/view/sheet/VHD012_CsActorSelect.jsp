<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD012Command" %>
<fw:init commandClass="<%= PHD012Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD012Command.KINOU_ID) %>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHSAR_TITLE" ) );
	
	List<VPersonBelongUnionExDto> belList = AU.getSessionAttr( session, CsSessionKey.PERSON_BELONG_LIST );
	HashMap<String, String> srchCondMap = AU.getSessionAttr( session, CsSessionKey.VHD012_SRCH_COND );
	if (srchCondMap == null) {
		srchCondMap = new HashMap<String, String>();
	}
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
<body id="lyca" data-vmid="VmSHVSAR">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD012">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation">
<%----------------------------------------------------- Fix Content Area -----------------------------------------------------%>

	<div class="ope-board">
		<div class="whitebd">
			<div class="gridform">
				<div class="gf-row">
					<label class="f5x">
						<span class="lbl"><%= vm.gCL( "LSHSAR_SRCH_TH_1" ) %></span>
						<input type="text" class="block" name="SrchCondPersonNm"  maxlength="100" value="">
					</label>
					<label class="f6x">
						<span class="lbl"><%= vm.gCL( "LSHSAR_SRCH_TH_2" ) %></span>
						<input type="text" class="block" name="SrchCondShozoku"   maxlength="100" value="">
					</label>
					<label class="f5x">
						<span class="lbl"><%= vm.gCL( "LSHSAR_SRCH_TH_3" ) %></span>
						<input type="text" class="block" name="SrchCondYakushoku" maxlength="100" value="">
					</label>
				</div>
			</div>
		</div>
		<hr>
	</div><!-- /.ope-board -->

<%-- ================================================== Main Content Area ==================================================--%>
<div class="desk"><div class="container">

	<div class="navbarBtns">
		<div class="leftArea">
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
			<button type="button" id="search" class="btn btn-secondary"><i class="fa fa-search"></i><%= vm.gCL( "LSHSAR_SRCH_BTN" ) %></button>
		</div>
	</div>

	<div class="guidanceMessage">
		<ul>
			<li><%= vm.gCL( "LSHSAR_RSLT_GUIDE" ) %></li>
		</ul>
	</div><!-- /guidanceMessage -->

	<div id="result" class="mod-table">
		<table class="stripe">
			<thead>
				<tr>
					<th><%= vm.gCL( "LSHSAR_RSLT_TH_1" ) %></th>
					<th><%= vm.gCL( "LSHSAR_RSLT_TH_2" ) %></th>
					<th><%= vm.gCL( "LSHSAR_RSLT_TH_3" ) %></th>
				</tr>
			</thead>
			<tbody>
				<%
					int cnt = (belList.size() > 100) ? 100 : belList.size();
					for (int i=0; i<cnt; i++) {
						VPersonBelongUnionExDto dto = belList.get(i);
				%>
				<tr data-guid="<%= dto.getGuid() %>" data-name="<%= dto.getPersonName() %>">
					<td><a href="#"><%= dto.getPersonName() %></a></td>
					<td><%= dto.getDeptNm() %></td>
					<td><%= dto.getClsCNm() %></td>
				</tr>
				<% } %>
			</tbody>
		</table>
	</div><!-- /.mod-table -->


<input type="hidden" name="actorIdx" value="<%= request.getParameter("actorIdx") %>">
<input type="hidden" name="actorCd" value="<%= request.getParameter("actorCd") %>">
<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
var reqActorIdx = '<%= request.getParameter("actorIdx") %>';
var reqActorCd = '<%= request.getParameter("actorCd") %>';

$(function(){
	 /**
	 ** Initialize
	**/
	<%-- Set Header Buttons --%>
	var hBtns = $('div.headerButtons button');
	$('#command .buttons p').append( hBtns );
	
	<%-- 入力した検索条件の復元 --%>
	$('input[name="SrchCondPersonNm"]' ).val('<%= CsUtil.restoreSrchCond( srchCondMap, "SrchCondPersonNm"  ) %>');
	$('input[name="SrchCondShozoku"]'  ).val('<%= CsUtil.restoreSrchCond( srchCondMap, "SrchCondShozoku"   ) %>');
	$('input[name="SrchCondYakushoku"]').val('<%= CsUtil.restoreSrchCond( srchCondMap, "SrchCondYakushoku" ) %>');
	
	 /**
	 ** Event
	**/
	$(document).on('click', '#search', function(){
		pageSubmit('/view/sheet/VHD012_CsActorSelect.jsp', 'INIT');
	});
	$('input[name^="SrchCond"]').keypress(function(e){
		// Enter Key
		if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
			pageSubmit('/view/sheet/VHD012_CsActorSelect.jsp', 'INIT');
		}
	});
	
	$(document).on('click', '#result a', function(event){
		event.preventDefault();
		$tr = $(this).closest('tr');
		var obj = {
			guid: $tr.data('guid'),
			name: $tr.data('name'),
			actorcd: reqActorCd
		};
		window.opener.applyNewActor(reqActorIdx, obj);
		window.close();
	});
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
