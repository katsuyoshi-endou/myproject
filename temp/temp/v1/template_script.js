$(function(){
	$document = $(document);
	

	/* Excelダウンロードボタン */
	var xlBtnid = _data["sheet"].layoutCd;
	if ( xlBtnid == "lay-cpln-v1" ){
		$(".xlDownload").attr("id", "CPLN");
	}
	else if ( xlBtnid == "lay-mkhy-v1" ){
		$(".xlDownload").attr("id", "MKHY");
	}
    else if ( xlBtnid == "lay-jksk-v1" ){
		$(".xlDownload").attr("id", "JKSK");
	}
	else if ( xlBtnid == "lay-skill-v1" ){
		$(".xlDownload").attr("id", "SKILL");
	}
	else {
		$(".xlDownload").remove();
	}
  
  
	/* 編集ボタン */
	$('button.cspe').each(function(){
		var chkfilid = "Fill--" + $(this).attr("data-cspe") + "_edit"; 
		if ( $.inArray( chkfilid, writeFillList ) == -1 ) {
			$(this).remove();
		}
	})
	
	 /* 補正 */
	$(function(){
		$(document).on( 'blur', '.weight input', function(){
			$(this).val( pretty0to100( $(this).val() ) );
			autoCalcMokHyo();
			autoCalcWeight();
		});
	});
	
	/* jRange */
	if ($('.tmpl-mrls').exists()) {
		mrlsInitJRange();
	}
	
	/*フィードバックグラフ*/
	if ($('.skillGraph').exists()) {
		drawSkillRadarGraph();
		drawSkillHorizontalGraph();
	}

	/*推奨研修・あなたのスキルレベル表示*/
	if ($('.FeedbackTable').exists()) {
		colorChangeSkillFeedback();
	}
	
	 /* Auto Calc */
	if ($('.autoCalcMok').exists()) {
		autoCalcMokHyo();
		autoCalcWeight();
  }

  // SB 用(編集画面タブ切換え)
	var tabpages = $('.tabpage');
  tabpages.hide();
  var tabId = "tab01"; //編集画面ではtab01が初期値として設定とする。
	$('#'+tabId).addClass("active");
  $('.tabpage.'+tabId).addClass("active").show();
  
  // SB 用(編集画面タブ切換え)
  $document.on("click", ".cstab ul li a",function(event) {
    event.preventDefault();
    tabpages.hide();
    $(".cstab ul li").removeClass("active");
    var nextCls = "." + $(this).parent().attr("id");// tab01
    var nextId  = "#" + $(this).parent().attr("id");// tab01
    $(nextCls).show();
    $(nextId).addClass("active");
  });
  
  // SB日付
  // $(".datepicker").datepicker({
	// 	//showButtonPanel: true,
	// 	changeYear: true,
	// 	changeMonth: true
	// 	//minDate: "-1M",
	// 	//maxDate: "+1M",
	// 	//firstDay: 1
	// });
	// $('.datepicker').datepicker("option", "dateFormat", 'yy/mm/dd' );

	$document.on( 'change', '.autoCalcMok select', function(){
		autoCalcMokHyo();
		autoCalcWeight();
	});
	$document.on( 'blur', '.autoCalcMok input', function(){
		autoCalcMokHyo();
		autoCalcWeight();
	});
	
	if ($('.autoCalcSKill').exists()) {
		autoCalcWeightSkill();
	}
	$document.on( 'blur', 'input.autoCalcSKill', function(){
		autoCalcWeightSkill();
	});
});	

function mrlsInitJRange() {
	$('input.jrange').jRange({
		from: 1,
		to: 5,
		step: 1,
		scale: [1,2,3,4,5],
		format: '%s',
		width: 300,
		showLabels: false,
		snap: true
	});
	$('.jrange-disable').jRange('disable');
}

	


function errMsg(msgID) {
	var labels = _data["label"];
	var msgs = {
	"MkhyMokErrorMsg" : labels["MkhyMokErrorMsg"],
	"MkhyWeiErrorMsg" : labels["MkhyWeiErrorMsg"],
	"MkhyHyHErrorMsg" : labels["MkhyHyHErrorMsg"],
	"MkhyHyBErrorMsg" : labels["MkhyHyBErrorMsg"],
	"MkhyHyFErrorMsg" : labels["MkhyHyFErrorMsg"],
	"CplnErrorChkMsg" : labels["CplnErrorChkMsg"],
	"MrlsErrorChkMsg" : labels["MrlsErrorChkMsg"],
	}
	return msgs[msgID];
}





  

function autoCalcMokHyo() {
	var hyoSumOwn = new Decimal(0);
	var hyoSumBos = new Decimal(0);
	$('.oneMokuhyo').each(function(){
		$area = $(this);
		var mltRsltOwn = new Decimal(1);
		var mltRsltBos = new Decimal(1);
		$(".mok_hyo_own_mlti_tgt", $area).each(function(){
			var pointOwn = new Decimal(getCellNum( $(this) ));
			mltRsltOwn = mltRsltOwn.times(pointOwn);
		})
		hyoSumOwn = hyoSumOwn.plus(mltRsltOwn);
		if (mltRsltOwn == 0){
			$(".mok_hyo_own_mlti_rslt", $area).text("")
		} else {
			$(".mok_hyo_own_mlti_rslt", $area).text(mltRsltOwn.toFixed(2))
		}
		$(".mok_hyo_bos_mlti_tgt", $area).each(function(){
			var pointBos = new Decimal(getCellNum( $(this) ));
			mltRsltBos = mltRsltBos.times(pointBos);
		})
		hyoSumBos = hyoSumBos.plus(mltRsltBos);
		if (mltRsltBos == 0){
			$(".mok_hyo_bos_mlti_rslt", $area).text("")
		} else {
			$(".mok_hyo_bos_mlti_rslt", $area).text(mltRsltBos.toFixed(2))
		}
	});
	if (hyoSumOwn == 0){
		$(".mok_hyo_own_sum_rslt").text("");
	} else {
		$(".mok_hyo_own_sum_rslt").text(hyoSumOwn.toFixed(2));
	}
	if (hyoSumBos == 0){
		$(".mok_hyo_bos_sum_rslt").text("");
	} else {
		$(".mok_hyo_bos_sum_rslt").text(hyoSumBos.toFixed(2));
	}
}


