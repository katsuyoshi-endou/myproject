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
<%
	Log.method( userinfo.getLogin_no(), "IN", "" );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD023Command" %>
<fw:init commandClass="<%=PHD023Command.class%>" kinouTitle="<%=CommonParameter.getFuncName(PHD023Command.KINOU_ID)%>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHMYL_TITLE" ) );
	
	List<VCstSheetListDto> subDtoList = AU.getSessionAttr( session, CsSessionKey.VCST_SHEET_SINGLE_DTO_LIST );
	boolean isVisibleOtherList = (subDtoList.size() > 0);
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html onContextmenu="return false;">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
</head>
<body id="lyca" data-vmid="VmSHVMYL">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation">
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<button class="btn btn-back backToHome" type="button"><%= vm.gCL( "LSHMYL_NAV_BACK" ) %></button>
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
		</div>
	</div>

<div class="desk">
	<div class="container">
		<div class="mod-table">
			<div class="title"><%= vm.gCL( "LSHMYL_TITLE_ACTIVE" ) %></div>
			<div class="paper">
				<table>
					<thead>
						<tr>
							<th class="colA"><%= vm.gCL( "LSHMYL_TH_1" ) %></th>
							<th class="colB"><%= vm.gCL( "LSHMYL_TH_2" ) %></th>
							<th class="colC"><%= vm.gCL( "LSHMYL_TH_3" ) %></th>
							<th class="colD"><%= vm.gCL( "LSHMYL_TH_4" ) %></th>
							<th class="colE"><%= vm.gCL( "LSHMYL_TH_5" ) %></th>
						</tr>
					</thead>
					<tbody>
					<%
						for (VCstSheetListDto dto : subDtoList) {
							String isHold = (userinfo.getLogin_no().equals(dto.getHoldGuid())) ? "isHold" : "" ;
							if (!"1".equals(dto.getActiveFlg())) { continue; }
					%>
						<tr>
							<td><%= JspUtil.toPlainText( dto.getOperationNm()   ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol5()     ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol6()     ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol7()    ) %></td>
							<td>
								<a href="#" class="sh-status-chip <%= isHold %>" data-sheetid="<%= dto.getSheetId() %>"><%= dto.getStatusNm() %></a>
							</td>
						</tr>
					<% } %>
					</tbody>
				</table>
			</div><!-- /.paper -->
		</div><!-- /.mod-table -->

		<div class="mod-table">
			<div class="title"><%= vm.gCL( "LSHMYL_TITLE_PAST" ) %></div>
			<div class="paper">
				<table>
					<thead>
						<tr>
							<th class="colA"><%= vm.gCL( "LSHMYL_TH_1" ) %></th>
							<th class="colB"><%= vm.gCL( "LSHMYL_TH_2" ) %></th>
							<th class="colC"><%= vm.gCL( "LSHMYL_TH_3" ) %></th>
							<th class="colD"><%= vm.gCL( "LSHMYL_TH_4" ) %></th>
							<th class="colE"><%= vm.gCL( "LSHMYL_TH_5" ) %></th>
						</tr>
					</thead>
					<tbody>
					<%
						for (VCstSheetListDto dto : subDtoList) {
							String isHold = (userinfo.getLogin_no().equals(dto.getHoldGuid())) ? "isHold" : "" ;
							if ("1".equals(dto.getActiveFlg())) { continue; }
					%>
						<tr>
							<td><%= JspUtil.toPlainText( dto.getOperationNm()  ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol5()     ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol6()     ) %></td>
							<td><%= JspUtil.toPlainText( dto.getListCol7()    ) %></td>
							<td class="<%= isHold %>"><a href="#" class="sh-status-chip" data-sheetid="<%= dto.getSheetId() %>"><%= dto.getStatusNm() %></a></td>
						</tr>
					<% } %>
					</tbody>
				</table>
			</div><!-- /.paper -->
		</div><!-- /.mod-table -->

	</div><!-- /.container -->
</div><!-- /.desk -->


<%-- ==================================================/Main Content Area ==================================================--%>
<div style="display:none;">
	<fw:transit kinouId="VHD023">
	<input type="hidden" name="sheetId" value="">
	<input type="hidden" name="state" value="">
	<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
	</fw:transit>
</div>
</div><!-- /#gOperation -->
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
	$(document).on('click', 'a.sh-status-chip', function(event){
		event.preventDefault();
		var sheetId = $(this).data('sheetid');
		showSheet('/servlet/CsSheetServlet', 'INIT', sheetId);
	});
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
