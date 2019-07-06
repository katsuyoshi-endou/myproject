<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*"%>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*"%>
<%@ page import="jp.co.hisas.career.app.talent.bean.*" %>
<%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.app.talent.mold.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%!
	String convertToJSVal(String str) {
		if (str != null) {
			// バックスラッシュのエスケープ
			str = str.replaceAll("\\\\", "\\\\\\\\");
			// ダブルクォーテーションのエスケープ
			str = str.replaceAll("\"", "\\\\\"");
		}
		return str;
	}
%>
<%
	VmVTLSCE vm = AU.getRequestAttr( request, "vm" );
	
	/* 検索条件マスタ */
	LegacyKensakuDefBean legacyKensakuDefBeanBean = vm.legacyKensakuDefBean;
	
	
	/**************** 個人属性汎用検索機能 ****************/
	// 個人属性汎用検索機能 - 検索カテゴリ
	ArrayList<KensakuCategoryDto> kCategoryDtoList = legacyKensakuDefBeanBean.getKensakuCategoryDtoList();
	// 個人属性汎用検索機能 - 保管した検索条件の復元
	MysrchCndLgcMold pzCond = vm.cndLgcMold;
	boolean existPzCond = (pzCond != null);
	if (existPzCond) {
		pzCond.row1Query = convertToJSVal( pzCond.row1Query );
		pzCond.row2Query = convertToJSVal( pzCond.row2Query );
		pzCond.row3Query = convertToJSVal( pzCond.row3Query );
		pzCond.row4Query = convertToJSVal( pzCond.row4Query );
		pzCond.row5Query = convertToJSVal( pzCond.row5Query );
	}
%>
<%-- ================================================== Main Content Area ==================================================--%>


		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<!-- 個人属性汎用検索機能                                                                                                -->
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<h3 class="mgt"><%= vm.gCL("LTLSCE_BOX_TITLE") %></h3>
		<div id="PZSearchCondition" class="mod-table paper" style="word-break: break-all;">
			<table>
				<colgroup>
					<col style="width: 3%;" />
					<col style="width:20%;" />
					<col style="width:37%;" />
					<col style="width:25%;" />
					<col style="width:15%;" />
				</colgroup>
				<thead>
					<tr>
						<th></th>
						<th><%= vm.gCL("LTLSCE_TH_BOX_1") %></th>
						<th><%= vm.gCL("LTLSCE_TH_BOX_2") %></th>
						<th><%= vm.gCL("LTLSCE_TH_BOX_3") %></th>
						<th><%= vm.gCL("LTLSCE_TH_BOX_4") %></th>
					</tr>
				</thead>
				<tbody>
					<tr id="row1">
						<td class="colCheckbox">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="row1Checkbox" value="" />
									<i class="fa fa-check"></i>
								</label>
							</div>
						</td>
						<td class="colTabId">
							<div class="select block">
								<label><select name="row1TabId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colPzId">
							<div class="select block">
								<label><select name="row1PzId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colQuery"><input type="text" name="row1Query" value="" /></td>
						<td class="colKigo">
							<div class="select block">
								<label><select name="row1Kigo"><option value=""></option></select></label>
							</div>
						</td>
					</tr>
					<tr id="row2">
						<td class="colCheckbox">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="row2Checkbox" value="" />
									<i class="fa fa-check"></i>
								</label>
							</div>
						</td>
						<td class="colTabId">
							<div class="select block">
								<label><select name="row2TabId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colPzId">
							<div class="select block">
								<label><select name="row2PzId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colQuery"><input type="text" name="row2Query" value="" /></td>
						<td class="colKigo">
							<div class="select block">
								<label><select name="row2Kigo"><option value=""></option></select></label>
							</div>
						</td>
					</tr>
					<tr id="row3">
						<td class="colCheckbox">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="row3Checkbox" value="" />
									<i class="fa fa-check"></i>
								</label>
							</div>
						</td>
						<td class="colTabId">
							<div class="select block">
								<label><select name="row3TabId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colPzId">
							<div class="select block">
								<label><select name="row3PzId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colQuery"><input type="text" name="row3Query" value="" /></td>
						<td class="colKigo">
							<div class="select block">
								<label><select name="row3Kigo"><option value=""></option></select></label>
							</div>
						</td>
					</tr>
					<tr id="row4">
						<td class="colCheckbox">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="row4Checkbox" value="" />
									<i class="fa fa-check"></i>
								</label>
							</div>
						</td>
						<td class="colTabId">
							<div class="select block">
								<label><select name="row4TabId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colPzId">
							<div class="select block">
								<label><select name="row4PzId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colQuery"><input type="text" name="row4Query" value="" /></td>
						<td class="colKigo">
							<div class="select block">
								<label><select name="row4Kigo"><option value=""></option></select></label>
							</div>
						</td>
					</tr>
					<tr id="row5">
						<td class="colCheckbox">
							<div class="checkbox">
								<label>
									<input type="checkbox" name="row5Checkbox" value="" />
									<i class="fa fa-check"></i>
								</label>
							</div>
						</td>
						<td class="colTabId">
							<div class="select block">
								<label><select name="row5TabId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colPzId">
							<div class="select block">
								<label><select name="row5PzId"><option value=""></option></select></label>
							</div>
						</td>
						<td class="colQuery"><input type="text" name="row5Query" value="" /></td>
						<td class="colKigo">
							<div class="select block">
								<label><select name="row5Kigo"><option value=""></option></select></label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div><!-- /#PZSearchCondition -->