function autoCalcWeight() {
	var weightSum = new Decimal(0);
	$('.mok_wght_sum_tgt').each(function(){
		var weight = new Decimal(getCellNum( $(this) ));
		weightSum = weightSum.plus(weight);
	})
	if (weightSum == 0){
		$(".mok_wght_sum_rslt").text("");
	} else {
		$(".mok_wght_sum_rslt").text(weightSum.toFixed(0));
	}
}

function customPartialEditCheck(cspe, cspearg) {
	return true;
}

function customForwardCheck() {
	try {
		if ( _data["sheet"].layoutCd == 'lay-mkhy-v1' ){
			if (needsCheck("Fill--chk_necessary_mkhy_mok_hon")) {
				/* 目標設定未入力チェック */
				chkEmpMok();
				/* ウェイトチェック */
				chkWeight100();
			}
			if (needsCheck("Fill--chk_necessary_mkhy_hyo_hon")) {
				/* 評価(本人)未入力チェック */
				chkEmpHyoOwn();
			}
			if (needsCheck("Fill--chk_necessary_mkhy_hyo_bos")) {
				/* 評価(本人)未入力チェック */
				chkEmpHyoBos();
			}
			/* 評価結果チェック */
			if (needsCheck("Fill--chk_necessary_mkhy_hyo_fin_1st")) {
				chkEmpHyoFinal("chkEmpty_hyo_final_1st");
			}
			if (needsCheck("Fill--chk_necessary_mkhy_hyo_fin_2nd")) {
				chkEmpHyoFinal("chkEmpty_hyo_final_2nd");
			}
			if (needsCheck("Fill--chk_necessary_mkhy_hyo_fin_3rd")) {
				chkEmpHyoFinal("chkEmpty_hyo_final_3rd");
			}
		}
		if ( _data["sheet"].layoutCd == 'lay-mrls-v1' ){
			if (needsCheck("Fill--chk_necessary_mrls")) {
				/* モラルサーベイ必須チェック */
				chkEmpMrl();
			}
		}
		if ( _data["sheet"].layoutCd == 'lay-cpln-v1' ){
			if (needsCheck("Fill--chk_necessary_cpln")) {
				/* キャリアプラン必須チェック */
				chkEmpCpln();
			}
		}
	} catch (e) {
		alert(e);
		return false;
	}
	return true;
}

function chkEmpMok() {
	var chkRst = true;
	$("[class*='chkMkhyArea']").each(function(){ 	
		var isAllBlank = true;
		var $chkEmptyMok = $(".chkEmpty_mok", this);
		var mokNum = $(this).attr("class").substr(19,2);
		var mokViewClassNm = "chkMkhyView" + mokNum;
		$chkEmptyMok.each(function(){ 
			if( !(_.isEmpty( $.trim($(this).text()) ))){
				isAllBlank = false;
			}
		})
		//全て未入力の場合はチェック不要
		if (!isAllBlank){
			$chkEmptyMok.each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})	
			$(".chkEmpty_mok", '.' + mokViewClassNm).each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})	
		}	
	})
	if (!chkRst){
		throw errMsg("MkhyMokErrorMsg");
	}
}

function chkWeight100() {
    var wght_sum = _data["fill"]["mkhy_konki_ichiran_weight_sum_san"];
	if (_.isEmpty(wght_sum)) {
		return true;
	} else {
		wght_sum = new Decimal(wght_sum);
	}
	if (wght_sum != 100) {
	　　//エラークラスの付与
		$(".mokWeight").each(function(){ 
		    $(this).addClass("error");
		 })
		throw errMsg("MkhyWeiErrorMsg");
	}
}

function chkEmpHyoOwn() {
	var chkRst = true;
	$("[class*='chkMkhyArea']").each(function(){ 	
		var isAllBlank = true;
		var $chkEmptyMok = $(".chkEmpty_hyo_own", this);
		var mokNum = $(this).attr("class").substr(19,2);
		var mokViewClassNm = "chkMkhyView" + mokNum;
		$chkEmptyMok.each(function(){ 
			if( !(_.isEmpty( $.trim($(this).text()) ))){
				isAllBlank = false;
			}
		})
		//全て未入力の場合はチェック不要
		if (!isAllBlank){
			$chkEmptyMok.each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})	
			$(".chkEmpty_hyo_own", '.' + mokViewClassNm).each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})	
		}	
	})
	if (!chkRst){
		throw errMsg("MkhyHyHErrorMsg");
	}
}

