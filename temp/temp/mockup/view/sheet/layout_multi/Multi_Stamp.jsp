<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD030Command" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.cache.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.util.dto.useful.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<fw:init commandClass="<%= PHD030Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD030Command.KINOU_ID) %>" />
<jsp:useBean id="oneMenu" class="jp.co.hisas.career.app.common.bean.CareerMenuBean" scope="session" />
<%
	Tray tray = new Tray( request, response );
	VmVSHFSS vm = new VmVSHFSS( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHFSS_TITLE" ) );
	
	CsMultiSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_MULTI_SHEET );
	String trans  = oneMenu.menuTrans;
	boolean isNoActionMode = true;
	
	HashMap<String, String> srchCondMap = jsp.gamenCondMap;
	String formGrpCd = AU.nvl( srchCondMap.get( "formGrpCd" ), "");
	String statusCd = CsUtil.ntb( jsp.gamenCondMap.get( "statusCd" ) );
	
	if (jsp.hitCnt > 500) {
		session.setAttribute( AppSessionKey.RESULT_MSG_WARN, vm.gCL( "LSHFSS_MSG_TOOMANYROWS" ) );
	}
	
	String theTab = "";
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html onContextmenu="return false;">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.css" type="text/css" media="screen" />
<style type="text/css">
#Multi tbody tr {
	display: none;
}
#Multi tbody tr.shown {
	display: table-row;
}
</style>
</head>
<body id="lyca" data-vmid="VmSHVFSS">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD030">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation">
<%----------------------------------------------------- Fix Content Area -----------------------------------------------------%>

	<div class="ope-board">
		<div class="whitebd">
			<div class="fb fb-lr">
				<div class="fi fi-flex1 gridform">
					<div class="gf-row">
						<label class="f5x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_1" ) %></span>
							<input type="text" class="block" name="personId" value="" maxlength="9">
						</label>
						<label class="f5x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_3" ) %></span>
							<input type="text" class="block" name="deptNm" value="" maxlength="40">
						</label>
						<label class="f6x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_5" ) %></span>
							<div class="select">
								<label>
									<select name="operationCd">
										<option value=""></option>
										<% for (ValueTextSortDto dto : jsp.operationList) { %>
										<option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
										<% } %>
									</select>
								</label>
							</div>
						</label>
					</div>
					<div class="gf-row">
						<label class="f5x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_2" ) %></span>
							<input type="text" class="block fkktohkk" name="personNm" value="" maxlength="100">
						</label>
						<label class="f5x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_4" ) %></span>
							<div class="select">
								<label>
									<select name="clsBCd">
										<option value=""></option>
										<% for (ValueTextSortDto dto : jsp.divList) { %>
										<option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
										<% } %>
									</select>
								</label>
							</div>
						</label>
						<label class="f6x">
							<span class="lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_6" ) %></span>
							<div class="select">
								<label>
									<select name="statusCd">
										<option value=""></option>
										<% for (ValueTextSortDto dto : jsp.statusList) { %>
										<option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
										<% } %>
									</select>
								</label>
							</div>
						</label>
					</div>
				</div>
				<div class="fi" style="width:150px; margin-left:15px;">
					<div class="fm-item">
						<div class="fm-lbl"><%= vm.gCL( "LSHFSS_SRCH_TH_7" ) %></div>
						<div class="fm-val">
							<div class="radios">
								<div class="radio">
									<label>
										<input type="radio" id="radio01" name="holdFilter" value="ALL">
										<i class="fa fa-circle"></i>
										<span><%= vm.gCL( "LSHFSS_SRCH_RAD_1" ) %></span>
									</label>
								</div>
								<div class="radio">
									<label>
										<input type="radio" id="radio02" name="holdFilter" value="ACTOR" checked="checked">
										<i class="fa fa-circle"></i>
										<span><%= vm.gCL( "LSHFSS_SRCH_RAD_2" ) %></span>
									</label>
								</div>
								<div class="radio">
									<label>
										<input type="radio" id="radio03" name="holdFilter" value="HOLD">
										<i class="fa fa-circle"></i>
										<span><%= vm.gCL( "LSHFSS_SRCH_RAD_3" ) %></span>
									</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<hr>
	</div><!-- /.ope-board -->

