<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<jsp:useBean id="jvProfileBean" class="jp.co.hisas.career.app.talent.bean.JvProfileBean" scope="session" />
<%!
	String getViewStr(String str) {
		String s = PZZ010_CharacterUtil.sanitizeStrData( str ).replaceAll("\\n","<br>");
		       s = ("".equals(s)) ? "-" : s ;
		return s;
	}
%>
<%
	String[] komokuIdArr = {
		"buyer_kenshu_kamoku_gr",
		"buyer_kenshu_hissu_kbn",
		"buyer_kenshu_kamoku_cd",
		"buyer_kenshu_kamoku",
		"buyer_kenshu_jukojokyo",
		"buyer_kenshu_shuryobi",
		"buyer_kenshu_ryakusho"
	};
%>
<%------------------------------------------------------------------------------------------------------------------------------
	Section HTML
------------------------------------------------------------------------------------------------------------------------------%>
<style>
#SkillCheckSteps {
  background-color: #fff;
}
#SkillCheckSteps svg {
  display: block;
  margin: 0 auto;
}
</style>

<div id="SkillCheckSteps"></div>

<script>
var scs_skills = <%= jvProfileBean.getShelfJsonByPzIds( komokuIdArr ) %>;
var buyer_shikaku_2 = '<%= jvProfileBean.getCValue( "buyer_shikaku_2" ) %>';
var buyer_shikaku_1 = '<%= jvProfileBean.getCValue( "buyer_shikaku_1" ) %>';


/*
 * K2 - 選択:s 必須:h
 * K1 - 選択:s 選択必須:h
 */

$(function() {
	
	SkillCheckSteps.draw(scs_skills, buyer_shikaku_2, buyer_shikaku_1);
	
});
</script>

<script src="/<%= AppDef.CTX_ROOT %>/assets/vendor/d3.v3.min.js"></script>
<script src="/<%= AppDef.CTX_ROOT %>/view/talent/profile/addons/SkillCheckSteps.js"></script>
