<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
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
<%@ page import="jp.co.hisas.career.app.talent.command.PTLPRFCommand" %>
<fw:init commandClass="<%= PTLPRFCommand.class %>" kinouTitle="<%= CommonParameter.getFuncName(PTLPRFCommand.KINOU_ID) %>" />
<jsp:useBean id="jvProfileBean" class="jp.co.hisas.career.app.talent.bean.JvProfileBean" scope="session" />
<%@ page import="jp.co.hisas.career.app.talent.bean.KomokuFilterBean" %>
<%@ page import="jp.co.hisas.career.app.talent.util.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%!
	String getViewStr(String str) {
		String s = str.replaceAll("\\n","<br>");
		       s = ("".equals(s)) ? "-" : s ;
		return s;
	}
%>
<%
	VmVTLPRF vm = AU.getRequestAttr( request, "vm" );
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LTLPRF_TITLE" ) );
	Tray tray = new Tray( request, response );
	boolean isMainWindow = !"SubWindow".equals( AU.getRequestValue( request, "windowMode" ) );

	String state = tray.state;
	String srchOrPcup = AU.getReqSesVal( request, JvSessionKey.SRCH_OR_PCUP );
	KomokuFilterBean kf = jvProfileBean.getKomokuFilter();

	// 前の人 / 次の人
	int crrSrchIdx = SU.toInt( (String)AU.getSessionAttr( session, JvSessionKey.TGT_SRCH_IDX ), 0 );
	boolean hasPrev = "true".equals( AU.getRequestAttr( request, "jvProfilePagingHasPrev" ) );
	boolean hasNext = "true".equals( AU.getRequestAttr( request, "jvProfilePagingHasNext" ) );

	// 表示対象のタブ情報
	List<String> tabList = jvProfileBean.tabList;
	tabList.remove( "COMMON-BOX" );

	//TODO: キャメルケース変換に使っているだけなので要改善
	HashMap<String, String> tabMap = new HashMap<String, String>();
	tabMap.put("TAB_01","tab01");  tabMap.put("TAB_11","tab11");  tabMap.put("TAB_21","tab21");
	tabMap.put("TAB_02","tab02");  tabMap.put("TAB_12","tab12");  tabMap.put("TAB_22","tab22");
	tabMap.put("TAB_03","tab03");  tabMap.put("TAB_13","tab13");  tabMap.put("TAB_23","tab23");
	tabMap.put("TAB_04","tab04");  tabMap.put("TAB_14","tab14");  tabMap.put("TAB_24","tab24");
	tabMap.put("TAB_05","tab05");  tabMap.put("TAB_15","tab15");  tabMap.put("TAB_25","tab25");
	tabMap.put("TAB_06","tab06");  tabMap.put("TAB_16","tab16");  tabMap.put("TAB_26","tab26");
	tabMap.put("TAB_07","tab07");  tabMap.put("TAB_17","tab17");  tabMap.put("TAB_27","tab27");
	tabMap.put("TAB_08","tab08");  tabMap.put("TAB_18","tab18");  tabMap.put("TAB_28","tab28");
	tabMap.put("TAB_09","tab09");  tabMap.put("TAB_19","tab19");  tabMap.put("TAB_29","tab29");
	tabMap.put("TAB_10","tab10");  tabMap.put("TAB_20","tab20");  tabMap.put("TAB_30","tab30");
	tabMap.put("TAB_EDGE","tabEdge");
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<style type="text/css">
div#content .sect div.outputTable {
	margin: 5px 0 30px 0;
}
.bgYellow {
	background-color: #FFFACD !important;
}
.english {
	font-family: Arial, 'ＭＳ ゴシック', sans-serif !important;
}
</style>
</head>
<body id="lyca" data-vmid="VmVTLPRF">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<fw:transit kinouId="VJA010">
<%-- ================================================== Main Content Area ==================================================--%>

