<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.common.vm.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVCAAPP vm = new VmVCAAPP( tray );
	
	String funcTitle = SU.ntb( (String) AU.getRequestAttr( request, "FUNC_TITLE" ) );
%>
<script>
/* Window Auto Close */
var serverKey = '<%= (String)session.getAttribute( "WindowKey" ) %>';
var cookieKey = '';
setInterval( "checkWindowKey()", 1000 );
</script>


<div id="gHeader">
	<div class="appbar">
		<div class="holder">
			<div class="appbar-L">
				<nav class="appLogo">
					<span class="appName">
						<span class="title"><%= vm.gCL("APP_NAME") %></span>
					</span>
				</nav>
			</div>
			<div class="appbar-C">
				<div class="func-title"><%= funcTitle %></div>
			</div>
			<div class="appbar-R">
				<div class="func-logout">
					<button class="btn btn-transp" type="button" onclick="javascript:window.close();">
						<i class="fa fa-close"></i>
						<span><%= vm.gCL("APP_BTN_CLOSE") %></span>
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
