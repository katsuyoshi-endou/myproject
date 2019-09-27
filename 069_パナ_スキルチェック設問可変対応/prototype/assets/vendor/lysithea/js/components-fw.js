var App = {
  root: '',
  Config: {},
  LabelMap: {},
  Modal: {},
  UI: {
    Button: {},
    Filter: {},
    Flip: {},
    Picker: {},
    Pophelp: {},
    Popover: {},
    TwbsEx: {}
  },
  UA: {},
  Ajax: {},
  API: {},
  loadLabelMap: function(labelMap) {
    this.LabelMap = labelMap;
  },
  activate: function() {
    App.UI.initialize();
  },
  startup: function() {
    if (typeof __startup === "function") {
      __startup();
    }
  }
};

App.UI.initialize = function(){
  App.UI.Button.initialize();
  App.UI.Filter.initialize();
  App.UI.Flip.initialize();
  App.UI.Picker.initialize();
  App.UI.Pophelp.initialize();
  App.UI.Popover.initialize();
  App.UI.TwbsEx.initialize();
}

App.Modal.modalizePersonlist = function(multiple) {
  // モーダルテンプレートの用意
  var modal = $('#modal-template-personlist').clone();
  var targetId = $(multiple).attr('data-modalid');
  var disabled = $(multiple).attr('disabled');
  $(modal).attr('id', targetId);

  // optionタグの変換
  var opts = _.map(multiple, function(el,idx){ return el; });
  var converted = App.Modal.convertMultiple(opts);

  // 選択ボタンの生成
  var cnt  = $(multiple).find('option:selected').length;
  var btn = $('<button type="button" class="btn btn-modal" data-toggle="modal"></button>');
  $(btn).attr('data-target', '#'+targetId);
  $(btn).attr('id', targetId + '-select-btn');
  $(btn).attr('disabled', disabled);
  $(btn).text(commonLabels.shainListSelectButton);
  $(btn).append('<span class="cnt">'+cnt+'</span>');
  $(multiple).after(btn);

  // モーダル内テーブル
  var $table = $(modal).find('.modal-body table');
  $table.append(converted.tbody);
  $table.find('thead tr th:nth-child(2)').attr('colspan', converted.colspan);

  // モーダルの設置
  $(modal).appendTo('.functionArea');

  // モーダルイベント - OKボタン
  $(modal).on('click', '.modal-footer .modal-btn-ok', function(){
    $(modal).find('.checkall').prop('checked', false);

    var $filter = $(modal).find('.localfilter');
    $filter.val("");
    $filter.trigger('keyup');

    $(multiple).find('option').prop('selected', false);

    var checkedVals = _.map($(modal).find('input[type="checkbox"]:checked'), function(d){
      return $(d).val();
    });
    _.each(checkedVals, function(v){
      $(multiple).find('option[value="'+v+'"]').prop('selected', true);
    });
    $(btn).find('.cnt').text(checkedVals.length);
    $(modal).modal('hide');
  });

  // モーダルイベント - OKボタン
  $(modal).on('click', '.checkall', function(){
    var stat = $(this).prop('checked');
    $(modal).find('tbody tr:not(.hide) input[type="checkbox"]').prop('checked', stat);
  });

  // モーダルイベント - フォーカス時に列幅維持（列自動調整防止）
  $(modal).on('focus', '.modal-body .localfilter', function(){
    $(modal).find('tr.width-keeper td').each(function(i,d){
      $(d).attr('width', $(d).width());
    });
  });

  // モーダルイベント - キー入力でローカルフィルタ
  $(modal).on('keyup', '.modal-body .localfilter', function(){
    var inp = $(this).val();
    var $trs = $(this).closest("table").find("tbody tr");
    $trs.removeClass('hide');
    $trs.each(function(){
      var text = $(this).text();
      if (!~text.indexOf(inp)) {
        $(this).addClass("hide");
      }
    });
  });

  // モーダルイベント - IE ×アイコンクリック
  $(modal).on('mouseup', '.modal-body .localfilter', function(){
    var $input = $(this);
    // マウスアップイベント発火後に空欄で×アイコンクリックと判断
    setTimeout(function(){
      if ($input.val() == "") {
        $input.trigger("keyup");
      }
    }, 1);
  });
}

