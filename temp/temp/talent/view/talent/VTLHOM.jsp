<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher("/view/error.jsp").forward( request, response );
	}
%>
<% Log.method( userinfo.getLogin_no(), "IN", "" ); %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.talent.command.PTLHOMCommand" %>
<fw:init commandClass="<%= PTLHOMCommand.class %>" kinouTitle="<%= CommonParameter.getFuncName(PTLHOMCommand.KINOU_ID) %>" />
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%!
	
%>
<%
	AU.setReqAttr( request, "FUNC_TITLE", CommonLabel.getLabel( userinfo.getParty(), "LTLHOM_TITLE", userinfo.getLangNo() ) );
	
	VmVTLHOM vm = AU.getSessionAttr( session, VmVTLHOM.VMID );
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
<body id="lyca" data-vmid="VmVTLHOM">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody" class="hasSidebar">
<%-- Sidebar -----------------------------------------------------------------------------------------------------------------%>

<jsp:include page="/view/talent/VTL_Sidebar.jsp" flush="false" />

<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<fw:transit kinouId="VTLHOM">
<%-- ================================================== Right Content Area =================================================--%>


	<div class="desk">
		<div class="container">
			<jsp:include page="./InstantSearch.jsp" flush="false" />
		</div>
	</div><!-- /.desk -->


<input type="hidden" name="selectedMenuId" value="">


<%-- ==================================================/Main Content Area ==================================================--%>
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->

<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