<%-- ==================================================/Main Content Area ==================================================--%>
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
<%-- タブのプルダウンリストデータを生成 --%>
var tabIdPulldownData = [
<%
	for ( int catCnt = 0; catCnt < kCategoryDtoList.size(); catCnt++ ) {
		KensakuCategoryDto kCategoryDto = kCategoryDtoList.get( catCnt );
		final String kCategoryID   = SU.ntb( kCategoryDto.getKensakuCategoryId() );
		final String kCategoryName = SU.ntb( kCategoryDto.getKensakuCategoryName().replaceAll("\"","\\\\\"") );
		String comma = (catCnt==0) ? "" : "," ;
%>
	<%= comma %> {value:'<%= kCategoryID %>', text:'<%= kCategoryName %>'}
<%
	}
%>
];

<%-- タブ毎の項目プルダウンリストデータを生成 --%>
var pzIdPullArray = new Array();
<%
	for ( int catCnt = 0; catCnt < kCategoryDtoList.size(); catCnt++ ) {
		KensakuCategoryDto kCategoryDto = kCategoryDtoList.get( catCnt );
		final String kCategoryID   = SU.ntb( kCategoryDto.getKensakuCategoryId() );
%>
pzIdPullArray["<%= kCategoryID %>"] = [
<%
		ArrayList<KensakuKomokuDto> komokuDtoList = legacyKensakuDefBeanBean.getKensakuKomokuDtoList( kCategoryDto.getKensakuCategoryId() );
		for( int komokuCnt = 0; komokuCnt < komokuDtoList.size(); komokuCnt++ ) {
			KensakuKomokuDto kKomokuDto = komokuDtoList.get( komokuCnt );
			final String kKomokuId   = SU.ntb( kKomokuDto.getKensakuKomokuId() );
			final String kKomokuPzId = SU.ntb( kKomokuDto.getPersonZokuseiId() );
			final String kKomokuName = SU.ntb( kKomokuDto.getKensakuKomokuName().replaceAll("\"","\\\\\"") );
			Integer nyuryokuKetasu = kKomokuDto.getNyuryokuKetasu();
			nyuryokuKetasu = ( nyuryokuKetasu == null ) ? new Integer( "-1" ) : nyuryokuKetasu ;
			final int kensakuType  = kKomokuDto.getKensakuType().intValue();
			String comma = (komokuCnt==0) ? "" : "," ;
%>
	<%= comma %> {value:'<%= kKomokuId %>', text:'<%= kKomokuName %>', kensakuType:'<%= kensakuType %>', maxlength:'<%= nyuryokuKetasu %>' }
<%		} %>
];
<%	} %>

<%-- コードマスタのプルダウンリストデータを生成 --%>
var pzCodeMasterArray = new Array();
<%
	for ( int catCnt = 0; catCnt < kCategoryDtoList.size(); catCnt++ ) {
		KensakuCategoryDto kCategoryDto = kCategoryDtoList.get( catCnt );
		ArrayList<KensakuKomokuDto> komokuDtoList = legacyKensakuDefBeanBean.getKensakuKomokuDtoList( kCategoryDto.getKensakuCategoryId() );
		for( int komokuCnt = 0; komokuCnt < komokuDtoList.size(); komokuCnt++ ) {
			KensakuKomokuDto kKomokuDto = komokuDtoList.get( komokuCnt );
			final String kKomokuId = SU.ntb( kKomokuDto.getKensakuKomokuId() );
			ArrayList<CodeMasterDto> codeList = legacyKensakuDefBeanBean.getCodeMasterDtoList( kKomokuDto.getMasterId() );
			String arrayContent = "";
			for( int codeCnt = 0; codeCnt < codeList.size(); codeCnt++ ) {
				CodeMasterDto codeMasterDto = codeList.get( codeCnt );
				String masterName = SU.ntb( ( codeMasterDto.getMasterName().toString() ) );
				String masterCode = SU.ntb( ( codeMasterDto.getMasterCode().toString() ) );
				// 名称検索
				if ( new Integer("1").equals( kKomokuDto.getPersonZokuseiKensakuType() ) ) {
					masterCode = masterName;
				}
				String comma = (codeCnt==0) ? "" : "," ;
				arrayContent += comma + " {value:'" + masterCode + "', text:'" + masterName + "'}";
			}
			if ( codeList.size() > 0 ) {
%>
pzCodeMasterArray["<%= kKomokuId %>"] = [<%= arrayContent %>];
<%
			}
		}
	}