App.Modal.convertMultiple = function(options) {
  var objs = _.map(options, function(option){
    var obj = {
      "val": $(option).val(),
      "txtArr": $(option).text().split('　'),
      "checked": $(option).prop('selected')
    };
    return obj;
  });

  var colspan = 1;
  if (objs[0]) {
    colspan = objs[0].txtArr.length;
  }

  var tbody = $('<tbody></tbody>');

  var trD = $('<tr class="width-keeper"></tr>');
  _.times(objs[0].txtArr.length + 1, function(){
    $(trD).append('<td></td>');
  });
  tbody.append(trD);

  _.each(objs, function(obj){
    var cbox = $('<input type="checkbox">');
    $(cbox).val(obj.val);
    $(cbox).prop('checked', obj.checked);
    var tr = $('<tr></tr>');
    var tdCbox = $('<td></td>').append(cbox);
    $(tr).append(tdCbox);
    _.each(obj.txtArr, function(txt){
      $(tr).append('<td>'+txt+'</td>');
    });
    tbody.append(tr);
  });
  return {"tbody": tbody, "colspan": colspan};
}

App.UI.Button = {

  initialize: function(){
    this.dropdown();
  },

  dropdown: function(){
    $('.btn-dropdown > .btn').on('click', function(){
      $(this).parent().toggleClass('opened');
    });
  }

};

App.UI.Filter = {

  initialize: function(){
    this.localfilterSel();
  },

  localfilterSel: function(){
    var org_options = $('.mod-localfilter-sel select option').clone();

    // キー入力イベントでフィルタリング
    $('.mod-localfilter-sel input').on('keyup', function(){
      // keep
      $selected_options = $(this).parent().find('option:selected');

      // refresh
      var new_options = $(org_options).clone();
      $select = $(this).parent().find('select');
      $select.empty();
      $select.append(new_options);

      // restore from keep
      $selected_options.each(function(){
        var val = $(this).val();
        $select.find('option[value="'+val+'"]').prop('selected', true);
      });

      // filtering
      var inp = $(this).val();
      $options = $(this).parent().find('option');
      $options.each(function(){
        var text = $(this).text();
        if (!~text.indexOf(inp)) {
          $(this).remove();
        }
      });
    });

    // IE ×アイコンクリック
    $('.mod-localfilter-sel input').on('mouseup', function(){
      var $input = $(this);
      // マウスアップイベント発火後に空欄で×アイコンクリックと判断
      setTimeout(function(){
        if ($input.val() == "") {
          $input.trigger("keyup");
        }
      }, 1);
    });
  }

};

App.UI.Flip = {

  initialize: function(){
    this.togglePanel();
  },

  togglePanel: function(){
    $('i.fold-tgl').each(function(){
      var isDefaultClosed = $(this).hasClass('fa-plus-square-o');
      if (isDefaultClosed) {
        $(this).closest('.rack-row').find('.flip-body').hide();
      }
    });
    $('#gBody').on('click', '.flip-tgl', function(){
      var $icon = $(this).find('i');
      if ($icon.hasClass('fa-minus-square-o')) {
        $icon.removeClass('fa-minus-square-o').addClass('fa-plus-square-o');
      } else {
        $icon.removeClass('fa-plus-square-o').addClass('fa-minus-square-o');
      }
      $(this).parent().find('.flip-body').slideToggle();
    });
  }

};

App.UI.Picker = {

  initialize: function(){
    this.datePickerYm();
  },

  datePickerYm: function(){
    $('.mod-datepicker-ym').on('click', '.picker:not(.picker-disabled)', function(e){
      e.preventDefault();
      var isPrev = $(this).hasClass('prev');
      var crr = $(this).siblings('input').val();
      var result = crr;
      if (crr.match(/(\d{4})\/(\d{2})/)) {
        if (isPrev) {
          result = moment(crr, "YYYY/MM").subtract(1, 'months').format("YYYY/MM");
        }
        else {
          result = moment(crr, "YYYY/MM").add(1, 'months').format("YYYY/MM");
        }
      }
      var inp = $(this).siblings('input');
      inp.val(result);
      inp.focus();
    });
  }

};

