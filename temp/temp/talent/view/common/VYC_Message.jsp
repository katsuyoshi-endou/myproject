<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.app.common.vm.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVCAAPP vm = new VmVCAAPP( tray );
	
	String errorMessage   = AU.getReqSesVal(request, AppSessionKey.RESULT_MSG_ERROR);
	String warningMessage = AU.getReqSesVal(request, AppSessionKey.RESULT_MSG_WARN);
	String successMessage = AU.getReqSesVal(request, AppSessionKey.RESULT_MSG_INFO);
	
	// セッションから削除
	request.getSession().removeAttribute(AppSessionKey.RESULT_MSG_ERROR);
	request.getSession().removeAttribute(AppSessionKey.RESULT_MSG_WARN);
	request.getSession().removeAttribute(AppSessionKey.RESULT_MSG_INFO);
%>

<%-- 全てメッセージがNULLなら領域を表示しない --%>
<%-- 表示順はエラー→警告→完了の優先で行なう --%>
<% if (errorMessage != null || warningMessage != null || successMessage != null) { %>
<div id="gMsg"><div class="container">

	<% if (errorMessage != null) { %>
	<div class="result-msg msg-error">
		<div class="lbl"><%= vm.gCL( "FW_MSG_RSLT_ERROR" ) %></div>
		<div class="body">
			<p><%= errorMessage %></p>
		</div>
	</div>
	<% } %>
	<% if (warningMessage != null) { %>
	<div class="result-msg msg-warn">
		<div class="lbl"><%= vm.gCL( "FW_MSG_RSLT_WARN" ) %></div>
		<div class="body">
			<p><%= warningMessage %></p>
		</div>
	</div>
	<% } %>
	<% if (successMessage != null) { %>
	<div class="result-msg msg-info">
		<div class="lbl"><%= successMessage %></div>
	</div>
	<% } %>

</div></div>
<% } %>
