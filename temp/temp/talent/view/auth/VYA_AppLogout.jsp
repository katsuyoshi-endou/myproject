<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%
	String msg = AU.getRequestAttr( request, "logout_message" );
	String wndTitle = AU.getRequestAttr( request, "window_title" );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html class="FullHeight">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
</head>
<body id="lyca" data-vmid="VmVCALGO">
<div id="gApp">
<div id="gBody">
	<div class="fullHeight layout-gate stack-vertical">

		<div class="central gate-body">
			<div class="mod-login-form paper">
				<div class="text-center" style="margin-top:1em;">
					<p><%= msg %></p>
				</div>
			</div>
		</div>

	</div>
</div><!-- /#gBody -->
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
<script>
$(function() {
	$('title').html('<%= wndTitle %>')
});
</script>
</html>
