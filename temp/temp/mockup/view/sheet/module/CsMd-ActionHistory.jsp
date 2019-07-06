<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%!
	String print( String str ) {
		return SU.nvl( StringEscapeUtils.escapeXml( str ), "" );
	}
%>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	boolean isMainWindow = !"SubWindow".equals( request.getParameter( "windowMode" ) );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Form Layout
------------------------------------------------------------------------------------------------------------------------------%>

<style type="text/css">
#action-history {
	display: none;
}
</style>
<div id="action-history" class="hyokasheetInner">
	<div class="sheet-section">

	<h3 class="lightBg"><%= vm.gCL( "LHD010_ACTHIST_TITLE" ) %></h3>
	
	<div class="mod-table">
		<table>
			<tr>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH1" ) %></th>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH2" ) %></th>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH3" ) %></th>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH4" ) %></th>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH5" ) %></th>
				<th><%= vm.gCL( "LHD010_ACTHIST_TH6" ) %></th>
			</tr>
		<%
			String excludedActionCd = "STAY";
			for (VCstSheetActionLogDto dto : jsp.actionLogList) {
				if (SU.matches( dto.getActionCd(), excludedActionCd )) {
					continue;
				} else {
		%>
			<tr>
				<td><%= print( dto.getTimestamp()  ) %></td>
				<td><%= print( dto.getPersonName() ) %></td>
				<td><%= print( dto.getActorNm()    ) %></td>
	 			<td><%= print( dto.getStatusNm()   ) %></td>
				<td><%= print( dto.getActionNm()   ) %></td>
				<td><%= print( dto.getDelivMsg()   ) %></td>
			</tr>
		<% 
				} 
			 } 
		%>
		</table>
	</div>

	</div><!-- /sheet-section -->
</div><!-- /hyokasheetInner -->

