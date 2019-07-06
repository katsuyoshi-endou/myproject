<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<jsp:useBean id="oneMenu" class="jp.co.hisas.career.app.common.bean.CareerMenuBean" scope="session" />
<%
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	String sheettemplate  = AU.getSessionAttr( session, CsSessionKey.CS_SHEET_TEMPLATE );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Form Layout
------------------------------------------------------------------------------------------------------------------------------%>

	<div class="hyokasheet-header">
		<%-- ヘッダボタン --%>
		<jsp:include page="../module/CsMd-HeaderBtns.jsp" flush="false" />
		
		<%-- 共通ヘッダ部品 --%>
		<jsp:include page="CsF-pkg_CommonHeader.jsp" flush="false" />
		
		<%-- シートステータス部品 --%>
		<jsp:include page="../module/CsMd-StatusFlow.jsp" flush="false" />
	</div>


	<div class="hyokasheetInner">

		<div class="sheet-section">
			
			<%-- シートテンプレート --%>
			<div id="us-template-rendering" class="readonly"></div>
			
		</div><!-- /sheet-section -->

	</div><!-- /hyokasheetInner -->



<%-- ========================================= Underscore.js Template Layout Layer =========================================--%>
<%-- C:/lysitheacareer/sheettemplate --%>
<%= sheettemplate %>
