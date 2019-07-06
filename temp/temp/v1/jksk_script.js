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
    //    startView: 1,
    //    minViewMode: 1,
    format: "yyyy/mm/dd",
    autoclose: true,
    toggleActive: true,
  });

  // 上長所見欄の表示・非表示
  if (needsCheck("jksk_bos_mendan")) {
    $("div#bossShokenArea").show();
  }

  // 「未申請」のとき、「過去業務へ移動」と「回答内容クリア」ボタンを表示
  if (_data.sheet.statusCd === "00-New") {
    var elem = $("div.GeGyomuBtnGrp");
    if (elem !== undefined) {
      elem.show();
    }
  }

  // 「過去業務へ移動」ボタン押下
  $document.on("click", "#btn_AnsMove", function() {
    if (!window.confirm(confMsg("JkskMoveGyomConfMsg"))) {
      return false;
    }

    // 過去業務欄への移動
    moveCurrentWorkContents();

    return true;
  });

  // 「回答内容クリア」ボタン押下
  $document.on("click", "#btn_AnsClr", function() {
    if (!window.confirm(confMsg("JkskClearCurGyomuConfMsg"))) {
      return false;
    }

    clearGenzaiKaitoNaiyo();

    return true;
  });

  // 現在の業務内容の勤務期間の半角数字チェック
  $document.on("blur", "#jksk_ge_kin_kikan", function() {
    var val = $(this).val();

    if (!checkHalfwidthNumbers(val)) {
      alert(errMsg("JkskHalfWidthNumberErrMsg"));
      $(this).val("");
      return false;
    }
    return true;
  });

  // 保有スキル・免許・資格欄の言語レベル表示・非表示
  $document.on("change", "#jksk_skill_lang_02_nm, #jksk_skill_lang_03_nm", function() {
    ctrlLanguageLavelTableRows($(this));
  });

  // プログラミングスキル欄の自動展開
  $document.on("change", "#jksk_skill_prog_ques_01", function() {
    ctrlProgLevelTableRows($(this));
  });

  // 全件ON/OFFボタンでの表示・非表示切り替え
  $document.on("click", "#btn_skill_onoff", function() {
    ctrlJinjiNaviShikakuTableRows($(this), "toggle");
  });

  // 現在の業務内容の従事期間の自動計算
  $("#jksk_ge_kai").on("changeDate", function(e) {
    var date = new Date($(this).datepicker("getDate"));

    var from = date.getFullYear() + "/" + ("0" + (date.getMonth() + 1)).slice(-2);

    var kikan = calcPeriod(from, $("#jksk_ge_shu").text());

    $("#jksk_ge_jyu").text(kikan);
  });

  // 過去の業務内容1-5の従事期間の自動計算（開始項目の変更イベント）
  $("#jksk_ka_01_kai, #jksk_ka_02_kai, #jksk_ka_03_kai, #jksk_ka_04_kai, #jksk_ka_05_kai").on("changeDate", function(e) {
    var $from = $(this);
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "jyu");

    var $to = $("#" + toName);
    var $target = $("#" + tgtName);

    var kikan = calcPeriod($from.val(), $to.val());

    $target.text(kikan);
  });

  // 過去の業務内容1-5の従事期間の自動計算（終了項目の変更イベント）
  $("#jksk_ka_01_shu, #jksk_ka_02_shu, #jksk_ka_03_shu, #jksk_ka_04_shu, #jksk_ka_05_shu").on("changeDate", function(e) {
    var $to = $(this);
    var fromName = $(this).attr("id").replace("shu", "kai");
    var tgtName = $(this).attr("id").replace("shu", "jyu");

    var $from = $("#" + fromName);
    var $target = $("#" + tgtName);

    var kikan = calcPeriod($from.val(), $to.val());

    $target.text(kikan);
  });

  // 海外・外国語利用経験欄の期間自動計算（開始項目の変更イベント）
  $("#jksk_glo_busi_exp_01_kai, #jksk_glo_busi_exp_02_kai, #jksk_glo_busi_exp_03_kai, jksk_glo_ryu_exp_01_kai, jksk_glo_ryu_exp_02_kai, jksk_glo_ryu_exp_03_kai").on("changeDate", function(e) {
    var $from = $(this);
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "jyu");

    var $to = $("#" + toName);
    var $target = $("#" + tgtName);

    var kikan = calcPeriod($from.val(), $to.val());

    $target.text(kikan);
  });

  // 海外・外国語利用経験欄の期間自動計算（開始項目の終了イベント）
  $("#jksk_glo_busi_exp_01_shu, #jksk_glo_busi_exp_02_shu, #jksk_glo_busi_exp_03_shu, #jksk_glo_ryu_exp_01_shu, #jksk_glo_ryu_exp_02_shu, #jksk_glo_ryu_exp_03_shu").on("changeDate", function(e) {
    var $from = $(this);
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "jyu");

    var $to = $("#" + toName);
    var $target = $("#" + tgtName);

    var kikan = calcPeriod($from.val(), $to.val());

    $target.text(kikan);
  });

  // 日本語以外のビジネス経験の表示・非表示制御
  $document.on("change", "#jksk_glo_busi_lang_ans01", function() {
    ctrlGloBusiLangTableRows($(this));
  });

  // 日本以外のビジネス経験の表示・非表示制御
  $document.on("change", "#jksk_glo_busi_exp_ans01", function() {
    ctrlGloBusiExpTableRows($(this));
  });

  // 就学・留学経験の表示・非表示制御
  $document.on("change", "#jksk_glo_ryu_exp_ans01", function() {
    ctrlGloRyuExpTableRows($(this));
  });

  // 初期化処理
  initialJkskSheet();
});

