var dg = Debug("common.js");

/* axios
=============================================== */
// axios - disable cache
axios.interceptors.request.use(function(config) {
  if (typeof config.params === "undefined") {
    config.params = {};
  }
  if (typeof config.params === "object") {
    if (
      typeof URLSearchParams === "function" &&
      config.params instanceof URLSearchParams
    ) {
      config.params.append("_", Date.now());
    } else {
      config.params._ = Date.now();
    }
  }
  return config;
});

// axios - update PopAlertTimeout
axios.interceptors.response.use(function(response) {
  window.resetPopAlertAt();
  return response;
});

/* Unavailable Window Auto Close
=============================================== */
function checkWindowKey() {
	__cookieKey = getCookieValue( 'WindowKey' );
	if (__serverKey == 'null') {
		// 'null' means Timeout. waiting for another window.
		__serverKey = __cookieKey;
	}
	if (__serverKey != __cookieKey) {
		// IE Only
		close_win();
		// For Chrome
		$('#lyca').addClass("CLOSED");
	}
}

function getCookieValue( keyname ) {
	var st = "";
	var ed = "";
	if (document.cookie.length > 0) {
		st = document.cookie.indexOf( keyname + "=" );
		if (st != -1) {
			st = st+keyname.length + 1;
			ed = document.cookie.indexOf( ";", st );
			if (ed == -1) ed = document.cookie.length;
			return document.cookie.substring( st, ed );
		}
	}
	return "";
}

function close_win() {
	var nvua = navigator.userAgent;
	if (nvua.indexOf( 'MSIE' ) >= 0) {
		(window.open( '', '_top' ).opener=top).close();
	}
	else if (nvua.indexOf( 'Gecko' ) >= 0) {
		top.name = 'CLOSE_WINDOW';
		wid = window.open( '', 'CLOSE_WINDOW' );
		top.close();
	}
}

/* Disable Inputs for multiple submits
=============================================== */
var __DISABLED = false;
function disableAllInputs() {
	__DISABLED = true;
	$('input, button, select, option, textarea, a').prop('disabled', true);
	showBlockingOverlay();
}

/* Popup alert before session timeout
=============================================== */
var __TIMEOUT_SEC;
var __TIMEOUT_AT;
var __POPALERT_AT;
var __ALREADY_TIMEOUT;
var __NEEDS_ALERT;
function setPopAlertAt( sessionTimeoutSec ) {
	var currentAt  = new Date();
	var timeoutSec = Number( sessionTimeoutSec );
	__TIMEOUT_SEC  = sessionTimeoutSec;
	__TIMEOUT_AT   = new Date(   currentAt.getTime() + (timeoutSec * 1000) );
	__POPALERT_AT  = new Date( __TIMEOUT_AT.getTime() - (10 * 60 * 1000) ); // 10 min before
	__NEEDS_ALERT  = !(__serverKey == 'null');
}

function resetPopAlertAt() {
	setPopAlertAt( __TIMEOUT_SEC );
	dg("__TIMEOUT_AT", __TIMEOUT_AT);
}

function popAlertTimeout() {
	// If you want to show this alert immediately, run `__POPALERT_AT = new Date();`
	var currentAt  = new Date();
	var goAlert    = __POPALERT_AT.getTime() < currentAt.getTime();
	var yetAlert   = $('#popAlertTimeout').length == 0;
	if (goAlert && yetAlert && __NEEDS_ALERT) {
		var jikoku = __TIMEOUT_AT.getHours() + ':' + ('00'+__TIMEOUT_AT.getMinutes()).slice(-2);
		var popHtml = '';
		popHtml += '<div id="popAlertTimeout">';
		popHtml += '  <h3><i class="fa fa-exclamation-triangle"></i>'+App.LabelMap["FW_MSG_TIMEOUT_POPALERT"]+'（'+jikoku+'）</h3>';
		popHtml += '  <p>'+App.LabelMap["FW_MSG_TIMEOUT_POPALERT_DESC"]+'</p>';
		popHtml += '</div>';
		$('body').append( popHtml );
		$('#popAlertTimeout').fadeIn(3000);
	}
	__ALREADY_TIMEOUT = __TIMEOUT_AT.getTime() < currentAt.getTime();
}

function chkTimeout() {
	if (__ALREADY_TIMEOUT) {
		alert( App.LabelMap["FW_MSG_TIMEOUT"] );
		return false;
	} else {
		return true;
	}
}

/* Header Buttons
=============================================== */
function logoutButtonClicked() {
	if (!chkTimeout()) { return false; }
	
	if (confirm(App.LabelMap["FW_MSG_LOGOUT_CFM"])) {
		top.location.href = App.root + "/servlet/LogoutServlet";
	} else {
		return false;
	}
}

function openHelpWindow(url) {
	window.open(url,'subwin_help','scrollbars=yes, resizable=yes, width=900, height=600, top=50, left=50, location=no, menubar=no, status=no');
}

