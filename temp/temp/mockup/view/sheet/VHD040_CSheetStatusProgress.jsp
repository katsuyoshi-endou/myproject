<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD040Command" %>
<fw:init commandClass="<%= PHD040Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD040Command.KINOU_ID) %>" />
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.event.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL("LSHPRG_TITLE") );
	
	CsProgressEventResult result = AU.getSessionAttr( session, CsSessionKey.CS_PROGRESS );
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
div.sheet-status {
	margin: 10px 0;
}
table.sheet-status-layout {
	margin: 0 auto 0 0;
}
table.sheet-status-col {
	margin: 0 5px !important;
}
table.sheet-status-col td {
	padding: 0 5px !important;
}
th.sheet-status-active,
th.sheet-status-inactive {
	padding: 5px;
}
th.sheet-status-inactive {
	/*background-color: #f9f9f9 !important;*/
	border-bottom: 0 !important;
	color: #555 !important;
	text-shadow: none !important;
}
td.sheet-status-person {
	cursor: pointer !important;
}
td.sheet-status-person a {
	font-size: 16px !important;
	line-height: 1.8 !important;
}
td.isZero a {
	font-weight: normal !important;
	text-decoration: none;
}
td.sheet-status-person .sh-status-chip {
	margin: 4px;
	padding: 0 6px;
}
</style>
</head>
<body id="lyca" data-vmid="VmSHVPRG">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD040">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk"><div class="container">
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<button class="btn btn-back backToHome" type="button"><%= vm.gCL( "LSHPRG_NAV_BACK" ) %></button>
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
		</div>
	</div>

	<div class="guidanceMessage hideWhenBlank">
		<ul><li><%= vm.gCL( "LSHPRG_GUIDE" ) %></li></ul>
	</div><!-- /guidanceMessage -->

<% Map <String, String> isFollowModeMap = result.isFollowModeMap; %>
<% List<String> opeList = result.opSets.get( tray.party ); %>
<% for (String opeCd : opeList) { %>
	<% boolean isFollowMode = SU.matches( isFollowModeMap.get( opeCd ), "true" ); %>
	<div class="titlePrimary" style="margin:20px 0;"><%= result.opeMap.get( opeCd ).get( 0 ).getOperationNm() %></div>
	<div id="ope_<%= opeCd %>">
	<div class="area2nd" style="margin:0 0 0 20px;">
	<% for (String fgCd : result.fgSets.get( opeCd )) { %>
		<h3 class="sectionTitleSecond grp-jisk" style="font-size:16px;margin:10px 0;"><%= result.opeFgMap.get( opeCd+fgCd ).get( 0 ).getFormGrpNm() %></h3>
		<div class="sheet-status">
			<table class="sheet-status-layout" style="width:100%;">
				<tr>
					<% for (String sgCd : result.sgSets.get( opeCd+fgCd )) { %>
					<td style="width:23%;">
						<table class="sheet-status-col" style="width:98%;" data-operationCd="<%= opeCd %>" data-formGrpCd="<%= fgCd %>">
							<tr>
								<% if (isFollowMode) { %>
								<th colspan="3" class="sheet-status-inactive">
								<% } else { %>
								<th colspan="2" class="sheet-status-inactive">
								<% } %>
									<%= result.opeFgSgMap.get( opeCd+fgCd+sgCd ).get( 0 ).getStatusGrpNm() %>
								</th>
							</tr>
							<tr>
								<th class="sheet-status-inactive" style="width:50%;"><%= vm.gCL( "LSHPRG_TH_01" ) %></th>
								<th class="sheet-status-inactive" style="width:25%;"><%= vm.gCL( "LSHPRG_TH_02" ) %></th>
								<% if (isFollowMode) { %>
								<th class="sheet-status-inactive follow" style="width:25%;"><%= vm.gCL( "LSHPRG_TH_03" ) %></th>
								<% } %>
							</tr>
							<% for (String stCd : result.stSets.get( opeCd+fgCd+sgCd )) { %>
							<%
								CsxSheetStatusProgressDto cntDto = result.sheetCountMap.get( opeCd+fgCd+stCd );
								CsxSheetStatusProgressDto cntFollowDto = result.sheetCountMap.get( opeCd+fgCd+stCd+"follow" );
								CsxSheetStatusProgressDto holdDto = AU.nvl( result.sheetHoldMap.get( opeCd+fgCd+stCd ), new CsxSheetStatusProgressDto() );
								String statusNm  = cntDto.getStatusNm();
								String sheetCnt  = (0 == cntDto.getSheetCount()) ? "-" : cntDto.getSheetCount().toString();
								String sheetCntFollow  = (0 == cntFollowDto.getSheetCount()) ? "-" : cntFollowDto.getSheetCount().toString();
								String clsIsZeroHk = (       cntDto.getSheetCount() == 0 ) ? "isZero" : "";
								String clsIsZeroFl = ( cntFollowDto.getSheetCount() == 0 ) ? "isZero" : "";
								String clsIsHold = ( holdDto.getSheetCount() != null ) ? "isHold" : "";
								String boxId     = opeCd + "-" + fgCd + "-" + stCd;
							%>
								<tr data-statusCd="<%= stCd %>">
									<td style="text-align:left;"><%= statusNm %></td>
									<td class='sheet-status-person <%= clsIsZeroHk %>'        id='<%= boxId %>'     data-boxid='<%= boxId %>'    ><a href='#' class="sh-status-chip <%= clsIsHold %>"><%= sheetCnt %></a></td>
									<% if (isFollowMode) { %>
									<td class='sheet-status-person <%= clsIsZeroFl %> follow' id='<%= boxId %>-fol' data-boxid='<%= boxId %>-fol'><a href='#' class="sh-status-chip"><%= sheetCntFollow %></a></td>
									<% } %>
								</tr>
							<% } %>
						</table>
					</td>
					<% } %>
				</tr>
			</table>
		</div>
	<% } %>
	</div><!-- /area2nd -->
	</div><!-- /#ope_<%= opeCd %> -->
<% } %>

