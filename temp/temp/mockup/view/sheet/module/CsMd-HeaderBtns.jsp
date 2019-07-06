<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<jsp:useBean id="oneMenu" class="jp.co.hisas.career.app.common.bean.CareerMenuBean" scope="session" />
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	String vid = AU.getRequestAttr( request, "CURRENT_VID" );
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	String trans = oneMenu.menuTrans;
	
	boolean isMainWindow = !"SubWindow".equals( request.getParameter( "windowMode" ) );
	boolean isInnerSheet = "InnerSheet".equals( request.getParameter( "viewMode" ) );
	boolean notOwner     = !jsp.sheetInfo.getOwnGuid().equals( userinfo.getLogin_no() );
	
	String bulkOpeCd = AU.getSessionAttr( session, CsSessionKey.CS_BULK_OPERATION_CD );
	boolean canBackVSHBLK = SU.isNotBlank( bulkOpeCd );
	boolean canBackVHD040 = "TRANS-VHD040".equals(trans) && SU.isBlank( bulkOpeCd );
	
	String formCd = jsp.sheetInfo.getFormCd();
%>
	<div class="navbarBtns">
<% if (isMainWindow) { %>
		<div class="leftArea">
			<%-- 戻る --%>
			<% if (!isInnerSheet) { %>
				<% if ("TRANS-VHD020".equals(trans)) { %><button type="button" id="transVHD020" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHD021".equals(trans)) { %><button type="button" id="transVHD021" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHD022".equals(trans)) { %><button type="button" id="transVHD022" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHD023".equals(trans)) { %><button type="button" id="transVHD023" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if (canBackVHD040)                { %><button type="button" id="transVHD040" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHE020".equals(trans)) { %><button type="button" id="transVHE020" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHE021".equals(trans)) { %><button type="button" id="transVHE021" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
				<% if ("TRANS-VHF010".equals(trans)) { %><button type="button" id="transVHF010" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
			<% } else { %>
				<button type="button" id="transRELOAD" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_TO_SHEET_BTN" ) %></button>
			<% } %>
			<%-- 一覧 --%>
			<% if ("TRANS-VHD050".equals(trans)) { %><button type="button" id="transVHD050" class="btn btn-back"><%= vm.gCL( "LHD010_TRANS-VHD023_BTN" ) %></button><% } %>
			<% if ("TRANS-CSMLTI".equals(trans)) { %><button type="button" id="transCSMLTI" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
			<% if ("TRANS-CSMLTICSC".equals(trans)) { %><button type="button" id="transCSMLTICSC" class="btn btn-back"><%= vm.gCL( "LHD031_RETURN_BTN" ) %></button><% } %>
			<% if (canBackVSHBLK) { %><button type="button" id="transVSHBLK" class="btn btn-back"><%= vm.gCL( "LHD010_BACK_BTN" ) %></button><% } %>
			
			<% if (AU.isDebugMode()) { %>
			<button type="button" id="transRELOAD" class="btn"><%= vm.gCL( "LHD010_SHEET_RELOAD_BTN" ) %></button>
			<% } %>
		</div><!-- /leftArea -->
		<div class="rightArea">
			<div id="us-template-rendering-hbtn"></div>

			<!-- 立場切替ボタン -->
			<% if (SU.equals( vid, "SHVSHT" )) { %>
				<div class="btn-group showSwitchActor">
			    <button type="button" class="btn dropdown-toggle " data-toggle="dropdown" aria-expanded="false"><%= vm.gCL( "LHD010_CHGACT_BTN" ) %><span class="caret"></span></button>
			    <ul class="dropdown-menu dropdown-menu-right">
						<% for (VCstSheetActorAndRefDto dto : jsp.actorCdList) { %>
				      <li><a href="#" class="do-switchActor" data-actorcd="<%= dto.getActorCd() %>"><%= dto.getActorNm() %></a></li>
						<% } %>
			    </ul>
			  </div>
			<% } %>

			<%-- アクションボタン（保存以外） --%>
			<div class="btns csActionBtns" style="display:inline-block;margin:0;padding:0;">
				<% for (CsmSheetActionDto dto : jsp.actionList) { %>
					<%   if (!"STAY".equals( dto.getActionCd() )) { %>
						<button type="button" id="btn_<%= dto.getActionCd() %>" class="btn" data-actioncd="<%= dto.getActionCd() %>"><%= dto.getActionNm() %></button>
					<%   } %>
				<% } %>
			</div><!-- /btns -->
			
			<% if (SU.equals( vid, "SHVFLP" )) { %>
				<button id="exec_flowptn" type="button" class="btn btn-secondary"><%= vm.gCL( "LSHFLP_BTN_OK" ) %></button>
			<% } %>
			
		</div><!-- /rightArea -->
<% } %>
<% if (!isMainWindow) { %>
		<button class="btn" onclick="javascript:window.close();"><%= "閉じる" %></button>
<% } %>
	</div>