<%-- ================================================== Main Content Area ==================================================--%>

	<div class="navbarBtns" style="display:none;">
		<div class="leftArea">
		<% if ("TRANS-CSMLTI".equals(trans)) { %>
			<button class="btn btn-back backToHome" type="button"><%= vm.gCL( "LSHFSS_RETURN_BTN" ) %></button>
		<% } %>
		<% if ("TRANS-VHD040".equals(trans)) { %>
			<button type="button" id="transVHD040" class="btn btn-back"><%= vm.gCL( "LSHFSS_RETURN_BTN" ) %></button>
		<% } %>
		</div>
		<div class="rightArea">
			<button type="button" id="SEARCH" class="btn btn-secondary"><i class="fa fa-search"></i><%= vm.gCL( "LSHFSS_SRCH_BTN" ) %></button>
		</div>
	</div>

	<div id="Multi">
		<div id="us-render-sheetlist"></div>
	</div>

<input type="hidden" name="formGrpCd" value="<%= formGrpCd %>">
<input type="hidden" name="tab" value="<%= theTab %>">
<input type="hidden" name="isStatusChanged" value="">

<input type="hidden" name="sheetId" value="">
<input type="hidden" name="sheetIdArray" value="">

<input type="hidden" name="xlsharp" value="">

	<%-- 子画面 --%>
	<input type="hidden" name="windowMode" value="" />
	<input type="hidden" name="masterId" value="" />
	<input type="hidden" name="masterName" value="" />


<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/layout_multi/careersheet_multi.js"></script>
<script>

var ngList = [];

var __MsgMap = {};
__MsgMap["APP_MSG_PC_ONLY"]    = "<%= vm.gCL( "APP_MSG_PC_ONLY" ) %>";
__MsgMap["LSHFSS_MSG_NOT_SEL"] = "<%= vm.gCL( "LSHFSS_MSG_NOT_SEL" ) %>";

function controlSrchCond() {
	var opeCd = $('select[name="operationCd"]').val();
	if (opeCd == '') {
		$('select[name="statusCd"]').prop('disabled', true);
		$('select[name="shozoku"]').prop('disabled', true);
	}
}

// 所属選択子画面表示
function searchGroupSelect( masterId, masterName ) {
	document.F001.masterId.value = masterId;
	document.F001.masterName.value = masterName;
	openSubWindow('/view/talent/search/VDA100_SearchGroup.jsp', 'INIT', 'hcdb_sub', 850 , 750);
}

$(function(){
	 /**
	 ** Initialize
	**/
	<%-- Tab Active/Inactive --%>
	tabActivateOnInit('<%= theTab %>');
	<%-- 検索前は画面下部を表示しない --%>
	var phase = '<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "search_phase" ) %>'
	if (phase == 'before_search') {
		$('#Multi').hide();
	}
	<%-- Table Header Checkbox --%>
	$('#fixLT thead th.checkallCell').append('<input type="checkbox" id="checkall" name="checkall"/>');
	<%-- 入力した検索条件の復元 --%>
	$(' input[name="personId"]'    ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "personId"     ) %>');
	$(' input[name="personNm"]'    ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "personNm"     ) %>');
	$(' #scsid-shozoku label'     ).text('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "deptNm"       ) %>');
	$(' input[name="deptNm"]'      ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "deptNm"       ) %>');
	$(' input[name="deptCd"]'      ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "deptCd"       ) %>');
	$('select[name="clsBCd"]'      ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "clsBCd"       ) %>');
	$('select[name="operationCd"]' ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "operationCd"  ) %>');
	$('select[name="statusCd"]'    ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "statusCd"     ) %>');
	$(' input[name="holdFilter"][value="<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "holdFilter" ) %>"]').prop('checked', true);
	$('select[name="searchDiv"]'   ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "searchDiv"    ) %>');
	$('select[name="actorCd"]'     ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "actorCd"      ) %>');
	$('select[name="sort"]'        ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "sort"         ) %>');
	controlSrchCond();
	<%-- 運用未選択時にExcelダウンロードボタン非表示 --%>
	var opeCd = $('select[name="operationCd"]').val();
	if (opeCd == "") {
		$('#btn_xldownload').hide();
	}
	
	 /**
	 ** Event
	**/
	$('.ope-board .whitebd input').keypress(function(e){
		// Enter Key
		if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
			$('.fkktohkk').trigger('focusout');
			$('#SEARCH').click();
		}
	});
	$('.fkktohkk').focusout(function() {
		$(this).val( optimizeHalfKana( $(this).val() ) );
	});
	$('select[name="operationCd"]').bind('change', function(){
		pageSubmit('/servlet/CsMultiSheetServlet', 'CHANGE_OPERATION');
	});
	$('#btn_deptchoice').bind('click', function(){
		searchGroupSelect('shozoku', 'LDA010_BASE_TH_08');
	});
	$(document).on('click', 'a.sheetlink', function(ev){
		ev.preventDefault();
		var sheetId = $(this).attr('data-sheetid');
		showSheet( sheetId );
	});
	
	// タブ切り替え
	$(document).on('click', '#sh-multi-tabs .tab', function(e){
		e.preventDefault();
		var tabId = $(this).attr('data-tabid');
		tabActivate( tabId );
	});
	
	$('select[name="statusCd"]').bind('change', function() {
		document.F001.isStatusChanged.value = true;
	});
	
});
</script>


