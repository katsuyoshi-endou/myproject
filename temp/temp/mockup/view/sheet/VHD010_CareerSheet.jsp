<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	final String loginId = userinfo.getLogin_no();
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher("/view/error.jsp").forward( request, response );
	}
%>
<% Log.method( userinfo.getLogin_no(), "IN", "" ); %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.sheet.command.PHD010Command" %>
<fw:init commandClass="<%= PHD010Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PHD010Command.KINOU_ID) %>" />
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHSHT_TITLE" ) );
	
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	boolean isMainWindow = !"SubWindow".equals( AU.getRequestValue( request, "windowMode" ) );
	String exclusiveKey = jsp.exclusiveKey.getExclusiveKey().toString();
	
	String selfSheetId = jsp.sheetInfo.getSheetId();
	boolean isKamiki = SU.equals( SU.extract( jsp.sheetInfo.getOperationCd(), "^20..(K|S)" ), "K" );
	
	String templatescript = AU.getSessionAttr( session, CsSessionKey.CS_SHEET_TEMPLATE_JS );

  	AU.setReqAttr( request, "CURRENT_VID", "SHVSHT" );

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
<body id="lyca" data-vmid="VmSHVSHT">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VHD010">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation"><div class="desk"><div class="container-fluid">
<%-- ================================================== Main Content Area ==================================================--%>


<div class="pnl"><div class="pnl-body">

	<%-- シートID表示 --%>
	<div style="float:right;"><span class="hiddenSheetId"><%= selfSheetId %></span></div>
	<!-- <%-- DEBUG INFO --%>
		SheetId     : <%= jsp.sheetInfo.getSheetId()     %>
		CompanyCd   : <%= jsp.sheetInfo.getParty()       %>
		OperationCd : <%= jsp.sheetInfo.getOperationCd() %> / <%= jsp.sheetInfo.getOperationNm()   %>
		FormGrpCd   : <%= jsp.sheetInfo.getFormGrpCd()   %> / <%= jsp.sheetInfo.getFormGrpNm()     %>
		FormCtgCd   : <%= jsp.sheetInfo.getFormCtgCd()   %>
		FormCd      : <%= jsp.sheetInfo.getFormCd()      %> / <%= jsp.sheetInfo.getFormNm()        %>
		OwnGuid     : <%= jsp.sheetInfo.getOwnGuid()     %>
		LayoutCd    : <%= jsp.sheetInfo.getLayoutCd()    %>
		LabelSetCd  : <%= jsp.sheetInfo.getLabelSetCd()  %>
		ParamSetCd  : <%= jsp.sheetInfo.getParamSetCd()  %>
		FillSetCd   : <%= jsp.sheetInfo.getFillSetCd()   %>
		MaskCd      : <%= jsp.sheetInfo.getMaskCd()      %>
		FlowCd      : <%= jsp.sheetInfo.getFlowCd()      %>
		FlowPtn     : <%= jsp.sheetInfo.getFlowPtn()     %>
		SeqNo       : <%= jsp.sheetInfo.getSeqNo()       %>
		StatusCd    : <%= jsp.sheetInfo.getStatusCd()    %> / <%= jsp.sheetInfo.getStatusNm()      %>
		ActorCd     : <%= jsp.usingActorCd               %>
		MainActorCd : <%= jsp.sheetInfo.getMainActorCd() %>
		HoldGuid    : <%= jsp.sheetInfo.getHoldGuid()    %>
	-->


	<%-- フォームレイアウト --%>
	<jsp:include page="form/CsF-pkg_DefaultSheet.jsp" flush="false" />


	<%-- 伝言モーダルウィンドウ --%>
	<jsp:include page="module/CsMd-ModalDelivMsg.jsp" flush="false" />


	<%-- 操作履歴 --%>
	<jsp:include page="module/CsMd-ActionHistory.jsp" flush="false" />

</div><!-- /.pnl-body --></div><!-- /.pnl -->