<% if (isMainWindow) { %>
	<div class="navbarBtns">
		<div class="leftArea">
			<% if (vm.isFromSelf) { %>
			<button type="button" id="transJVSELF" class="do-back-home btn btn-back"><%= vm.gCL("LTLPRF_BACK_BTN") %></button>
			<% } else { %>
			<button type="button" id="transJVSRCH" class="BackToList btn btn-back"><%= vm.gCL("LTLPRF_BACK_BTN") %></button>
			<% } %>
		</div><!-- /leftArea -->
		<div class="rightArea">
			<div class="btns">
			<% if (kf.isVisible( "jvprof_pdf_dlbtn" )) { %>
				<%-- PDFダウンロード --%>
				<input type="button" id="transJVPdfChoice" class="btn" value='<%= vm.gCL("LTLPRF_PDF_BTN") %>' />
			<% } %>
			<%-- 前の人 / 次の人 --%>
			<% if (hasPrev) { %><button type="button" class="prev btn"><i class="fa fa-angle-double-left"></i>&nbsp;<%= vm.gCL("LTLPRF_PREV_BTN") %></button></li><% } %>
			<% if (hasNext) { %><button type="button" class="next btn"><%= vm.gCL("LTLPRF_NEXT_BTN") %>&nbsp;<i class="fa fa-angle-double-right"></i></button></li><% } %>
			</div>
		</div><!-- /rightArea -->
	</div>
<% } %>

<div class="desk no-padd">

	<%-- 共通表示領域 --%>
	<jsp:include page="/view/talent/profile/modules/JvProfCommonArea.jsp" flush="false" />

	<!-- タブ -->
	<div class="ope-board">
		<div class="container">
			<ul class="tabNavigation tabs">
				<%
					int tabCount = 0;
					for (String tabId : tabList) {
						if (tabCount == 0) {
				%>
				<li id="<%= tabMap.get(tabId) %>" class="tab active"><a href="#<%= tabMap.get(tabId) %>"><%= getViewStr(vm.gCL(tabId)) %></a></li>
				<% } else { %>
				<li id="<%= tabMap.get(tabId) %>" class="tab"><a href="#<%= tabMap.get(tabId) %>"><%= getViewStr(vm.gCL(tabId)) %></a></li>
				<%
						}
						tabCount++;
					}
				%>
			</ul>
		</div><!-- /.container -->
	</div><!-- /.ope-board -->

	<div class="container">