%>

<%-- 項目に対応する検索記号のプルダウンリストデータを生成 --%>
var kigoPullArray = new Array();
<%
	for ( int catCnt = 0; catCnt < kCategoryDtoList.size(); catCnt++ ) {
		KensakuCategoryDto kCategoryDto = kCategoryDtoList.get( catCnt );
		ArrayList<KensakuKomokuDto> komokuDtoList = legacyKensakuDefBeanBean.getKensakuKomokuDtoList( kCategoryDto.getKensakuCategoryId() );
		for( int komokuCnt = 0; komokuCnt < komokuDtoList.size(); komokuCnt++ ) {
			KensakuKomokuDto kKomokuDto = komokuDtoList.get( komokuCnt );
			final String kKomokuId   = SU.ntb( kKomokuDto.getKensakuKomokuId() );
			ArrayList<KensakuKigoDto> kigoList = legacyKensakuDefBeanBean.getKensakuKigoDtoList( kKomokuDto.getKensakuKomokuId() );
			String arrayContent = "";
			for( int kigoCnt = 0; kigoCnt < kigoList.size(); kigoCnt++ ) {
				KensakuKigoDto kKigoDto = kigoList.get( kigoCnt );
				final String kigoType  = SU.ntb( kKigoDto.getKigoType() );
				final String hyojiName = SU.ntb( kKigoDto.getHyojiName() );
				String comma = (kigoCnt==0) ? "" : "," ;
				arrayContent += comma + " {value:'" + kigoType + "', text:'" + hyojiName + "'}";
			}
%>
kigoPullArray["<%= kKomokuId %>"] = [<%= arrayContent %>];
<%
		}
	}
%>

