<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ page import="jp.co.hisas.career.util.cache.*" %>
<%
	/* レイアウトテンプレートのキャッシュクリア */
	LayoutTemplateCache.clearCache();
	
	/* シートテンプレートのキャッシュクリア */
	CsTemplateCache.clearCache();
	
	String action = request.getParameter( "action" );
	String msg = "";
	String rsltMsg = "";
	if (action != null) {
		int index = Integer.parseInt( action );
		switch( index ) {
			case 1:
				msg = "CCP_PARAMの再読込";
				CommonParameter.find();
				break;
			case 2:
				msg = "CCP_LABELの再読込";
				Connection conn = PZZ040_SQLUtility.getConnection("");
				CommonLabel.find(conn);
				PZZ040_SQLUtility.close(conn);
				break;
			case 5:
				msg = "プロパティファイルの再読込";
				ReadFile.refreshAllProperties();
				break;
		}
	}
	if ( !"".equals( msg ) ) {
		rsltMsg = msg + "が完了しました。";
	}
%>
<html>
<head>
<title>refresh.jsp</title>
<style>
table td {
	padding: 5px;
}
</style>
</head>
<body>
	<ul style="color:red;">
		<li>レイアウトテンプレートのキャッシュをクリアしました。</li>
		<li>シートテンプレートのキャッシュをクリアしました。</li>
		<li><%= rsltMsg %></li>
	</ul>
	<table>
		<tr>
			<td>CCP_PARAM</td>
			<td><input type="button" value="再読込" onclick="location.href='refresh.jsp?action=1'"></td>
		</tr>
		<tr>
			<td>CCP_LABEL</td>
			<td><input type="button" value="再読込" onclick="location.href='refresh.jsp?action=2'"></td>
		</tr>
		<tr>
			<td>プロパティファイル</td>
			<td><input type="button" value="再読込" onclick="location.href='refresh.jsp?action=5'"></td>
		</tr>
	</table>
</body>
</html>
