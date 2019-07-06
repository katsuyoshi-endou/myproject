<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.common.vm.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVCAAPP vm = new VmVCAAPP( tray );
	
	String guid  = SU.ntb( tray.userinfo.getLogin_no() );
	String simei = SU.ntb( tray.userinfo.getKanjiSimei() );
	String funcTitle = SU.ntb( (String) AU.getRequestAttr( request, "FUNC_TITLE" ) );
	
	/* Logout or Error */
	boolean isExit = "true".equals( (String)request.getParameter("isexit") );
%>
<div id="gHeader">
	<div class="appbar">
		<div class="holder">
			<div class="appbar-L">
				<nav class="appLogo">
					<a class="appName backToHome" href="#">
						<span class="title"><%= vm.gCL("APP_NAME") %></span>
					</a>
				</nav>
				<button class="btn btn-transp backToHome" type="button">
					<i class="fa fa-home"></i>
					<span><%= vm.gCL("APP_BTN_HOME") %></span>
				</button>
			</div>
			<div class="appbar-C">
				<% if (!isExit) { %>
				<div class="func-title"><%= funcTitle %></div>
				<% } %>
			</div>
			<div class="appbar-R">
				<% if (AU.isDebugMode()) { %>
					<div class="debug-mode">DEBUG MODE</div>
				<% } %>
				<% if (!isExit) { %>
				<div class="btn-group">
					<button type="button" class="btn btn-transp dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<i class="fa fa-user"></i><span><%= simei %></span><i class="fa fa-caret-down"></i>
					</button>
					<ul class="dropdown-menu dropdown-menu-right">
						<li><span><%= guid %></span></li>
						<li role="separator" class="divider"></li>
						<li>
							<a href="#" id="logout">
								<i class="fa fa-sign-out"></i>
								<span><%= vm.gCL("APP_BTN_LOGOUT") %></span>
							</a>
						</li>
					</ul>
				</div>
				<% } %>
			</div>
		</div>
	</div>
</div>
