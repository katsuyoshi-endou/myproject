
$(function(){
	$document = $(document);
	
	 /**
	 ** Initialize
	**/
	
	// ヘッダボタンを右上にセット
	if ($('[name="windowMode"]').val() != "SubWindow") {
		var hBtns = $('div.headerButtons button');
		$('#command .buttons p').append( hBtns );
	}
	
	// FORWARDボタンを青色に
	$('.csActionBtns [data-actioncd="FORWARD"], .csActionBtns [data-actioncd="SKIP"]').each(function(){
		var $self = $(this);
		if ( $self.hasClass('btn') ) {
			$self.addClass('btn-secondary');
		}
	});
	
	// DELETEボタンを赤色に
	$('.csActionBtns [data-actioncd="DELETE"]').each(function(){
		var $self = $(this);
		if ( $self.hasClass('btn') ) {
			$self.addClass('btn-delete');
		}
	});
	
	// IE テキストエリア幅調整
	if (isIE()) { $('textarea').css('width', '90%'); }
	
	 /**
	 ** Header Buttons
	**/
	$document.on('click', '#transVHD020', function(){
		pageSubmit('/view/sheet/VHD020_CareerSheetList.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHD021', function(){
		pageSubmit('/view/sheet/VHD021_CSheetListOnActor.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHD022', function(){
		pageSubmit('/view/sheet/VHD022_CSheetUnifyListOnActor.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHD023', function(){
		pageSubmit('/view/sheet/VHD023_SingleSheetList.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHD040', function(){
		pageSubmit('/servlet/CsMultiSheetServlet', 'RESTORE');
	});
	$document.on('click', '#transVHD050', function(){
		pageSubmit('/view/sheet/VHD023_SingleSheetList.jsp', 'INIT');
	});
	$document.on('click', '#transVHE020', function(){
		pageSubmit('/view/sheet/VHE020_CareerSheetList.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHE021', function(){
		pageSubmit('/view/sheet/VHE021_CareerSheetMyList.jsp', 'RESTORE');
	});
	$document.on('click', '#transVHF010', function(){
		pageSubmit('/servlet/CsMultiSheetServlet', 'RESTORE');
	});
	$document.on('click', '#transCSMLTI', function(){
		pageSubmit('/servlet/CsMultiSheetServlet', 'RESTORE');
	});
	$document.on('click', '#transCSMLTICSC', function(){
		pageSubmit('/servlet/CsMultiSheetCascServlet', 'RESTORE');
	});
	$document.on('click', '#transVSHBLK', function(){
		pageSubmit('/servlet/CsBulkServlet', 'RESTORE');
	});
	
	// Excelダウンロードボタン
	$document.on('click', '.xlDownload', function(){
		if (App.UA.isMobile()) {
			alert(__MsgMap["APP_MSG_PC_ONLY"]);
			return false;
		}
		document.F001.xlsharp.value = 'CS_SINGLE';
		var xlform = $(this).attr('id');
		pageSubmit('/servlet/SheetDownloadServlet', xlform);
		setTimeout( function(){
			$('.blockingOverlay').addClass('clickToReload');
			$('.blockingOverlay').css('cursor', 'pointer');
		}, 1000 );
	});
	// Excelアップロードボタン
	$document.on('click', '#excelUpload', function(){
		if (App.UA.isMobile()) {
			alert(__MsgMap["APP_MSG_PC_ONLY"]);
			return false;
		}
		openExcelUploadModal();
	});
	// Reload after disabled
	$(document).on('click', '.blockingOverlay.clickToReload', function(event){
		__DISABLED = false;
		$('[name=state], [name=tokenNo]').prop('disabled', false);
		pageSubmit('/servlet/CsSheetServlet', 'RESTORE');
	});
	
	 /**
	 ** Modal Window
	**/
	$document.on('click', '#modal-overlay, #modal-window .close', function(){
		closeModal();
	});
	$document.on('click', '.CsDeliv #modal-submit-btn', function(){
		__CS_WAIT_MODAL[__CS_MODAL_ACTION_CD] = false;
		execSheetAction( __CS_MODAL_ACTION_CD );
	});
	$document.on('click', '.CsExcelUpload #modal-submit-btn', function(){
		if(window.File && window.FileReader) {
			if ( document.getElementById("excelFile").files[0] == null ){
				alert(__MsgMap["LSHSHT_MSG_CHK_UPFILE_REQUIRED"]);
				return false;
			}
			var filesize = document.getElementById("excelFile").files[0].size;
			var maxsize = $(':hidden[name="max_filebyte"]').val();
			if (filesize > maxsize){
				alert(__MsgMap["LSHSHT_MSG_CHK_UPFILE_TOO_LARGE"]);
				return false;
			}
		}
		$('form[name="F001"]').attr('enctype', 'multipart/form-data');
		pageSubmit( '/servlet/CsExcelUploadServlet', 'STAY' );
	});
	
//	console.log("-- careersheet.js done --");
});

function makeFills() {
	// サーバから取得したfillContentでinput/textareaに埋め込み :: Fill & NestFill
	$('textarea[name*="Fill--"]').each(function(){
		var elemName = $(this).prop('name');
		$(this).val( fillMap[elemName] );
	});
	$('input[name*="Fill--"]').each(function(){
		var elemName = $(this).prop('name');
		var elemType = $($(this)[0]).attr('type');
		if (elemType === 'radio') {
			$(this).val( [ fillMap[elemName] ] );
		} else if (elemType === 'checkbox') {
			var isChecked = 'on' === fillMap[elemName];
			$(this).prop( 'checked', isChecked );
		} else {
			$(this).val( fillMap[elemName] );
		}
	});
	$('select[name*="Fill--"]').each(function(){
		var elemName = $(this).prop('name');
		$(this).val( fillMap[elemName] );
	});
	
	// 入力エリアをReadOnlyに
	for (var i=0; i<readFillList.length; i++) {
		try {
			var elem = "*[name='" + readFillList[i] + "']";
			var elemTag = $(elem)[0].tagName;
			var elemType = $(elem).attr('type');
			var elemContent = getReadOnlyContent(elem, elemTag);
			if (elemType === 'checkbox') {
				$(elem).prop('disabled', true);
				$(elem).attr('data-mask', 'read');
			} else {
				$(elem).replaceWith( elemContent );
			}
		} catch (e) {
		}
	}
	// 上記ReadOnly処理後に残った入力エリアがwriteリストになければReadOnlyに :: Fill
	$('*[name*="Fill--"]').each(function(){
		var elemType = $(this).attr('type');
		if (elemType === 'checkbox') {
			// チェックボックスはReadモード( data-mask: read )として残される。
			// そのため、ここに到達した場合にマスクNULLのものだけを取り除いている。
			var elemName = $(this).prop('name');
			var elemTag  = $(this)[0].tagName;
			var isWriteFill = $.inArray( elemName, writeFillList );
			var mask = $(this).attr('data-mask');
			if (mask === 'read') {
				// Keep
			} else {
				if (-1 == isWriteFill) {
					if ($(this).siblings('i').exists()) {
						$(this).closest('.checkbox').remove();
					} else {
						$(this).remove();
					}
				} else {
					// Write mode (do nothing)
				}
			}
		} else {
			var elemName = $(this).prop('name');
			var elemTag  = $(this)[0].tagName;
			var elemContent = getReadOnlyContent(this, elemTag);
			var isWriteFill = $.inArray( elemName, writeFillList );
			if (-1 == isWriteFill) {
				$(this).replaceWith( elemContent );
			}
		}
	});
}

function cstabActivate( tabId ) {
	var tabpages = $('.tabpage');
	tabpages.hide();
	if (_.isEmpty(tabId)) {
		tabId = $('.tabarea > li:first-child').attr('id');
	}
	$('#'+tabId).addClass("active");
	$('.tabpage.'+tabId).addClass("active").show();
	
	$document.on("click", ".cstab ul li a",function(event) {
		event.preventDefault();
		tabpages.hide();
		$(".cstab ul li").removeClass("active");
		var nextCls = "." + $(this).parent().attr("id");// tab01
		var nextId  = "#" + $(this).parent().attr("id");// tab01
		$(nextCls).show();
		$(nextId).addClass("active");
	});
}

function drawStatusSummary( statusCd, loginUser, holdUser ) {
	var $elem = $('[data-statuscd="' + statusCd + '"]>td');
	$elem.parent().parent().find('th').addClass('active');
	$elem.find('.fa').addClass('fa-play');
	if (loginUser == holdUser) {
		$elem.addClass('isHold');
	} else {
		$elem.addClass('isActive');
	}
}

function isIE() {
	var userAgent = window.navigator.userAgent.toLowerCase();
	if (userAgent.indexOf('msie') != -1) {
		return true;
	}
	return false;
}

function pulldownAutoSelect( name, val ) {
	if (val != null && val != '') {
		$('select[name="' + name + '" ]').val( val );
	} else {
		$('[name="' + name + '"] option:first-child').prop('selected', true);
	}
}

function getReadOnlyContent(jqObj, tagName) {
	var elemContent;
	if (tagName == 'TEXTAREA') {
		elemContent = $(jqObj).val();
	} else if (tagName == 'INPUT') {
		elemContent = $(jqObj).val();
	} else if (tagName == 'SELECT') {
		elemContent = $(':selected', jqObj).text();
	}
	return escapeHTML(elemContent);
}

function escapeHTML(text) {
	return String(text)
		.replace(/&/g, '&amp;')//&(?!\w+;)
		.replace( /</g, "&lt;" )
		.replace( />/g, "&gt;" )
		.replace( /\n/g, "<br>" )
		.replace( /"/g, "&quot;" )//"
		.replace( /'/g, "&#39;" )//'
		.replace( /^$/g, "&nbsp;" );// add space when blank for replaceWith
}

var __CS_MODAL_ACTION_CD = "";
function openCsDelivModal( actionCd ) {
	__CS_MODAL_ACTION_CD = actionCd;
	var leftPos = ($(document).width() / 2) - 265;
	var topPos  = 150;
	$('#modal-overlay').show();
	if (!$('#modal-window>.CsDeliv').exists()) {
		$('#modal-window').empty();
		$('#modal-window').append( $('.modal-body-src').html() );
	}
	$('#modal-window').css('left', leftPos+'px').css('top', topPos+'px').show();
	$('#modal-window textarea').focus();
	var btnTxt = $('.csActionBtns [data-actioncd="'+actionCd+'"]').eq(0).text();
	$('#modal-window .modal-header h4').text( btnTxt + 'コメント' );
}

function closeModal() {
	__CS_WAIT_MODAL[__CS_MODAL_ACTION_CD] = true;
	$('#modal-overlay').hide();
	$('#modal-window').hide();
}

function openCsXluploadModal() {
	var leftPos = ($(document).width() / 2) - 265;
	var topPos  = 150;
	$('#modal-overlay').show();
	if (0 == $('#modal-window>div').length) {
		$('#modal-window').append( $('.modal-body-src').html() );
	};
	$('#modal-window').css('left', leftPos+'px').css('top', topPos+'px').show();
	$('#modal-window textarea').focus();
}

function openExcelUploadModal() {
	$('#modal-overlay').show();
	$('#modal-window').empty();
	$('#modal-window').append( $('#modal-template-xlup').html() );
	var leftPos = ($(document).width() / 2) - 265;
	var topPos  = 150;
	$('#modal-window').css('left', leftPos+'px').css('top', topPos+'px').show();
}

function closeCsXluploadModal() {
	$('#modal-overlay').hide();
	$('#modal-window').hide();
}

function execSheet(url, state, sheetId) {
	showSheet(url, state, sheetId)
}

function showSheet(url, state, sheetId) {
	document.F001.sheetId.value = sheetId;
	pageSubmit(url, state);
}

function downloadExcel(state) {
	if (!chkTimeout()) { return false; }
	if (__DISABLED) { return false; }
	document.F001.action = "/servlet/PersonalExcelDownloadServlet";
	document.F001.state.value = formType;
	document.F001.submit();
}

function sheetBasicInputCheck() {
	return basicInputCheck();
}

function cspeCheckboxRequestHandler() {
	var $checkboxes = $('input:checkbox[name^="Fill--"]');
	$checkboxes.each(function(i, el){
		// Disable it and Make another hidden input for sending request as a text
		var elName = $(el).attr('name');
		var isChecked = $(el).prop('checked');
		$(el).prop('disabled', true);
		$(el).attr('name', elName+'__handled');
		makeRequestParameter(elName, isChecked ? "on" : "off");
	});
}

function isWriteFill( fillId ) {
	var isWriteFill = $.inArray( "Fill--" + fillId, writeFillList );
	return (-1 == isWriteFill) ? false : true;
}


 /**
 ** Calc Utils
**/

function needsCheck(fillId) {
	return $.inArray( fillId, writeFillList ) != -1;
}

function getCellNum( $that ) {
	var num = 0;
	if ($that.find('select').exists()) {
		num = Number( $that.find('option:selected').val() );
		return _.isNaN(num) ? 0 : num;
	} else if ($that.find('input').exists()) {
		num = Number( $that.find('input').val() );
		return _.isNaN(num) ? 0 : num;
	} else {
		num = Number( $that.text() );
		return _.isNaN(num) ? 0 : num;
	}
}

function toInt( str ) {
	if (!str.match(/^[0-9]+$/)) {
		return "";
	}
	if (_.isEmpty( str )) {
		return "";
	}
	var num = Number( str );
	if (_.isNaN( num )) {
		return "";
	}
	return Math.floor( num );
}

function isInt0to100( str ) {
	var num = Number( str );
	if (_.isNaN( num )) {
		return false;
	}
	if (num == 100) {
		return true;
	}
	if (!!num.toString().match(/^[0-9]?[0-9]$/)) {
		return true;
	}
	return false;
}

function pretty0to100( val ) {
	val = FHConvert.ftoh( val )
	if (_.isEmpty( val )) { return ""; }
	var num = toInt( val );
	if (num === '' || num < 0 || 100 < num) {
		alert(__MsgMap["LSHSHT_MSG_CHK_INT_100"]);
		return "";
	} else if (isInt0to100( num )) {
		return num;
	} else {
		return "";
	}
}

function refreshRequiredState( flowptn ) {
	var mainActors = flowPtnList[flowptn].mainActors;
	$('#actorlist tr[data-idx]').each(function(){
		$(this).removeClass('required');
		var compare = $.inArray($(this).data('actorcd'), mainActors);
		if (compare !== -1) {
			$(this).addClass('required');
		}
	});
}

function refreshChgBtnState( loginId ) {
	// Login user == actor : hide
	$('#actorlist tr[data-actorguid="'+loginId+'"]').find('.btn_chg').hide();
	$('#actorlist tr[data-actorguid="'+loginId+'"]').find('.btn_del').hide();
	// Owner == actor : hide
	$('#actorlist tr[data-actorcd="act-owner"]').find('.btn_chg').hide();
	$('#actorlist tr[data-actorcd="act-owner"]').find('.btn_chg').hide();
}