<%-- InPage Hidden Requests -----------------------------------------%>
<input type="hidden" name="windowMode" value="<%= request.getParameter( "windowMode" ) %>">
<input type="hidden" name="sheetId" value="<%= selfSheetId %>">
<input type="hidden" name="csPartialEdit" value="">
<input type="hidden" name="csPartialEditArg" value="">
<input type="hidden" name="exclusiveKey" value="<%= exclusiveKey %>">
<input type="hidden" name="xlsharp" value="">
<input type="hidden" name="tabkeep" value="">

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /.container --></div><!-- /.desk --></div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
var writeFillList = [
	<%= jsp.getMapKeysForJSArray( jsp.fillMaskMap, "write" ) %>
];
<%-- - - - - - - - - - - - - CSM_SHEET_LAYOUT_JS - - - - - - - - - - - - --%>
<% for (CsmSheetLayoutJsDto js : jsp.layoutJsList) { %>
	<%= js.getScript() %>
<% } %>
<%-- - - - - - - - - - - - - CSM_SHEET_LAYOUT_PD - - - - - - - - - - - - --%>
var cspd = { dummy: ''
<%
	for (String key : jsp.layoutPdList.keySet()) {
		List<PulldownMasterDto> list = jsp.layoutPdList.get( key );
%>
	, "<%= key %>": [ {}
	<% for (PulldownMasterDto pd : list) { %>
		, {value: '<%= pd.getPdValue() %>', text: '<%= pd.getPdText() %>'}
	<% } %>
	]
<% } %>
};
</script>
<%-- - - - - - - - Underscore.js Template Rendering Layer - - - - - - - ---%>
<jsp:include page="/view/sheet/CsTemplateDataBridge.jsp" flush="false" />
<script>
usTemplateRender('#us-template-layout-hbtn', '#us-template-rendering-hbtn', _data);
usTemplateRender('#us-template-layout-attr', '#us-template-rendering-attr', _data);
usTemplateRender('#us-template-layout', '#us-template-rendering', _data);
</script>
<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.js"></script>
<script>
<%-- - - - - - - - - - - - - CSM_SHEET_ACTION - - - - - - - - - - - - - ---%>
var confMsgList = { dummy: ''
	<% for (CsmSheetActionDto dto : jsp.actionList) { %>
	<%   if (!"STAY".equals( dto.getActionCd() )) { %>
	, <%= dto.getActionCd() %>: "<%= dto.getConfirmMsg() %>"
	<%   } %>
	<% } %>
};
var __CS_WAIT_MODAL = { dummy: ''
	<% for (CsmSheetActionDto dto : jsp.actionList) { %>
	<%   if (!"STAY".equals( dto.getActionCd() )) { %>
	, <%= dto.getActionCd() %>: <%= "1".equals( dto.getUseDelivFlg() ) %>
	<%   } %>
	<% } %>
};

function execSheetAction( actionCd ) {
	if (actionCd == 'FORWARD' || actionCd == 'SKIP') {
		if (typeof customForwardCheck === "function" && !customForwardCheck()) {
			return false;
		}
	}
	if (__CS_WAIT_MODAL[actionCd]) {
		openCsDelivModal( actionCd );
		return false;
	}
	if ($('#modal-overlay:visible').length > 0) {
		if (($('#modal-window textarea').val()+"").length > 100) {
			alert("<%= vm.gCL("LSHSHT_MSG_COMMENT_FILLOVER") %>");
			return false;
		}
	}
	var confMsg = confMsgList[actionCd];
	if (confMsg != '' && !confirm(confMsg)) {
		__CS_WAIT_MODAL[__CS_MODAL_ACTION_CD] = true;
		return false;
	}
	pageSubmit( '/servlet/CsSheetActionServlet', actionCd );
}

var isMainWindow = <%= isMainWindow %>;
var initTabId = '<%= SU.ntb( AU.getRequestValue( request, "tabkeep" ) ) %>';

var __MsgMap = {};
__MsgMap["APP_MSG_PC_ONLY"] = '<%= vm.escj( vm.gCL( "APP_MSG_PC_ONLY" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_UPFILE_REQUIRED"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_UPFILE_REQUIRED" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_UPFILE_TOO_LARGE"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_UPFILE_TOO_LARGE" ) ) %>';
__MsgMap["LSHSHT_MSG_CHK_INT_100"] = '<%= vm.escj( vm.gCL( "LSHSHT_MSG_CHK_INT_100" ) ) %>';

