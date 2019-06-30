/* eslint-disable vars-on-top */
$(function() {
  var $document = $(document);

  // SB 用(編集画面タブ切換え)
  var tabpages = $(".tabpage");
  tabpages.hide();
  var tabId = "tab01";

  // 編集画面ではtab01が初期値として設定とする。
  $("#" + tabId).addClass("active");
  $(".tabpage." + tabId)
    .addClass("active")
    .show();

  // SB 用(編集画面タブ切換え)
  $document.on("click", ".cstab ul li a", function(event) {
    event.preventDefault();
    tabpages.hide();
    $(".cstab ul li").removeClass("active");
    var nextCls =
      "." +
      $(this)
        .parent()
        .attr("id");
    var nextId =
      "#" +
      $(this)
        .parent()
        .attr("id");
    $(nextCls).show();
    $(nextId).addClass("active");
  });
});

/**
 * 
 */
function checkJkskRequired() {
  var bErr = false;

  $( ".required" ).each( function( i, elem ) {
    if ( elem.text() === "" ) {
      bErr = true;
    }
  });

  if ( bErr ) {
    alert( "必須項目が未入力です。" );
  }

  return !bErr;
}

function checkJkskSkill() {
  var elem1 = $( "input[name='jksk_skill_lang_02_nm']" );
  var elem2 = $( "input[name='jksk_skill_lang_02_nm_other']" );

  if ( !checkRelatedOthersRequire( elem1, elem2, "その他" )) {
    alert( "「その他」を選択した場合、該当設問に回答してください。" );
    return false;
  }
  return true;
}

/**
 * elem1の要素の値が、valueであるとき、elem2の要素の値が未入力であるかをチェックする
 */
function checkRelatedOthersRequire( elem1, elem2, value ) {
  if ( elem1 === undefined || elem2 === undefined ) {
    return true;
  }

  if ( elem1.val() === value && elem2.val() === "" ) {
    return false;
  }
  return true;
}