__MsgMap = {};
__MsgMap["LTLSCE_MSG_DATE_FORMAT_NG"] = '<%= vm.gCL("LTLSCE_MSG_DATE_FORMAT_NG") %>';
__MsgMap["LTLSCE_MSG_NUM_FORMAT_NG"] = '<%= vm.gCL("LTLSCE_MSG_NUM_FORMAT_NG") %>';
$(function(){
	$document = $(document);
	
	 /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 * Initialize
	*/
	// タブ列のプルダウンリスト生成
	$('#PZSearchCondition td.colTabId select').empty();
	$.each(tabIdPulldownData, function(){
		var option = $('<option>', this);
		$('#PZSearchCondition td.colTabId select').append(option);
	});
	// 項目列のプルダウンリスト生成
	$('#PZSearchCondition td.colPzId select').empty();
	$('#PZSearchCondition td.colTabId select option:selected').each(function(){
		var trId  = $(this).closest('tr').attr("id");
		var catId = $(this).val();
		$.each(pzIdPullArray[catId], function(){
			var option = $('<option>', this);
			$('#PZSearchCondition tr#' + trId + ' td.colPzId select').append(option);
		});
	});
	
	// 入力:検索文字列/プルダウン選択を切り替える
	$('#PZSearchCondition td.colTabId select option:selected').each(function(){
		var trId  = $(this).closest('tr').attr("id");
		var tabId = $(this).val();
		changeQuery( trId, tabId, "" );
	});
	changeKigo( 'row1' );
	changeKigo( 'row2' );
	changeKigo( 'row3' );
	changeKigo( 'row4' );
	changeKigo( 'row5' );
	
	toggleTrDisableState( 'row1', true );
	toggleTrDisableState( 'row2', false );
	toggleTrDisableState( 'row3', false );
	toggleTrDisableState( 'row4', false );
	toggleTrDisableState( 'row5', false );
	
<% if (existPzCond) { %>
	<%---- 検索条件の復元 ----%>
	$('#PZSearchCondition :checkbox').prop('checked', false);
	toggleTrDisableState( 'row1', <%= pzCond.row1IsChecked %> );
	toggleTrDisableState( 'row2', <%= pzCond.row2IsChecked %> );
	toggleTrDisableState( 'row3', <%= pzCond.row3IsChecked %> );
	toggleTrDisableState( 'row4', <%= pzCond.row4IsChecked %> );
	toggleTrDisableState( 'row5', <%= pzCond.row5IsChecked %> );
	<% if (pzCond.row1IsChecked) { %>
			keepConditions( "row1", "<%= pzCond.row1TabId %>", "<%= pzCond.row1PzId %>", "<%= pzCond.row1Query %>", "<%= pzCond.row1Kigo %>" );
	<% } %>
	<% if (pzCond.row2IsChecked) { %>
			keepConditions( "row2", "<%= pzCond.row2TabId %>", "<%= pzCond.row2PzId %>", "<%= pzCond.row2Query %>", "<%= pzCond.row2Kigo %>" );
	<% } %>
	<% if (pzCond.row3IsChecked) { %>
			keepConditions( "row3", "<%= pzCond.row3TabId %>", "<%= pzCond.row3PzId %>", "<%= pzCond.row3Query %>", "<%= pzCond.row3Kigo %>" );
	<% } %>
	<% if (pzCond.row4IsChecked) { %>
			keepConditions( "row4", "<%= pzCond.row4TabId %>", "<%= pzCond.row4PzId %>", "<%= pzCond.row4Query %>", "<%= pzCond.row4Kigo %>" );
	<% } %>
	<% if (pzCond.row5IsChecked) { %>
			keepConditions( "row5", "<%= pzCond.row5TabId %>", "<%= pzCond.row5PzId %>", "<%= pzCond.row5Query %>", "<%= pzCond.row5Kigo %>" );
	<% } %>
<% } %>
	
	
	 /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 * Event
	*/
	// チェックボックスの状態が変更されたとき
	$("#PZSearchCondition :checkbox").on('click', function() {
		var trId = $(this).closest('tr').prop("id");
		var isChecked = $(this).prop('checked');
		toggleTrDisableState( trId, isChecked );
	});
	// タブのプルダウンが変更されたとき
	$("#PZSearchCondition td.colTabId select").change(function() {
		var trId = $(this).closest('tr').prop("id");
		var tabId = $(this).val();
		// 項目列のプルダウンリストを切り替える
		updatePzIdList( trId, tabId );
		// 入力:検索文字列/プルダウン選択を切り替える
		changeQuery( trId, tabId, "" );
		changeKigo( trId );
	});
	// 項目のプルダウンが変更されたとき
	$("#PZSearchCondition td.colPzId select").change(function() {
		var trId = $(this).closest('tr').prop("id");
		var tabId = $('#'+trId+' td.colTabId select option:selected').val();
		// 入力:検索文字列/プルダウン選択を切り替える
		changeQuery( trId, tabId, "" );
		changeKigo( trId );
	});
	// 検索文字列入力欄をフォーカスアウトしたとき
	$document.on('blur', '#PZSearchCondition .colQuery input', function() {
		// 数値項目に数値以外の場合は消去
		if ($(this).hasClass('numQuery')) {
			if (! $(this).val().match(/^[\d]+$/)) {
				$(this).val('');
			}
		}
	});
	
});


/**
 * チェック状態を見て検索ボタンの活性/非活性を切り替える
 */
function toggleTrDisableState( trId, isChecked ) {
	if (isChecked) {
		// 入力可能
		$("#"+trId+" select").prop('disabled', false);
		$("#"+trId+" :text").prop('disabled', false);
		$("#"+trId+" :checkbox").prop('checked', true);
		$("#"+trId+" :checkbox").val(true);
		$("#"+trId+" td").removeClass('disabledLine');
	} else {
		// 入力不可
		$("#"+trId+" select").prop('disabled', true);
		$("#"+trId+" :text").prop('disabled', true);
		$("#"+trId+" :checkbox").val(false);
		$("#"+trId+" td").addClass('disabledLine');
	}
}

/**
 * 入力:検索文字列/プルダウン選択を切り替える
 */
