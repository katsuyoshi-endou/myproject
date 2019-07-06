<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" errorPage = "/view/error.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*"%>
<%@ page import="jp.co.hisas.career.util.common.*"%>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*"%>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<%@ page import="jp.co.hisas.career.app.talent.command.PTLSCECommand" %>
<fw:init commandClass="<%=PTLSCECommand.class%>" kinouTitle="<%=CommonParameter.getFuncName(PTLSCECommand.KINOU_ID)%>" />
<%@ page import="jp.co.hisas.career.app.talent.mold.*" %>
<%@ page import="jp.co.hisas.career.app.talent.bean.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%
	AU.setReqAttr( request, "FUNC_TITLE", CommonLabel.getLabel( userinfo.getParty(), "LTLSCE_TITLE", userinfo.getLangNo() ) );

	VmVTLSCE vm  = AU.getRequestAttr( request, "vm" );
	String state = AU.getRequestValue( request, "state" );
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
.showcase-400.fb .fa-search {
  align-self: flex-end;
  font-size: 24px;
  margin: 0 15px 4px 0;
  color: #ccc;
}
.showcase-400.fb .vrt {
  width: 100%;
}
.shelfForm .shelfBox {
  border: 0;
  box-shadow: none;
}
.shelfForm .shelfBox td {
  padding: 0;
  border: 0;
}
</style>
</head>
<body id="lyca" data-vmid="VmVTLSCE">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<fw:transit kinouId="VDD010">
<%-- ================================================== Main Content Area ==================================================--%>


	<div class="navbarBtns">
		<div class="leftArea">
			<% if (vm.showBackBtn) { %>
			<button class="btn btn-back" id="transBACK" type="button"><%= vm.gCL("LTLSCE_BTN_BACK") %></button>
			<% } %>
		</div>
		<div class="centerArea">
			<i class="fa fa-search"></i>
			<span><%= vm.escx( vm.mySearch.getMysrchNm() ) %></span>
			<% if (vm.isShared) { %><span class="chip-shared"><%= vm.gCL("LTLAPP_SHARE_CHIP") %></span><% } %>
		</div>
		<div class="rightArea">
			<% if (!vm.isNew) { %>
			<button type="button" id="do-mysch-delete" class="btn btn-delete"><%= vm.gCL("LTLSCE_BTN_DEL") %></button>
			<% } %>
			<button type="button" id="LDA010_INIT_BTN" class="btn"><%= vm.gCL("LTLSCE_BTN_CLEAR") %></button>
			<button type="button" id="searchAdd" class="btn btn-secondary"><i class="fa fa-check"></i><%= vm.gCL("LTLSCE_BTN_OK") %></button>
		</div>
	</div>

	<div class="desk no-padd">
		<div class="ope-board">
			<div class="whitebd">
				<div class="tl-result-header">
					<div class="showcase-400 fb">
						<i class="fa fa-search"></i>
						<label class="vrt">
							<span class="lbl"><%= vm.gCL("LTLSCE_LBL_DISPNM") %></span>
							<input type="text" id="hozonNm" name="mysrch_nm" value="<%= vm.escx(vm.mySearch.getMysrchNm()) %>" maxlength="20" />
							<input type="hidden" name="mysrch_id" value="<%= vm.mySearch.getMysrchId() %>" />
						</label>
					</div>
				</div>
			</div>
			<hr>
		</div><!-- /.ope-board -->

		<div class="container">

			<div class="srchCondFrame">

				<jsp:include page="VTLSCE_Form_Basic.jsp" flush="false" />

				<jsp:include page="VTLSCE_Form_Legacy.jsp" flush="false" />

				<% if(AU.matchesCareerProperty( "USE_JV_SEARCH_SHELF", "YES" )) { %>
				<jsp:include page="VTLSCE_Form_Shelf.jsp" flush="false" />
				<% } %>

			</div><!-- /.srchCondFrame -->

		</div><!-- /.container -->
	</div><!-- /.desk -->


	<input type="hidden" name="windowMode" value=""/>
	<%-- 子画面 --%>
	<input type="hidden" name="masterId" value="" />
	<input type="hidden" name="masterName" value="" />


<%-- ==================================================/Main Content Area ==================================================--%>
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
<input type="hidden" name="whichBtn" value="">
</fw:transit>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>

function execSearch() {
	__IS_BASIC_CHK = false; // 複数選択向け 1000文字チェック回避
	pageSubmit("/servlet/SearchTalentsServlet", "SEARCH");
}

