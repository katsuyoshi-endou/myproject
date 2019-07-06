<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<style type="text/css">
.debuginfo {
	display: none;
	position: absolute;
	top: 10px;
	left: 10px;
	z-index: 9999;
	width: 60%;
	height: 90%;
	overflow: auto;
	padding: 20px;
	background: #fff;
	border: 1px solid #ddd;
	box-shadow: 0 1px 3px 0 #aaa;
	font-size: 12px;
	font-family: Arial;
}
.debuginfo h3 {
	padding: 0 0 4px;
	font-size: 20px;
	color: #555;
}
.debuginfo table {
	width: 100%;
	border-collapse: collapse;
}
.debuginfo th {
	padding: 4px;
	border: 1px solid #e9e9e9;
	background-color: #f7f7f7;
	text-align: left;
	color: #666;
}
.debuginfo td {
	padding: 4px;
	border: 1px solid #e9e9e9;
	font-family: monospace;
}
.debuginfo label {
	color: #999;
}
</style>
<div class="debuginfo">
<h3>Request Parameters</h3>
<table>
	<tr>
		<th style="width:25%;">Parameter Name</th>
		<th>Parameter Value</th>
	</tr>
<%
	Map reqParaMap = request.getParameterMap();
	TreeMap<String, String[]> paraMap = new TreeMap<String, String[]>( reqParaMap );
	for (Map.Entry<String, String[]> entry : paraMap.entrySet()) {
		String key = entry.getKey();
		String[] val = AU.encodeRequestValue( entry.getValue() );
		boolean isMulti = val.length > 1;
%>
	<tr>
		<td><%= key %></td>
		<% if (isMulti) { %>
		<td>
		<% for (int i=0; i<val.length; i++) { %>
		<label><%= "["+i+"] " %></label><%= StringEscapeUtils.escapeXml( val[i] ) %><br>
		<% } %>
		</td>
		<% } else { %>
		<td><%= StringEscapeUtils.escapeXml( val[0] ) %></td>
		<% } %>
	</tr>
<%
	}
%>
</table>
</div>
<!-- $('.debuginfo').show(); -->
