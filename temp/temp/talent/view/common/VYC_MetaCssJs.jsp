<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
	<title><%= CommonLabel.getLabel( userinfo.getParty(), "APP_WINDOW_TITLE", userinfo.getLangNo() ) %></title>
<%--------------------------------------------- Meta ---------------------------------------------%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="Content-Style-Type" content="text/css">
	<meta http-equiv="Content-Script-Type" content="text/javascript">
	<meta name="format-detection" content="telephone=no"><%-- for iPhone --%>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<meta http-equiv="Expires" content="Sat, 01 Jan 2000 00:00:00 GMT">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
<%!
	private String getHTTPDate() {
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("E, dd MMM yyyy hh:mm:ss zzz", java.util.Locale.US);
		formatter.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
		return formatter.format(new java.util.Date());
	}
%>
<%
	response.setHeader("Expires", getHTTPDate());
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-cache");
	
	String customCssPath = AU.getCareerProperty( "CUSTOM_CSS_PATH" );
%>
<%--------------------------------------- Vendor Libraries ---------------------------------------%>

	<!-- Vendor libraries bundled by webpack -->
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/bundle/vendor.bundle.js"></script>

	<!-- Custom components bundled by webpack -->
	<script src="/<%= AppDef.CTX_ROOT %>/assets/bundle/components.bundle.js"></script>
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/bundle/components.bundle.css" />

	<!-- Vue mount scripts bundled by webpack -->
	<script src="/<%= AppDef.CTX_ROOT %>/assets/bundle/vueapp.bundle.js"></script>

	<!-- Bootstrap -->
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/bootstrap-3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/vendor/bootstrap-3.3.7/css/bootstrap.min.css" media="screen">

	<!-- Tippy.js -->
	<script src="/<%= AppDef.CTX_ROOT %>/assets/vendor/tippy.all.min.js"></script>

	<!-- FontAwesome -->
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/vendor/font-awesome-4.7.0/css/font-awesome.min.css">

	<!-- Lysithea -->
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/vendor/lysithea/css/lysithea.css" media="screen, projection" />

<%------------------------------------------- This App -------------------------------------------%>

	<!-- CSS -->
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/bundle/style.bundle.css" />
	<% if (SU.isNotBlank( customCssPath )) { %>
	<link rel="stylesheet" href="<%= customCssPath %>" />
	<% } %>

	<!-- JavaScript -->
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/dyres/labelmap.js"></script>
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/lysithea/js/common.js"></script>
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/lysithea/js/jQ-common.js"></script>

<%-- !! scripts also exists on GlobalFooter !! --%>
