<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
	String query = (String)request.getQueryString();
	query = (query == null) ? "" : "?" + query ;
%>

<title></title>

<script>

function openWindow() {
	var url = "../servlet/PreLoginServlet<%=query%>";
	//var agent = navigator.userAgent;
	//
	//if (window.name != "hcdb_main") {
	//	if (agent.indexOf('MSIE') >= 0) {
	//		var win = window.open("","hcdb_main");
	//		if (win != null && typeof win !== "undefined") {
	//			(win.open('','_self').opener=win).close();
	//		}
	//	}
	//}
	//
	//window.name = "hcdb_main";
	document.location = url;
}

</script>
</head>
<body onload="openWindow();" onMouseDown="return false;" >
<form name="form1" method="post">
</form>
</body>
</html>