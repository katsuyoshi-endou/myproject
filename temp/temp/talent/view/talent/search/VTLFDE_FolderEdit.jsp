<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ page import="java.util.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.util.*"%>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*"%>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%@ page import="jp.co.hisas.career.app.talent.command.PTLFDECommand" %>
<fw:init commandClass="<%= PTLFDECommand.class %>" />
<%
	VmVTLFDE vm    = AU.getRequestAttr( request, "vm" );
	VmVTLHOM vmHom = AU.getSessionAttr( session, VmVTLHOM.VMID );

	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LTLFDE_TITLE" ) );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<style type="text/css">
.showcase-400.fb .fa {
  align-self: flex-end;
  font-size: 24px;
  margin: 0 15px 4px 0;
  color: #ccc;
}
.showcase-400.fb .vrt {
  width: 100%;
}
</style>
</head>
<body id="lyca" data-vmid="VmVTLFDE">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<% if (!vm.isNew) { %>
			<button class="btn btn-back" id="transBACK" type="button"><%= vm.gCL("LTLFDE_BTN_BACK") %></button>
			<% } %>
		</div>
		<div class="centerArea">
			<i class="fa fa-folder"></i>
			<span><%= vm.escx( vm.myFolder.getMyfoldNm() ) %></span>
			<% if (vm.isShared) { %><span class="chip-shared"><%= vm.gCL("LTLAPP_SHARE_CHIP") %></span><% } %>
		</div>
		<div class="rightArea">
			<% if (!vm.isNew) { %>
			<button type="button" id="do-myfld-delete" class="btn btn-delete"><%= vm.gCL("LTLFDE_BTN_DEL") %></button>
			<% } %>
			<button type="button" class="btn btn-secondary do-ok"><i class="fa fa-check"></i><%= vm.gCL("LTLFDE_BTN_OK") %></button>
		</div>
	</div>

	<div class="ope-board">
		<div class="whitebd">
			<div class="tl-result-header">
				<div class="showcase-400 fb">
					<i class="fa fa-folder"></i>
					<label class="vrt">
						<span class="lbl"><%= vm.gCL("LTLFDE_LBL_DISPNM") %></span>
						<input type="text" name="new_folder_name" value="<%= vm.escx(vm.myFolder.getMyfoldNm()) %>" maxlength="20" />
					</label>
				</div>
			</div>
		</div>
		<hr>
	</div><!-- /.ope-board -->


<%-- ==================================================/Main Content Area ==================================================--%>
<div style="display:none;">
	<fw:transit kinouId="VTLFDE">
	<input type="hidden" name="state" value="">
	<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
	</fw:transit>
</div>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
__MsgMap = {};
__MsgMap["LTLFDE_NEW_FOLD_DEFAULT_NM"] = '<%= vm.gCL("LTLFDE_NEW_FOLD_DEFAULT_NM") %>';
$(function(){
	$document = $(document);
	 /**
	 ** Initialize
	**/

	 /**
	 ** Event
	**/
	$document.on('click', '#transBACK', function(){
		pageSubmit('/app/list/index.jsp', 'RESTORE');
	});

	$document.on('click', '#do-myfld-delete', function(){
		if (!confirm("<%= vm.gCL("LTLFDE_MSG_DEL_CONFIRM") %>")) { return false; }
		pageSubmit("/servlet/MyFolderServlet", "DELETE");
	});

	$document.on('click', '.do-ok', function(){
		var foldnm = $('[name="new_folder_name"]').val();
		if (foldnm === "") {
			foldnm = __MsgMap["LTLFDE_NEW_FOLD_DEFAULT_NM"];
		}
		makeRequestParameter('new_folder_name', foldnm);
		pageSubmit("/servlet/MyFolderServlet", "SAVE");
	});
});
</script>

<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</body>
</html>