<%
	for (String tabId : tabList) {
%>
<%		if ("TAB_01".equals(tabId)) {	%><div id="tab01Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_01" flush="false" /></div><% } %>
<%		if ("TAB_02".equals(tabId)) {	%><div id="tab02Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_02" flush="false" /></div><% } %>
<%		if ("TAB_03".equals(tabId)) {	%><div id="tab03Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_03" flush="false" /></div><% } %>
<%		if ("TAB_04".equals(tabId)) {	%><div id="tab04Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_04" flush="false" /></div><% } %>
<%		if ("TAB_05".equals(tabId)) {	%><div id="tab05Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_05" flush="false" /></div><% } %>
<%		if ("TAB_06".equals(tabId)) {	%><div id="tab06Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_06" flush="false" /></div><% } %>
<%		if ("TAB_07".equals(tabId)) {	%><div id="tab07Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_07" flush="false" /></div><% } %>
<%		if ("TAB_08".equals(tabId)) {	%><div id="tab08Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_08" flush="false" /></div><% } %>
<%		if ("TAB_09".equals(tabId)) {	%><div id="tab09Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_09" flush="false" /></div><% } %>
<%		if ("TAB_10".equals(tabId)) {	%><div id="tab10Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_10" flush="false" /></div><% } %>
<%		if ("TAB_11".equals(tabId)) {	%><div id="tab11Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_11" flush="false" /></div><% } %>
<%		if ("TAB_12".equals(tabId)) {	%><div id="tab12Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_12" flush="false" /></div><% } %>
<%		if ("TAB_13".equals(tabId)) {	%><div id="tab13Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_13" flush="false" /></div><% } %>
<%		if ("TAB_14".equals(tabId)) {	%><div id="tab14Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_14" flush="false" /></div><% } %>
<%		if ("TAB_15".equals(tabId)) {	%><div id="tab15Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_15" flush="false" /></div><% } %>
<%		if ("TAB_16".equals(tabId)) {	%><div id="tab16Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_16" flush="false" /></div><% } %>
<%		if ("TAB_17".equals(tabId)) {	%><div id="tab17Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_17" flush="false" /></div><% } %>
<%		if ("TAB_18".equals(tabId)) {	%><div id="tab18Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_18" flush="false" /></div><% } %>
<%		if ("TAB_19".equals(tabId)) {	%><div id="tab19Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_19" flush="false" /></div><% } %>
<%		if ("TAB_20".equals(tabId)) {	%><div id="tab20Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_20" flush="false" /></div><% } %>
<%		if ("TAB_21".equals(tabId)) {	%><div id="tab21Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_21" flush="false" /></div><% } %>
<%		if ("TAB_22".equals(tabId)) {	%><div id="tab22Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_22" flush="false" /></div><% } %>
<%		if ("TAB_23".equals(tabId)) {	%><div id="tab23Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_23" flush="false" /></div><% } %>
<%		if ("TAB_24".equals(tabId)) {	%><div id="tab24Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_24" flush="false" /></div><% } %>
<%		if ("TAB_25".equals(tabId)) {	%><div id="tab25Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_25" flush="false" /></div><% } %>
<%		if ("TAB_26".equals(tabId)) {	%><div id="tab26Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_26" flush="false" /></div><% } %>
<%		if ("TAB_27".equals(tabId)) {	%><div id="tab27Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_27" flush="false" /></div><% } %>
<%		if ("TAB_28".equals(tabId)) {	%><div id="tab28Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_28" flush="false" /></div><% } %>
<%		if ("TAB_29".equals(tabId)) {	%><div id="tab29Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_29" flush="false" /></div><% } %>
<%		if ("TAB_30".equals(tabId)) {	%><div id="tab30Area" class="tabarea"><jsp:include page="/view/talent/profile/modules/JvProfTab.jsp?tab=TAB_30" flush="false" /></div><% } %>
<%
	}
%>
	</div><!-- /.container -->
</div><!-- /.desk -->


<input type="hidden" name="tgtSrchIdx" value="<%= crrSrchIdx %>">
<input type="hidden" name="prev_or_next" value="">
<input type="hidden" name="srch_or_pcup" value="<%= srchOrPcup %>">

<%-- ==================================================/Main Content Area ==================================================--%>
<input type="hidden" name="state" value="">
<input type="hidden" name="windowMode" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
$(function(){
	$document = $(document);
	 /**
	 ** Tab Switcher -------------------------------------------------------------------------------
	**/
	// タブ切替対象をまとめて取得
	var pages = $('.tabarea');
	// ページ読み込み完了時にすべて隠す
	pages.hide();
	// 先頭の領域を初期表示
	pages.eq(0).show();
	$document.on("click", ".tabNavigation li a",function(event) {
		// URL末尾のハッシュ付加防止
		event.preventDefault();
		// ひとまずすべて隠す
		pages.hide();
		// 遷移元タブを非アクティブ・押下可能に戻す
		var tabFrom = $(".tabNavigation li.active");
		var allTabs = $(".tabNavigation li");
		allTabs.removeClass("active");
		// 選択したタブのハッシュをIDに読み替えて表示
		var nextPage = this.hash;
		$(nextPage+'Area').fadeIn();
		$(this.hash).addClass("active");
	});
	//----------------------------------------------------------------------------------------------


	 /**
	 ** Event
	**/
	$document.on('click', '.prev', function(ev){
		ev.preventDefault();
		document.F001.prev_or_next.value = 'prev';
		pageSubmit('/servlet/JvProfileServlet', 'SLIDE');
	});
	$document.on('click', '.next', function(ev){
		ev.preventDefault();
		document.F001.prev_or_next.value = 'next';
		pageSubmit('/servlet/JvProfileServlet', 'SLIDE');
	});
	$document.on('click', '#transJVPdfChoice', function(){
		downloadJvPdfFile('CREATE');
	});
	$document.on('click', '.xlDownload', function(){
		makeRequestParameter( "xlsharp", "JV" );
		var templateId = $(this).attr('data-template');
		downloadXlsxFile(templateId);
	});
	$document.on('click', '.sheetlink', function(){
		var sheetId = $(this).attr('data-sheetid');
		var csTab   = $(this).attr('data-cstab');
		var actorCd = $(this).attr('data-actorcd');
		openSheetView( sheetId, actorCd, csTab );
	});


	 /**
	 ** Header Buttons
	**/
	$document.on('click', '.BackToList', function(){
		pageSubmit('/app/list/index.jsp', 'RESTORE');
	});


	 /**
	 ** Class Utilities
	**/
	$('td.tofixed1').each(function(){
		var n = Number($(this).text());
		if (!_.isNaN(n)) { $(this).text( n.toFixed(1) ); }
	});

});

