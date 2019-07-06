<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%
	boolean isMainWindow = !"SubWindow".equals( AU.getRequestValue( request, "windowMode" ) );
%>
<%-- Under Body Tag ----------------------------------------------------------------------------------------------------------%>
<% if (isMainWindow) { %>
<jsp:include page="/view/common/VYC_AppHeader.jsp" flush="false" />
<% } else { %>
<jsp:include page="/view/common/VYC_AppHeaderMini.jsp" flush="false" />
<% } %>
<jsp:include page="/view/common/VYC_Message.jsp" flush="false" />
