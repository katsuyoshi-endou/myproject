<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.bean.CsFlowPtnBean" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%!
	String print( String str ) {
		return SU.nvl( CsUtil.escapeForHTML( str ), "" );
	}
%>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	final String loginId = userinfo.getLogin_no();
	List<VCstSheetActorAndRefDto> actorList = AU.getSessionAttr( session, CsSessionKey.CS_ACTOR_LIST );
	List<String> holdActorList = AU.getSessionAttr( session, CsSessionKey.CS_HOLD_ACTOR_LIST );
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	boolean isMainWindow = !"SubWindow".equals( request.getParameter( "windowMode" ) );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Form Layout
------------------------------------------------------------------------------------------------------------------------------%>
<style>
.flowPtnTable table th,
.flowPtnTable table td {
	font-size: 12px !important;
}
.flowPtnTable table {
	border-top: 0 !important;
}
.flowPtnTable .status-group {
	background-color: #758d93 !important;
	color: #fff !important;
	text-shadow: 0 1px 1px #444 !important;
	border-bottom: 1px solid #5a6a6e !important;
}
.flowPtnTable .status {
	background-color: #f2f2f2 !important;
	border-bottom: 1px solid #ddd !important;
}
.flowPtnTable td {
	text-align: center !important;
}
</style>

	<div class="flowPtnTable mod-table ami no-shadow">
		<table style="width:auto; border:0;">
			<tr>
				<th class="dummyCell"><%= "" %></th>
				<th class="dummyCell"><%= "" %></th>
				<th class="dummyCell"><%= "" %></th>
				<% for (CsFlowPtnBean flowPtn : jsp.flowPtnList) { %>
				<td>
					<div class="radio">
						<label>
							<input type="radio" name="after_flowptn" value="<%= flowPtn.code %>">
							<i class="fa fa-circle"></i>
						</label>
					</div>
				</td>
				<% } %>
			</tr>
			<tr>
				<th class="dummyCell"><%= "" %></th>
				<th class="dummyCell"><%= "" %></th>
				<th class="dummyCell"><%= "" %></th>
				<% for (CsFlowPtnBean flowPtn : jsp.flowPtnList) { %>
				<td><%= flowPtn.name %></td>
				<% } %>
			</tr>
			<% for (VCsmFlowStatusDto flow : jsp.flowInfo) { %>
			<tr>
				<th class="status-group"><%= flow.getStatusGrpNm() %></th>
				<th class="status"><%= flow.getStatusNm() %></th>
				<th><%= flow.getMainActorNm() %></th>
				<% for (CsFlowPtnBean flowPtn : jsp.flowPtnList) { %>
					<% boolean isUse = flowPtn.pathStatuses.contains( flow.getStatusCd() ); %>
					<% String using = isUse ? "using" : ""; %>
					<td class="<%= flow.getStatusCd() %> <%= using %>"><%= isUse ? "<i class=\"fa fa-circle\"></i>" : "" %></td>
				<% } %>
			</tr>
			<% } %>
		</table>
	</div><!-- /mod-table -->

	<hr>

	<div id="actorlist" class="mod-table ami">
		<table class="stripe cellmiddle" style="margin:0 auto;">
				<tr>
					<th><%= vm.gCL( "LSHFLP_TH_1" ) %></th>
					<th><%= vm.gCL( "LSHFLP_TH_2" ) %></th>
					<th><%= vm.gCL( "LSHFLP_TH_3" ) %></th>
					<th><%= vm.gCL( "LSHFLP_TH_4" ) %></th>
					<th style="width:10%;"></th>
					<th style="width:10%;"></th>
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
					<td><%= print( actorNm ) %><span class="reqd"><%= vm.gCL( "LSHFLP_REQUIRED" ) %></span></td>
					<td><%= print( personName ) %></td>
					<td>→</td>
					<td>
						<input type="hidden" class="guid" name="actor-idx-<%= i %>-guid" value="<%= actorGuid %>">
						<input type="hidden" class="actorcd" name="actor-idx-<%= i %>-actorcd" value="<%= actorCd %>">
						<span class="afterName"><%= print( personName ) %></span>
					</td>
					<td>
						<button type="button" class="btn btn_chg"><%= vm.gCL( "LSHFLP_BTN_CHG" ) %></button>
					</td>
					<td>
						<button type="button" class="btn btn-delete btn_del"><%= vm.gCL( "LSHFLP_BTN_DEL" ) %></button>
					</td>
				</tr>
				<% } %>
		</table>
	</div><!-- /mod-table -->
