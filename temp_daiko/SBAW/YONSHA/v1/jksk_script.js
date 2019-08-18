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
    assumeNearbyYear: true
  });

  $(".datepicker-date").datepicker({
    language: "ja",
    format: "yyyy/mm/dd",
    autoclose: true,
    toggleActive: true,
    assumeNearbyYear: true
  });

  // 「未申請」時、上長所見欄編集ボタンは非表示
  if (!needsCheck("Fill--jksk_boss_edit_btn")) {
    $("button#bossEditBtn").remove();
  }

  // 本人シート時、「上長所見欄」・「単身赴任」欄の要素削除
  if ( _data.sheet.ownGuid === _data.user.operatorGuid ) {
    $("div#bossShokenArea").remove();
    $("tr#tanshinArea").remove();
  }

  // 「未申請」のとき、「過去業務へ移動」と「回答内容クリア」ボタングループを非表示
  if (_data.sheet.statusCd !== "00-New") {
    var elem = $("div.GeGyomuBtnGrp");
    if (elem.length !== 0) {
      elem.remove();
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
    ctrlLanguageLavelTableRows($(this).attr("id"), $(this).val());
  });

  // プログラミングスキル欄の自動展開
  $("#jksk_skill_prog_ques_01").on("change", function() {
    var val = $(this).val();

    if (val === "ある") {
      $(".prgLvlAnsGrp input").prop("disabled", false);
      $(".prgLvlAnsGrp").show();
    } else {
      $(".prgLvlAnsGrp input").prop("disabled", true);
      $(".prgLvlAnsGrp").hide();
    }
  });

  // 全件ON/OFFボタンでの表示・非表示切り替え
  $document.on("click", "#btn_skill_onoff", function() {
    ctrlJinjiNaviShikakuTableRows("toggle");
  });

  // 現在の業務内容の「従事期間」開始の変更イベント
  $("#jksk_ge_kai").on("changeDate", function(e) {
    var from = getDatePickerValueById("jksk_ge_kai", "2");
    var to = getValueById("jksk_ge_shu");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById("jksk_ge_kai", "");
      setValueById("jksk_ge_jyu", "");
      return;
    }

    setValueById("jksk_ge_jyu", calcPeriod(from, to));
  });

  // 現在の業務内容の「従事期間」開始のフォーカスアウトイベント
  $("#jksk_ge_kai").on("blur", function() {
    var from = getDatePickerValueById("jksk_ge_kai", "2");
    var to = getValueById("jksk_ge_shu");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById("jksk_ge_kai", "");
      setValueById("jksk_ge_jyu", "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(from);

    setValueById("jksk_ge_jyu", calcPeriod(from, to));
  });

  // 過去の業務内容1-4の従事期間の自動計算（開始項目の変更イベント）
  $("#jksk_ka_01_kai, #jksk_ka_02_kai, #jksk_ka_03_kai, #jksk_ka_04_kai").on("changeDate", function(e) {
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "jyu");

    var from = getDatePickerValueById($(this).attr("id"), "2");
    var to = getDatePickerValueById(toName, "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 過去の業務内容1-4の従事期間の自動計算（開始項目のフォーカスアウトイベント）
  $("#jksk_ka_01_kai, #jksk_ka_02_kai, #jksk_ka_03_kai, #jksk_ka_04_kai").on("blur", function(e) {
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "jyu");

    var from = getDatePickerValueById($(this).attr("id"), "2");
    var to = getDatePickerValueById(toName, "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(from);

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 過去の業務内容1-4の従事期間の自動計算（終了項目の変更イベント）
  $("#jksk_ka_01_shu, #jksk_ka_02_shu, #jksk_ka_03_shu, #jksk_ka_04_shu").on("changeDate", function(e) {
    var fromName = $(this).attr("id").replace("shu", "kai");
    var tgtName = $(this).attr("id").replace("shu", "jyu");

    var from = getDatePickerValueById(fromName, "2");
    var to = getDatePickerValueById($(this).attr("id"), "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 過去の業務内容1-4の従事期間の自動計算（終了項目のフォーカスアウトイベント）
  $("#jksk_ka_01_shu, #jksk_ka_02_shu, #jksk_ka_03_shu, #jksk_ka_04_shu").on("blur", function(e) {
    var fromName = $(this).attr("id").replace("shu", "kai");
    var tgtName = $(this).attr("id").replace("shu", "jyu");

    var from = getDatePickerValueById(fromName, "2");
    var to = getDatePickerValueById($(this).attr("id"), "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(to);

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 海外・外国語利用経験欄の期間自動計算（開始項目の変更イベント）
  $("#jksk_glo_busi_exp_01_kai, #jksk_glo_busi_exp_02_kai, #jksk_glo_busi_exp_03_kai, #jksk_glo_ryu_exp_01_kai, #jksk_glo_ryu_exp_02_kai, #jksk_glo_ryu_exp_03_kai").on("changeDate", function(e) {
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "kik");

    var from = getDatePickerValueById($(this).attr("id"), "2");
    var to = getDatePickerValueById(toName, "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 海外・外国語利用経験欄の期間自動計算（開始項目のフォーカスアウトイベント）
  $("#jksk_glo_busi_exp_01_kai, #jksk_glo_busi_exp_02_kai, #jksk_glo_busi_exp_03_kai, #jksk_glo_ryu_exp_01_kai, #jksk_glo_ryu_exp_02_kai, #jksk_glo_ryu_exp_03_kai").on("blur", function(e) {
    var toName = $(this).attr("id").replace("kai", "shu");
    var tgtName = $(this).attr("id").replace("kai", "kik");

    var from = getDatePickerValueById($(this).attr("id"), "2");
    var to = getDatePickerValueById(toName, "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(from);

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 海外・外国語利用経験欄の期間自動計算（終了項目の変更イベント）
  $("#jksk_glo_busi_exp_01_shu, #jksk_glo_busi_exp_02_shu, #jksk_glo_busi_exp_03_shu, #jksk_glo_ryu_exp_01_shu, #jksk_glo_ryu_exp_02_shu, #jksk_glo_ryu_exp_03_shu").on("changeDate", function(e) {
    var fromName = $(this).attr("id").replace("shu", "kai");
    var tgtName = $(this).attr("id").replace("shu", "kik");

    var from = getDatePickerValueById(fromName, "2");
    var to = getDatePickerValueById($(this).attr("id"), "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 海外・外国語利用経験欄の期間自動計算（終了項目のフォーカスアウトイベント）
  $("#jksk_glo_busi_exp_01_shu, #jksk_glo_busi_exp_02_shu, #jksk_glo_busi_exp_03_shu, #jksk_glo_ryu_exp_01_shu, #jksk_glo_ryu_exp_02_shu, #jksk_glo_ryu_exp_03_shu").on("blur", function(e) {
    var fromName = $(this).attr("id").replace("shu", "kai");
    var tgtName = $(this).attr("id").replace("shu", "kik");

    var from = getDatePickerValueById(fromName, "2");
    var to = getDatePickerValueById($(this).attr("id"), "2");

    if (compareNengetsu(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById($(this).attr("id"), "");
      setValueById(tgtName, "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(to);

    setValueById(tgtName, calcPeriod(from, to));
  });

  // 「資格入力（選択入力）」欄のxボタン押下
  $("button#shikakuClearBtn01, button#shikakuClearBtn02, button#shikakuClearBtn03, button#shikakuClearBtn04, button#shikakuClearBtn05").on("click", function() {
    var index = $(this).attr("data-row");

    clearShikakuTuikaSentakuArea(index);
  });

  // 日本語以外のビジネス経験の表示・非表示制御
  $("#jksk_glo_busi_lang_ques_01").on("change", function() {
    var regex = /^ある.*$/;
    var val = $(this).val();
    if (regex.test(val)) {
      $("tr.gloBusiLangAnsGrp").find("INPUT,SELECT,TEXTAREA").prop("disabled", false);
    } else {
      $("tr.gloBusiLangAnsGrp").find("INPUT,SELECT,TEXTAREA").prop("disabled", true);
    }

    controlVisibleElementsById(getValueById("jksk_glo_busi_lang_ques_01"), "ある", $("tr.gloBusiLangAnsGrp"));
  });

  // 日本以外のビジネス経験の表示・非表示制御
  $("#jksk_glo_busi_exp_ques_01").on("change", function() {
    var bDisabled;

    var val = $(this).val();
    if (val === "ある") {
      bDisabled = false;
    } else {
      bDisabled = true;
    }

    $("tr.gloBusiExpAnsGrp").find("INPUT,SELECT,TEXTAREA").prop("disabled", bDisabled);

    // 業務分類のhidden項目のdisabled属性を設定／解除
    for (var i = 1; i <= 3; i++) {
      var idx = ("0" + i).slice(-2);

      $("input[name='Fill--jksk_glo_busi_exp_" + idx + "_shokushu_A']").prop("disabled", bDisabled);
      $("input[name='Fill--jksk_glo_busi_exp_" + idx + "_shokushu_B']").prop("disabled", bDisabled);
      $("input[name='Fill--jksk_glo_busi_exp_" + idx + "_shokushu_C']").prop("disabled", bDisabled);
    }

    controlVisibleElementsById(getValueById("jksk_glo_busi_exp_ques_01"), "ある", $("tr.gloBusiExpAnsGrp"));
  });

  // 就学・留学経験の表示・非表示制御
  $("#jksk_glo_ryu_ques_01").on("change", function() {
    var val = $(this).val();
    if (val === "ある") {
      $("tr.gloRyuExpAnsGrp").find("INPUT,SELECT,TEXTAREA").prop("disabled", false);
    } else {
      $("tr.gloRyuExpAnsGrp").find("INPUT,SELECT,TEXTAREA").prop("disabled", true);
    }

    controlVisibleElementsById(getValueById("jksk_glo_ryu_ques_01"), "ある", $("tr.gloRyuExpAnsGrp"));
  });

  // 追加資格（選択入力）の「取得時期」の変更イベント
  $document.on("changeDate", "#jksk_skill_shikaku_tsuika_sen_01_date, #jksk_skill_shikaku_tsuika_sen_02_date, #jksk_skill_shikaku_tsuika_sen_03_date, #jksk_skill_shikaku_tsuika_sen_04_date, #jksk_skill_shikaku_tsuika_sen_05_date", function() {
    var fromName = $(this).attr("id");
    var toName = fromName.replace("date", "kigen");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(fromName, "");
      return;
    }
  });

  // 追加資格（選択入力）の「取得時期」のフォーカスアウトイベント
  $document.on("blur", "#jksk_skill_shikaku_tsuika_sen_01_date, #jksk_skill_shikaku_tsuika_sen_02_date, #jksk_skill_shikaku_tsuika_sen_03_date, #jksk_skill_shikaku_tsuika_sen_04_date, #jksk_skill_shikaku_tsuika_sen_05_date", function() {
    var fromName = $(this).attr("id");
    var toName = fromName.replace("date", "kigen");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(fromName, "");
      return;
    }

    // 入力された値をカレンダー日付と同期させる
    $(this).val(from);
  });

  // 追加資格（選択入力）の「有効期限」の変更イベント
  $document.on("changeDate", "#jksk_skill_shikaku_tsuika_sen_01_kigen, #jksk_skill_shikaku_tsuika_sen_02_kigen, #jksk_skill_shikaku_tsuika_sen_03_kigen, #jksk_skill_shikaku_tsuika_sen_04_kigen, #jksk_skill_shikaku_tsuika_sen_05_kigen", function() {
    var toName = $(this).attr("id");
    var fromName = toName.replace("kigen", "date");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(toName, "");
      return;
    }
  });

  // 追加資格（選択入力）の「有効期限」のフォーカスアウトイベント
  $document.on("blur", "#jksk_skill_shikaku_tsuika_sen_01_kigen, #jksk_skill_shikaku_tsuika_sen_02_kigen, #jksk_skill_shikaku_tsuika_sen_03_kigen, #jksk_skill_shikaku_tsuika_sen_04_kigen, #jksk_skill_shikaku_tsuika_sen_05_kigen", function() {
    var toName = $(this).attr("id");
    var fromName = toName.replace("kigen", "date");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(toName, "");
      return;
    }
    // 入力された値をカレンダー日付と同期させる
    $(this).val(to);
  });

  // 追加資格（その他）の「取得時期」の変更イベント
  $document.on("changeDate", "#jksk_skill_shikaku_tsuika_jiyu_01_date, #jksk_skill_shikaku_tsuika_jiyu_02_date, #jksk_skill_shikaku_tsuika_jiyu_03_date, #jksk_skill_shikaku_tsuika_jiyu_04_date, #jksk_skill_shikaku_tsuika_jiyu_05_date", function() {
    var fromName = $(this).attr("id");
    var toName = fromName.replace("date", "kigen");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(fromName, "");
      return;
    }
  });

  // 追加資格（その他）の「取得時期」のフォーカスアウトイベント
  $document.on("blur", "#jksk_skill_shikaku_tsuika_jiyu_01_date, #jksk_skill_shikaku_tsuika_jiyu_02_date, #jksk_skill_shikaku_tsuika_jiyu_03_date, #jksk_skill_shikaku_tsuika_jiyu_04_date, #jksk_skill_shikaku_tsuika_jiyu_05_date", function() {
    var fromName = $(this).attr("id");
    var toName = fromName.replace("date", "kigen");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(fromName, "");
      return;
    }
    // 入力された値をカレンダー日付と同期させる
    $(this).val(from);
  });

  // 追加資格（その他）の「有効期限」の変更イベント
  $document.on("changeDate", "#jksk_skill_shikaku_tsuika_jiyu_01_kigen, #jksk_skill_shikaku_tsuika_jiyu_02_kigen, #jksk_skill_shikaku_tsuika_jiyu_03_kigen, #jksk_skill_shikaku_tsuika_jiyu_04_kigen, #jksk_skill_shikaku_tsuika_jiyu_05_kigen", function() {
    var toName = $(this).attr("id");
    var fromName = toName.replace("kigen", "date");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(toName, "");
      return;
    }
  });

  // 追加資格（その他）の「有効期限」のフォーカスアウトイベント
  $document.on("blur", "#jksk_skill_shikaku_tsuika_jiyu_01_kigen, #jksk_skill_shikaku_tsuika_jiyu_02_kigen, #jksk_skill_shikaku_tsuika_jiyu_03_kigen, #jksk_skill_shikaku_tsuika_jiyu_04_kigen, #jksk_skill_shikaku_tsuika_jiyu_05_kigen", function() {
    var toName = $(this).attr("id");
    var fromName = toName.replace("kigen", "date");

    var from = getDatePickerValueById(fromName,"1");
    var to = getDatePickerValueById(toName, "1");

    if (compareDate(from, to) > 0) {
      alert(errMsg("JkskDateFormatErrMsg"));
      setCalendarValueById(toName, "");
      return;
    }
    // 入力された値をカレンダー日付と同期させる
    $(this).val(to);
  });

  // 「ハッカソン～」の選択が変更されたときのテキストエリアの表示・非表示
  $("select#jksk_skill_prog_ques_02").on("change", function() {
    var val = $(this).val();
    if (val === "あり") {
      $("#jksk_skill_prog_ques_03").prop("disabled", false);
    } else {
      $("#jksk_skill_prog_ques_03").prop("disabled", true);
    }
    controlVisibleElementsById($(this).val(), "あり", $("#jksk_skill_prog_ques_03"));
  });

  // 「OSS公開経験～」の選択が変更されたときのテキストエリアの表示・非表示
  $("select#jksk_skill_prog_ques_05").on("change", function() {
    var val = $(this).val();
    if (val === "あり") {
      $("#jksk_skill_prog_ques_06").prop("disabled", false);
    } else {
      $("#jksk_skill_prog_ques_06").prop("disabled", true);
    }
    controlVisibleElementsById($(this).val(), "あり", $("#jksk_skill_prog_ques_06"));
  });

  // 「語学スキル目安」ボタン押下
  $("button#LangSkillIndicBtn").on("click", function() {
    dispSkillLevelSubWindow("1", 900, 500);
  });

  // 「Excelレベル」ボタン押下
  $("button#ExcelLvlBtn").on("click", function() {
    dispSkillLevelSubWindow("2", 900, 500);
  });

  // Accessレベルボタン押下
  $("button#AccessLvlBtn").on("click", function() {
    dispSkillLevelSubWindow("3", 900, 500);
  });

  // プログラミングレベルボタン押下
  $("button#ProgSkillLvlBtn").on("click", function() {
    dispSkillLevelSubWindow("4", 900, 500);
  });

  // 現在の業務内容の「一覧から選択」ボタン押下
  $("button#jksk_ge_shokushu_btn").on("click", function() {
    setValueById("ref_gyomub_01", "jksk_ge_shokushu_A")
    setValueById("ref_gyomub_02", "jksk_ge_shokushu_B")
    setValueById("ref_gyomub_03", "jksk_ge_shokushu_C")

    makeRequestParameter("shokushu01", getValueById("jksk_ge_shokushu_A"));
    makeRequestParameter("shokushu02", getValueById("jksk_ge_shokushu_B"));
    makeRequestParameter("gyomub", getValueById("jksk_ge_shokushu_C"));

    openSubWindow("/view/sheet/VSHGYM_GyomuBunruiSelect.jsp", "INIT", "hcdb_sub", 1200, 600);
  });

  // 過去の業務内容1-4の「一覧から選択」ボタン押下
  $("button#jksk_ka_01_shokushu_btn, button#jksk_ka_02_shokushu_btn, button#jksk_ka_03_shokushu_btn, button#jksk_ka_04_shokushu_btn").on("click", function() {

    var row = $(this).attr("data-row");
    if ( row === "" ) {
      return true;
    }

    setValueById( "ref_gyomub_01", "jksk_ka_" + row +"_shokushu_A" );
    setValueById( "ref_gyomub_02", "jksk_ka_" + row +"_shokushu_B" );
    setValueById( "ref_gyomub_03", "jksk_ka_" + row +"_shokushu_C" );

    openSubWindow("/view/sheet/VSHGYM_GyomuBunruiSelect.jsp", "INIT", "hcdb_sub", 1200, 600);

    return true;
  });

  // 経験したい業務1-2の「一覧から選択」ボタン押下
  $("button#jksk_car_now_ques_03_btn, button#jksk_car_now_ques_04_btn").on("click", function() {

    var row = $(this).attr("data-row");
    if ( row === "" ) {
      return true;
    }

    setValueById( "ref_gyomub_01", "jksk_car_now_ques_" + row + "_A" );
    setValueById( "ref_gyomub_02", "jksk_car_now_ques_" + row + "_B" );
    setValueById( "ref_gyomub_03", "jksk_car_now_ques_" + row + "_C" );

    openSubWindow("/view/sheet/VSHGYM_GyomuBunruiSelect.jsp", "INIT", "hcdb_sub", 1200, 600);

    return true;
  });

  // 日本以外の国でのビジネス経験　業務分類1-3の「一覧から選択」ボタン押下
  $("button#jksk_glo_busi_exp_01_shokushu_btn, button#jksk_glo_busi_exp_02_shokushu_btn, button#jksk_glo_busi_exp_03_shokushu_btn").on("click", function() {

    var row = $(this).attr("data-row");
    if ( row === "" ) {
      return true;
    }

    setValueById( "ref_gyomub_01", "jksk_glo_busi_exp_" + row + "_shokushu_A" );
    setValueById( "ref_gyomub_02", "jksk_glo_busi_exp_" + row + "_shokushu_B" );
    setValueById( "ref_gyomub_03", "jksk_glo_busi_exp_" + row + "_shokushu_C" );

    openSubWindow("/view/sheet/VSHGYM_GyomuBunruiSelect.jsp", "INIT", "hcdb_sub", 1200, 600);

    return true;
  });

  // 上長所見欄の「一覧から選択」ボタン押下
  $("button#jksk_bos_now_ques_03_btn").on("click", function() {
    setValueById("ref_gyomub_01", "jksk_bos_now_ques_03_A")
    setValueById("ref_gyomub_02", "jksk_bos_now_ques_03_B")
    setValueById("ref_gyomub_03", "jksk_bos_now_ques_03_C")

    openSubWindow("/view/sheet/VSHGYM_GyomuBunruiSelect.jsp", "INIT", "hcdb_sub", 1200, 600);
  });

  // 追加資格（選択入力）の「資格選択」ボタン押下
  $(
    "button#jksk_skill_shikaku_tsuika_sen_01_nm_btn, button#jksk_skill_shikaku_tsuika_sen_02_nm_btn, button#jksk_skill_shikaku_tsuika_sen_03_nm_btn, button#jksk_skill_shikaku_tsuika_sen_04_nm_btn, button#jksk_skill_shikaku_tsuika_sen_05_nm_btn"
  ).on("click", function() {
    var row = $(this).attr("data-row");

    makeRequestParameter( "data-row", row );

    openSubWindow("/view/sheet/VSHSIK_ShikakuSelect.jsp", "INIT", "hcdb_sub", 1024, 600);
  });

  // プログラミングスキル「その他」の「業務利用」ラジオボタン押下
  var nowExpChecked = _data.fill.jksk_skill_prog_type_other_keiken === "" ? false : _data.fill.jksk_skill_prog_type_other_keiken;

  $("input[name='Grp--jksk_skill_prog_type_other_keiken']").click(function() {
    if($(this).val() === nowExpChecked) {
      $(this).prop("checked", false);
      $("input[name='Fill--jksk_skill_prog_type_other_keiken']").val("");
      nowExpChecked = false;
    } else {
      nowExpChecked = $(this).val();
      $("input[name='Fill--jksk_skill_prog_type_other_keiken']").val($(this).val());
    }
  });

  // プログラミングスキル「その他」の「スキル」ラジオボタン押下
  var nowLvlChecked = _data.fill.jksk_skill_prog_type_other_lv === "" ? false : _data.fill.jksk_skill_prog_type_other_lv;

  $("input[name='Grp--jksk_skill_prog_type_other_lv']").click(function() {
    if($(this).val() === nowLvlChecked) {
      $(this).prop("checked", false);
      $("input[name='Fill--jksk_skill_prog_type_other_lv']").val("");
      nowLvlChecked = false;
    } else {
      nowLvlChecked = $(this).val();
      $("input[name='Fill--jksk_skill_prog_type_other_lv']").val($(this).val());
    }
  });

  // 初期化処理
  initialJkskSheet();
});

/**
 * エラーメッセージ取り出し
 *
 * @param {*} msgID 取り出すメッセージID
 */
function errMsg(msgID) {
  var labels = _data.label;
  var msgs = {
    JkskHalfWidthNumberErrMsg: labels.JkskHalfWidthNumberErrMsg,
    JkskRequiredErrMsg: labels.JkskRequiredErrMsg,
    JkskSelOthersAnsErrMsg: labels.JkskSelOthersAnsErrMsg,
    JkskPastGyomuErrMsg: labels.JkskPastGyomuErrMsg,
    JkskNoCurentGyomuErrMsg: labels.JkskNoCurentGyomuErrMsg,
    JkskTargetQuesErrMsg: labels.JkskTargetQuesErrMsg,
    JkskDateFormatErrMsg: labels.JkskDateFormatErrMsg,
  };
  return msgs[msgID];
}

/**
 * 確認用メッセージ取り出し
 *
 * @param {*} msgID 取り出すメッセージID
 */
function confMsg(msgID) {
  var labels = _data.label;
  var msgs = {
    JkskMoveGyomConfMsg: labels.JkskMoveGyomConfMsg,
    JkskClearCurGyomuConfMsg: labels.JkskClearCurGyomuConfMsg,
    JkskGlobalExpConfMsg: labels.JkskGlobalExpConfMsg,
    JkskCurrentGyomuConfMsg: labels.JkskCurrentGyomuConfMsg,
    JkskClearShikakuTuikaConfMsg: labels.JkskClearShikakuTuikaConfMsg,
  };
  return msgs[msgID].replace(/\\r\\n/g, "\r\n");
}

/**
 * 画面初期化処理
 */
function initialJkskSheet() {
  // 終了年月（現在の業務内容）のデフォルト値設定
  $("input[name='Fill--jksk_ge_shu']").val(
    _data.sheet.operationCd.substr(0, 4) + "/" + "09"
  );

  // 言語レベル（言語1-2）の表示・非表示
  ctrlLanguageLavelTableRows("jksk_skill_lang_02_nm", _data.fill.jksk_skill_lang_02_nm);
  ctrlLanguageLavelTableRows("jksk_skill_lang_03_nm", _data.fill.jksk_skill_lang_03_nm);

  // プログラミングレベル1-20の表示・非表示
  controlVisibleElementsById(_data.fill.jksk_skill_prog_ques_01, "ある", $("tr.prgLvlAnsGrp"));

  // 人事Navi登録済み資格6-10の表示・非表示
  ctrlJinjiNaviShikakuTableRows("init");

  // ビジネス経験（日本語以外）欄の表示・非表示
  controlVisibleElementsById(_data.fill.jksk_glo_busi_lang_ques_01, "ある", $("tr.gloBusiLangAnsGrp"));

  // ビジネス経験（日本以外）欄の表示・非表示
  controlVisibleElementsById(_data.fill.jksk_glo_busi_exp_ques_01, "ある", $("tr.gloBusiExpAnsGrp"));

  // 就学・留学経験欄の表示・非表示
  controlVisibleElementsById(_data.fill.jksk_glo_ryu_ques_01, "ある", $("tr.gloRyuExpAnsGrp"));

  // 「一覧から選択」ボタンの表示・非表示
  controlSelectFromListButton();

  // 「資格選択」ボタン、資格削除ボタンの表示・非表示
  controlSikakuSelectButton();

  // スキルレベル（Excel&Access, プログラミング）の表示・非表示切り替え
  switchSkillLevelTable();

  // hidden項目の設定・解除
  controlHiddenFields();

  // プログラミング経験エリアの編集・閲覧制御
  controlProgramingQuesArea();

  setProgramingSkillRadioBtn();

  controlKanrisyokuKibouArea();

  // 「その他」ラジオボタンに値をセット
  $("input[name='Grp--jksk_skill_prog_type_other_lv']").val([_data.fill.jksk_skill_prog_type_other_lv]);
  $("input[name='Grp--jksk_skill_prog_type_other_keiken']").val([_data.fill.jksk_skill_prog_type_other_keiken]);
}

/**
 * 自己申告シートの申請時チェック処理
 */
function checkJkskSheet() {
  $("td.error").removeClass("error");

  var status = _data.sheet.statusCd;
  if (status === "00-New") {
    // 必須チェック
    if (!checkJkskRequired()) {
      alert(errMsg("JkskRequiredErrMsg"));
      return false;
    }

    // 値が入力済みのとき、必須となるチェック
    if (!checkRequireRelatedItems()) {
      alert(errMsg("JkskSelOthersAnsErrMsg"));
      return false;
    }

    // 回答内容によって必須となるチェック（自己申告）
    if (_data.sheet.layoutCd === "lay-jksk-tsu-v1") {
      if (!checkRequiredByJkskAnswer()) {
        return false;
      }
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
  } else if (status === "01-Check1st") {
    if (!checkJkskBossHyoka()) {
      alert(errMsg("JkskRequiredErrMsg"));
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
 *   ※「仕事の適性」項目は、少なくとも1つ選択されていることをチェックすることで未入力チェックとする
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

  if (_data.sheet.layoutCd === "lay-jksk-tsu-v1") {
    // 「仕事の適性（ある）」未入力チェック
    if (getValueById("jksk_gen_shigoto_05_01") === "" && getValueById("jksk_gen_shigoto_05_02") === "" && getValueById("jksk_gen_shigoto_05_03") === "") {
      $("#jksk_gen_shigoto_05_01").addClass("error");
      $("#jksk_gen_shigoto_05_02").addClass("error");
      $("#jksk_gen_shigoto_05_03").addClass("error");

      bErr = true;
    }

    // 「仕事の適性（ない）」未入力チェック
    if (getValueById("jksk_gen_shigoto_06_01") === "" && getValueById("jksk_gen_shigoto_06_02") === "" && getValueById("jksk_gen_shigoto_06_03") === "") {
      $("#jksk_gen_shigoto_06_01").addClass("error");
      $("#jksk_gen_shigoto_06_02").addClass("error");
      $("#jksk_gen_shigoto_06_03").addClass("error");

      bErr = true;
    }
  }
  return !bErr;
}

/**
 * 「上司所見欄」の未入力チェック
 */
function checkJkskBossHyoka() {
  var bErr = false;

  $(".boss-required").each(function() {
    if ($(this).text() === "") {
      $(this).addClass("error");
    bErr = true;
  }
  });

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
    var shokushuA = $("#jksk_ka_" + idx + "_shokushu_A");
    var shokushuB = $("#jksk_ka_" + idx + "_shokushu_B");
    var shokushuC = $("#jksk_ka_" + idx + "_shokushu_C");
    var naiyo = $("#jksk_ka_" + idx + "_gyomunaiyo");
    var kaisi = $("#jksk_ka_" + idx + "_kai");
    var shuryo = $("#jksk_ka_" + idx + "_shu");
    var kikan = $("#jksk_ka_" + idx + "_jyu");

    if (shozoku.text() !== "" || shokushuA.text() !=="" || naiyo.text() !== "" || kaisi.text() !== "" || shuryo.text() !== "" || kikan.text() !== "") {
      if (shozoku.text() === "") {
        shozoku.addClass("error");
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

  // プログラミングスキルの「その他」未入力チェック
  if (_data.sheet.layoutCd === "lay-jksk-tsu-v1") {
    if(!checkOtherProgramLanguage()) {
      bErr = true;
    }
  }

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
  var msg = errMsg("JkskTargetQuesErrMsg");

  // その他 -希望勤務地-
  var bErr = true;
  for (var k = 1; k <= 3; k++) {
    idx = ("0" + k).slice(-2);

    elem1 = $("#jksk_car_other_kinmu_" + idx);
    elem2 = $("#jksk_car_other_kinmu_kuni_" + idx);

    if (checkRelatedRequire(elem1, elem2, "海外", "")) {
      elem2.addClass("error");
      bErr = false;
    }
  }
  if (bErr === false) {
    window.alert(msg.replace("{0}", "希望勤務地"));
    return false;
  }

  // 今後のキャリア
  elem1 = $("#jksk_car_now_ques_02");
  elem2 = $("#jksk_car_now_ques_05");

  if (
    checkRelatedRequire(elem1, elem2, "直ちに新しい業務に挑戦してみたい", "") ||
    checkRelatedRequire(elem1, elem2, "1年以内に新しい業務に挑戦したい", "")
  ) {
    elem2.addClass("error");
    window.alert(msg.replace("{0}", "1年以内に携わりたい業務詳細"));
    return false;
  }

  // プログラミング関連の受賞歴
  elem1 = $("#jksk_skill_prog_ques_02");
  elem2 = $("#jksk_skill_prog_ques_03");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("error");
    window.alert(
      msg.replace(
        "{0}",
        "ハッカソン/プログラミングコンテスト・イベント等での受賞歴があれば、企画名および実績を教えて下さい。"
      )
    );
    return false;
  }

  // OSS公開歴
  elem1 = $("#jksk_skill_prog_ques_05");
  elem2 = $("#jksk_skill_prog_ques_06");

  if (checkRelatedRequire(elem1, elem2, "あり", "")) {
    elem2.addClass("error");
    window.alert(msg.replace("{0}", "OSS公開経験があれば、その内容を教えて下さい。 "));
    return false;
  }
  return true;
}

/**
 * 回答項目によって必須となるチェック（海外・外国語利用経験シート）
 */
function checkRequiredByGlobalSheet() {
  var bErr = false;
  var msg = errMsg("JkskTargetQuesErrMsg");

  // ビジネス経験（日本語以外・日本以外）就学・留学経験の各欄にて「ある」が選択されたときの未入力チェック

  // ビジネス経験（言語）
  var chkGloBusiLangArray = [
    "jksk_glo_busi_lang_01_nm",
    "jksk_glo_busi_lang_01_naiyo",
  ];
  var val = _data.fill.jksk_glo_busi_lang_ques_01;
  if (val.match(/^ある/)) {
    chkGloBusiLangArray.forEach(function(fillId) {
      if (!checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }

  if (bErr) {
    window.alert(msg.replace("{0}", "現在に至るまで、日本で日本語以外の言語を用いたビジネス経験はありますか？"));
    return false;
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
      if (!checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }

  if (bErr) {
    window.alert(msg.replace("{0}", "これまで日本以外の国でのビジネス経験はありますか？"));
    return false;
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
      if (!checkRequireById(fillId)) {
        $("#" + fillId).addClass("error");
        bErr = true;
      }
    });
  }

  if (bErr) {
    window.alert(msg.replace("{0}", "これまで日本以外の国での就学経験、留学経験はありますか？"));
    return false;
  }
  return true;
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
  var ret;

  if (getValueById(id) === "") {
    ret = false;
  } else {
    ret = true;
  }
  return ret;
}

/**
 * elem1の要素の値が、value1であるとき、elem2の要素の値がvalue2であるかをチェックする
 *
 * @param {*} elem1
 * @param {*} elem2
 * @param {*} value1
 * @param {*} value2
 *
 * TRUE : 一致する
 * FALSE : 一致しない
 */
function checkRelatedRequire(elem1, elem2, value1, value2) {
  if (elem1.length === 0 || elem2.length === 0) {
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

  if (from === "" || to === "") {
    return ret;
  }

  try {
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
      kikMonth = toMonth - fromMonth + 1
    } else if (kikYear > 0 && toMonth >= fromMonth) {
      // ex.2018/01 - 2019/12
      kikMonth = toMonth - fromMonth + 1;
    } else if (kikYear > 0 && toMonth < fromMonth) {
      // ex.2019/10 - 2020/04
      kikYear -= 1;
      kikMonth = (toMonth + 12) - fromMonth + 1;
    } else {
      kikYear = 0;
      kikMonth = 0;
    }

    if (kikMonth === 12) {
      kikYear += 1;
      kikMonth = 0;
    }

    // 計算結果を"○年○ヶ月"の形式に
    ret = kikYear.toFixed() + "年" + kikMonth.toFixed() + "ヶ月";
  } catch(e) {
    ret = "";
  }
  return ret;
}

/**
 * 業務内容を移動する
 */
function moveCurrentWorkContents() {
  // 現在の業務内容が未入力でないか？
  var geShozoku = getValueById("jksk_ge_shozoku");
  var geKigyomei = getValueById("jksk_ge_kigyomei");
  var geGyoNaiyo = getValueById("jksk_ge_gyomunaiyo");
  var geKai = getValueById("jksk_ge_kai");
  var geShu = getValueById("jksk_ge_shu");
  var geJyu = getValueById("jksk_ge_jyu");
  var geBunruiA = getValueById("jksk_ge_shokushu_A");
  var geBunruiB = getValueById("jksk_ge_shokushu_B");
  var geBunruiC = getValueById("jksk_ge_shokushu_C");

  // いずれかが未入力ならば、移動させない
  if (geShozoku === "" || geGyoNaiyo === "" || geKai === "" || geBunruiA === "") {
    alert(errMsg("JkskNoCurentGyomuErrMsg"));
    return false;
  }

  // 4→5
  setValueById("jksk_ka_05_shozoku", getValueById("jksk_ka_04_shozoku"));
  setValueById("jksk_ka_05_kigyomei", getValueById("jksk_ka_04_kigyomei"));
  setValueById("jksk_ka_05_shokushu_A", getValueById("jksk_ka_04_shokushu_A"));
  setValueById("jksk_ka_05_shokushu_B", getValueById("jksk_ka_04_shokushu_B"));
  setValueById("jksk_ka_05_shokushu_C", getValueById("jksk_ka_04_shokushu_C"));
  setValueById("jksk_ka_05_gyomunaiyo", getValueById("jksk_ka_04_gyomunaiyo"));
  setValueById("jksk_ka_05_kai", getValueById("jksk_ka_04_kai"));
  setValueById("jksk_ka_05_shu", getValueById("jksk_ka_04_shu"));
  setValueById("jksk_ka_05_jyu", getValueById("jksk_ka_04_jyu"));

  // 過去業務5用のhidden項目へコピー
  setValueByName("Fill--jksk_ka_05_shozoku", getValueById("jksk_ka_04_shozoku"));
  setValueByName("Fill--jksk_ka_05_kigyomei", getValueById("jksk_ka_04_kigyomei"));
  setValueByName("Fill--jksk_ka_05_shokushu_A", getValueById("jksk_ka_04_shokushu_A"));
  setValueByName("Fill--jksk_ka_05_shokushu_B", getValueById("jksk_ka_04_shokushu_B"));
  setValueByName("Fill--jksk_ka_05_shokushu_C", getValueById("jksk_ka_04_shokushu_C"));
  setValueByName("Fill--jksk_ka_05_gyomunaiyo", getValueById("jksk_ka_04_gyomunaiyo"));
  setValueByName("Fill--jksk_ka_05_kai", getValueById("jksk_ka_04_kai"));
  setValueByName("Fill--jksk_ka_05_shu", getValueById("jksk_ka_04_shu"));

  // 3→4, 2→3, 1→2
  for (var i = 3; i >= 1; i--) {
    var from = ("0" + i).slice(-2);
    var to = ("0" + (i + 1)).slice(-2);

    setValueById("jksk_ka_" + to + "_shozoku", getValueById("jksk_ka_" + from + "_shozoku"));
    setValueById("jksk_ka_" + to + "_kigyomei", getValueById("jksk_ka_" + from + "_kigyomei"));
    setValueById("jksk_ka_" + to + "_shokushu_A", getValueById("jksk_ka_" + from + "_shokushu_A"));
    setValueById("jksk_ka_" + to + "_shokushu_B", getValueById("jksk_ka_" + from + "_shokushu_B"));
    setValueById("jksk_ka_" + to + "_shokushu_C", getValueById("jksk_ka_" + from + "_shokushu_C"));
    setValueById("jksk_ka_" + to + "_gyomunaiyo", getValueById("jksk_ka_" + from + "_gyomunaiyo"));
    setCalendarValueById("jksk_ka_" + to + "_kai", "");
    setCalendarValueById("jksk_ka_" + to + "_shu", "");
    setCalendarValueById("jksk_ka_" + to + "_kai", getValueById("jksk_ka_" + from + "_kai"));
    setCalendarValueById("jksk_ka_" + to + "_shu", getValueById("jksk_ka_" + from + "_shu"));
    setValueById("jksk_ka_" + to + "_jyu", getValueById("jksk_ka_" + from + "_jyu"));

    // hidden項目へデータをセット
    setValueByName("Fill--jksk_ka_" + to + "_shokushu_A", getValueById("jksk_ka_" + from + "_shokushu_A"));
    setValueByName("Fill--jksk_ka_" + to + "_shokushu_B", getValueById("jksk_ka_" + from + "_shokushu_B"));
    setValueByName("Fill--jksk_ka_" + to + "_shokushu_C", getValueById("jksk_ka_" + from + "_shokushu_C"));
  }

  // 現在の業務内容を過去1に移動
  setValueById("jksk_ka_01_shozoku", geShozoku);
  setValueById("jksk_ka_01_kigyomei", geKigyomei);
  setValueById("jksk_ka_01_shokushu_A", geBunruiA);
  setValueById("jksk_ka_01_shokushu_B", geBunruiB);
  setValueById("jksk_ka_01_shokushu_C", geBunruiC);
  setValueById("jksk_ka_01_gyomunaiyo", geGyoNaiyo);
  setCalendarValueById("jksk_ka_01_kai", "");
  setCalendarValueById("jksk_ka_01_shu", "");
  setCalendarValueById("jksk_ka_01_kai", geKai);
  setCalendarValueById("jksk_ka_01_shu", geShu);
  setValueById("jksk_ka_01_jyu", geJyu);

  // hidden項目へデータをセット
  setValueByName("Fill--jksk_ka_01_shokushu_A", geBunruiA);
  setValueByName("Fill--jksk_ka_01_shokushu_B", geBunruiB);
  setValueByName("Fill--jksk_ka_01_shokushu_C", geBunruiC);

  return true;
}

/**
 * datepickerのカレンダー項目にデータをセットする
 *  ※valメソッドでは、値がきちんとセットされないため
 *
 * @param {*} id
 * @param {*} value
 */
function setCalendarValueById(id, value) {
  var $elem = $("#" + id);
  var tagName = $elem[0].tagName.toUpperCase();

  if (tagName === "INPUT") {
    $elem.datepicker("setDate", value);
  } else {
    $elem.val(value);
  }
}

/**
 * detepickerのカレンダー項目から日付データを、"YYYY/MM/DD" もしくは "YYYY/MM"形式で取得し、返す。
 *
 * @param {*} id id名
 * @param {*} mode 取得形式
 *             1 : YYYY/MM/DD
 *             2 : YYYY/DD
 */
function getDatePickerValueById(id, mode) {
  var ret = "";
  var $elem = $("#" + id);
  if ($elem.length === 0) {
    return ret;
  }

  var value = $elem.datepicker("getDate");
  if (value !== null && value !== "Invalid Date") {
    var date = new Date(value);
    switch (mode) {
      case "1" :
        ret = date.getFullYear() + "/" + ("0" + (date.getMonth() + 1)).slice(-2) + "/" + ("0" + date.getDate()).slice(-2);
        break;
      case "2" :
        ret = date.getFullYear() + "/" + ("0" + (date.getMonth() + 1)).slice(-2);
        break;
      default :
        ret = "";
        break;
    }
  }
  return ret;
}

/**
 * 「現在の業務内容」欄をクリアする
 */
function clearGenzaiKaitoNaiyo() {
  setValueById("jksk_ge_shozoku", "");
  setValueById("jksk_ge_kigyomei", "");
  setValueById("jksk_ge_shokushu_A", "");
  setValueById("jksk_ge_shokushu_B", "");
  setValueById("jksk_ge_shokushu_C", "");
  setValueById("jksk_ge_gyomunaiyo", "");
  setCalendarValueById("jksk_ge_kai", "");
  setValueById("jksk_ge_jyu", "");
  setValueById("jksk_ge_kin_chiiki", "");
  setValueById("jksk_ge_kin_kikan", "");

  // hidden項目のデータをクリア
  setValueByName("Fill--jksk_ge_shokushu_A", "");
  setValueByName("Fill--jksk_ge_shokushu_B", "");
  setValueByName("Fill--jksk_ge_shokushu_C", "");

  return true;
}

/**
 * 引数で指定した値の半角数字チェックを行う
 *
 * @param {*} numVal
 *
 * TRUE  : OK
 * FALSE : FALSE
 */
function checkHalfwidthNumbers(numVal) {
  // 半角数字パターン
  var pattern = /^\d*$/;

  return pattern.test(numVal);
}

/**
 * 言語（英語以外1,2）の選択内容により「読み書き」・「会話」欄の表示・非表示を制御する
 * 　※空欄が選択されたとき、「読み書き」、「会話」行を非表示＆言語選択以外を非表示
 *
 * @param {*} idName
 * @param {*} val
 */
function ctrlLanguageLavelTableRows(idName, val) {
  if (idName === "") {
    return true;
  }

  var clsGrpName = (idName === "jksk_skill_lang_02_nm") ? "lang02AnsGrp" : "lang03AnsGrp";
  if (val === "") {
    $("tr." + clsGrpName + ":eq(0)").children(":gt(1)").hide();
    $("tr." + clsGrpName + ":eq(0)").children(":eq(1)").attr("colspan", "3");
    $("tr." + clsGrpName + ":eq(0)").children(":eq(1)").prop("disabled", true);
    $("tr." + clsGrpName + ":not(:eq(0))").prop("disabled", true);
    $("tr." + clsGrpName + ":not(:eq(0))").hide();
  } else {
    $("tr." + clsGrpName + ":eq(0)").children(":gt(1)").show();
    $("tr." + clsGrpName + ":eq(0)").children(":eq(1)").removeAttr("colspan");
    $("tr." + clsGrpName + ":eq(0)").children(":eq(1)").prop("disabled", false);
    $("tr." + clsGrpName + ":not(:eq(0))").prop("disabled", false);
    $("tr." + clsGrpName + ":not(:eq(0))").show();
  }
  return true;
}

/**
 * 「人事Navi登録済み資格」欄の6-10行目の表示・非表示を制御する
 *
 * @param {*} mode
 *              init : 初期表示時、非表示
 *              toggle : 表示←→非表示の切り替え
 */
function ctrlJinjiNaviShikakuTableRows(mode) {
  if (mode === "init") {
    $("tr.naviShikakuGrp").hide();
  } else if (mode === "toggle") {
    $("tr.naviShikakuGrp").toggle();
  }

  return true;
}

/**
 * valの内容が、patternに一致するとき、elemで指定された要素を表示する。
 * また、valueに一致しないときは、非表示にする
 *
 * @param {*} val
 * @param {*} pattern
 * @param {*} elemName
 * @param {*} clsName
 */
function controlVisibleElementsById(val, pattern, elem) {
  if (elem.length === 0) {
    return true;
  }

  if (val.match(pattern)) {
    elem.show();
  } else {
    elem.hide();
  }
  return true;
}

/**
 * 「追加資格（選択入力）」欄のxボタンが押下されたときの入力内容クリア処理
 *
 * @param {*} index
 */
function clearShikakuTuikaSentakuArea(index) {
  var msg = confMsg("JkskClearShikakuTuikaConfMsg");

  if (!window.confirm(msg)) {
    return false;
  }

  // ※資格名の欄のみ<span>タグ内のテキストを消す（<td>で消すとxボタンも消えるため）
  $("#jksk_skill_shikaku_tsuika_sen_" + index + "_nm" + " span").text("");

  setCalendarValueById("jksk_skill_shikaku_tsuika_sen_" + index + "_date", "");
  setCalendarValueById("jksk_skill_shikaku_tsuika_sen_" + index + "_kigen", "");

  // hidden項目の値をクリア
  setValueByName("Fill--jksk_skill_shikaku_tsuika_sen_" + index + "_code", "");
  setValueByName("Fill--jksk_skill_shikaku_tsuika_sen_" + index + "_nm", "");

  return true;
}

/**
 * idで指定された要素の値を取得する
 *
 * @param {*} id
 */
function getValueById(id) {
  var ret = "";

  if (id === "") {
    return ret;
  }

  var $elem = $("#" + id);
  if ($elem.length === 0) {
    return ret;
  }

  var tName = $elem[0].tagName.toUpperCase();
  if (tName.match(/INPUT|TEXTAREA|SELECT/)) {
    ret = $elem.val();
  } else {
    ret = $elem.text();
  }
  return ret;
}

/**
 * id="id"で指定された要素へvalueをセットする
 *
 * @param {*} id
 * @param {*} value
 */
function setValueById(id, value) {
  if (id === "") {
    return true;
  }

  var $elem = $("#" + id);
  if ($elem.length === 0) {
    return true;
  }

  var tName = $elem[0].tagName.toUpperCase();
  if (tName.match(/INPUT|TEXTAREA|SELECT/)) {
    $elem.val(value);
  } else {
    $elem.text(value);
  }

  return true;
}

/**
 * name="name" で指定された要素に、valueをセットする
 *
 * @param {*} name
 * @param {*} value
 */
function setValueByName(name, value) {
  if (name === "") {
    return true;
  }

  var $elem = $("[name='" + name + "']");
  if ($elem.length === 0) {
    return true;
  }

  var tName = $elem[0].tagName.toUpperCase();
  if (tName.match(/INPUT|TEXTAREA|SELECT/)) {
    $elem.val(value);
  } else {
    $elem.text(value);
  }

  return true;
}

/**
 * 資格登録子画面で選択された値を呼び出し元の画面に反映する
 *
 * @param {*} row 反映する行
 * @param {*} param 値
 *              code : 資格コード
 *              name : 資格名
 */
function applyShikakuInfo( row, param ) {
  $("#jksk_skill_shikaku_tsuika_sen_" + row + "_nm span").text(param.name);

  // hidden項目にも値をセット
  setValueByName("Fill--jksk_skill_shikaku_tsuika_sen_" + row + "_code", param.code);
  setValueByName("Fill--jksk_skill_shikaku_tsuika_sen_" + row + "_nm", param.name);
}

/**
 * 業務分類登録子画面で選択された値を呼び出し元の画面に反映する
 *
 * @param {*} param 値
 *              shokushu1 : 職種1
 *              shokushu2 : 職種2
 *              bunrui :    分類
 */
function applyGyomubInfo( param ) {
  var ref01 = getValueById("ref_gyomub_01");
  var ref02 = getValueById("ref_gyomub_02");
  var ref03 = getValueById("ref_gyomub_03");

  setValueById( ref01, param.shokushu1 );
  setValueById( ref02, param.shokushu2 );
  setValueById( ref03, param.bunrui );

  // hidden項目にも値をセット
  setValueByName( "Fill--" + ref01, param.shokushu1 );
  setValueByName( "Fill--" + ref02, param.shokushu2 );
  setValueByName( "Fill--" + ref03, param.bunrui );
}

/**
 * 「一覧から選択」ボタンの制御
 */
function controlSelectFromListButton() {
  if (needsCheck("Fill--jksk_boss_edit")) {
    $( "button#jksk_ge_shokushu_btn" ).remove();
    $( "button#jksk_ka_01_shokushu_btn" ).remove();
    $( "button#jksk_ka_02_shokushu_btn" ).remove();
    $( "button#jksk_ka_03_shokushu_btn" ).remove();
    $( "button#jksk_ka_04_shokushu_btn" ).remove();
    $( "button#jksk_car_now_ques_03_btn" ).remove();
    $( "button#jksk_car_now_ques_04_btn" ).remove();
    $( "button#jksk_glo_busi_exp_01_shokushu_btn" ).remove();
    $( "button#jksk_glo_busi_exp_02_shokushu_btn" ).remove();
    $( "button#jksk_glo_busi_exp_03_shokushu_btn" ).remove();
  } else if (needsCheck("Fill--jksk_own_edit")) {
    $( "button#jksk_bos_now_ques_03_btn" ).remove();
  }
  }

/**
 * 「資格選択」ボタンおよび資格削除ボタンの制御
 */
function controlSikakuSelectButton() {
  if (!needsCheck("Fill--jksk_own_edit")) {
    for (var i = 1; i <= 5; i++) {
      var idx = ( "0" + i ).slice( -2 );

      $("button#jksk_skill_shikaku_tsuika_sen_" + idx + "_nm_btn").remove();
      $("button#shikakuClearBtn" + idx).remove();
    }
  }
}

/**
 * 引数で指定された年月日の大小を比較する
 *
 * @param {*} date1
 * @param {*} date2
 *
 * @return 0  : date1とdate2は同じ
 *         1  : date1 > date2
 *         -1 : date < date2
 */
function compareDate(date1, date2) {
  if (date1 === "" || date2 === "") {
    return 0;
  }

  var cmpDate1 = new Date(date1);
  var cmpDate2 = new Date(date2);

  // 比較元1
  var cmpYear1 = parseInt(cmpDate1.getFullYear(), 10);
  var cmpMonth1 = parseInt((cmpDate1.getMonth() + 1), 10);
  var cmpDay1 = parseInt(cmpDate1.getDate(), 10);

  // 比較元2
  var cmpYear2 = parseInt(cmpDate2.getFullYear(), 10);
  var cmpMonth2 = parseInt((cmpDate2.getMonth() + 1), 10);
  var cmpDay2 = parseInt(cmpDate2.getDate(), 10);

  if (cmpYear1 === cmpYear2) {
    if (cmpMonth1 === cmpMonth2) {
      return cmpDay1 - cmpDay2;
    } else {
      return cmpMonth1 - cmpMonth2;
    }
  } else {
    return cmpYear1 - cmpYear2;
  }
}

/**
 * 引数で指定された年月の大小を比較する
 *
 * @param {*} date1
 * @param {*} date2
 *
 * @return 0  : date1とdate2は同じ
 *         1  : date1 > date2
 *         -1 : date < date2
 */
function compareNengetsu(date1, date2) {
  if (date1 === "" || date2 === "") {
    return 0;
  }

  // YYYY/MM/01の形式にしてチェック関数に渡す
  var tmpFrom = date1 + "/" + "01";
  var tmpTo = date2 + "/" + "01";

  return compareDate(tmpFrom, tmpTo);
}

function switchSkillLevelTable() {
  if (needsCheck("Fill--jksk_own_edit")) {
    $("div.viewTable").remove();
  } else {
    $("div.editTable").remove();
  }
}

function controlHiddenFields() {
  if (needsCheck("Fill--jksk_own_edit")) {
    $("div.bossHiddenField").remove();
  } else {
    $("div.honninHiddenField").remove();
  }
}

/**
 * プログラミングに関する質問欄の項目表示・非表示
 */
function controlProgramingQuesArea() {
  // 「ハッカソン～」欄の制御
  var val = _data.fill.jksk_skill_prog_ques_02;
  var $elem = $("#jksk_skill_prog_ques_02");
  if ($elem.length === 0) {
    return;
  }

  var tagName = $elem[0].tagName.toUpperCase();
  if (tagName === "TD") {
    controlVisibleElementsById(val, "あり", $("td#jksk_skill_prog_ques_03 div"));
  } else if (tagName === "SELECT") {
    controlVisibleElementsById(val, "あり", $("textarea#jksk_skill_prog_ques_03"));
  }

  // 「OSS～」欄の制御
  val = _data.fill.jksk_skill_prog_ques_05;
  $elem = $("#jksk_skill_prog_ques_05");
  if ($elem.length === 0) {
    return;
  }

  tagName = $elem[0].tagName.toUpperCase();
  if (tagName === "TD") {
    controlVisibleElementsById(val, "あり", $("td#jksk_skill_prog_ques_06 div"));
  } else if (tagName === "SELECT") {
    controlVisibleElementsById(val, "あり", $("textarea#jksk_skill_prog_ques_06"));
  }
}

/**
 * プログラミングスキル＆利用経験のデフォルト設定
 */
function setProgramingSkillRadioBtn() {
  var status = _data.sheet.statusCd;
  if (status === "00-New") {
    for (var i = 1; i <= 20; i++) {
      var idx = ("0" + i).slice(-2);
      var skill = _data.fill["jksk_skill_prog_type_" + idx + "_lv"];

      if (skill === "") {
        $("input[name='Fill--jksk_skill_prog_type_" + idx + "_lv']:eq(0)").prop("checked", true);
      }

      var used = _data.fill["jksk_skill_prog_type_" + idx + "_keiken"];
      if (used === "") {
        $("input[name='Fill--jksk_skill_prog_type_" + idx + "_keiken']:eq(0)").prop("checked", true);
      }
    }
  }
}

/**
 * プログラミングスキルの「その他」欄の未入力チェック
 *   プログラミングスキルの「その他」言語欄のいずれかが入力されているときの未入力チェック
 *   「プログラミングスキルをお持ちですか？」が、"ある"の場合のみチェックを実施する
 */
function checkOtherProgramLanguage() {
  var prgAns = _data.fill.jksk_skill_prog_ques_01;

  if (prgAns === "ある") {
    var langName = _data.fill.jksk_skill_prog_type_other_nm;
    var langLevel = _data.fill.jksk_skill_prog_type_other_lv;
    var langExp = _data.fill.jksk_skill_prog_type_other_keiken;

    if (!((langName === "" && langLevel === "" && langExp === "") || (langName !== "" && langLevel !== "" && langExp !== ""))) {
      if (langName === "") {
        $("td#jksk_skill_prog_type_other_nm").addClass("error");
      }
      if (langLevel === "") {
        $("td#jksk_skill_prog_type_other_lv_noexp").addClass("error");
        $("td#jksk_skill_prog_type_other_lv_shoky").addClass("error");
        $("td#jksk_skill_prog_type_other_lv_chuky").addClass("error");
        $("td#jksk_skill_prog_type_other_lv_jouky").addClass("error");
      }
      if (langExp === "") {
        $("td#jksk_skill_prog_type_other_keiken").addClass("error");
      }
      return false;
    }
  }
  return true;
}

/**
 * 管理職希望欄の表示・非表示制御
 * 　「クラスB名称」が、CSM_SHEET_PARAM#jksk_kanrisyoku_grade_@@（@@は、00から始まる連番）に定義されている場合、
 * 　「将来管理職になりたいですか？」の欄を表示し、定義されていないときは非表示にする。
 */
function controlKanrisyokuKibouArea() {
  var i = 0;
  var idx;
  var grade;
  var bFind;

  bFind = false;
  while(true) {
    i += 1;
    idx = ("0" + i).slice(-2);

    grade = _data.param["jksk_kanrisyoku_grade_" + idx];
    if (grade === undefined) {
      break;
    } else {
      if (_data.sheet.clsBNm === grade) {
        bFind = true;
        break;
      }
    }
  }
  if (!bFind) {
    $("#jkskCar3yrAns04Area").remove();
  }
}

/**
 * スキルレベル子画面を表示する
 *
 * @param {*} type 表示する子画面の種類
 *              1 : 語学スキル
 *              2 : Excelレベル
 *              3 : Accessレベル
 *              4 : プログラミングレベル
 * @param {*} width ウィンドウ幅
 * @param {*} height ウィンドウ高さ
 */
function dispSkillLevelSubWindow(type, width, height) {
  var elementId;

  switch(type) {
    case "1" :
      elementId = "LangLevelSubWnd";
      break;
    case "2" :
      elementId = "ExcelLevelSubWnd";
      break;
    case "3" :
      elementId = "AccessLevelSubWnd";
      break;
    case "4" :
      elementId = "ProgLevelSubWnd";
      break;
    default :
      elementId = "";
      break;
  }

  if (elementId !== "") {
    var option =
      "width=" + width +
      ",height=" + height +
      ",location=no" +
      ",scrollbars=no";

    var wnd = window.open("../view/sheet/module/CsMd-JkskSkillMsg.jsp", "_blank", option);

    var html = $("div#" + elementId).html();
    var timerId = setInterval(function() {
      var element = wnd.$("div#SkillLevelContent");
      if (element.length > 0) {
        clearInterval(timerId);
        element.append(html);
      }
    }, 100);
  }
}

function makeRequestParamFromDisabledFields() {
  $("#disabledHiddenArea").empty();

  $(":disabled").each(function() {
    var ctrlname = $(this).attr("name");
    var val;

    // ラジオボタンを除いたdisabledのフィールド用のhideen項目を作成
    var ctrlType = $(this).attr("type");
    if (ctrlType === undefined || ctrlType.toUpperCase() !== "RADIO") {
      $("<input>").attr({
        type: 'hidden',
        name: ctrlname,
        value: val
      }).appendTo("#disabledHiddenArea");
    }
  });

  // 「プログラミングスキルをお持ちですか？」が、「ない」に設定されているとき
  var $elem = $("#jksk_skill_prog_ques_01");
  if ($elem.length !== 0 && $elem.val() === "ない") {
    // プログラミングスキル1～20とその他を初期化する
    for (var i = 0; i <= 20; i++) {
      var idx = ("0" + i).slice(-2);

      // プログラミングスキル
      $("<input>").attr({
        type: 'hidden',
        name: 'Fill--jksk_skill_prog_type_' + idx + '_lv',
        value: "なし"
      }).appendTo("#disabledHiddenArea");

      // 業務利用
      $("<input>").attr({
        type: 'hidden',
        name: 'Fill--jksk_skill_prog_type_' + idx + '_keiken',
        value: "利用なし"
      }).appendTo("#disabledHiddenArea");
    }

    // 「その他」の初期化
    $("<input>").attr({
      type: 'hidden',
      name: 'Fill--jksk_skill_prog_type_other_nm',
      value: ""
    }).appendTo("#disabledHiddenArea");

    $("input[name='Fill--jksk_skill_prog_type_other_lv']").val("");
    $("input[name='Fill--jksk_skill_prog_type_other_keiken']").val("");
  }

  return true;
}
