<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%
	String lblTitle = CommonLabel.getLabel( userinfo.getParty(), "LYA010_TITLE", userinfo.getLangNo() );
	String lblId    = CommonLabel.getLabel( userinfo.getParty(), "LYA010_ID", userinfo.getLangNo() );
	String lblPw    = CommonLabel.getLabel( userinfo.getParty(), "LYA010_PW", userinfo.getLangNo() );
	String lblBtn   = CommonLabel.getLabel( userinfo.getParty(), "LYA010_BTN", userinfo.getLangNo() );
	String personCodeMaxLength = AU.getCareerProperty("SIMEI_NO_MAX_LENGTH");
	String errMsg = PZZ010_CharacterUtil.normalizedStr((String)request.getAttribute("DB_ERR_MSG"));
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html class="FullHeight">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<style type="text/css">
</style>
</head>
<body id="lyca" data-vmid="VmVCALGI">
<div id="gApp">
<div id="gBody" class="dispOff">
	<div id="fLogin" class="dispOff fullHeight layout-gate stack-vertical">

		<div class="central gate-body">
			<div class="mod-login-form paper">
				<div class="logo">
					<div class="logo-img"></div>
				</div>
				<form name="form1" class="form-body" onsubmit="return false;">
					<div class="form-group">
						<div class="msg"><%= errMsg %></div>
					</div>
					<div class="fb fb-lr">
						<div class="form-group fi fi-flex1">
							<label>Party</label>
							<input class="form-control" type="text" name="p" value="<%= AU.getCareerProperty("DEFAULT_PARTY") %>">
						</div>
						<div class="form-group fi fi-flex1" style="margin-left:15px;">
							<label>Language</label>
							<div class="select block">
								<label>
									<select name="lang" class="block">
										<option value="ja">ja</option>
										<option value="en-US">en</option>
										<option value="zh">zh</option>
									</select>
								</label>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label>Global User ID</label>
						<input class="form-control" type="text" name="guid" maxlength="<%= personCodeMaxLength %>">
					</div>
					<div class="form-group">
						<label>Password</label>
						<input class="form-control" type="password" name="password">
					</div>
					
					<button type="submit" id="LoginBtn" class="btn btn-big btn-primary block">Login</button>
					
					<input type="hidden" name="authType" value="appAuth">
				</form>
			</div>
		</div>

		<footer>
		</footer>

	</div>
</div><!-- /#gBody -->


<script type="text/javascript">
function login(arg){
	if(document.form1.guid.value === ""){
		alert("<%= lblId %>を入力してください。");
		document.form1.guid.focus();
		return false;
	}
	if(document.form1.password.value === ""){
		alert("<%= lblPw %>を入力してください。");
		document.form1.password.focus();
		return false;
	}
	document.getElementById("LoginBtn").disabled = true;
	document.form1.action="/<%= AppDef.CTX_ROOT %>/servlet/LoginServlet";
	document.form1.method = "POST";
	document.form1.submit();
	return true;
}

$(function(){
	$(window).bind("load", function() {
		$('#container').fadeIn(300,'swing').removeClass('dispOff');
		document.form1.guid.focus();
	});
	
	$(document).on('click', '#LoginBtn', function(){
		login();
	});
});
</script>
</div><!-- /#gApp -->
</body>
</html>
