$(function() {
  var $document = $(document);

  // SB日付
  $(".datepicker-months").datepicker({
    language: "ja",
    startView: 1,
    minViewMode: 1,
    format: "yyyy/mm",
    autoclose: true,
    toggleActive: true,
  });

  $(".datepicker-date").datepicker({
    language: "ja",
    startView: 1,
    minViewMode: 1,
    format: "yyyy/mm/dd",
    autoclose: true,
    toggleActive: true,
  });

  // 「未申請」のとき、「過去業務へ移動」と「回答内容クリア」ボタンを表示
  if (_data.sheet.statusCd === "00-New") {
    var elem = $("div.GeGyomuBtnGrp");
    if (elem !== undefined) {
      elem.show();
    }
  }

  // 「過去業務へ移動」ボタン押下
  $document.on("click", "#btn_AnsMove", function() {
    if (window.confirm("現在の業務内容を過去の業務内容に移動します。よろしいですか。")) {
      return false;
    }
    moveCurrentWorkContents();
  });

  // 「回答内容クリア」ボタン押下
  $document.on("click", "#btn_AnsClr", function() {
    window.confirm("回答内容をクリアします。");
  });
});

/**
 * 自己申告シートの申請時チェック処理
 *
 */
function checkJkskSheet() {
  // 必須チェック
  if (!checkJkskRequired()) {
    alert("必須項目が未入力です。");
    return false;
  }

  // 関連する項目の必須チェック
  if (!checkRequireRelatedItems()) {
    alert("「その他」を選択した場合、該当設問に回答してください。");
    return false;
  }

  if (!checkRequiredByJkskAnswer()) {
    return false;
  }

  return true;
}

/**
 * 未入力チェック
 */
function checkJkskRequired() {
  var bErr = false;

  $(".required").each(function(i, elem) {
    if (elem.text() === "") {
      elem.addClass("chkNG");
      bErr = true;
    }
  });
  return !bErr;
}

/**
 * 関連する項目の必須チェック
 */
function checkRequireRelatedItems() {
  var bErr = false;

  // 保有スキル・免許・資格
  $(".srcNullChk").each(function(i, elem) {
    if (elem.text() === "その他") {
      var tgtElem = elem.closest("tr").children(".tgtNullChk");
      if (tgtElem !== undefined) {
        if (tgtElem.text() === "") {
          tgtElem.addClass("chkNG");
          bErr = true;
        }
      }
    }
  });

  var elem1;
  var elem2;
  var idx;

  // ビジネス経験（言語1-3）
  for (var j = 1; J <= 3; j++) {
    idx = ("0" + j).slice(-2);

    elem1 = $("[name='jksk_glo_busi_lang_" + idx + "_nm']");
    elem2 = $("[name='jksk_glo_busi_lang_" + idx + "_nm_other']");

    if (checkRelatedRequire(elem1, elem2, "その他", "")) {
      elem2.addClass("chkNG");
      bErr = true;
    }
  }

  // 就学・留学経験（経験内容1-3）
  for (var k = 1; k <= 3; k++) {
    idx = ("0" + k).slice(-2);

    elem1 = $("[name='jksk_glo_ryu_exp_" + idx + "_naiyo']");
    elem2 = $("[name='jksk_glo_ryu_exp_" + idx + "_naiyo_other']");

    if (checkRelatedRequire(elem1, elem2, "その他", "")) {
      elem2.addClass("chkNG");
      bErr = true;
    }
  }
  return !bErr;
}

/**
 * 回答項目によって必須となるチェック（自己申告シート）
 */
function checkRequiredByJkskAnswer() {
  var elem1;
  var elem2;

  // その他 -希望勤務地-
  for (var k = 1; k <= 3; k++) {
    idx = ("0" + k).slice(-2);

    elem1 = $(".srcKinNullChk" + idx);
    elem2 = $(".tgtKinNullChk" + idx);

    if (checkRelatedRequire(elem1, elem2, "海外", "")) {
      elem2.addClass("chkNG");
      bErr = true;
    }
  }

  // 今後のキャリア
  elem1 = $(".srcCarQANullChk");
  elem2 = $(".tgtCarQANullChk");

  if (
    checkRelatedRequire(elem1, elem2, "直ちに新しい業務に調整してみたい", "") ||
    checkRelatedRequire(elem1, elem2, "1年以内に新しい業務に挑戦したい", "")
  ) {
    elem2.addClass("chkNG");
    bErr = false;
  }

  // プログラミング関連の受賞歴
  elem1 = $(".srcPrgAwrdNullChk");
  elem2 = $(".tgtPrgAwrdNullChk");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("chkNG");
    bErr = false;
  }

  // OSS公開歴
  elem1 = $(".srcOssRlsNullChk");
  elem2 = $(".tgtOssRlsNullChk");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("chkNG");
    bErr = false;
  }
  return true;
}

