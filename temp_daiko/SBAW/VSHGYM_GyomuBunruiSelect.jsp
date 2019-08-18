<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.event.*" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher( "/view/error.jsp" ).forward( request, response );
	}
%>
<%
	Log.method( userinfo.getLogin_no(), "IN", "" );
%>

<%@ page import="jp.co.hisas.career.app.sheet.command.PSHGYMCommand" %>
<fw:init commandClass="<%=PSHGYMCommand.class%>" kinouTitle="<%=CommonParameter.getFuncName(PSHGYMCommand.KINOU_ID)%>" />
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%
	Tray tray = new Tray( request, response );
	VmVSHGYM vm = new VmVSHGYM( tray );

	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHGYM_TITLE" ));

	JkskGyomuBunruiEventResult result = AU.getSessionAttr( session, CsSessionKey.JKSK_GYOMUB_RESULT );
	List<ZzCsmJkskGyomubDto> gyomubList = result.getGyomubList();
	List<String> shokushuList = result.getShokushuList();
	Map<String, List<String>> shokushu2Map = result.getShokushu2Map();
	Map<String, List<String>> bunruiMap = result.getBunruiMap();
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />

<style type="text/css">
  .radio label i{
    border: 2px solid #C7C7C7;
  }
  .showcase-999{
    width: 999px;
    margin: 0 auto;
  }
</style>
</head>
<body data-vmid="VmVSHGYM">
<div id="gApp">
  <jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
  <div id="gBody">
    <div id="gOperation">
      <fw:transit kinouId="">
        <div id="navbar">
          <div class="navbar-body btns"></div>
        </div>

        <div class="navbarBtns">
          <div class="leftArea">
            <div class="btns" style="display:inline-block;margin:0;padding:0;">
              <button class="btn btn-back" type="button" onclick="javascript:window.close();"><%= vm.gCL( "LSHEDIT_NAV_BACK" ) %></button>
            </div>
          </div>
          <div class="rightArea">
            <button type="button" id="btn_SELECT" class="btn btn-secondary btn-big"><%= vm.gCL( "LSHEDIT_SELECT" ) %></button>
          </div>
        </div>
        <div class="desk">
          <div class="showcase-999">
            <div class="mod-table">
              <table>
                <tr>
                  <th><%= vm.gCL( "LSHGYM_SRCH_TH_1" ) %></th>
                  <td>
                    <select name="shokushu" id="shokushu" style="width: 200px;">
                      <option value="" selected></option>
                      <% for ( String val : shokushuList ) { %>
                      <option value="<%= val %>"><%= val %></option>
                      <% } %>
                    </select>
                  </td>
                  <th><%= vm.gCL( "LSHGYM_SRCH_TH_2" ) %></th>
                  <td>
                    <select name="shokushu2" id="shokushu2" style="width: 200px;"></select>
                  </td>
                  <th><%= vm.gCL( "LSHGYM_SRCH_TH_3" ) %></th>
                  <td>
                    <select name="bunrui" id="bunrui" style="width: 200px;"></select>
                  </td>
                </tr>
              </table>
            </div>
          </div>
          <h3></h3>
          <div class="container">
            <div class="showcase-999">
              <div id="gyomublist" class="mod-table">
                <table id="result" style="margin:0 auto;">
                  <thead>
                    <tr>
                      <th style="text-align: center;"><button type="button" id="clear_btn" class="btn"><%= vm.gCL( "LSHGYM_RSLT_CLEAR" ) %></button></th>
                      <th style="width:20%;"><%= vm.gCL( "LSHGYM_RSLT_TH_1" ) %></th>
                      <th style="width:15%;"><%= vm.gCL( "LSHGYM_RSLT_TH_2" ) %></th>
                      <th style="width:20%;"><%= vm.gCL( "LSHGYM_RSLT_TH_3" ) %></th>
                      <th style="width:35%;"><%= vm.gCL( "LSHGYM_RSLT_TH_4" ) %></th>
                    </tr>
                  </thead>
                  <tbody>
                  <% for ( ZzCsmJkskGyomubDto dto : gyomubList ) { %>
                    <tr>
                      <td style="text-align: center;">
                        <span class="radio">
                          <label>
                            <input type="radio" value="<%= dto.getSort() %>" name="gyomubGroup"/>
                            <i class="fa fa-circle"></i>
                          </label>
                        </span>
                      </td>
                      <td><%= dto.getShokushuNm() %></td>
                      <td><%= dto.getShokushuNm2() %></td>
                      <td><%= dto.getGyomuBunrui() %></td>
                      <td><%= dto.getShokushuDesc() %></td>
                    </tr>
                  <% } %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        <input type="hidden" name="state" value="">
        <input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
        <input type="hidden" name="windowMode" value="SubWindow">
        <input type="hidden" name="shokushu01" value="<%= AU.getRequestValue(request, "shokushu01") %>">
        <input type="hidden" name="shokushu02" value="<%= AU.getRequestValue(request, "shokushu02") %>">
        <input type="hidden" name="gyomub" value="<%= AU.getRequestValue(request, "gyomub") %>">
      </fw:transit>
    </div>
  </div>
<script>
var sks2Map = new Map();
<% for ( Map.Entry<String, List<String>> entry : shokushu2Map.entrySet()) { %>
  var arry = new Array();
  <% for ( String val : entry.getValue()) { %>
    arry.push("<%= val %>");
  <% } %>
  sks2Map.set("<%= entry.getKey() %>", arry);
<% } %>

