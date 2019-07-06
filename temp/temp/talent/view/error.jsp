<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" isErrorPage="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.common.bean.UserInfoBean" %>
<%@ page import="jp.co.hisas.career.framework.exception.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%!
	String getHintMsg( String errMsg ) {
		if (errMsg == null) { return ""; }
		Map<String, String> hintMap = new HashMap<String, String>();
		
		hintMap.put( "The Network Adapter could not establish the connection", "データベース接続に失敗しました。接続設定を確認してください。" );
		hintMap.put( "列名が無効です", "SELECT句の AS がDTO変換ルール用（ ITEM_NO1 AS itemNo1 ）になっていない可能性があります。" );
		hintMap.put( "列索引が無効です", "動的SQLの ? の数がパラメータリストと一致していない可能性があります。" );
		
		String hintMsg = "";
		for (String hintKey : hintMap.keySet()) {
			if (errMsg.contains( hintKey )) {
				hintMsg = hintMap.get( hintKey );
			}
		}
		return hintMsg;
	}
%>
<%
	AU.setReqAttr( request, "FUNC_TITLE", "Error" );
	userinfo = AU.nvl( userinfo, new UserInfoBean() );
	String loginNo = userinfo.getLogin_no();
	String errMsg   = AU.getSessionAttr( session, "VYY_ERROR_PAGE_REQUEST_KEY" );
	String dbErrMsg = AU.getRequestAttr( request, "DB_ERR_MSG" );
	Exception e     = AU.getRequestAttr( request, "Exception" );
	if (e != null) {
		if (AU.isDebugMode()) {
			errMsg = e.getMessage();
		} else if (SU.isNotBlank( dbErrMsg )) {
			errMsg = dbErrMsg;
		} else if (e instanceof SQLException) {
			errMsg = "データベース接続エラーです。";
		} else {
			errMsg = "アプリケーションエラーです。";
		}
		// 標準エラー出力に出力
		System.err.println( "*** Message From error.jsp ***" );
		System.err.println( e );
	}
	else if (SU.isNotBlank( errMsg )) {
		session.removeAttribute("VYY_ERROR_PAGE_REQUEST_KEY");
	}
	else if (SU.isBlank( loginNo )) {
		// 操作のない状態が続いたためタイムアウトしました。
		errMsg = CommonLabel.getLabel( userinfo.getParty(), "FW_MSG_TIMEOUT_ERR", userinfo.getLangNo() );
	}
	else {
		errMsg = AU.getCareerProperty( "ERRMSG_UNEXPECTED" );
	}
	
	String hintMsg = getHintMsg( errMsg );
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
#hintMsgArea {
	margin: 0 2em;
}
#hintMsgArea p {
	margin: 2em 0;
	padding: 12px 10px 10px 45px;
	color: #0000AF;
	border: 1px solid #0000AF;
	background-color: #DDFAFF;
}
.stacktrace {
	padding: 12px 10px 10px 45px;
	font-family: Consolas;
}
</style>
</head>
<body id="lyca" data-vmid="VmVCAERR">
<div id="gApp">
<jsp:include page="/view/common/VYC_AppHeader.jsp?isexit=true" flush="false" />
<div id="gBody">
	<div id="gOperation">
		<div class="desk">
			<div class="container">
				<div class="result-msg msg-error">
					<div class="lbl">Error</div>
					<div class="body"><%= errMsg %></div>
				</div>

				<% if (AU.isDebugMode()) { %>
				<div class="pnl">
					<div class="pnl-body">
						<% if (SU.isNotBlank( hintMsg )) { %>
						<div id="hintMsgArea">
							<p><%= hintMsg %></p>
						</div>
						<% } %>
						<div class="stacktrace">
							<% if (e != null) { for (StackTraceElement ste : e.getStackTrace()) { %>
							<%= ste.getClassName() + " #" + ste.getMethodName() + " (" + ste.getFileName() + ":" + ste.getLineNumber() + ")" %><br>
							<% } } %>
						</div>
					</div>
				</div>
				<% } %>

			</div>
		</div>
	</div><!-- /#gOperation -->
</div><!-- /#gBody -->


<div id="stacktrace" style="display:none;">
<%= e %>
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
<% if (e != null) { for (StackTraceElement ste : e.getStackTrace()) { %>
<%= ste.getClassName() + " #" + ste.getMethodName() + " (" + ste.getFileName() + ":" + ste.getLineNumber() + ")" %>
<% } } %>
</div>

<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