function errMsg(msgID) {
  var labels = _data.label;
  var msgs = {
    JkskHalfWidthNumberErrMsg: labels.JkskHalfWidthNumberErrMsg,
    JkskRequiredErrMsg: labels.JkskRequiredErrMsg,
    JkskSelOthersAnsErrMsg: labels.JkskSelOthersAnsErrMsg,
    JkskPastGyomuErrMsg: labels.JkskPastGyomuErrMsg,
    JkskNoCurentGyomuErrMsg: labels.JkskNoCurentGyomuErrMsg,
    JkskTargetQuesErMsg: labels.JkskTargetQuesErMsg,
    JkskMoveGyomConfMsg: labels.JkskMoveGyomConfMsg,
  };
  return msgs[msgID];
}

function confMsg(msgID) {
  var labels = _data.label;
  var msgs = {
    JkskMoveGyomConfMsg: labels.JkskMoveGyomConfMsg,
    JkskClearCurGyomuConfMsg: labels.JkskClearCurGyomuConfMsg,
    JkskGlobalExpConfMsg: labels.JkskGlobalExpConfMsg,
    JkskCurrentGyomuConfMsg: labels.JkskCurrentGyomuConfMsg,
  };
  return msgs[msgID];
}

function initialJkskSheet() {
  // 言語レベル（言語1-2）の表示・非表示
  ctrlLanguageLavelTableRows($("#jksk_skill_lang_02_nm"));
  ctrlLanguageLavelTableRows($("#jksk_skill_lang_03_nm"));

  // プログラミングレベル1-20の表示・非表示
  ctrlProgLevelTableRows($("#jksk_skill_prog_ques_01"));

  // 人事Navi登録済み資格6-10の表示・非表示
  ctrlJinjiNaviShikakuTableRows("#btn_skill_onoff", "init");

  // ビジネス経験（日本語以外）欄の表示・非表示
  ctrlGloBusiLangTableRows($("#jksk_glo_busi_lang_ans01"));

  // ビジネス経験（日本以外）欄の表示・非表示
  ctrlGloBusiExpTableRows($("#jksk_glo_busi_exp_ans01"));

  // 就学・留学経験欄の表示・非表示
  ctrlGloRyuExpTableRows($("#jksk_glo_ryu_exp_ans01"));
}

/**
 * 自己申告シートの申請時チェック処理
 *
 */