function chkEmpHyoBos() {
	var chkRst = true;
	$("[class*='chkMkhyArea']").each(function(){ 	
		var isAllBlank = true;
		var $chkEmptyMok = $(".chkEmpty_hyo_bos", this);
		var mokNum = $(this).attr("class").substr(19,2);
		var mokViewClassNm = "chkMkhyView" + mokNum;
		$chkEmptyMok.each(function(){ 
			if( !(_.isEmpty( $.trim($(this).text()) ))){
				isAllBlank = false;
			}
		})
		//全て未入力の場合はチェック不要
		if (!isAllBlank){
			$chkEmptyMok.each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})
			$(".chkEmpty_hyo_bos", '.' + mokViewClassNm).each(function(){ 
				if( _.isEmpty( $.trim($(this).text()) )){
					chkRst = false;
					$(this).addClass("error");
				}
			})	
		}	
	})
	if (!chkRst){
		throw errMsg("MkhyHyBErrorMsg");
	}
}

function chkEmpHyoFinal(classNm) {
	var $chkHyoka = $("." + classNm);
	if( _.isEmpty( $.trim($chkHyoka.text()) )){
		$chkHyoka.addClass("error");
		throw errMsg("MkhyHyFErrorMsg");
	}
}

function chkEmpMrl() {
	var chkRst = true;
	$(".chkEmpty_mrls").each(function(){ 	
		if( _.isEmpty( $.trim($(this).text()) )){
			chkRst = false;
			$(this).addClass("error");
		}
	})
	if (!chkRst){
		throw errMsg("MrlsErrorChkMsg");
	}
}

function chkEmpCpln() {
	var chkRst = true;
	$(".chkEmpty_cpln").each(function(){ 	
		if( _.isEmpty( $.trim($(this).text()) )){
			chkRst = false;
			$(this).addClass("error");
		}
	})
	if (!chkRst){
		throw errMsg("CplnErrorChkMsg");
	}
}


function autoCalcWeightSkill() {
  var weightSum = 0;
  $('.skill_wght_sum_tgt').each(function(i,e){
    var num = Number($(e).val());
    weightSum = weightSum + num;
  })
  if (weightSum == 0){
    $(".skill_wght_sum_rslt").text("");
  } else {
    $(".skill_wght_sum_rslt").text(weightSum);
  }
}

function customForwardCheck(actioncd) {
/* スキル申請時必須チェック */
  var result = true;
  console.log(actioncd);
  if ( _data["sheet"].layoutCd == 'lay-skill-v1' || _data["sheet"].layoutCd == 'lay-gymkn-v1'){
    if(actioncd == "FORWARD"){
      if (needsCheck("Fill--chk_necessary_skill")) {
        result = chkEmpZenTab();
      } else if(needsCheck("Fill--chk_necessary_gymkn")) {
        result = checkGyomuKbnTab();
      }
    }
  }
  return result;
}

function customPartialEditCheck(cspe, cspearg) {
/* スキル保存時必須チェック */
  $('.sheet-section .chkNG').removeClass('chkNG');
  var result = true;
  if(cspe ===  "skill_gyomukbn"){
    result = checkSkillGyomukbn();
  }
  if(cspe ===  "skill_zokusei"){
    result = checkSkillZokusei();
  }
  if(cspe ===  "skill_check"){
    result = checkSkillCheck();
  }
  if(cspe === "gymkn_gyomukbn") {
    result = checkGyomuGyomuKbn();
  }
  return result;
}

/*
  業務区分調査シートの申請ボタン押下時、業務区分調査タブチェック
    ウェイト合計値のチェック
    担当業務内容の入力チェック
*/
function checkGyomuKbnTab() {
  $('.chkEmpTantoGyomu').removeClass("error");
  $('.skill_wght_sum_rslt').removeClass("error");

  var val = $('.chkEmpTantoGyomu').text();
  if(_.isEmpty(val)){
    $('.chkEmpTantoGyomu').addClass("error");
    alert('担当業務を選択してください。');
    return false;
  }

  val = $('.skill_wght_sum_rslt').text();
  if(_.isEmpty(val)){
    $('.skill_wght_sum_rslt').addClass("error");
    alert('ウェイトを入力してください。');
    return false;
  }
  return true;
}

/*
  業務区分調査シートの担当業務内容の入力チェック
*/
function checkGyomuTantoGyomu() {
  var $this = $('.chkEmpSkillZokusei');

  var errorflg = true;
  var v = $this.val();
  if(_.isEmpty(v)){
    $this.addClass("chkNG");
    errorflg = false;
  }
  if (!errorflg){
    alert("担当業務を選択してください。");
    return false;
  }
  return true;
}

/*
  業務区分調査シートの「保存」ボタン押下時チェック
    ウェイトの合計値チェック
    担当業務内容の入力チェック
*/
function checkGyomuGyomuKbn() {
  if(!checkGyomuTantoGyomu()) {
    return false;
  }

  $('.skill_wght_sum_rslt').removeClass("error");
  var errorflg = true;
  var wght_sum = $('.skill_wght_sum_rslt').text();
  if (_.isEmpty(wght_sum)) {
    errorflg = false;
  } else {
    wght_sum = new Decimal(wght_sum);
  }
  if (wght_sum != 100) {
    errorflg = false;
  }
  if(!errorflg){
    //エラークラスの付与
    $('.skill_wght_sum_rslt').addClass("error");
    alert("ウェイト合計が100%になるようにウェイトを入力してください。");
    return false;
  }
  return true;
}