/* Sub Window
=============================================== */
var __CHILDWINDOWS = new Array();
var __JUST_WAIT = false;
function openSubWindow(path, state, target, w, h, autoClose) {
	if (__DISABLED) { return false; }
	if (__JUST_WAIT) { return false; }
	__JUST_WAIT = true;
	window.setTimeout(function(){ __JUST_WAIT = false; }, 2000);
	if (typeof w === "undefined") { w = 820; }
	if (typeof h === "undefined") { h = 600; }
	var arg = 'toolbar=no, menubar=no, status=no, scrollbars=yes, resizable=yes, width=' + w + ', height=' + h + ', top=0, left=0';
	target = target.replace(/-/g, '');
	var win = window.open( '', target, arg );
	if (typeof autoClose === "undefined" || autoClose) {
		__CHILDWINDOWS.push( win );
	}
	document.F001.method = 'post';
	document.F001.target = target;
	document.F001.action = App.root + path;
	document.F001.state.value = state;
	document.F001.windowMode.value = 'SubWindow';
	document.F001.submit();
	document.F001.windowMode.value = null; // for Parent Trans
}

/* Tab
=============================================== */
function tabActivate( tabid ) {
	$('.tab li').removeClass('active');
	$('#' + tabid).addClass('active');
}

/* Common Function - Page Transition
=============================================== */
__INPUT_CHANGED = false;
__IS_BASIC_CHK = true;
function pageSubmit(path, state) {
	if (!keyEventCheck()) { return false; }
	if (!chkTimeout()) { return false; }
	if (__DISABLED) { return false; }
	if (__INPUT_CHANGED) {
		var ans = confirm(App.LabelMap["FW_MSG_DISMISS_CFM"]);
		if (!ans) { return false; }
	}
	if (__IS_BASIC_CHK && !_.isEmpty(state) && !state.match(/^(INIT|RESTORE)$/)) {
		if (!basicInputCheck()) { return false; }
	}
	document.F001.action = App.root + path;
	document.F001.state.value = state;
	document.F001.target = "_self";
	document.F001.submit();
	disableAllInputs();
}

function pageGet(path, state) {
	if (!keyEventCheck()) { return false; }
	if (!chkTimeout()) { return false; }
	if (__DISABLED) { return false; }
	if (__INPUT_CHANGED) {
		var ans = confirm(App.LabelMap["FW_MSG_DISMISS_CFM"]);
		if (!ans) { return false; }
	}
	if (__IS_BASIC_CHK && !_.isEmpty(state) && !state.match(/^(INIT|RESTORE)$/)) {
		if (!basicInputCheck()) { return false; }
	}
	window.location = App.root + path;
	disableAllInputs();
}

function pageTrans(path, params, isDownload) {
	if (!keyEventCheck()) { return false; }
	if (!chkTimeout()) { return false; }
	if (__DISABLED) { return false; }
	if (__INPUT_CHANGED) {
		var ans = confirm(App.LabelMap["FW_MSG_DISMISS_CFM"]);
		if (!ans) { return false; }
	}
	// Required: "url-search-params-polyfill"
	var urlsp = new URLSearchParams(params);
	var suffix = urlsp ? "?" + urlsp.toString() : "";
	window.location = App.root + path + suffix;
	if (!isDownload) {
		disableAllInputs();
	}
}

function keyEventCheck() {
	if (window.event && window.event.shiftKey) {
		alert(App.LabelMap["FW_MSG_SHIFTKEY_NG"]);
		return false;
	}
	return true;
}

function basicInputCheck() {
	var ngList = new Array();
	$('textarea, input').each(function(){
		$(this).removeClass('chkNG');
		var tagName = $(this)[0].tagName;
		if (tagName == 'TEXTAREA') {
			var len = $(this).val().replace( /\n/g, ' ' ).length;
			if (len > 1000) {
				ngList.push( $(this) );
			}
		}
		else if (tagName == 'INPUT') {
			var len = $(this).val().replace( /\n/g, ' ' ).length;
			if (len > 100) {
				ngList.push( $(this) );
			}
		}
	});
	if (ngList.length > 0) {
		for (var i=0; i<ngList.length; i++) {
			ngList[i].addClass('chkNG');
		}
		alert(App.LabelMap["FW_MSG_TEXT_LEN_LIMIT"]);
		return false;
	}
	return true;
}

/* Common Function - File Download
=============================================== */
function downloadJvPdfFile(state) {
	if (!chkTimeout()) { return false; }
	document.F001.action = App.root + "/servlet/JvProfilePdfServlet";
	document.F001.state.value = state;
	document.F001.target = "_self";
	document.F001.submit();
	showBlockingOverlay();
}

function downloadCsvFile(state) {
	if (!chkTimeout()) { return false; }
	document.F001.action = App.root + "/servlet/CsvDownloadServlet";
	document.F001.state.value = state;
	document.F001.target = "_self";
	document.F001.submit();
	showBlockingOverlay();
}