function checkJkskSheet() {
  $("td.chkNG").removeClass("chkNG");

  // 必須チェック
  if (!checkJkskRequired()) {
    alert(errMsg("JkskRequiredErrMsg"));
    return false;
  }

  if (_data.sheet.statusCd === "00-New") {
    // 関連する項目の必須チェック
    if (!checkRequireRelatedItems()) {
      alert(errMsg("JkskSelOthersAnsErrMsg"));
      return false;
    }

    // 回答内容によって必須となるチェック（自己申告）
    if (!checkRequiredByJkskAnswer()) {
      return false;
    }

    // 回答内容によって必須となるチェック（海外・外国語利用経験）
    if (!checkRequiredByGlobalSheet()) {
      return false;
    }

    // 過去の業務内容の入力チェック
    if (!checkRequiredPastGyomu()) {
      alert(errMsg("JkskPastGyomuErrMsg"));
      return false;
    }
  }

  if (_data.sheet.statusCd === "00-New") {
    msg = confMsg("JkskGlobalExpConfMsg");
  } else if (_data.sheet.statusCd === "01-Check1st") {
    msg = confMsg("JkskCurrentGyomuConfMsg");
  }
  if (!window.confirm(msg)) {
    return false;
  }

  return true;
}

/**
 * 未入力チェックを行う
 *   class="required"が付与されているタグに対して未入力チェックする
 *   ※1 : 「業務分類（職種/職種2/分類）」項目は、３項目がすべて選択されているか、未選択のどちらか
 *   ※2 : 「仕事の適性」項目は、少なくとも1つ選択されていることをチェックすることで未入力チェックとする
 */
function checkJkskRequired() {
  var bErr = false;

  // class="required"に対するチェック
  $(".required").each(function() {
    if ($(this).text() === "") {
      $(this).addClass("error");
      bErr = true;
    }
  });

  // 「仕事の適性」未入力チェック
  var tekisei1 = $("#jksk_gen_shigoto_05_01");
  var tekisei2 = $("#jksk_gen_shigoto_05_02");
  var tekisei3 = $("#jksk_gen_shigoto_05_03");

  if (tekisei1.text() === "" && tekisei2.text() === "" && tekisei3.text() === "") {
    tekisei1.addClass("error");
    tekisei2.addClass("error");
    tekisei3.addClass("error");

    bErr = true;
  }

  tekisei1 = $("#jksk_gen_shigoto_06_01");
  tekisei2 = $("#jksk_gen_shigoto_06_02");
  tekisei3 = $("#jksk_gen_shigoto_06_03");

  if (tekisei1.text() === "" && tekisei2.text() === "" && tekisei3.text() === "") {
    tekisei1.addClass("error");
    tekisei2.addClass("error");
    tekisei3.addClass("error");

    bErr = true;
  }

  return !bErr;
}

/**
 * 過去の業務内容1-4の未入力チェック
 */
function checkRequiredPastGyomu() {
  var bErr = false;

  for (var i = 1; i <= 4; i++) {
    var idx = ("0" + i).slice(-2);

    var shozoku = $("#jksk_ka_" + idx + "_shozoku");
    var kigyomei = $("#jksk_ka_" + idx + "_kigyomei");
    var shokushuA = $("#jksk_ka_" + idx + "_shokushu_A");
    var shokushuB = $("#jksk_ka_" + idx + "_shokushu_B");
    var shokushuC = $("#jksk_ka_" + idx + "_shokushu_C");
    var naiyo = $("#jksk_ka_" + idx + "_gyomunaiyo");
    var kaisi = $("#jksk_ka_" + idx + "_kai");
    var shuryo = $("#jksk_ka_" + idx + "_shu");
    var kikan = $("#jksk_ka_" + idx + "_jyu");

    if (shozoku.text() !== "" || kigyomei.text() !== "" || shokushuA.text() !=="" || naiyo.text() !== "" || kaisi.text() !== "" || shuryo.text() !== "" || kikan.text() !== "") {
      if (shozoku.text() === "") {
        shozoku.addClass("error");
        bErr = true;
      }
      if (kigyomei.text() === "") {
        kigyomei.addClass("error");
        bErr = true;
      }
      if (naiyo.text() === "") {
        naiyo.addClass("error");
        bErr = true;
      }
      if (kaisi.text() === "") {
        kaisi.addClass("error");
        bErr = true;
      }
      if (shuryo.text() === ""){
        shuryo.addClass("error");
        bErr = true;
      }
      if (kikan.text() === "") {
        kikan.addClass("error");
        bErr = true;
      }
      if (shokushuA.text() === "") {
        shokushuA.addClass("error");
        shokushuB.addClass("error");
        shokushuC.addClass("error");
        bErr = true;
      }
    }
  }
  return !bErr;
}