$(function(){
	$document = $(document);
	
	 /**
	 ** Initialize
	**/
	if (!isMainWindow) {
    $('.cspe').hide();
    $('.mp_edit').hide();
    // 子画面を開いたときにセッションのシート情報が書き換えられるので、
    // 再描画することで元に戻す。ただし子画面で何も操作しないことが前提。
    window.opener.reloadSheet();
  }
	cstabActivate(initTabId);
	drawStatusSummary('<%= jsp.sheetInfo.getStatusCd() %>', '<%= loginId %>', '<%= jsp.sheetInfo.getHoldGuid() %>');
	if ($('#action-history-tgt').exists()) {
		$('#action-history .sheet-section').children().appendTo('#action-history-tgt');
	}
	
	$('[data-cspdrstr]').each(function(){
		var self = this;
		var key = $(self).data('cspdrstr');
		var txt = $(self).text();
		$.each(cspd[key], function(){
			if (this.value == txt) {
				$(self).text( this.text );
			}
		});
	});

  //立場切替 表示判定
  var actorCdList = [];
  <% for (VCstSheetActorAndRefDto dto : jsp.actorCdList) { %>
    actorCdList.push("<%= dto.getActorCd() %>");
  <% } %>

  if( actorCdList.length <= 1 ) {
    $('.showSwitchActor').css("display", "none");
  }

  //立場切替 選択されているアクターのチェックマーク
  var slctedActor = "<%= jsp.usingActorCd %>";
  $('.do-switchActor[data-actorCd="' + slctedActor + '"]').append('<i class="fa fa-check" style="float:right;"></i>');

   /**
   ** Event
  **/
  /* Action Buttons */
  $document.on('click', '.csActionBtns button', function(){
    execSheetAction( $(this).data('actioncd') );
  });
  
  <%-- Reload after disabled --%>
  $document.on('click', '#disabledWrap.clickToReload', function(event){
    _DISABLED = false;
    $('[name=state], [name=tokenNo]').prop('disabled', false);
    showSheet('/servlet/CsSheetServlet', 'RESTORE', '<%= selfSheetId %>');
  });
  <%-- シート再表示 --%>
  $document.on('click', '#transRELOAD', function(event){
    event.preventDefault();
    reloadSheet();
  });
  <%-- シート参照 --%>
  $document.on('click', 'a.refSheet', function(event){
    event.preventDefault();    
    var relatedId = $(this).attr('relatedId');
    var relatedSheetId = $(this).attr('relatedSheetId');
    makeRequestParameter( "relatedId", relatedId );
    openSubWindow('/servlet/CsSheetServlet', 'PAST', relatedSheetId, 1000, 800, false);
  });
  // フローパターン
  $document.on('click', '#btn_chgflowptn', function(){
    makeRequestParameter( "viewMode", "InnerSheet" );
    pageSubmit('/view/sheet/VHD010_ChgFlowPtn.jsp', 'INIT');
  });
	// 記入者の確認・変更
	$document.on('click', '#btn_actors', function(){
		pageSubmit('/view/sheet/VHD014_CsActors.jsp', 'INIT');
	});
	// 参照者の確認・変更
	$document.on('click', '#btn_referers', function(){
    pageSubmit('/view/sheet/VHD013_CsReferers.jsp', 'INIT');
	});
  //立場切替
  $('.do-switchActor').click( function(){
    var switchActorCd = $(this).attr('data-actorcd');
    addRequestParameter( 'switchActorCd', switchActorCd );
    pageSubmit('/servlet/CsSheetServlet', 'SWITCH_ACTOR');
  });

  <%-- フォーム切替タブ --%>
  $document.on('click', '.tablist a', function(ev){
    ev.preventDefault();
    var tabId = $(this).parent().prop('id');
    document.F001.csTab.value = tabId;
    pageSubmit('/servlet/CsSheetServlet', 'TAB');
  });
  <%-- 部分編集 --%>
  $document.on('click', '.cspe', function(){
    var cspe    = $(this).data('cspe');
    var cspearg = $(this).data('cspearg');
    if (typeof customPartialEditBeforeCheck === "function") {
      if (!customPartialEditBeforeCheck( cspe, cspearg, $(this) )) { return false; }
    }
    document.F001.csPartialEdit.value = cspe;
    document.F001.csPartialEditArg.value = cspearg;
    var tabId   = $('.tabarea > .active').attr('id');		makeRequestParameter('tabkeep', tabId);
		pageSubmit('/servlet/CsSheetServlet', 'EDIT');
	});
});

function reloadSheet() {
  showSheet('/servlet/CsSheetServlet', 'RESTORE', '<%= selfSheetId %>');
}
</script>
<script id="modal-template-xlup" type="text/template">

	<div class="CsExcelUpload">
		<div class="closearea"><a class="close" href="#"><i class="fa fa-close"></i></a></div>
		<div class="modal-header">
			<h4>Excelアップロード</h4>
			<p>アップロードするExcelファイルを指定して下さい。<br>回答内容は編集可能な範囲で反映され、ステータスは変更されません。</p>
		</div>
		<div class="modal-body">
			<div class="form-group well" style="margin-bottom: 0;">
				<input type="file" id="excelFile" name="excelFile">
			</div>
		</div>
		<div class="modal-footer">
			<button id="modal-submit-btn" type="button" class="btn btn-primary">アップロード</button>
		</div>
	</div>

</script>

<%-- CareerSheet Custom JavaScript -- C:/lysitheacareer/sheettemplate/PARTY_script.js ----------------------------------------%>
<script><%= templatescript %></script>

<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