function checkSkillGyomukbn() {
  var result = true;
  //result = chkSeinoSeisuSkillGyomuKbn();
  //if(result){
  result = chkWeight100SkillGyomuKbn();
  //}
  return result;
}

function checkSkillZokusei() {
  var result = true;
  var isEmptyChkOk = true;

  var A = chkEmpSkillZokusei();
  var B = chkSetsumon09();
  var C = chkSetsumon11();
  var D = chkSetsumon12();
  
  isEmptyChkOk = A && B && C && D;
  if(!isEmptyChkOk){
    alert("属性調査設問にすべて回答してください。");
    result = isEmptyChkOk;
  }
  else {
    result = chkSeinoSeisuSkillZokusei();
    if(result) {
      result = chkHaniSkillZokusei();
      if(result) {
        result = chkMujunSkillZokusei01();
        if(result) {
          result = chkMujunSkillZokusei02();
          if(result) {
            result = chkHaniSkillZokuseiNenGetsu();
          }
        }
      }
    }
  }
  return result;
}

function checkSkillCheck() {
  var result = true;
  result = chkEmpSkillSkill();
  if(result){
    result = chkKuhakuSkillSkillBosComment();
  }
  return result;
}

function chkEmpZenTab() {
  if(_data["sheet"].statusCd == "00-New"){

    var errorflg = true;
    $(".chkEmpZenTabHon").each(function(i,e){
      if( _.isEmpty( $.trim($(this).text()) )){
        errorflg = false;
      }
    })
    if (!errorflg){
      alert("未入力タブが存在します。")
      return false;
    }
    return true;
  }
  if(_data["sheet"].statusCd == "01-Check1st" || _data["sheet"].statusCd =="02-Check2nd"){
    var errorflg = true;
    $(".chkEmpZenTabHyo").each(function(i,e){
      if( _.isEmpty( $.trim($(this).text()) )){
        errorflg = false;
      }
    })
    if (!errorflg){
      alert("未入力タブが存在します。")
      return false;
    }
    return true;
  }
}

function chkWeight100SkillGyomuKbn() {
  errorflg = true;
  var wght_sum = $('.skill_wght_sum_rslt').text();
  if (_.isEmpty(wght_sum)) {
    errorflg = false;
  } else {
    wght_sum = new Decimal(wght_sum);
  }
  if (wght_sum != 100) {
    errorflg = false;
  }
  if(!errorflg){
    //エラークラスの付与
    $('.skill_wght_sum_rslt').addClass("error");
    alert("業務区分調査のウェイト合計が100%になるようにウェイトを入力してください。");
    return false;
  }
  return true;
}

function chkEmpSkillZokusei() {
  var errorflg = true;
  $('.chkEmpSkillZokusei').each(function(i,e){
    var v = $(e).val();
    if(_.isEmpty(v)){
      $(this).addClass("chkNG");
      errorflg = false;
    };
  })
  if (!errorflg){
    return false;
  }
  return true;
}

function chkSetsumon09() {
  var hasCheck = $('.chkSetsumon09 input:checked').exists();
  var isSonota = !($.trim($('.chkEmpSkillZokuseiTextOther01').val()) === "");
  if(!(hasCheck || isSonota)){
    $('.chkSetsumon09').addClass('chkNG');
    $('.chkEmpSkillZokuseiTextOther01').addClass('chkNG');
  }
  return hasCheck || isSonota;
}

function chkSetsumon11() {
  var hasCheck = $('.chkSetsumon11 input:checked').exists();
  var isSonota = !($.trim($('.chkEmpSkillZokuseiTextOther02').val()) === "");
  if(!(hasCheck || isSonota)){
    $('.chkSetsumon11').addClass('chkNG');
    $('.chkEmpSkillZokuseiTextOther02').addClass('chkNG');
  }
  return hasCheck || isSonota;
}

function chkSetsumon12() {
  var hasCheck = $('.chkSetsumon12 input:checked').exists();
  var isSonota = !($.trim($('.chkEmpSkillZokuseiTextOther03').val()) === "");
  if(!(hasCheck || isSonota)){
    $('.chkSetsumon12').addClass('chkNG');
    $('.chkEmpSkillZokuseiTextOther03').addClass('chkNG');
  }
  return hasCheck || isSonota;
}

function chkSeinoSeisuSkillZokusei() {
  var errorflg = false;
  $('.skill_zokusei_seinoseisu').each(function(i,e){
    var v = $(e).val();
    if(!_.isEmpty(v)){
      if(!/^([1-9]\d*|0)$/.test(v)){
        $(e).addClass('chkNG');
        errorflg = true;
      }
    }
  });
  if(errorflg){
    alert("正の整数を入力してください。");
    return false;
  }
  return true; 
}

function chkHaniSkillZokusei() {
  var errorflg = false;
  $('.skill_zokusei_hani').each(function(i,e){
    var v = $(e).val();
    if(!_.isEmpty(v)){
      if(!(1950 <= v && 2030 >= v)){
        errorflg = true;
        $(this).addClass('chkNG');
      }
    }
  });
  if(errorflg){
    alert('設問6の数値を見直してください。');
    return false;
  }
  return true;
}

