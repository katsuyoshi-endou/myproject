<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />


<% if (AU.isDebugMode()) { %>
<%-- DEBUG INFO --%>
<jsp:include page="/view/common/VYC_DebugInfo.jsp" flush="false" />
<% } %>


<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/lysithea/js/components-fw.js"></script>

<% if (SU.equals( AppDef.APP_ID, "Sheet" )) { %>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/js/components-sheet.js"></script>
<% } else if (SU.equals( AppDef.APP_ID, "Talent" )) { %>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/js/components-talent.js"></script>
<% } else if (SU.equals( AppDef.APP_ID, "Admin" )) { %>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/js/components-admin.js"></script>
<% } %>

<script>
var __serverKey = '<%= (String)session.getAttribute("WindowKey") %>';
var __cookieKey = '';

$(function(){
	App.root = "/<%= AppDef.CTX_ROOT %>";
	App.Config = { PopAlertTimeout: true };
	App.loadLabelMap(__labelMap);
	App.activate();
	App.startup();
	
	/* Window Auto Close */
	setInterval( "checkWindowKey()", 1000 );
	
	/* Alert Before Session Timeout  */
	if (App.Config.PopAlertTimeout) {
		setPopAlertAt('<%= session.getMaxInactiveInterval() %>');
		setInterval( function(){ popAlertTimeout(); }, 10000 );
	}
});
</script>


<% Log.method( userinfo.getLogin_no(), "OUT", "" ); %>