// 複数選択子画面表示
function searchCondSelect( masterId, masterName, mltPzId ) {
	document.F001.masterId.value = masterId;
	document.F001.masterName.value = masterName;
	makeRequestParameter( 'rstrSeparatedKeys', $('[name="Mlt--' + mltPzId + '_cd"]').val() );
	openSubWindow('/view/talent/search/VTLSPZ_PzTree.jsp', 'INIT', 'hcdb_sub', 850 , 750);
}

// 所属選択子画面表示
function searchGroupSelect( masterId, masterName ) {
	document.F001.masterId.value = masterId;
	document.F001.masterName.value = masterName;
	openSubWindow('/view/talent/search/VTLSDP_DeptTree.jsp', 'INIT', 'hcdb_sub', 650 , 750);
}

__MsgMap = {};
__MsgMap["LTLSCE_NEW_SRCH_DEFAULT_NM"] = '<%= vm.gCL("LTLSCE_NEW_SRCH_DEFAULT_NM") %>';
__MsgMap["LTLSCE_MSG_SRCH_NM_LIMIT"] = '<%= vm.gCL("LTLSCE_MSG_SRCH_NM_LIMIT") %>';
__MsgMap["LTLSCE_MSG_SRCH_TGT_NG"] = '<%= vm.gCL("LTLSCE_MSG_SRCH_TGT_NG") %>';
$(function(){
	$document = $(document);

	 /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 * Initialize
	*/
<% if (vm.legacyKensakuDefBean.canRetireSrch && !SU.matches( state, "NEW|CLEAR" )) { %>
	// 退職者を除くチェックボックスの状態復元（新規・初期化時以外）
	var retChecked = <%= SU.equals( "on", vm.getSglSearchValue( "currentstatus_except_retire" )) %>;
	$('input[name=Sgl--currentstatus_except_retire]').prop( 'checked', retChecked );
	var remChecked = <%= SU.equals( "on", vm.getSglSearchValue( "currentstatus_except_remove" )) %>;
	$('input[name=Sgl--currentstatus_except_remove]').prop( 'checked', remChecked );
<% } %>

	// 入力箇所の強調
	emphasizeQueriedShelf();


	 /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 * Event
	*/
	$document.on('click', '#transBACK', function(){
		pageSubmit('/app/list/index.jsp', 'RESTORE');
	});

	// 削除
	$document.on('click', '#do-mysch-delete', function(){
		if (!confirm("<%= vm.gCL("LTLSCE_MSG_DEL_CONFIRM") %>")) { return false; }
		pageSubmit("/servlet/MySearchServlet", "DELETE");
	});

	// 条件クリア
	$document.on('click', '#LDA010_INIT_BTN', function(){
		pageSubmit("/view/talent/search/VTLSCE_SearchCondEdit.jsp", "CLEAR");
	});

	// 退職者を除くチェックボックス
	$("input[name=Sgl--isGensyokuOnly]").on('click', function() {
		var isChecked = $(this).prop('checked');
		$(this).val(isChecked);
	});

	// 入力箇所の強調（値変更時）
	$(document).on('change', '.shelfQuery', function(e){
		emphasizeQueriedShelf();
	});

	$document.on('click', '#LDA010_BASE_BELONG_BTN', function(){
		searchGroupSelect('shozoku', 'LDA010_BASE_TH_08', 'commn_shozoku');
	});

	// 検索条件保存
	$document.on('click', '#searchAdd', function() {
		doSearchAdd();
	});

	/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 * Check
	 */
	// 検索ボタンクリック
	$(".searchButton").on('click', function(ev) {
		try {
<%--
			// Check in VTLSCE_Form_Legacy.jsp
			checkBeforePZSearch();
--%>
		} catch(ex) {
			alert(ex);
			return false;
		}

		// 検索処理実行
		execSearch();
	});

});

function emphasizeQueriedShelf() {
	$('.shelfQuery').each(function(i,el){
		var $cell = $(el).closest('.slf-pz');
		if (!_.isEmpty($(el).val())) {
			$cell.addClass('active');
		} else {
			$cell.removeClass('active');
		}
	});
}

// 検索条件保存
function doSearchAdd() {
	var hozonNm = $("#hozonNm").val();
	var addlist = $('[name="mysrchid"]').val();
	if (hozonNm == "") {
		$("#hozonNm").val(__MsgMap["LTLSCE_NEW_SRCH_DEFAULT_NM"]);
	}
	if (hozonNm.length > 20) {
		alert(__MsgMap["LTLSCE_MSG_SRCH_NM_LIMIT"]);
		return false;
	}
	if (addlist == "") {
		alert(__MsgMap["LTLSCE_MSG_SRCH_TGT_NG"]);
		return false;
	} else {
		pageSubmit("/servlet/MySearchServlet", "SAVE");
	}
}
</script>

<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
