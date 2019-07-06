<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ page import="java.util.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.*"%>
<%@ page import="jp.co.hisas.career.util.*"%>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%@ page import="jp.co.hisas.career.app.common.bean.UserInfoBean" %>
<%
	VmVTLPTC vm = AU.getRequestAttr( request, VmVTLPTC.VMID );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL("LTLPTC_TITLE") );
	
	UserInfoBean userInfo = AU.getSessionAttr( session, UserInfoBean.SESSION_KEY );
	String loginGuid = userInfo.getLogin_no();
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html class="FullHeight">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
</head>
<body id="lyca" data-vmid="VmVTLPTC">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<%-- ================================================== Main Content Area ==================================================--%>

<div id="VueTLPTC" v-cloak class="desk no-padd">

	<jsp:include page="/view/talent/vue/components/tlptc-modal.jsp" flush="false" />
	<jsp:include page="/view/talent/vue/components/tlptc-shareptc.jsp" flush="false" />

</div><!-- /#VueTLPTC.desk -->


<%-- ==================================================/Main Content Area ==================================================--%>
<div style="display:none;">
	<fw:transit kinouId="VTLPTC">
	<input type="hidden" name="state" value="">
	<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
	</fw:transit>
</div>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/talent/vue/VueTLPTC.js?_v=<%= AU.getYYYYMMDD() %>"></script>
<script>
var vm = <%= SU.toJson(vm) %>;
var loginUser = { guid: '<%= loginGuid %>' };
function __startup() {
	mountVueTLPTC(vm, loginUser);
}
</script>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
