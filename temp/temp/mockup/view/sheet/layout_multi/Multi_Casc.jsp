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
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD031Command" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.cache.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.util.dto.useful.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<fw:init commandClass="<%= PHD031Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD031Command.KINOU_ID) %>" />
<jsp:useBean id="oneMenu" class="jp.co.hisas.career.app.common.bean.CareerMenuBean" scope="session" />
<%
	Tray tray = new Tray( request, response );
	VmVSHFSC vm = new VmVSHFSC( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHFSC_TITLE" ) );
	
	CsMultiSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_MULTI_SHEET );
	String trans  = oneMenu.menuTrans;
	boolean isNoActionMode = true;
	
	HashMap<String, String> srchCondMap = jsp.gamenCondMap;
	String formGrpCd = AU.nvl( srchCondMap.get( "formGrpCd" ), "");
	String statusCd = CsUtil.ntb( jsp.gamenCondMap.get( "statusCd" ) );
	
	if (jsp.hitCnt > 500) {
		session.setAttribute( AppSessionKey.RESULT_MSG_INFO, vm.gCL( "LSHFSC_MSG_TOOMANYROWS" ) );
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
</style>
</head>
<body id="lyca" data-vmid="VmSHVFSC">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD031">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation">
<%----------------------------------------------------- Fix Content Area -----------------------------------------------------%>

	<div class="ope-board">
		<div class="whitebd">
			<div class="gridform">
				<div class="gf-row">
					<label class="f5x">
						<span class="lbl"><%= vm.gCL( "LSHFSC_SRCH_TH_1" ) %></span>
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
					<label class="f6x">
						<span class="lbl"><%= vm.gCL( "LSHFSC_SRCH_TH_2" ) %></span>
						<input type="text" class="block" name="deptNm" value="" maxlength="40">
					</label>
					<label class="f5x">
						<span class="lbl"><%= vm.gCL( "LSHFSC_SRCH_TH_3" ) %></span>
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
		</div>
		<hr>
	</div><!-- /.ope-board -->

<%-- ================================================== Main Content Area ==================================================--%>

	<div class="navbarBtns" style="display:none;">
		<div class="leftArea">
		<% if ("TRANS-CSMLTICSC".equals(trans)) { %>
			<button class="btn btn-back backToHome" type="button"><%= vm.gCL( "LSHFSC_RETURN_BTN" ) %></button>
		<% } %>
		<% if ("TRANS-VHD040".equals(trans)) { %>
			<button type="button" id="transVHD040" class="btn btn-back"><%= vm.gCL( "LSHFSC_RETURN_BTN" ) %></button>
		<% } %>
		<% if ("TRANS-VHF010".equals(trans)) { %>
			<button type="button" id="transVHF010" class="btn btn-back"><%= vm.gCL( "LSHFSC_RETURN_BTN" ) %></button>
		<% } %>
		</div>
		<div class="rightArea">
			<button type="button" id="SEARCHCASC" class="btn btn-secondary"><i class="fa fa-search"></i><%= vm.gCL( "LSHFSC_SRCH_BTN" ) %></button>
		</div>
	</div>

	<div class="ope-board">
		<div class="holder">
			<div id="sh-multi-tabs" class="tabs">
				<div class="tab" data-tabid="ctg-ALL">
					<a href="#">
						<%= vm.gCL( "LSHFSC_TAB_HIT" ) %>
						<span class="badge"><%= jsp.hitCnt %></span>
					</a>
				</div>
			</div>
		</div>
	</div><!-- /.ope-board -->

	<div id="Multi">
		<div class="desk">
			<div class="container">
				<div class="mod-table">
					<table>
						<thead>
							<th class="colA"><%= vm.gCL( "LSHFSC_RSLT_TH_1"  ) %></th>
							<th class="colB"><%= vm.gCL( "LSHFSC_RSLT_TH_2"  ) %></th>
							<th class="colC"><%= vm.gCL( "LSHFSC_RSLT_TH_ST" ) %></th>
						</thead>
						<tbody>
						<%
							for (VCsInfoAttrDto sheetDto : jsp.multiCsList) {
								String sheetId = sheetDto.getSheetId();
								boolean matchStatus = statusCd.equals(sheetDto.getStatusCd());
								boolean isHold = userinfo.getLogin_no().equals(sheetDto.getHoldGuid());
								String  isHoldText = (isHold) ? "isHold" : "" ;
						%>
							<tr data-lineId="<%= sheetId %>" data-tabid="ctg-ALL">
								<td><%= sheetDto.getOperationNm() %></td>
								<td><%= sheetDto.getDeptNm() %></td>
								<td><a href="#" class="sheetlink sh-status-chip <%= isHoldText %>" data-sheetid="<%= sheetId %>"><%= sheetDto.getStatusNm() %></a></td>
							</tr>
						<% } %>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


<input type="hidden" name="formGrpCd" value="<%= formGrpCd %>">
<input type="hidden" name="tab" value="<%= theTab %>">
<input type="hidden" name="isStatusChanged" value="casc">

<input type="hidden" name="sheetId" value="">
<input type="hidden" name="sheetIdArray" value="">

<input type="hidden" name="xlsharp" value="">

<input type="hidden" name="cascOrStamp" value="">

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
		$('#sh-multi-tabs').hide();
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
	$('select[name="clsHCd"]'      ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "clsHCd"       ) %>');
	$('select[name="operationCd"]' ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "operationCd"  ) %>');
	$('select[name="statusCd"]'    ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "statusCd"     ) %>');
	$(' input[name="holdFilter"][value="<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "holdFilter" ) %>"]').prop('checked', true);
	$('select[name="searchDiv"]'   ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "searchDiv"    ) %>');
	$('select[name="actorCd"]'     ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "actorCd"      ) %>');
	$('select[name="sort"]'        ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "sort"         ) %>');
	$('select[name="cascOrStamp"]' ).val('<%= CsUtil.restoreSrchCond( jsp.gamenCondMap, "cascOrStamp"  ) %>');
	controlSrchCond();
	<%-- 運用未選択時にExcelダウンロードボタン非表示 --%>
	var opeCd = $('select[name="operationCd"]').val();
	if (opeCd == "") {
		$('#btn_xldownload').hide();
	}
	
	 /**
	 ** Event
	**/
	$('.searchCondTable input').keypress(function(e){
		// Enter Key
		if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
			$('#SEARCHCASC').click();
		}
	});
	$('.fkktohkk').focusout(function() {
		$(this).val( optimizeHalfKana( $(this).val() ) );
	});
	$('select[name="operationCd"]').bind('change', function(){
		pageSubmit('/servlet/CsMultiSheetCascServlet', 'CHANGE_OPERATION');
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
	$(document).on('click', '.tabMultiCs li', function(){
		var idstr = $(this).prop('id');
		//document.F001.tab.value = idstr;
		execSearch('/servlet/CsMultiSheetCascServlet', 'SEARCH', idstr);
	});
	
	$('select[name="statusCd"]').bind('change', function() {
		document.F001.isStatusChanged.value = true;
	});
	
});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