<% for (JvTabJsDto js : jvProfileBean.jvTabJsList) {
	out.println( js.getScript() );
} %>

// 1列目のデータ部がひとつ上と同じ値の場合、空欄に変換する
function changeCellBlank(sectionId){
	var prevStr = "";
	var nowStr = "";
	$("#" + sectionId + " .outputTable table tbody tr").each(function(){
		var $tdObject = $(this).find("td:first");
		nowStr = $tdObject.text();
		if (nowStr == prevStr) {
			$tdObject.text("");
		}
		prevStr = nowStr;
	});
}

// リストタイプのデータが無い場合、セクションごと非表示にする
function changeListSectionNonDisplay(sectionId) {
	var displayFlg = false;
	$("#" + sectionId + " tbody tr:first td").each(function (){
		if ( ($(this).text() != "-")){
			displayFlg = true;
			return false;
		}
	});
 	if(!displayFlg){
		$("#" + sectionId).hide();
	}
}

// ボックスタイプのデータが無い場合、セクションごと非表示にする
function changeBoxSectionNonDisplay(sectionId) {
	var displayFlg = false;
	$("#" + sectionId + " tbody tr").each(function (){
		$(this).find("td").each(function (){
			if ($(this).text() != "-"){
				displayFlg = true;
				return false;
			}
		});
		if (displayFlg) {
			return false;
		}
	});
 	if(!displayFlg){
		$("#" + sectionId).hide();
	}
}

// 1列目の幅が引数の値となる行列変換を行う
function transMatrix(sectionId, headerWidth) {
	var col = 0;
	var $table = $("#" + sectionId + " .outputTable table");
	$table.find("tr").addClass("orginal");
	$table.find("thead, tbody").children().unwrap();
	$table.find("tr:first td, tr:first th").each(function(){
		col = 0;
		var nth = $(this).index() + 1;
		$table.append("<tr />");
		$table.find("tr.orginal").each(function(){
			$table.find("tr:eq(" + $(this).index() + ") > :nth-child(" + nth + ")").clone(true).appendTo($table.find(" tr:last"));
			if (col == 0) {
				$table.find("tr:last th").width( headerWidth );
			}
			col++;
		});
	});
	$table.find("tr.orginal").remove();
    if (col == 1){
        $table.width( headerWidth );
    }
	$table.css("table-layout", "fixed");
}

// 1行目のtdをthに変換する
function changeTdToTh(sectionId) {
	$("#" + sectionId + " tr:eq(0) td").each(function (){
		$(this).wrap($("<th></th>"));
		$(this).contents().unwrap();
	});
}

function openSheetView( sheetId, actorCd, csTab ) {
	makeRequestParameter( "sheetId", sheetId );
	makeRequestParameter( "actorCd", actorCd );
	makeRequestParameter( "csTab", csTab );
	openSubWindow('/servlet/CsSheetServlet', 'VIEW', sheetId, 1000, 800, false);
}

</script>
<jsp:include page="./addons/AddonBase.jsp" flush="false" />
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</body>
</html>
