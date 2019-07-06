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
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%@ page import="jp.co.hisas.career.app.talent.command.PDD041Command" %>
<fw:init commandClass="<%= PDD041Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PDD041Command.KINOU_ID) %>" />
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%@ page import="jp.co.hisas.career.app.talent.util.*" %>
<%@ page import="jp.co.hisas.career.app.talent.bean.*" %>
<%@ page import="jp.co.hisas.career.app.talent.servlet.JvPzCsvDownloadServlet" %>
<%
	Tray tray = new Tray( request, response );
	VmVTLCSV vm = new VmVTLCSV( tray );

	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LTLCSV_TITLE" ) );

	List<JvProfTabSectDto> tabSects   = AU.getSessionAttr( session, JvSessionKey.SRCH_VISIBLE_TAB_SECTS );
	Map<String, JvSectTblMapDto> sectTblMap = AU.getSessionAttr( session, JvSessionKey.SRCH_SECT_TBL_MAP );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
</head>
<body id="lyca" data-vmid="VmVTLCSV">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<%-- ================================================== Main Content Area ==================================================--%>

	<div class="navbarBtns">
		<div class="leftArea">
			<button class="btn btn-back" id="transBACK" type="button"><%= vm.gCL( "LTLCSV_BTN_BACK" ) %></button>
			<% if (AU.isDebugMode()) { %><button type="button" id="transRELOAD" class="btn">RELOAD</button><% } %>
		</div>
		<div class="centerArea">
		</div>
		<div class="rightArea">
		</div>
	</div>

	<div class="showcase-500">
	<%
		for (JvProfTabSectDto dto : tabSects) {
			String bxOrLt = SU.equals( dto.getLayoutType(), "Box" ) ? "_BX" : "_LT";
			String sectptn = dto.getSectId() + bxOrLt;
			JvSectTblMapDto mDto = sectTblMap.get( dto.getSectId() );
			if (mDto == null) {
				continue;
			}
	%>
		<div class="pnl" data-sectptn="<%= sectptn %>">
			<div class="pnl-title">
				<span class="title"><%= mDto.getCsvPtnNm() %></span>
				<button type="button" class="btn btn-neon do-download"><i class="fa fa-download"></i><%= vm.gCL( "LTLCSV_BTN_DL" ) %></button>
			</div>
		</div>
	<%
		}
	%>
	</div>


<%-- ==================================================/Main Content Area ==================================================--%>
<div style="display:none;">
	<fw:transit kinouId="VTLCSV">
	<input type="hidden" name="state" value="">
	<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
	</fw:transit>
</div>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>

$(function(){
	$document = $(document);

	 /**
	 ** Initialize
	**/
	$document.on('click', '.do-download', function(){
		var sectptn = $(this).closest('.pnl').attr('data-sectptn');
		downloadJvPzCsvFile( sectptn );
	});

	 /**
	 ** Header Buttons
	**/
	$document.on('click', '#transBACK', function(){
		pageSubmit('/app/list/index.jsp', 'RESTORE');
	});
	$document.on('click', '#transRELOAD', function(){
		pageSubmit('/view/talent/search/VTLCSV_CSV.jsp', 'INIT');
	});

	 /**
	 ** Security Guard
	**/
	// 右クリック禁止
	$document.bind("contextmenu", function(e){
		return false;
	});
	// 選択禁止
	$document.bind("selectstart", function(e){
		return false;
	});

	 /**
	 ** After Process
	**/
});

function downloadJvPzCsvFile( sectptn ) {
	if (!chkTimeout()) { return false; }
	makeRequestParameter( "sectptn", sectptn );
	document.F001.action = App.root + "/servlet/JvPzCsvDownloadServlet";
	document.F001.state.value = 'SECT';
	document.F001.submit();
	showBlockingOverlay();
}

</script>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</body>
</html>