<input type="hidden" name="operationCd" value="">
<input type="hidden" name="formGrpCd" value="">
<input type="hidden" name="statusCd" value="">
<input type="hidden" name="holdFilter" value="">

<%-- for VHD021 --%>
<input type="hidden" name="SrchCondOperationCd" value="">
<input type="hidden" name="SrchFormGrpCd" value="">
<input type="hidden" name="SrchCondStatusCd" value="">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>
$(function(){
	 /**
	 ** Initialize
	**/
	
	 /**
	 ** Event
	**/
	$(document).on('click', '.sheet-status-person', function(event){
		try{ $(this).find('a').click(); }catch(e){}
	});
	$(document).on('click', '.sheet-status-person a', function(event){
		event.preventDefault();
		var parentObj = $(this).parent().parent().parent().parent();
		
<% String dest = "VHD030"; %>
<% if ("VHD030".equals(dest)) { %>
		document.F001.operationCd.value = $(parentObj).attr('data-operationCd');
		document.F001.formGrpCd.value   = $(parentObj).attr('data-formGrpCd');
		document.F001.statusCd.value    = $(this).parent().parent().attr('data-statusCd');
		if ( $(this).parent().hasClass('follow') ){
				document.F001.holdFilter.value    = 'FOLLOW';
				pageSubmit('/servlet/CsMultiSheetFollowServlet', 'SEARCH');
		} else {
				pageSubmit('/servlet/CsMultiSheetServlet', 'SEARCH');
		}
<% } else if ("VHD021".equals(dest)) { %>
		document.F001.SrchCondOperationCd.value = $(parentObj).attr('data-operationCd');
		document.F001.SrchFormGrpCd.value       = $(parentObj).attr('data-formGrpCd');
		document.F001.SrchCondStatusCd.value    = $(parentObj).attr('data-statusCd');
		pageSubmit('/view/sheet/VHD021_CSheetListOnActor.jsp', 'INIT');
<% } %>
		return false; // for event infinite loop
	});
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
