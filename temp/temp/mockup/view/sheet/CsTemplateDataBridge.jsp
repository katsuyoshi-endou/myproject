<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
%>
<script>
var _data = {};
_data["user"]  = <%= SU.toJson( userinfo ) %>;
_data["sheet"] = <%= SU.toJson( jsp.sheetInfoAttr ) %>;
_data["fill"] = { "dummy" : ''
<% for (Map.Entry<String, String> entry : jsp.getTemplateDataFillMap().entrySet()) { %>
	, "<%= entry.getKey() %>" : '<%= CsUtil.escapeForHTML( entry.getValue() ) %>'<% } %>
};
_data["label"] = <%= SU.toJson( jsp.getLabelSetMap() ) %>;
_data["param"] = <%= SU.toJson( jsp.getParamSetMap() ) %>;
_data["actor"] = { "dummy" : ''
<% for (VCstSheetActorAndRefDto dto : jsp.getActorAndRefererAll()) { %>
	, "<%= dto.getActorCd() %>": {
		  "actOrRef": '<%= dto.getActOrRef() %>'
		, "actorNm": '<%= CsUtil.escapeForJS( dto.getActorNm() ) %>'
		, "actorSort": '<%= dto.getActorSort() %>'
		, "guid": '<%= dto.getGuid() %>'
		, "personName": '<%= CsUtil.escapeForJS( dto.getPersonName() ) %>'
	  }<% } %>
};
_data["tooltip"] = function(str) {
	return '<span data-toggle="tooltip" title="'+str+'"><i class="fa fa-info-circle"></i></span>';
}
_data["checkmark"] = function(arg) {
	var judge = false;
	if (typeof arg === "boolean") { judge = arg; }
	if (typeof arg === "string")  { judge = (arg === "on"); }
	return judge ? '<i class="checkmark fa fa-check"></i>' : '';
}
</script>