function chkMujunSkillZokusei01() {
  if($('input[name=Fill--skill_zokusei_09_chotatsu]').prop("checked")){
    var count = 0;
    $('.chkEmpSkillZokuseiChkBx01').each(function(i,e){
      if($(this).prop("checked")){
        count = count + 1;
      }
    })
    $('.chkEmpSkillZokuseiTextOther01').each(function(i,e){
      var v = $(e).val();
      if(!_.isEmpty(v)){
        count = count + 1;
      }
    })
    if(count > 1){
      //$('input[name=Fill--skill_zokusei_09_chotatsu]').closest('.checkbox').addClass('chkNG');
      alert("設問9または設問11で「調達業務以外は経験していない」、「所有資格なし」を選択している場合は、他項目を選択しないでください。");
      return false;
    }
  }
  return true;
}

function chkMujunSkillZokusei02() {
  if($('input[name=Fill--skill_zokusei_11_sikakunashi]').prop("checked")){
    var count = 0;
    $('.chkEmpSkillZokuseiChkBx02').each(function(i,e){
      if($(this).prop("checked")){
        count = count + 1;
      }
    })
    $('.chkEmpSkillZokuseiTextOther02').each(function(i,e){
      var v = $(e).val();
      if(!_.isEmpty(v)){
        count = count + 1;
      }
    })
    if(count > 1){
      //$('input[name=Fill--skill_zokusei_11_sikakunashi]').closest('.checkbox').addClass('chkNG');
      alert("設問9または設問11で「調達業務以外は経験していない」、「所有資格なし」を選択している場合は、他項目を選択しないでください。");
      return false;
    }
  }
  return true;
}

function chkHaniSkillZokuseiNenGetsu() {
  var errorflg = false;
  $('.skill_zokusei_hani_Nen').each(function(i,e){
    var v = $(e).val();
    if(!_.isEmpty(v)){
      if(!( 0 <= v && 99 >= v)){
        errorflg = true;
        $(this).addClass('chkNG');
      }
    }
  });
  $('.skill_zokusei_hani_Getsu').each(function(i,e){
    var v = $(e).val();
    if(!_.isEmpty(v)){
      if(!( 0 <= v && 11 >= v)){
        errorflg = true;
        $(this).addClass('chkNG');
      }
    }
  });
  if(errorflg){
    alert('設問7の数値を見直してください。');
    return false;
  }
  return true;
}

function chkEmpSkillSkill() {
  var errorflg = true;
  if(_data["sheet"].statusCd == "00-New"){
    $('.chkEmpSkillSkill').each(function(i,e){
      var v = $(e).val();
      if(_.isEmpty(v)){
        $(this).addClass("chkNG");
        errorflg = false;
      };
    })
    if (!errorflg){
      alert("調達スキルチェックをすべて記入してください。");
      return false;
    }
    return true;
  }

  if(_data["sheet"].statusCd == "01-Check1st" || _data["sheet"].statusCd =="02-Check2nd"){
    $('.chkEmpSkillSkillHyo').each(function(i,e){
      var v = $(e).val();
      if(_.isEmpty(v)){
        $(this).addClass("chkNG");
        errorflg = false;
      };
    })
    if (!errorflg){
      alert("調達スキルチェックをすべて記入してください。");
      return false;
    }
    return true;
  }
}

function chkKuhakuSkillSkillBosComment() {
  if(_data["sheet"].statusCd == "01-Check1st" || _data["sheet"].statusCd =="02-Check2nd"){
    var errorflg = true;
    var v = $('textarea[name=Fill--skill_bos_comment]').val()
    if(_.isEmpty(v) || /^[\s]+$/.test(v)){
      $('textarea[name=Fill--skill_bos_comment]').addClass("chkNG");
      errorflg = false;
    }
    if(!errorflg){
      alert('上司コメントを正しく入力してください。')
      return false;
    }
  }
  return true;
}