/**
 * 関連する項目の必須チェック
 */
function checkRequireRelatedItems() {
  var bErr = false;

  var elem1;
  var elem2;
  var idx;

  // 保有スキル・免許・資格
  for (var i = 2; i <= 3; i++) {
    idx = ("0" + i).slice(-2);

    elem1 = $("#jksk_skill_lang_" + idx + "_nm");
    elem2 = $("#jksk_skill_lang_" + idx + "_nm_other");

    // 言語が「その他」のとき、名称が入力されているか？
    if (checkRelatedRequire(elem1, elem2, "その他", "")) {
      elem2.addClass("error");
      bErr = true;
    }
  }

  // ビジネス経験（言語1-3）
  for (var j = 1; j <= 3; j++) {
    idx = ("0" + j).slice(-2);

    elem1 = $("#jksk_glo_busi_lang_" + idx + "_nm");
    elem2 = $("#jksk_glo_busi_lang_" + idx + "_nm_other");

    // 言語が「その他」のとき、名称が入力されているか？
    if (checkRelatedRequire(elem1, elem2, "その他", "")) {
      elem2.addClass("error");
      bErr = true;
    }
  }

  // 就学・留学経験（経験内容1-3）
  for (var k = 1; k <= 3; k++) {
    idx = ("0" + k).slice(-2);

    elem1 = $("#jksk_glo_ryu_exp_" + idx + "_naiyo");
    elem2 = $("#jksk_glo_ryu_exp_" + idx + "_naiyo_other");

    // 経験内容が「その他」のとき、その他記入欄が入力されているか？
    if (checkRelatedRequire(elem1, elem2, "その他", "")) {
      elem2.addClass("error");
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

    elem1 = $("#jksk_car_other_kinmu_" + idx);
    elem2 = $("#jksk_car_other_kinmu_kuni_" + idx);

    if (checkRelatedRequire(elem1, elem2, "海外", "")) {
      elem2.addClass("error");
      bErr = true;
    }
  }

  // 今後のキャリア
  elem1 = $("#jksk_car_now_ques_02");
  elem2 = $("#jksk_car_now_ques_05");

  if (
    checkRelatedRequire(elem1, elem2, "直ちに新しい業務に調整してみたい", "") ||
    checkRelatedRequire(elem1, elem2, "1年以内に新しい業務に挑戦したい", "")
  ) {
    elem2.addClass("error");
    bErr = false;
  }

  // プログラミング関連の受賞歴
  elem1 = $("#jksk_skill_prog_ques_02");
  elem2 = $("#jksk_skill_prog_ques_03");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("error");
    bErr = false;
  }

  // OSS公開歴
  elem1 = $("#jksk_skill_prog_ques_05");
  elem2 = $("#jksk_skill_prog_ques_06");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("error");
    bErr = false;
  }
  return true;
}

/**
 * 回答項目によって必須となるチェック（海外・外国語利用経験シート）
 */