App.UI.Pophelp = {

  initialize: function(){
    this.registerEvents();
  },

  registerEvents: function(){
    $(document).on('click', '.popSwitch', function(){
      $('.popInfo').removeClass('pop-show');
      var tgtHelpElm = $('.popInfo', $(this).parent().parent() );
      var posBtmRX = 12 + tgtHelpElm.parent().offset().left + tgtHelpElm.width() ;
      var posBtmRY = 12 + tgtHelpElm.parent().offset().top  + tgtHelpElm.height();
      var posRowTopY = tgtHelpElm.parent().parent().parent().offset().top ;
      var viewBtmRX  = tgtHelpElm.closest('.container').width()  - 20;
      var viewBtmRY  = tgtHelpElm.closest('.container').height() + 60;
      var offsetRX = -6;
      if (posBtmRX > viewBtmRX) { offsetRX = offsetRX + (viewBtmRX - posBtmRX) + 4; }
      tgtHelpElm.css({'left' : offsetRX});
      var offsetRY = 0 - (posBtmRY - posRowTopY);
      tgtHelpElm.css({'top' : offsetRY});
      tgtHelpElm.addClass('pop-show');
    }).css('cursor','pointer'); //for iOS Tap

    $(document).on('click', '.popInfo', function(){
      $(this).removeClass('pop-show');
    }).css('cursor','pointer'); //for iOS Tap
  }

};

App.UI.Popover = {

  initialize: function(){
    // this.disapproval();
  },

  disapproval: function(){
    $('#gBody').on('click', '.mod-disapproval .btn-ok', function(){
      var inp = $(this).closest('.mod-disapproval').find('.disappr-alias');
      var tr = $(this).closest('tr[data-rowidx]');
      var reason = tr.find('input[name="DisapprovalReason"]');
      $(reason).val(inp.val());
      $(this).closest('.popover').popover('hide');

      $('html, body').stop().animate({scrollLeft: $(reason).offset().left}, 'fast');
    });
  }

};

App.UI.TwbsEx = {

  initialize: function(){
    this.keepDropdownMenuOnClick();
  },

  keepDropdownMenuOnClick: function(){
    $(document).on('click', '.dropdown-menu', function(ev){
      ev.stopPropagation();
    });
  }

};

App.UA = {

  isMobile: function() {
    var ua = window.navigator.userAgent.toLowerCase();
    if (ua.indexOf("ipad")   != -1) { return true; }
    if (ua.indexOf("iphone") != -1) { return true; }
    return false;
  }

};

App.Ajax.GET = function(servlet, state, dataObj, callback) {
  dataObj.state = state;
  dataObj.tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "GET",
    url: App.root + "/servlet/" + servlet,
    cache: false,
    data: dataObj
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}

App.Ajax.POST = function(servlet, state, dataObj, callback) {
  dataObj.state = state;
  dataObj.tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "POST",
    url: App.root + "/servlet/" + servlet,
    cache: false,
    data: dataObj
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}

App.API.GET = function(apiPath, dataObj, callback) {
  dataObj.tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "GET",
    url: App.root + "/api" + apiPath,
    cache: false,
    data: dataObj
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}

App.API.POST = function(apiPath, dataObj, callback) {
  dataObj.tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "POST",
    url: App.root + "/api" + apiPath,
    cache: false,
    data: dataObj
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}

App.API.PUT = function(apiPath, dataObj, callback) {
  dataObj.tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "PUT",
    url: App.root + "/api" + apiPath,
    cache: false,
    dataType: 'json',
    contentType: 'application/json',
    data: JSON.stringify(dataObj)
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}

App.API.DELETE = function(apiPath, queryString, callback) {
  var tokenNo = document.F001.tokenNo.value;
  $.ajax({
    method: "DELETE",
    // DELETE Request has NO payload body.
    url: App.root + "/api" + apiPath + "?tokenNo=" + tokenNo + "&" + queryString,
    cache: false
  })
  .done(function(result) {
    if (_.isFunction(callback)) {
      callback(result);
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    console.log(jqXHR.responseJSON);
  });
}