function changeQuery( trId, tabId, queryVal ) {
	$('#'+trId+' td.colQuery').empty();
	var selectedPzId = $('#'+trId+' td.colPzId select option:selected').val();
	var kType = getPzIdProperty( tabId, selectedPzId, "kensakuType" );
	var len   = getPzIdProperty( tabId, selectedPzId, "maxlength" );
	if ('5' == kType) {
		// 検索タイプ"5":プルダウン選択
		$('#'+trId+' td.colQuery').append( $('<select name="'+trId+'Query">') );
		$.each(pzCodeMasterArray[selectedPzId], function(){
			var option = $('<option>', this);
			$('#'+trId+' td.colQuery select').append(option);
			if ('' != queryVal) {
				$("#"+trId+" td.colQuery select option[value='"+queryVal+"']").each(function(){
					$(this).prop('selected', true);
				});
			}
		});
	} else if ('8' == kType) {
		// 検索タイプ"8":テキストボックス(日付)
		$('#'+trId+' td.colQuery').append('<input type="text" class="textBox dateQuery" name="'+trId+'Query" value="" maxlength="'+len+'" />');
		$('#'+trId+' td.colQuery .dateQuery').val(queryVal);
	} else if ('1' == kType) {
		// 検索タイプ"1":テキストボックス(数値)
		$('#'+trId+' td.colQuery').append('<input type="text" class="textBox numQuery"  name="'+trId+'Query" value="" maxlength="'+len+'" />');
		$('#'+trId+' td.colQuery .numQuery').val(queryVal);
	} else {
		// 検索タイプ"0":テキストボックス(文字列)
		$('#'+trId+' td.colQuery').append('<input type="text" class="textBox textQuery" name="'+trId+'Query" value="" maxlength="'+len+'" />');
		$('#'+trId+' td.colQuery .textQuery').val(queryVal);
	}
}

function getPzIdProperty( tabId, pzId, key ) {
	var prop;
	for (var i = 0; i < pzIdPullArray[tabId].length; i ++) {
		if (pzId == pzIdPullArray[tabId][i]["value"]) {
			prop = pzIdPullArray[tabId][i][key];
			break;
		}
	}
	return prop;
}

function updatePzIdList( trId, tabId ) {
	$('#'+trId+' td.colPzId select').empty();
	$.each(pzIdPullArray[tabId], function(){
		var option = $('<option>', this);
		$('#'+trId+' td.colPzId select').append(option);
	});
}

/**
 * 入力した検索条件を維持する（引数をもとに再セットする）
 */
function keepConditions( rowId, tabVal, pzVal, queryVal, kigoVal ) {
	try {
		// タブの復元
		$("#"+rowId+" td.colTabId select option[value="+tabVal+"]").each(function(){
			$(this).prop('selected', true);
			updatePzIdList( rowId, tabVal );
		});
		// 項目の復元
		$("#"+rowId+" td.colPzId select option[value="+pzVal+"]").each(function(){
			$(this).prop('selected', true);
		});
		// 検索文字列の復元
		changeQuery( rowId, tabVal, queryVal );
		// 検索方法の復元
		changeKigo( rowId );
		$("#"+rowId+" td.colKigo select option[value="+kigoVal+"]").each(function(){
			$(this).prop('selected', true);
		});
	} catch(e) {
		console.error(e);
	}
}

/**
 * 記号のプルダウンリストを切り替える
 */
function changeKigo( trId ) {
	$('#'+trId+' td.colKigo select').empty();
	var selectedPzId = $('#'+trId+' td.colPzId select option:selected').val();
	if (typeof selectedPzId === "undefined") {
	} else {
		$.each(kigoPullArray[selectedPzId], function(){
			var option = $('<option>', this);
			$('#'+trId+' td.colKigo select').append(option);
		});
	}
}

/**
 * 検索実行時の入力チェック
 * ※ 呼出元: VTLSCE_SearchCondEdit.jsp
 * ※ Throws Exception
 */
function checkBeforePZSearch() {
	$("#PZSearchCondition .colCheckbox :checked").each(function(){
		var trId = $(this).closest('tr').prop('id');
		var tabId = $('#'+trId+' td.colTabId select option:selected').val();
		var selectedPzId = $('#'+trId+' td.colPzId select option:selected').val();
		var kText = getPzIdProperty( tabId, selectedPzId, "text" );
		$("#"+trId+" td.colQuery input").each(function(){
			// 検索タイプ"8":テキストボックス(日付) 入力チェック
			if ( $(this).hasClass('dateQuery') ) {
				var chkVal = $(this).val();
				var regex = new RegExp( "^[0-9]{4}/[0-9]{2}/[0-9]{2}$", "i" );
				if ( !chkVal.match( regex ) ) {
					throw kText + __MsgMap["LTLSCE_MSG_DATE_FORMAT_NG"];
				}
			}
			// 検索タイプ"1":テキストボックス(数値) 入力チェック
			if ( $(this).hasClass('numQuery') ) {
				var chkVal = $(this).val();
				var regex = new RegExp( "^[0-9]+$", "i" );
				if ( !chkVal.match( regex ) ) {
					throw kText + __MsgMap["LTLSCE_MSG_NUM_FORMAT_NG"];
				}
			}
		});
	});
}
</script>
