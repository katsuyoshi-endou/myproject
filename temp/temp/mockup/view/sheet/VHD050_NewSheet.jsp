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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD050Command" %>
<fw:init commandClass="<%=PHD050Command.class%>" kinouTitle="<%=CommonParameter.getFuncName(PHD050Command.KINOU_ID)%>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHNEW_TITLE" ) );
	
	List<VCsmActiveOpeFormDto> formList = AU.getSessionAttr( session, CsSessionKey.CS_ACTIVE_OPE_FORM_LIST );
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
<body id="lyca" data-vmid="VmSHVNEW">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD050">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk"><div class="container">
<%-- ================================================== Main Content Area ==================================================--%>

	<div class="navbarBtns">
		<div class="leftArea">
			<button class="btn btn-back backToHome" type="button"><%= vm.gCL( "LSHNEW_NAV_BACK" ) %></button>
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
			<button id="create" class="btn btn-secondary"><i class="fa fa-check"></i><%= vm.gCL( "LSHNEW_CRAT_BTN" ) %></button>
		</div>
	</div>

	<div class="mod-table" style="width:75%; margin:0 auto;">
		<h3 class="sectionTitleSecond" style="font-size:16px;margin-top:30px;"><%= vm.gCL( "LSHNEW_TITLE_ACTIVE" ) %></h3>
		<table>
			<thead>
				<tr>
					<th style="width:25px;"></th>
					<th class="colA"><%= vm.gCL( "LSHNEW_TH_01" ) %></th>
					<th class="colC"><%= vm.gCL( "LSHNEW_TH_02" ) %></th>
				</tr>
			</thead>
			<tbody>
			<%
				for (VCsmActiveOpeFormDto dto : formList) {
					String argOpe = dto.getOperationCd();
					String argGrp = dto.getFormGrpCd();
					String argFrm = dto.getFormCd();
			%>
				<tr>
					<td class="center">
						<div class="radio no-margin">
							<label>
								<input type="radio" name="selectedForm" data-arg-ope="<%= argOpe %>" data-arg-grp="<%= argGrp %>" data-arg-frm="<%= argFrm %>" />
								<i class="fa fa-circle"></i>
							</label>
						</div>
					</td>
					<td><%= JspUtil.toPlainText( dto.getOperationNm() ) %></td>
					<td><%= JspUtil.toPlainText( dto.getFormNm()      ) %></td>
				</tr>
			<% } %>
			</tbody>
		</table>
	</div><!-- /outputTable -->


<input type="hidden" name="operationCd" value="">
<input type="hidden" name="formGroupCd" value="">
<input type="hidden" name="formCd" value="">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>

var ccpL = {};
ccpL["LSHNEW_MSG_NOT_SEL"] = '<%= vm.gCL( "LSHNEW_MSG_NOT_SEL" ) %>';

$(function(){
	 /**
	 ** Initialize
	**/
	//$($(':radio[name="selectedForm"]')[0]).prop('checked', true);
	
	 /**
	 ** Event
	**/
	$(document).on('click', '#create', function(event){
		var $choice = $(':radio[name="selectedForm"]:checked');
		if ($choice.length == 0) {
			alert(ccpL["LSHNEW_MSG_NOT_SEL"]);
			return false;
		}
		document.F001.operationCd.value = $choice.attr('data-arg-ope');
		document.F001.formGroupCd.value = $choice.attr('data-arg-grp');
		document.F001.formCd.value      = $choice.attr('data-arg-frm');
		pageSubmit('/servlet/CsNewSheetServlet', 'CREATE');
	});
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
