<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%!
	String print( String str ) {
		return SU.nvl( CsUtil.escapeForHTML( str ), "" );
	}
%>
<%
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	boolean isMainWindow = !"SubWindow".equals( request.getParameter( "windowMode" ) );
	
	String state = AU.getRequestValue( request, "state" );
	boolean isVIEW = SU.equals( state, "VIEW" );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Form Layout
------------------------------------------------------------------------------------------------------------------------------%>

	<table class="titleArea">
		<tr>
			<td class="cellLeft">
				<ul>
					<li class="sheet-title-operation"><%= jsp.sheetInfo.getOperationNm() %></li>
					<li class="sheet-title-form"><%= jsp.sheetInfo.getFormNm() %></li>
				</ul>
<% if (isMainWindow) { %>
				<%
				String past1 = jsp.getFillContent( "RelatedSheetID-PAST1" );  String past1Nm = jsp.getLabel( "PAST1_NM" );
				String past2 = jsp.getFillContent( "RelatedSheetID-PAST2" );  String past2Nm = jsp.getLabel( "PAST2_NM" );
				%>
				<div class="refSheetLinks">
				<% if (!CsUtil.isBlank(past1)) { %><a class="refSheet" relatedId="RelatedSheetID-PAST1" relatedSheetId="<%= past1 %>" href="#"><%= past1Nm %></a><% } %>
				<% if (!CsUtil.isBlank(past2)) { %><a class="refSheet" relatedId="RelatedSheetID-PAST2" relatedSheetId="<%= past2 %>" href="#"><%= past2Nm %></a><% } %>
				</div>
<% } %>
			</td>
			<td class="cellRight">
				
				<div id="us-template-rendering-attr" class="readonly"></div>
				
			</td>
		</tr>
	</table>

