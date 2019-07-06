function isCheckedAny(list) {
	if (list.length == 0) {
		alert("対象を選択してください。");
		return false;
	} else {
		return true;
	}
}

function getCheckedSheetIdArray() {
	var list = new Array();
	$('input[name^="cbox"]:checked').each(function(){
		list.push( $(this).val() );
	});
	return list;
}

function execSearch(url, state, tab) {
	document.F001.tab.value = tab;
	document.F001.action = App.root + url;
	document.F001.state.value = state;
	document.F001.target = "_self";
	document.F001.submit();
	disableAllInputs();
}

function showSheet(sheetId) {
	document.F001.sheetId.value = sheetId;
	pageSubmit('/servlet/CsSheetServlet', 'INIT');
}

function downloadCsMultiExcelFile(templateId) {
	if (!chkTimeout()) { return false; }
	document.F001.xlsharp.value = 'CS_MULTI';
	document.F001.action = App.root + "/servlet/PersonalExcelDownloadServlet";
	document.F001.state.value = templateId;
	document.F001.target = "_self";
	document.F001.submit();
	showBlockingOverlay();
}

function execMultiSheet( state ) {
	if (__DISABLED) { return false; }
	document.F001.action = App.root + '/servlet/CsMultiSheetServlet';
	document.F001.state.value = state;
	try{document.F001.windowMode.value = null;}catch(e){}
	document.F001.target = "_self";
	document.F001.submit();
	disableAllInputs();
}

function checkedLineControl( afterState, lineId ) {
	var lineLB = $('#fixLB tr[data-lineId="'+lineId+'"]');
	var lineRB = $('#fixRB tr[data-lineId="'+lineId+'"]');
	if (afterState) {
		// Checkbox OFF -> ON
		$(lineLB).find('input[name^="cbox"]:checkbox').prop('checked', true);
		$(lineLB).addClass("checked");
		$(lineRB).addClass("checked");
	} else {
		// Checkbox ON -> OFF
		$(lineLB).find('input[name^="cbox"]:checkbox').prop('checked', false);
		$(lineLB).removeClass("checked");
		$(lineRB).removeClass("checked");
	}
}

