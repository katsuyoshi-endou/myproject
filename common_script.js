$(function() {
  var $document = $(document);

  /* Excelダウンロードボタン */
  var xlBtnid = _data.sheet.layoutCd;
  if (xlBtnid === "lay-cpln-v1") {
    $(".xlDownload").attr("id", "CPLN");
  } else if (xlBtnid === "lay-jksk-v1") {
    $(".xlDownload").attr("id", "JKSK");
  } else {
    $(".xlDownload").remove();
  }

  /* 編集ボタン */
  $("button.cspe").each(function() {
    var chkfilid = "Fill--" + $(this).attr("data-cspe") + "_edit";
    if ($.inArray(chkfilid, writeFillList) === -1) {
      $(this).remove();
    }
  });

  // SB 用(編集画面タブ切換え)
  var tabpages = $(".tabpage");
  tabpages.hide();
  // 編集画面ではtab01が初期値として設定とする。
  var tabId = "tab01";
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
        .attr("id"); // tab01
    var nextId =
      "#" +
      $(this)
        .parent()
        .attr("id"); // tab01
    $(nextCls).show();
    $(nextId).addClass("active");
  });
});

// error message
function errMsg(msgID) {
  var labels = _data.label;
  var msgs = {
    // "MkhyMokErrorMsg" : labels["MkhyMokErrorMsg"],
    // "MkhyWeiErrorMsg" : labels["MkhyWeiErrorMsg"],
  };
  return msgs[msgID];
}

function customPartialEditCheck(cspe, cspearg) {
  return true;
}

function customForwardCheck() {
  try {
    if (_data.sheet.layoutCd === "lay-jksk-tsu-v1") {
      if (needsCheck("Fill--chk_jksk_fwrd")) {
        if (!checkJkskSheet()) {
          return false;
        }
      }
    }
  } catch (e) {
    alert(e);
    return false;
  }
  return true;
}

function customPartialEditCheck(cspe, cspearg) {
  /* 保存時必須チェック */
  $(".sheet-section .chkNG").removeClass("chkNG");
  var result = true;
  if (cspe === "skill_gyomukbn") {
    result = checkSkillGyomukbn();
  }
  if (cspe === "skill_zokusei") {
    result = checkSkillZokusei();
  }
  if (cspe === "skill_check") {
    result = checkSkillCheck();
  }
  if (cspe === "gymkn_gyomukbn") {
    result = checkGyomuGyomuKbn();
  }
  if (cspe === "jksk") {
    result = checkJksk();
  }
  return result;
}