function checkRequiredByGlobalSheet() {
  var bErr = false;

  // ビジネス経験（日本語以外・日本以外）就学・留学経験の各欄にて「ある」が選択されたときの未入力チェック

  // ビジネス経験（言語）
  var chkGloBusiLangArray = [
    "jksk_glo_busi_lang_01_nm",
    "jksk_glo_busi_lang_01_naiyo",
  ];
  if (_data.fill.jksk_glo_busi_lang_ques_01 === "ある") {
    chkGloBusiLangArray.forEach(function(fillId) {
      if (checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }

  // ビジネス経験（日本以外の国）
  var chkGloBusiExpArray = [
    "jksk_glo_busi_exp_01_chiiki",
    "jksk_glo_busi_exp_01_kuni",
    "jksk_glo_busi_exp_01_shubetsu",
    "jksk_glo_busi_exp_01_shokushu_A",
    "jksk_glo_busi_exp_01_shokushu_B",
    "jksk_glo_busi_exp_01_shokushu_C",
    "jksk_glo_busi_exp_01_naiyo",
    "jksk_glo_busi_exp_01_kai",
    "jksk_glo_busi_exp_01_shu",
    "jksk_glo_busi_exp_01_kik",
  ];

  if (_data.fill.jksk_glo_busi_exp_ques_01 === "ある") {
    chkGloBusiExpArray.forEach(function(fillId) {
      if (checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }

  // 就学・留学経験
  var chkGloRyuExpArray = [
    "jksk_glo_ryu_exp_01_chiiki",
    "jksk_glo_ryu_exp_01_kuni",
    "jksk_glo_ryu_exp_01_naiyo",
    "jksk_glo_ryu_exp_01_kai",
    "jksk_glo_ryu_exp_01_shu",
    "jksk_glo_ryu_exp_01_kik",
  ];

  if (_data.fill.jksk_glo_ryu_ques_01 === "ある") {
    chkGloRyuExpArray.forEach(function(fillId) {
      if (checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }
  return !bErr;
}

/**
 * 引数で指定された要素の未入力をチェックする
 *
 * @param {*} id
 *
 * TRUE  : OK
 * FALSE : NG
 */
function checkRequireById(id) {
  if (id === "") {
    return true;
  }

  var $elem = $("#" + id);
  if ($elem !== undefined) {
    var val;
    var tagName = $elem.tagName.toUpperCase();
    if (tagName.match(/INPUT|TEXTAREA|SELECT/)) {
      val = $elem.val();
    } else {
      val = $elem.text();
    }
    return val === "" ? false : true;
  }
  return true;
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

  var tag1 = elem1[0].tagName.toUpperCase();
  var tag2 = elem2[0].tagName.toUpperCase();

  var elem1Val;
  var elem2Val;
  if (tag1.match(/INPUT|TEXTAREA|SELECT/)) {
    elem1Val = elem1.val();
  } else {
    elem1Val = elem1.text();
  }

  if (tag2.match(/INPUT|TEXTAREA|SELECT/)) {
    elem2Val = elem2.val();
  } else {
    elem2Val = elem2.text();
  }

  if (elem1Val === value1 && elem2Val === value2) {
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
function calcPeriod(from, to) {
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

function moveCurrentWorkContents() {
  var copyIdArray = [
    "jksk_ge_shozoku",
    "jksk_ge_kigyomei",
    "jksk_ge_shokushu_A",
    "jksk_ge_shokushu_B",
    "jksk_ge_shokushu_C",
    "jksk_ge_gyomunaiyo",
    "jksk_ge_kai",
    "jksk_ge_shu",
    "jksk_ge_jyu",
  ];

  // 現在の業務内容が未入力でないか？
  var geShozoku = $("#jksk_ge_shozoku").val();
  var geKigyomei = $("#jksk_ge_kigyomei").val();
  var geGyoNaiyo = $("#jksk_ge_gyomunaiyo").val();
  var geKai = $("#jksk_ge_kai").val();
  var geShu = $("#jksk_ge_shu").text();
  var geJyu = $("#jksk_ge_jyu").text();
  var geBunruiA = $("#jksk_ge_shokushu_A").text();
  var geBunruiB = $("#jksk_ge_shokushu_A").text();
  var geBunruiC = $("#jksk_ge_shokushu_A").text();

  // いずれかが未入力ならば、移動させない
  if (geShozoku === "" || geKigyomei === "" || (geShozoku === "その他" && geKigyomei === "") || geGyoNaiyo === "" || geKai === "" || geBunruiA === "" ) {
    alert(errMsg("JkskNoCurentGyomuErrMsg"));
    return false;
  }

  // 内容を移動する（現在→過去1、過去1→過去2...）
  for (var i = 4; i >= 1; i--) {
    var from = ("0" + i).slice(-2);
    var to = ("0" + (i + 1)).slice(-2);

    $("#jksk_ka_" + to + "_shozoku").val($("#jksk_ka_" + from + "_shozoku").val());
    $("#jksk_ka_" + to + "_kigyomei").val($("#jksk_ka_" + from + "_kigyomei").val());
    $("#jksk_ka_" + to + "_shokushu_A").text($("#jksk_ka_" + from + "_shokushu_A").text());
    $("#jksk_ka_" + to + "_shokushu_B").text($("#jksk_ka_" + from + "_shokushu_B").text());
    $("#jksk_ka_" + to + "_shokushu_C").text($("#jksk_ka_" + from + "_shokushu_C").text());
    $("#jksk_ka_" + to + "_gyomunaiyo").val($("#jksk_ka_" + from + "_gyomunaiyo").val());
    $("#jksk_ka_" + to + "_kai").val($("#jksk_ka_" + from + "_kai").val());
    $("#jksk_ka_" + to + "_shu").val($("#jksk_ka_" + from + "_shu").val());
    $("#jksk_ka_" + to + "_jyu").val($("#jksk_ka_" + from + "_jyu").val());
  }

  // 現在の業務内容を過去1に移動＆クリア？
  $("#jksk_ka_01_shozoku").val(geShozoku);
  $("#jksk_ka_01_kigyomei").val(geKigyomei);
  $("#jksk_ka_01_shokushu_A").text(geBunruiA);
  $("#jksk_ka_01_shokushu_B").text(geBunruiB);
  $("#jksk_ka_01_shokushu_C").text(geBunruiC);
  $("#jksk_ka_01_gyomunaiyo").val(geGyoNaiyo);
  $("#jksk_ka_01_kai").val(geKai);
  $("#jksk_ka_01_shu").val(geShu);
  $("#jksk_ka_01_jyu").val(geJyu);

  return true;
}

function clearGenzaiKaitoNaiyo() {
  $("#jksk_ge_shozoku").val("");
  $("#jksk_ge_kigyomei").val("");
  $("#jksk_ge_shokushu_A").text("");
  $("#jksk_ge_shokushu_B").text("");
  $("#jksk_ge_shokushu_C").text("");
  $("#jksk_ge_gyomunaiyo").val("");
  $("#jksk_ge_kai").val("");
  $("#jksk_ge_jyu").text("");
  $("#jksk_chiiki").val("");
  $("#jksk_ge_kin_kikan").val("");

  return true;
}

function checkHalfwidthNumbers(numVal) {
  // 半角数字パターン
  var pattern = /^\d*$/;

  return pattern.test(numVal);
}

function ctrlLanguageLavelTableRows($this) {
  if ($this === undefined) {
    return true;
  }

  var idName = $this.attr("id");
  var val = $this.val();

  if (idName === "jksk_skill_lang_02_nm") {
    if (val === "") {
      $("tr.lang02AnsGrp").hide();
    } else {
      $("tr.lang02AnsGrp").show();
    }
  } else if (idName === "jksk_skill_lang_03_nm") {
    if (val === "") {
      $("tr.lang03AnsGrp").hide();
    } else {
      $("tr.lang03AnsGrp").show();
    }
  }
  return true;
}

function ctrlProgLevelTableRows($this) {
  if ($this === undefined) {
    return true;
  }

  if ($this.val() === "ある") {
    $("tr.prgLvlAnsGrp").show();
  } else {
    $("tr.prgLvlAnsGrp").hide();
  }
  return true;
}

function ctrlGloBusiLangTableRows($this) {
  if ($this === undefined) {
    return true;
  }

  if ($this.val() === "ある") {
    $("tr.gloBusiLangAnsGrp").show();
  } else {
    $("tr.gloBusiLangAnsGrp").hide();
  }
  return true;
}

function ctrlJinjiNaviShikakuTableRows($this, mode) {
  if ($this === undefined) {
    return true;
  }

  if (mode === "init") {
    $("tr.naviShikakuGrp").hide();
  } else if (mode === "toggle") {
    $("tr.naviShikakuGrp").toggle();
  }

  return true;
}

function ctrlGloBusiExpTableRows($this) {
  if ($this === undefined) {
    return true;
  }

  if ($this.val() === "ある") {
    $("tr.gloBusiExpAnsGrp").show();
  } else {
    $("tr.gloBusiExpAnsGrp").hide();
  }
  return true;
}

function ctrlGloRyuExpTableRows($this) {
  if ($this === undefined) {
    return true;
  }

  if ($this.val() === "ある") {
    $("tr.gloRyuExpAnsGrp").show();
  } else {
    $("tr.gloRyuExpAnsGrp").hide();
  }
  return true;
}