var pasteInputList = {};
function getPasteInputList() {
	pasteInputList = {};
	var pia = $('#PasteInputArea').val();
	var lines = pia.split('\n');
	var isLineContinuing = false;
	var beforeLine = "";
	var lineArr = new Array();
	$.each(lines,function(i,line){
		line = line.replace( /""/g, '%DQ%' );
		var isKaigyoS = (line.match( /\t"[^"]*$/ ) != null);
		var isKaigyoE = (line.match( /"\t[^"]*$/ ) != null || line.match( /"$/ ) != null);//"
		if (isKaigyoS || isLineContinuing) {
			isLineContinuing = true;
			beforeLine += line + "%KAIGYO%";
			if (isKaigyoE) {
				lineArr.push( beforeLine );
				beforeLine = "";
				isLineContinuing = false;
			}
		}
		else {
			lineArr.push( beforeLine + line );
			beforeLine = "";
		}
	});
	$.each(lineArr,function(i,line){
		line = line.replace( /\t"/g, '\t' );//"
		line = line.replace( /"\t/g, '\t' );//"
		line = line.replace( /%DQ%/g, '"' );
		line = line.replace( /%KAIGYO%/g, '\n' );
		var cols = line.split('\t');
		pasteInputList[cols[0]] = cols;
		beforeLine = "";
		isLineContinuing = false;
	});
	return pasteInputList;
}

function pasteInputForPulldown( fixRB, query, val ) {
	// Invalid value will be returned null.
	var tgt = $(fixRB).find(query).val( val ).change();
	if ($(tgt).val() == null) {
		// null then set blank.
		$(fixRB).find(query).val( "" ).change();
	}
}

function tabActive(id) {
	$('#'+id).addClass('selected');
	$('#'+id+' a').replaceWith('<strong>'+$('#'+id).text()+'</strong>')
}

function tabMultiCsActive(id) {
	$('#'+id).addClass('active');
}

function isIE() {
	var userAgent = window.navigator.userAgent.toLowerCase();
	if (userAgent.indexOf('msie') != -1) {
		return true;
	}
	return false;
}

var isFirstNG = true;
function checkFillsMulti( sheetId ) {
	var ngList = new Array();
	var fixRB = $('#fixRB');
	$(fixRB).find('textarea[name*="' + sheetId + '--Fill--"]').each(function(){
		$(this).removeClass('chkNG');
		var tagName = $(this)[0].tagName;
		var selector = "*[name='" + this.name + "']";
		if (tagName == 'TEXTAREA') {
			var len = $(this).val().replace( /\n/g, ' ' ).length;
			if (len > 500) {
				ngList.push( selector );
			}
		}
	});
	if (ngList.length > 0) {
		if (!isIE()) {
			for (var i=0; i<ngList.length; i++) {
				$(fixRB).find(ngList[i]).addClass('chkNG');
			}
			if (isFirstNG) {
				$(fixRB).find('.chkNG').each(function(){
					var tagName = $(this)[0].tagName;
					if (tagName != 'TEXTAREA') {
						$(this).wrap('<div class="chkNG">');
					}
				});
				isFirstNG = false;
			}
		}
		setTimeout(function(){ try{ $(fixRB).find(ngList[0]).focus(); }catch(e){} }, 0);
		alert('テキストは500文字以内で入力してください。');
		return false;
	}
	return true;
}

function stripeInTab() {
	$('.tabarea>li').each(function(i,el){
		var tabId = $(el).data('tabid');
		var trs = $('.tabstripe tr[data-tabid='+tabId+']');
		_.each(trs, function(tr,i){
			if (i%2 == 0) { $(tr).addClass('gray'); }
		});
	});
}

$(function(){
	 /**
	 ** Initialize
	**/
	// HeaderFixedTable: Disable Cloned Inputs
	$('#fixLT a, #fixLT input, #fixLT select, #fixLT textarea').prop('disabled', true);
	$('#fixRT a, #fixRT input, #fixRT select, #fixRT textarea').prop('disabled', true);
	$('#fixLB a, #fixLB input, #fixLB select, #fixLB textarea').prop('disabled', true);
	$('#fixLB td:nth-child(1) :checkbox, #fixLB td:nth-child(2) a').prop('disabled', false);
	
	// ヘッダボタンを右上にセット
	if ($('[name="windowMode"]').val() != "SubWindow") {
		var hBtns = $('div.headerButtons button');
		$('#command .buttons p').append( hBtns );
	}
	
	// button.FORWARDを青色ボタンに
	$('button.FORWARD').removeClass('btn120').addClass('btn120primary');
	
	// IE テキストエリア幅調整
	if (isIE()) { $('textarea').css('width', '90%'); }
	
	// タブ内の行縞模様
	stripeInTab();
	
	// サーバチェックNG項目に赤枠
	var fixRB = $('#fixRB');
	if (!isIE()) {
		for (var i=0; i<ngList.length; i++) {
			$(fixRB).find('[name="' + ngList[i] + '"]').addClass('chkNG');
		}
		$(fixRB).find('.chkNG').each(function(){
			var tagName = $(this)[0].tagName;
			if (tagName != 'TEXTAREA') {
				$(this).wrap('<div class="chkNG">');
			}
		});
	}
	setTimeout(function(){ try{ $(fixRB).find('.chkNG')[0].focus(); }catch(e){} }, 0);
	
	 /**
	 ** Event
	**/
	$('input[name*="Fill--"].num').change(function(){
		if (isNaN(Number($(this).val()))) { $(this).val(''); }
	});
	$('input[name*="Fill--"].int').change(function(){
		var int = parseInt($(this).val());
		if (isNaN(int)) { $(this).val(''); }
		else if ((int+"").match( /^[0-9]+$/ ) == null) { $(this).val(''); }
		else { $(this).val(int) }
	});
	// ヘッダボタンクリック
	$(document).on('click', '#transVHD040', function(){
		pageSubmit('/view/sheet/VHD040_CSheetStatusProgress.jsp', 'RESTORE');
	});
	$(document).on('click', '#transVHF010', function(){
		pageSubmit('/view/sheet/VHF010_AprvProgList.jsp', 'RESTORE');
	});
	// 表示ボタンクリック
	$(document).on('click', '#SEARCH', function(){
		pageSubmit('/servlet/CsMultiSheetServlet', 'SEARCH');
	});
	// シート進捗フォロー検索ボタンクリック
	$(document).on('click', '#SEARCHFOLLOW', function(){
		document.F001.holdFilter.value    = 'FOLLOW';
		pageSubmit('/servlet/CsMultiSheetFollowServlet', 'SEARCH');
	});
	// 組織のシート検索検索ボタンクリック
	$(document).on('click', '#SEARCHCASC', function(){
		pageSubmit('/servlet/CsMultiSheetCascServlet', 'SEARCH');
	});
	// タブ切り替え
	$(document).on('click', '.tabNavigation li', function(){
		var idstr = $(this).prop('id');
		document.F001.tab.value = idstr;
		execSearch('/servlet/CsMultiSheetServlet', 'SEARCH', idstr);
	});
	// 並び替えプルダウン
	$('#sortPulldown').change(function(a,b){
		pageSubmit('/servlet/CsMultiSheetServlet', 'SEARCH');
	});
	// Excelダウンロード（ボタン）
	$('#btn_xldownload').bind('click', function(){
		var opeCd = $('[name="operationCd"]').val();
		var templateId = 'List_' + opeCd;
		downloadCsMultiExcelFile( templateId );
	});
	$(document).on('click', '#xldownload-dropdown li a', function(e){
		e.preventDefault();
		if (App.UA.isMobile()) {
			alert(__MsgMap["APP_MSG_PC_ONLY"]);
			return false;
		}
		var opeCd = $('[name="operationCd"]').val();
		if (opeCd == '') {
			alert(__MsgMap["LSHFSS_MSG_NOT_SEL"]);
			$('#xlPulldown').val("");
			return false;
		}
		var xlTemplate = $(this).attr('data-xltemplate');
		if (xlTemplate == '') {
			return false;
		}
		var sqlprop = $(this).attr('data-sqlprop');
		if (sqlprop == '') {
			return false;
		}
		downloadXlsxFileWithSqlprop( opeCd, xlTemplate, sqlprop );
	});
	// Reload after disabled
	$(document).on('click', '#disabledWrap.clickToReload', function(event){
		__DISABLED = false;
		$('[name=state], [name=tokenNo]').prop('disabled', false);
		$('*[disabled]').prop('disabled', false);
		pageSubmit('/servlet/CsMultiSheetServlet', 'SEARCH');
	});
	
	
	// Table Header Checkbox Control
	$(document).on('click', '#fixLT #checkall', function(){
		var afterState = $(this).prop('checked');
		$('#fixLB tbody input[name^="cbox"]:checkbox').each(function(){
			var lineId = $(this).parent().parent().attr('data-lineId');
			checkedLineControl( afterState, lineId );
		});
	});
	// Each Line Checkbox Control
	$('#fixLB tbody input[name^="cbox"]:checkbox').change(function(){
		var afterState = $(this).prop('checked');
		var lineId = $(this).parent().parent().attr('data-lineId');
		checkedLineControl( afterState, lineId );
	});
	// Keyboard input in Fill then Checkbox ON
	$('#fixRB input, #fixRB select, #fixRB textarea').change(function(){
		var lineId = $(this).parent().parent().attr('data-lineId');
		if (!lineId) {
			lineId = $(this).parent().parent().parent().attr('data-lineId');
		}
		checkedLineControl( true, lineId );
	});
	
});

function downloadXlsxFileWithSqlprop(xlTemplatePrefix, xlTemplateId, sqlPropKey) {
	if (!chkTimeout()) { return false; }
	document.F001.action = App.root + "/servlet/CsMultiSheetServlet";
	document.F001.state.value = "EXCEL_DL";
	makeRequestParameter( "xlTemplateType", 'SQLPROP' );
	makeRequestParameter( "xlTemplatePrefix", xlTemplatePrefix );
	makeRequestParameter( "xlTemplateId", xlTemplateId );
	makeRequestParameter( "sqlPropKey", sqlPropKey );
	document.F001.submit();
	showBlockingOverlay();
}

function tabActivateOnInit( tabId ) {
	var $tbody = $('#Multi tbody');
	var tabs = _.map($('#sh-multi-tabs .tab'), function(d){
		return $(d).attr('data-tabid');
	});
	// Badge
	_.each(tabs, function(tabId){
		var cnt = $tbody.find('tr[data-tabid="'+tabId+'"]').length;
		$('#sh-multi-tabs .tab[data-tabid="'+tabId+'"] .badge').text( cnt );
	});
	// Activate on init
	if (_.isEmpty( tabId )) {
		tabId = $('#sh-multi-tabs .tab:first-child').attr('data-tabid');
	}
	tabActivate( tabId );
}

function tabActivate( tabId ) {
	$('#sh-multi-tabs .tab').removeClass('active');
	$('#sh-multi-tabs .tab[data-tabid="'+tabId+'"]').addClass('active');
	tabChanged( tabId );
}

function tabChanged( tabId ) {
	var $tbody = $('#Multi tbody');
	$tbody.find('tr').removeClass('shown');
	$tbody.find('tr[data-tabid="'+tabId+'"]').addClass('shown');
	
	var $xldl = $('#xldownload-dropdown');
	$xldl.find('li').removeClass('shown');
	$xldl.find('li[data-tabid="'+tabId+'"]').addClass('shown');
}