<%-- - - - - - - - - Underscore.js Template Layout Layer - - - - - - - - --%>
<script id="us-template-sheetlist" type="text/template">
<% if (SU.isNotBlank( formGrpCd )) { %>
<%= LayoutTemplateCache.getTemplate( "CsMultiStamp-" + formGrpCd ) %>
<% } else { %>
<%= LayoutTemplateCache.getTemplate( "CsMultiStamp" ) %>
<% } %>
</script>
<%-- - - - - - - - Underscore.js Template Rendering Layer - - - - - - - ---%>
<script>
var _data = {};

_data["label"] = {
	  "LSHFSS_RSLT_TH_1" : '<%= vm.gCL( "LSHFSS_RSLT_TH_1"  ) %>'
	, "LSHFSS_RSLT_TH_2" : '<%= vm.gCL( "LSHFSS_RSLT_TH_2"  ) %>'
	, "LSHFSS_RSLT_TH_3" : '<%= vm.gCL( "LSHFSS_RSLT_TH_3"  ) %>'
	, "LSHFSS_RSLT_TH_4" : '<%= vm.gCL( "LSHFSS_RSLT_TH_4"  ) %>'
	, "LSHFSS_RSLT_TH_5" : '<%= vm.gCL( "LSHFSS_RSLT_TH_5"  ) %>'
	, "LSHFSS_RSLT_TH_ST": '<%= vm.gCL( "LSHFSS_RSLT_TH_ST" ) %>'
};

_data["list"] = [];
<%
	for (VCsInfoAttrDto sheetDto : jsp.multiCsList) {
		boolean isHold = userinfo.getOperatorGuid().equals(sheetDto.getHoldGuid());
%>
_data["list"].push(
	{
		       "sheetId": '<%= sheetDto.getSheetId() %>'
		,  "matchStatus": <%= statusCd.equals(sheetDto.getStatusCd()) %>
		,       "isHold": <%= isHold %>
		,   "isHoldText": '<%= (isHold) ? "isHold" : "" %>'
		,  "operationNm": '<%= sheetDto.getOperationNm() %>'
		,    "formGrpNm": '<%= sheetDto.getFormGrpNm() %>'
		,    "formCtgCd": '<%= sheetDto.getFormCtgCd() %>'
		,       "formNm": '<%= sheetDto.getFormNm() %>'
		,      "ownGuid": '<%= sheetDto.getOwnGuid() %>'
		,     "statusNm": '<%= sheetDto.getStatusNm() %>'
		,"ownPersonName": '<%= sheetDto.getOwnPersonName() %>'
		,"ownPersonKana": '<%= sheetDto.getOwnPersonKana() %>'
		,       "cmpaNm": '<%= sheetDto.getCmpaNm() %>'
		,        "stfNo": '<%= sheetDto.getStfNo() %>'
		,       "deptNm": '<%= sheetDto.getDeptNm() %>'
		,   "fullDeptNm": '<%= sheetDto.getFullDeptNm() %>'
		,       "clsANm": '<%= sheetDto.getClsANm() %>'
		,       "clsBNm": '<%= sheetDto.getClsBNm() %>'
		,       "clsCNm": '<%= sheetDto.getClsCNm() %>'
		,       "clsDNm": '<%= sheetDto.getClsDNm() %>'
		,       "clsENm": '<%= sheetDto.getClsENm() %>'
		,       "clsFNm": '<%= sheetDto.getClsFNm() %>'
		,       "clsGNm": '<%= sheetDto.getClsGNm() %>'
		,       "clsHNm": '<%= sheetDto.getClsHNm() %>'
		,       "clsINm": '<%= sheetDto.getClsINm() %>'
		,       "clsJNm": '<%= sheetDto.getClsJNm() %>'
		,       "clsKNm": '<%= sheetDto.getClsKNm() %>'
		,       "clsLNm": '<%= sheetDto.getClsLNm() %>'
		,       "clsMNm": '<%= sheetDto.getClsMNm() %>'
		,       "clsNNm": '<%= sheetDto.getClsNNm() %>'
	}
);
<% } %>
usTemplateRender('#us-template-sheetlist', '#us-render-sheetlist', _data);
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
