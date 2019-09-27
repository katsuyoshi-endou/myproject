
jQuery.fn.exists = function(){return Boolean(this.length > 0);}

$(function(){
	
	 /**
	 ** Common Initialize
	**/
	
	// テーブル奇数行 背景色
	$("table.stripe tr:nth-child(odd)").addClass("gray");
	
	// 空白時は隠す（ガイダンスなど）
	$('.hideWhenBlank').each(function(){
		if ($(this).text().replace(/(^\s+)|(\s+$)/g, "") != '') { $(this).show(); }
	});
	
	// ヘッダボタンを右上にセット
	var hBtns = $('div.headerButtons button');
	$('#headerBtnArea').prepend( hBtns );
	
	// Navbar
	$('.navbar-body').prepend( $('.navbarBtns>div') );
	if ( $('.navbarBtns.navbar-not-use').exists() ) {
		$('#navbar').hide();
	}
	// Navbar(Fixed)
	$('body').prepend( '<div id="navbar-fixed"></div>' );
	$('#navbar-fixed').prepend( $('.navbar-body').clone() );
	var $nav = $('#navbar-fixed');
	$(window).scroll(function() {
		if($(window).scrollTop() > 140) {
			$nav.addClass('fixed');
		} else {
			$nav.removeClass('fixed');
		}
	});
	
	 /**
	 ** Common Event
	**/
	
	// ホームに戻るリンク
	$(document).on('click', '.backToHome, .do-back-home', function(ev){
		ev.preventDefault();
		pageGet( '/servlet/HomeServlet', "" );
	});
	// ロゴクリック → メニュー
	$('#appLogo').hover(
		function(){ $(this).css('cursor', 'pointer'); },
		function(){ $(this).css('cursor', 'inherit'); }
	);
	// 子画面自動クローズ
	$(window).on("unload", function(){
		for(var i=0; i<__CHILDWINDOWS.length; i++) {
			__CHILDWINDOWS[i].close();
		}
	});
	// ログアウト
	$(document).on('click', '#logout', function(ev){
		ev.preventDefault();
		logoutButtonClicked();
	});
	// リザルトメッセージの閉じるボタン
	$(document).on('mouseover', '#msgArea ul, #msgArea .closeMsg', function(){
		$(this).on('click', function(){ $(this).parent().hide(); });
	});
	
	
	// Tooltips
	$('[data-toggle="tooltip"]').tooltip({ html:true, placement:'auto top' });
	
	// 検索条件にタグ入力で自動削除
	$(document).on('change', '.searchCondTable input', function(){
		var str = $(this).val();
		str = str.replace( /<(\/?[a-zA-Z]*?)?>/g, '' );
		$(this).val( str );
	});
});