function downloadXlsxFile(templateId) {
	if (!chkTimeout()) { return false; }
	document.F001.action = App.root + "/servlet/SheetDownloadServlet";
	document.F001.state.value = templateId;
	document.F001.target = "_self";
	document.F001.submit();
	showBlockingOverlay();
}
function downloadXlsxFileWithSqlProp(sqlPropKey) {
	if (!chkTimeout()) { return false; }
	document.F001.action = App.root + "/servlet/ExcelDownloadServlet";
	document.F001.state.value = "SQLPROP";
	makeRequestParameter( "sqlPropKey", sqlPropKey );
	document.F001.target = "_self";
	document.F001.submit();
	showBlockingOverlay();
}

function showBlockingOverlay() {
	if ($('.blockingOverlay').length === 0) {
		$('body').append('<div class="blockingOverlay"><div class="loadingIcon"><i class="fa fa-spinner fa-spin"></i></div></div>');
	}
	$('.blockingOverlay').show();
	setTimeout( function(){ $('.blockingOverlay').css('cursor','pointer'); }, 2000 );
	$(document).on('click', '.blockingOverlay', function(){
		setTimeout( function(){
			$('.blockingOverlay').remove();
			__DISABLED = false;
		}, 2000 );
	});
}

/* リクエストパラメータ生成
=============================================== */
function makeRequestParameter( name, value ) {
	var size = $('form[name="F001"] input[name="'+name+'"]').length;
	if (size == 0) {
		var input = document.createElement( "input" );
		input.setAttribute( "type", "hidden" );
		input.setAttribute( "name", name );
		input.setAttribute( "value", value );
		document.F001.appendChild( input );
	} else {
		// Update
		$('form[name="F001"] input[name="'+name+'"]').val( value );
	}
}

function addRequestParameter( name, value ) {
	var input = document.createElement( "input" );
	input.setAttribute( "type", "hidden" );
	input.setAttribute( "name", name );
	input.setAttribute( "value", value );
	document.F001.appendChild( input );
}

/* 半角カタカナ
=============================================== */
function optimizeHalfKana( str ) {
	try {
		var z = ['ｶﾞ', 'ｷﾞ', 'ｸﾞ', 'ｹﾞ', 'ｺﾞ', 'ｻﾞ', 'ｼﾞ', 'ｽﾞ', 'ｾ', 'ｿﾞ', 'ﾀﾞ', 'ﾁﾞ', 'ﾂﾞ', 'ﾃﾞ', 'ﾄﾞ', 'ﾊﾞ', 'ﾋﾞ', 'ﾌﾞ', 'ﾍﾞ', 'ﾎﾞ', 'ﾊﾟ', 'ﾋﾟ', 'ﾌﾟ', 'ﾍﾟ', 'ﾎﾟ', 'ｳﾞ', 'ｧ', 'ｱ', 'ｨ', 'ｲ', 'ｩ', 'ｳ', 'ｪ', 'ｴ', 'ｫ', 'ｵ', 'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ', 'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ', 'ﾀ', 'ﾁ', 'ｯ', 'ﾂ', 'ﾃ', 'ﾄ', 'ﾅ', 'ﾆ', 'ﾇ', 'ﾈ', 'ﾉ', 'ﾊ', 'ﾋ', 'ﾌ', 'ﾍ', 'ﾎ', 'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ', 'ｬ', 'ﾔ', 'ｭ', 'ﾕ', 'ｮ', 'ﾖ', 'ﾗ', 'ﾘ', 'ﾙ', 'ﾚ', 'ﾛ', 'ﾜ', 'ｦ', 'ﾝ'];
		var h = ['ガ', 'ギ', 'グ', 'ゲ', 'ゴ', 'ザ', 'ジ', 'ズ', 'セ', 'ゾ', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド', 'バ', 'ビ', 'ブ', 'ベ', 'ボ', 'パ', 'ピ', 'プ', 'ペ', 'ポ', 'ヴ', 'ァ', 'ア', 'ィ', 'イ', 'ゥ', 'ウ', 'ェ', 'エ', 'ォ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ', 'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ッ', 'ツ', 'テ', 'ト', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'マ', 'ミ', 'ム', 'メ', 'モ', 'ャ', 'ヤ', 'ュ', 'ユ', 'ョ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヲ', 'ン'];
		for (i = 0; i <= h.length; i++) {
			str = str.split( h[i] ).join( z[i] );
		}
		if (str.match( /^[ｧ-ﾝﾞﾟ ]*$/ )) {
			return str;
		}
	} catch(e) {
	}
	return "";
}

/* Underscore.js Template Engine Rendering
=============================================== */
function usTemplateRender(fromSelector, toSelector, dataSet) {
	_.templateSettings = {
	  evaluate    : /\{\{(.+?)\}\}/g,
	  interpolate : /\{\{=(.+?)\}\}/g,
	  escape      : /\{\{-(.+?)\}\}/g
	};
	try {
		var compiled = _.template( $(fromSelector).html() );
		$(toSelector).replaceWith( compiled(dataSet) );
	} catch(e) {
		console.warn( "Unable to compile the template." );
		console.error( e );
	}
}