function colorChangeSkillFeedback() {
  // 昨年度(本人)と今年度(本人)比較
  if(!(_data["fill"]["skill_csr_hyo_sak"] === "")){
    if(_data["fill"]["skill_csr_hyo_kon"] < _data["fill"]["skill_csr_hyo_sak"]){
      $("td[name=skill_csr_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_csr_hyo_kon"] > _data["fill"]["skill_csr_hyo_sak"]){
      $("td[name=skill_csr_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_senryaku_hyo_kon"] < _data["fill"]["skill_senryaku_hyo_sak"]){
      $("td[name=skill_senryaku_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_senryaku_hyo_kon"] > _data["fill"]["skill_senryaku_hyo_sak"]){
      $("td[name=skill_senryaku_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_kaihatsukobai_hyo_kon"] < _data["fill"]["skill_kaihatsukobai_hyo_sak"]){
      $("td[name=skill_kaihatsukobai_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_kaihatsukobai_hyo_kon"] > _data["fill"]["skill_kaihatsukobai_hyo_sak"]){
      $("td[name=skill_kaihatsukobai_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_chotatsukanren_hyo_kon"] < _data["fill"]["skill_chotatsukanren_hyo_sak"]){
      $("td[name=skill_chotatsukanren_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_chotatsukanren_hyo_kon"] > _data["fill"]["skill_chotatsukanren_hyo_sak"]){
      $("td[name=skill_chotatsukanren_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_chotatsugyomu_hyo_kon"] < _data["fill"]["skill_chotatsugyomu_hyo_sak"]){
      $("td[name=skill_chotatsugyomu_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_chotatsugyomu_hyo_kon"] > _data["fill"]["skill_chotatsugyomu_hyo_sak"]){
      $("td[name=skill_chotatsugyomu_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_global_hyo_kon"] < _data["fill"]["skill_global_hyo_sak"]){
      $("td[name=skill_global_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_global_hyo_kon"] > _data["fill"]["skill_global_hyo_sak"]){
      $("td[name=skill_global_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_kansetsu_hyo_kon"] < _data["fill"]["skill_kansetsu_hyo_sak"]){
      $("td[name=skill_kansetsu_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_kansetsu_hyo_kon"] > _data["fill"]["skill_kansetsu_hyo_sak"]){
      $("td[name=skill_kansetsu_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_seisan_hyo_kon"] < _data["fill"]["skill_seisan_hyo_sak"]){
      $("td[name=skill_seisan_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_seisan_hyo_kon"] > _data["fill"]["skill_seisan_hyo_sak"]){
      $("td[name=skill_seisan_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
      if(_data["fill"]["skill_chotatsujyoho_kiban_hyo_kon"] < _data["fill"]["skill_chotatsujyoho_kiban_hyo_sak"]){
      $("td[name=skill_chotatsujyoho_kiban_hyo_kon]").css('backgroundColor', '#88C6F2');
    }
      if(_data["fill"]["skill_chotatsujyoho_kiban_hyo_kon"] > _data["fill"]["skill_chotatsujyoho_kiban_hyo_sak"]){
      $("td[name=skill_chotatsujyoho_kiban_hyo_kon]").css('backgroundColor', '#FF7E5E');
    }
  }

  // 昨年度(上司)※非表示 と今年度(上司)比較
  if(!(_data["fill"]["skill_csr_hyo_bos"] === "")){
    if(!(_data["fill"]["skill_csr_hyo_sak_bos"] === "")){
      if(_data["fill"]["skill_csr_hyo_bos"] < _data["fill"]["skill_csr_hyo_sak_bos"]){
        $("td[name=skill_csr_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_csr_hyo_bos"] > _data["fill"]["skill_csr_hyo_sak_bos"]){
        $("td[name=skill_csr_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_senryaku_hyo_bos"] < _data["fill"]["skill_senryaku_hyo_sak_bos"]){
        $("td[name=skill_senryaku_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_senryaku_hyo_bos"] > _data["fill"]["skill_senryaku_hyo_sak_bos"]){
        $("td[name=skill_senryaku_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_kaihatsukobai_hyo_bos"] < _data["fill"]["skill_kaihatsukobai_hyo_sak_bos"]){
        $("td[name=skill_kaihatsukobai_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_kaihatsukobai_hyo_bos"] > _data["fill"]["skill_kaihatsukobai_hyo_sak_bos"]){
        $("td[name=skill_kaihatsukobai_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_chotatsukanren_hyo_bos"] < _data["fill"]["skill_chotatsukanren_hyo_sak_bos"]){
        $("td[name=skill_chotatsukanren_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_chotatsukanren_hyo_bos"] > _data["fill"]["skill_chotatsukanren_hyo_sak_bos"]){
        $("td[name=skill_chotatsukanren_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_chotatsugyomu_hyo_bos"] < _data["fill"]["skill_chotatsugyomu_hyo_sak_bos"]){
        $("td[name=skill_chotatsugyomu_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_chotatsugyomu_hyo_bos"] > _data["fill"]["skill_chotatsugyomu_hyo_sak_bos"]){
        $("td[name=skill_chotatsugyomu_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_global_hyo_bos"] < _data["fill"]["skill_global_hyo_sak_bos"]){
        $("td[name=skill_global_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_global_hyo_bos"] > _data["fill"]["skill_global_hyo_sak_bos"]){
        $("td[name=skill_global_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_kansetsu_hyo_bos"] < _data["fill"]["skill_kansetsu_hyo_sak_bos"]){
        $("td[name=skill_kansetsu_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_kansetsu_hyo_bos"] > _data["fill"]["skill_kansetsu_hyo_sak_bos"]){
        $("td[name=skill_kansetsu_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_seisan_hyo_bos"] < _data["fill"]["skill_seisan_hyo_sak_bos"]){
        $("td[name=skill_seisan_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_seisan_hyo_bos"] > _data["fill"]["skill_seisan_hyo_sak_bos"]){
        $("td[name=skill_seisan_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
        if(_data["fill"]["skill_chotatsujyoho_kiban_hyo_bos"] < _data["fill"]["skill_chotatsujyoho_kiban_hyo_sak_bos"]){
        $("td[name=skill_chotatsujyoho_kiban_hyo_bos]").css('backgroundColor', '#88C6F2');
      }
        if(_data["fill"]["skill_chotatsujyoho_kiban_hyo_bos"] > _data["fill"]["skill_chotatsujyoho_kiban_hyo_sak_bos"]){
        $("td[name=skill_chotatsujyoho_kiban_hyo_bos]").css('backgroundColor', '#FF7E5E');
      }
    }
  }
}

function drawSkillRadarGraph(){
  var f = _data["fill"];
  var p = _data["param"];
  var dsBos = {
    label: "今年度（上司）",
    backgroundColor: "rgba(153, 102, 255, 0.2)",
    borderColor: "rgba(153, 102, 255, 0.8)",
    pointBackgroundColor: "rgba(153, 102, 255, 0.8)",
    pointBorderColor: "rgba(153, 102, 255, 0.8)",
    pointHoverBackgroundColor: "rgba(153, 102, 255, 0.8)",
    pointHoverBorderColor: "rgba(153, 102, 255, 0.8)",
    pointRadius: 1,
    borderWidth: 2,
    data: [
      f["skill_csr_hyo_bos"],
      f["skill_senryaku_hyo_bos"],
      f["skill_kaihatsukobai_hyo_bos"],
      f["skill_chotatsukanren_hyo_bos"],
      f["skill_chotatsugyomu_hyo_bos"],
      f["skill_global_hyo_bos"],
      f["skill_kansetsu_hyo_bos"],
      f["skill_seisan_hyo_bos"],
      f["skill_chotatsujyoho_kiban_hyo_bos"]
    ]
  };
  var dsKon = {
    label: "今年度（本人）",
    backgroundColor: "rgba(0, 176, 255, 0.2)",
    borderColor: "rgba(0, 176, 255, 0.8)",
    pointBackgroundColor: "rgba(0, 176, 255, 0.8)",
    pointBorderColor: "rgba(0, 176, 255, 0.8)",
    pointHoverBackgroundColor: "rgba(0, 176, 255, 0.8)",
    pointHoverBorderColor: "rgba(0, 176, 255, 0.8)",
    pointRadius: 1,
    borderWidth: 2,
    data: [
      f["skill_csr_hyo_kon"],
      f["skill_senryaku_hyo_kon"],
      f["skill_kaihatsukobai_hyo_kon"],
      f["skill_chotatsukanren_hyo_kon"],
      f["skill_chotatsugyomu_hyo_kon"],
      f["skill_global_hyo_kon"],
      f["skill_kansetsu_hyo_kon"],
      f["skill_seisan_hyo_kon"],
      f["skill_chotatsujyoho_kiban_hyo_kon"]
    ]
  };
  var dsSak = {
    label: "昨年度（本人）",
    backgroundColor: "rgba(255, 178, 0, 0.0)",
    borderColor: "rgba(255, 178, 0, 0.8)",
    pointBackgroundColor: "rgba(255, 178, 0, 0.4)",
    pointBorderColor: "rgba(255, 178, 0, 0.2)",
    pointHoverBackgroundColor: "rgba(255, 178, 0, 0.4)",
    pointHoverBorderColor: "rgba(255, 178, 0, 0.2)",
    pointRadius: 1,
    borderWidth: 1,
    data: [
      f["skill_csr_hyo_sak"],
      f["skill_senryaku_hyo_sak"],
      f["skill_kaihatsukobai_hyo_sak"],
      f["skill_chotatsukanren_hyo_sak"],
      f["skill_chotatsugyomu_hyo_sak"],
      f["skill_global_hyo_sak"],
      f["skill_kansetsu_hyo_sak"],
      f["skill_seisan_hyo_sak"],
      f["skill_chotatsujyoho_kiban_hyo_sak"]
    ]
  };
  var dsAvg = {
    label: "全社平均",
    backgroundColor: "rgba(255, 99, 132,0.0)",
    borderColor: "rgba(255, 99, 132,0.8)",
    pointBackgroundColor: "rgba(255, 99, 132,0.4)",
    pointBorderColor: "rgba(255, 99, 132,0.2)",
    pointHoverBackgroundColor: "rgba(255, 99, 132,0.4)",
    pointHoverBorderColor: "rgba(255, 99, 132,0.2)",
    pointRadius: 1,
    borderWidth: 1,
    data: [
      p["skill_csr_hyo_sak_avg"],
      p["skill_senryaku_hyo_sak_avg"],
      p["skill_kaihatsukobai_hyo_sak_avg"],
      p["skill_chotatsukanren_hyo_sak_avg"],
      p["skill_chotatsugyomu_hyo_sak_avg"],
      p["skill_global_hyo_sak_avg"],
      p["skill_kansetsu_hyo_sak_avg"],
      p["skill_seisan_hyo_sak_avg"],
      p["skill_chotatsujyoho_kiban_hyo_sak_avg"]
    ]
  };
  var useDataSets = [];
  if (dsBos.data[0] === "") { makeItTransparent(dsBos); }
  if (dsKon.data[0] === "") { makeItTransparent(dsKon); }
  if (dsSak.data[0] === "") { makeItTransparent(dsSak); }
  if (dsAvg.data[0] === "") { makeItTransparent(dsAvg); }
  useDataSets.push(dsBos);
  useDataSets.push(dsKon);
  useDataSets.push(dsSak);
  useDataSets.push(dsAvg);

  var ctx = document.getElementById("myRadarChart");
  var myRadarChart = new Chart(ctx, {
    type: 'radar',
    data: {
      labels: ["CSR", "戦略マネジメント", "開発購買", "調達関連知識", "調達実務", "グローバル調達", "間接材調達", "生産管理", "調達情報基盤"],
      datasets: useDataSets
    },
    options: {
      layout: {
        padding: 10
      },
      legend: {
        position: "top",
        labels: { fontSize: 11 }
      },
      scale: {
        gridLines: {
          color: "rgba(0,0,0,0.05)"
        },
        angleLines: {
          color: "rgba(0,0,0,0.05)"
        },
        ticks: {
          min: 1,
          max: 5
        }
      }
    }
  });
}

function makeItTransparent(d) {
  d["backgroundColor"] = "rgba(0,0,0,0)";
  d["borderColor"] = "rgba(0,0,0,0)";
  d["pointBackgroundColor"] = "rgba(0,0,0,0)";
  d["pointBorderColor"] = "rgba(0,0,0,0)";
  d["pointHoverBackgroundColor"] = "rgba(0,0,0,0)";
  d["pointHoverBorderColor"] = "rgba(0,0,0,0)";
  d["data"] = [9,9,9,9,9,9,9,9,9];
}

function drawSkillHorizontalGraph(){
  var f = _data["fill"];
  var p = _data["param"];
  var ds = {
    you: [
      f["skill_sotai_your_csr"],
      f["skill_sotai_your_senryaku"],
      f["skill_sotai_your_kaihatsukobai"],
      f["skill_sotai_your_chotatsukanren"],
      f["skill_sotai_your_chotatsugyomu"],
      f["skill_sotai_your_global"],
      f["skill_sotai_your_kansetsu"],
      f["skill_sotai_your_seisan"],
      f["skill_sotai_your_chotatsujyoho_kiban"]
    ],
    lt2: [
      p["skill_avgrate_csr_lt2"],
      p["skill_avgrate_sen_lt2"],
      p["skill_avgrate_kai_lt2"],
      p["skill_avgrate_cka_lt2"],
      p["skill_avgrate_cgy_lt2"],
      p["skill_avgrate_glo_lt2"],
      p["skill_avgrate_kan_lt2"],
      p["skill_avgrate_sei_lt2"],
      p["skill_avgrate_cjy_lt2"]
    ],
    lt3: [
      p["skill_avgrate_csr_lt3"],
      p["skill_avgrate_sen_lt3"],
      p["skill_avgrate_kai_lt3"],
      p["skill_avgrate_cka_lt3"],
      p["skill_avgrate_cgy_lt3"],
      p["skill_avgrate_glo_lt3"],
      p["skill_avgrate_kan_lt3"],
      p["skill_avgrate_sei_lt3"],
      p["skill_avgrate_cjy_lt3"]
    ],
    lt4: [
      p["skill_avgrate_csr_lt4"],
      p["skill_avgrate_sen_lt4"],
      p["skill_avgrate_kai_lt4"],
      p["skill_avgrate_cka_lt4"],
      p["skill_avgrate_cgy_lt4"],
      p["skill_avgrate_glo_lt4"],
      p["skill_avgrate_kan_lt4"],
      p["skill_avgrate_sei_lt4"],
      p["skill_avgrate_cjy_lt4"]
    ],
    gt4: [
      p["skill_avgrate_csr_gt4"],
      p["skill_avgrate_sen_gt4"],
      p["skill_avgrate_kai_gt4"],
      p["skill_avgrate_cka_gt4"],
      p["skill_avgrate_cgy_gt4"],
      p["skill_avgrate_glo_gt4"],
      p["skill_avgrate_kan_gt4"],
      p["skill_avgrate_sei_gt4"],
      p["skill_avgrate_cjy_gt4"]
    ]
  };
  var ctx = document.getElementById("myHorizontalChart");
  var data = {
    labels: [
      "CSR",
      "戦略マネジメント",
      "開発購買",
      "調達関連知識",
      "調達実務",
      "グローバル調達",
      "間接材調達",
      "生産管理",
      "調達情報基盤"
    ],
    datasets: [
      {
        type: 'line',
        yAxisID: "y-axis-you",
        label: 'あなたの位置',
        data: ds.you,
        backgroundColor: "rgba(85,142,213,1.0)",
        borderColorer: "rgba(85,142,213,1.0)",
        fill: false,
        borderWidth: 2,
        lineTension: 0
      },
      {
        type: 'bar',
        yAxisID: "y-axis-avg",
        label: '2未満',
        data: ds.lt2,
        backgroundColor: "rgba(147,205,221,1.0)",
        hoverBackgroundColor: "rgba(147,205,221,1.0)",
        borderWidth: 1
      },
      {
        type: 'bar',
        yAxisID: "y-axis-avg",
        label: '2以上3未満',
        data: ds.lt3,
        backgroundColor: "rgba(195,214,155,1.0)",
        hoverBackgroundColor: "rgba(195,214,155,1.0)",
        borderWidth: 1
      },
      {
        type: 'bar',
        yAxisID: "y-axis-avg",
        label: '3以上4未満',
        data: ds.lt4,
        backgroundColor: "rgba(249,247,173,1.0)",
        hoverBackgroundColor: "rgba(249,247,173,1.0)",
        borderWidth: 1
      },
      {
        type: 'bar',
        yAxisID: "y-axis-avg",
        label: '4以上',
        data: ds.gt4,
        backgroundColor: "rgba(217,150,148,1.0)",
        hoverBackgroundColor: "rgba(217,150,148,1.0)",
        borderWidth: 1
      }
    ]
  };
  var options = {
    legend: {
      position: 'top',
      display: false,
      label: {
        boxHeight: 2
      }
    },
    tooltips: {
      enabled: false
    },
    scales: {
      xAxes: [
        {
          stacked: true,
          gridLines: { display: false },
          ticks: { fontColor:'#333' },
          barThickness: 30,
          display: false
        }
      ],
      yAxes: [
        {
          id: "y-axis-you",
          display: true,
          position: "right",
          gridLines: { display: false },
          ticks: { beginAtZero: true, min: 0, max: 100, fontColor: "#fff" },
          stacked: true,
        },
        {
          id: "y-axis-avg",
          position: "left",
          ticks: { beginAtZero: true, max: 100, stepSize: 20 },
          stacked: true,
          scaleLabel:{
            display: false,
            labelString: "全社平均(%)",
          }
        }
      ]
    }
  };

  var myHorizontalChart = new Chart(ctx, {
    type: 'bar',
    data: data,
    options: options
  });
}