var bnrMap = new Map();
<% for ( Map.Entry<String, List<String>> entry : bunruiMap.entrySet()) { %>
  var arry = new Array();
  <% for ( String val : entry.getValue()) { %>
    arry.push("<%= val %>");
  <% } %>
  bnrMap.set("<%= entry.getKey() %>", arry);
<% } %>

$(function() {
	var $document = $(document);
	
	// 画面最上段の「閉じる」ボタンは非表示
	$( "button.btn.btn-transp" ).remove();

	// 職種2、分類選択リストの初期化
	$( "#shokushu2 > option" ).remove();
	$( "#bunrui > option" ).remove();
	
	// 「選択」ボタン押下
	$( "button#btn_SELECT" ).on( "click", function() {
		var param = {
			shokushu1: "",
			shokushu2: "",
			bunrui: ""
		};
		
		if ( $( "input[name='gyomubGroup']:checked" ).val() !== undefined ) {
			var $elem = $( "input[name='gyomubGroup']:checked" );

			var shokushu1Nm = $elem.closest( "tr" ).find( "td:eq(1)" ).text();
			var shokushu2Nm = $elem.closest( "tr" ).find( "td:eq(2)" ).text();
			var bunruiNm = $elem.closest( "tr" ).find( "td:eq(3)" ).text();

			param.shokushu1 = shokushu1Nm;
			param.shokushu2 = shokushu2Nm;
			param.bunrui = bunruiNm;

		}
		window.opener.applyGyomubInfo( param );
		window.close();
	});
	
	// 「職種」コンボボックスの選択イベント
	$("select#shokushu").on("change", function() {
		var str = $(this).val();

		$( "input[name='gyomubGroup']:checked" ).prop("checked", false);

		$("#shokushu2 > option").remove();
		$("#bunrui > option").remove();

		if (str !== "") {
			var aray = sks2Map.get(str);
			$("select#shokushu2").append($("<option>").html("").val("").attr("data-parent", ""));
			aray.forEach(function(value) {
				$("select#shokushu2").append($("<option>").html(value).val(value).attr("data-parent", str));
			});
		}
		controlGyomuBunruiTable(str, "", "");
	});
	
	// 「職種2」コンボボックスの選択イベント
	$("select#shokushu2").on("change", function() {
		var parent = $("select#shokushu2 option:selected").attr("data-parent");
		var str = $("select#shokushu2 option:selected").text();

		$( "input[name='gyomubGroup']:checked" ).prop("checked", false);

		$("#bunrui > option").remove();

		if (str !== "") {
			var aray = bnrMap.get(str);
			$("select#bunrui").append($("<option>").html("").val("").attr("data-parent", ""));
			aray.forEach(function(value) {
				$("select#bunrui").append($("<option>").html(value).val(value).attr("data-parent", str));
			});
		}
		controlGyomuBunruiTable(parent, str, "");
	});
	
	// 「分類」コンボボックスの選択イベント
	$("select#bunrui").on("change", function() {
		var shokushu1 = $("select#shokushu").val();
		var shokushu2 = $("select#bunrui option:selected").attr("data-parent");
		var bunrui = $(this).val();

		$( "input[name='gyomubGroup']:checked" ).prop("checked", false);

		controlGyomuBunruiTable(shokushu1, shokushu2, bunrui);
	});
	
	$("button#clear_btn").on("click", function() {
		var $elem = $( "input[name='gyomubGroup']:checked" );
		if ($elem.length !== 0) {
			$elem.prop("checked", false);
		}
	});
	
	// 初期値で選択
	selectDefaultValue();
});

/**
 * 「職種」、「職種2」、「分類」コンボボックスが選択されたときのテーブル絞り込み処理
 */
function controlGyomuBunruiTable(val1, val2, val3) {
	var re1 = new RegExp(val1);
	var re2 = new RegExp(val2);
	var re3 = new RegExp(val3);

	// ラジオボタンを未選択状態に
	$("input[name='gyomubGroup']").removeAttr("checked");

	$("table#result tbody tr" ).each( function() {
		var txt1 = $( this ).find( "td:eq(1)" ).text();
		var txt2 = $( this ).find( "td:eq(2)" ).text();
		var txt3 = $( this ).find( "td:eq(3)" ).text();
		
		if ( txt1.match( re1 ) != null && txt2.match( re2 ) != null && txt3.match( re3 ) != null) {
			$( this ).show();
		} else {
			$( this ).hide();
		}
	});
}

function unEscapeHTML(str) {
	return str
			.replace(/(&lt;)/g, '<')
			.replace(/(&gt;)/g, '>')
			.replace(/(&quot;)/g, '"')
			.replace(/(&#39;)/g, "'")
			.replace(/(&amp;)/g, '&');
}

function selectDefaultValue() {
	var shokushu01 = $("input[name='shokushu01']").val() === null ? "" : $("input[name='shokushu01']").val();
	var shokushu02 = $("input[name='shokushu02']").val() === null ? "" : $("input[name='shokushu02']").val();
	var gyomub = $("input[name='gyomub']").val() === null ? "" : $("input[name='gyomub']").val();

	if (shokushu01 !== "") {
		$("table#result tbody tr").each(function() {
			var val1 = $(this).find("td:eq(1)").text();
			var val2 = $(this).find("td:eq(2)").text();
			var val3 = $(this).find("td:eq(3)").text();
			
			if (val1 === shokushu01 && val2 === shokushu02 && val3 === gyomub) {
				$(this).find("td:eq(0)").find("input[type='radio']").prop("checked", true);
				return true;
			}
		});
	}
}
</script>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div>
</body>
</html>