/**
 * 回答項目によって必須となるチェック（海外・外国語利用経験シート）
 */
function checkRequiredByGlobalSheet() {
  var bErr = false;
  var elem;

  // ビジネス経験（日本語以外・日本以外）就学・留学経験の各欄にて「ある」が選択されたときの未入力チェック

  // ビジネス経験（言語）
  if (_data.fill.jksk_glo_busi_lang_ques_01 === "ある") {
    elem = $("[name='jksk_glo_busi_lang_01_nm_other']");
    if (elem !== undefined && elem.text() === "") {
      elem.addClass("chkNG");
      bErr = true;
    }

    elem = $("[name='jksk_glo_busi_lang_01_naiyo']");
    if (elem !== undefined && elem.text() === "") {
      elem.addClass("chkNG");
      bErr = true;
    }
  }

  // ビジネス経験（日本以外の国）
  if (_data.fill.jksk_glo_busi_exp_ques_01 === "ある") {

  }

  return !bErr;
}

function checkSonotaKomoku() {
  var errFlg = false;

  // 「保有スキル・免許・資格」欄の「その他」選択時、未入力チェック
  if (_data.fill.jksk_skill_lang_02_nm === "その他") {
    if (_data.fill.jksk_skill_lang_02_nm_other === "") {
      errFlg = true;
    }
  }
}

/**
 * elem1の要素の値が、value1であるとき、elem2の要素の値がvalue2であるかをチェックする
 */
function checkRelatedRequire(elem1, elem2, value1, value2) {
  if (elem1 === undefined || elem2 === undefined) {
    return true;
  }

  if (elem1.val() === value1 && elem2.val() === value2) {
    return true;
  }
  return false;
}

/**
 * ２つの年月の差分を求めて、「〇年△ヶ月」の形式で返す
 *
 * @param {*} from 開始年月
 * @param {*} to 終了年月
 */
function autoCalcKikan(from, to) {
  var ret = "";

  var fromDate = from.split("/");
  var toDate = to.split("/");

  var fromYear = parseInt(fromDate[0], 10);
  var fromMonth = parseInt(fromDate[1], 10);

  var toYear = parseInt(toDate[0], 10);
  var toMonth = parseInt(toDate[1], 10);

  var kikYear = parseInt(toYear - fromYear, 10);
  var kikMonth = 0;

  // ex.2019/06 - 2019/04
  if (kikYear === 0 && toMonth < fromMonth) {
    ret = "";
  } else if (kikYear === 0 && toMonth >= fromMonth) {
    // ex.2019/01 - 2019/04
    kikMonth = toMonth - fromMonth;
  } else if (kikYear > 0 && toMonth >= fromMonth) {
    // ex.2018/01 - 2019/04
    kikMonth = toMonth - fromMonth;
  } else if (kikYear > 0 && toMonth < fromMonth) {
    // ex.2019/10 - 2020/04
    kikYear -= 1;
    kikMonth = toMonth + 12 - fromMonth;
  } else {
    kikYear = 0;
    kikMonth = 0;
  }

  // 計算結果を"○年○ヶ月"の形式に
  if (kikYear === 0 && kikMonth > 0) {
    ret = "0年" + kikMonth.toFixed() + "ヶ月";
  } else if (kikYear > 0 && kikMonth === 0) {
    ret = kikYear.toFixed() + "年";
  } else {
    ret = kikYear.toFixed() + "年" + kikMonth.toFixed() + "ヶ月";
  }
  return ret;
}

function getSheetNendo(operCd) {
  if (operCd === "") {
    return "";
  }

  return operCd.slice(0, 4);
}
