<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<jsp:useBean id="userinfo" class="jp.co.hisas.career.app.common.bean.UserInfoBean" scope="session" />
<%
	/* Session Timeout */
	if ( userinfo == null || "".equals(userinfo.getLogin_no()) ) {
		config.getServletContext().getRequestDispatcher("/view/error.jsp").forward( request, response );
	}
%>
<% Log.method( userinfo.getLogin_no(), "IN", "" ); %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.cache.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.useful.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.event.CsSheetEventResult" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="jp.co.hisas.career.app.sheet.command.PSHSTCCommand" %>
<fw:init commandClass="<%= PSHSTCCommand.class %>" kinouTitle="<%= CommonParameter.getFuncName(PSHSTCCommand.KINOU_ID) %>" />
<%
	Tray tray = new Tray( request, response );
	VmVSHSTC vm = AU.getRequestAttr( request, "vm" );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL( "LSHSTC_TITLE" ) );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html onContextmenu="return false;">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/view/sheet/careersheet.css" type="text/css" media="screen" />
<style type="text/css">
#SEARCH {
  width: 80px;
  display: inline-block;
}
#EXECUTE{
  width: 80px;
  display: inline-block;
}
.buttonArea {
  margin-top: 20px;
}
.leftArea {
  width: 350px;
  height: 80px;
}
.rightArea {
  width: 350px;
  height: 80px;
}
.fullArea {
}
.flex-container {
  display: flex;
  justify-content: flex-start;
}
.grid .gc:not(:last-child) {
  margin-right: 60px;
}
/*---------- for Fixed Midashi ----------*/
thead tr:first-child th:nth-child(3) {
  width: 200px !important;
}
.fixed_header_display_none_at_print {
  box-shadow: 0 1px 2px 1px rgba(0,0,0,0.1);
}
</style>
</head>
<body id="lyca" data-vmid="VmVSHSTC">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<fw:transit kinouId="VSHSTC">
<jsp:include page="/view/common/VYC_Navbar.jsp" flush="false" />
<div id="gOperation">
<%----------------------------------------------------- Fix Content Area -----------------------------------------------------%>

  <div class="ope-board">
    <div class="whitebd">
      <div class="container fb fb-lr">
        <div class="fi fi-flex1 gridform">
          <div class="gf-row">
            <label class="f5x">
              <span class="lbl"><%= vm.gCL( "LSHSTC_SRCH_OPERATION" ) %></span>
      				<select name="operationCd">
                <% for (ValueTextSortDto dto : vm.operationList) { %>
                <option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
                <% } %>
      				</select>
            </label>
            <label class="f5x">
              <span class="lbl"><%= vm.gCL( "LSHSTC_SRCH_STATUS" ) %></span>
              <select name="statusCd" class="opeChg">
                <option value=""></option>
                <% for (ValueTextSortDto dto : vm.statusList) { %>
                <option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
                <% } %>
              </select>
            </label>
            <div class="buttonArea">
              <button type="button" id="SEARCH" class="btn do-search"><%= vm.gCL( "LSHSTC_BTN_SRCH" ) %></button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <hr>
  </div><!-- /.ope-board -->

<%-- ================================================== Main Content Area ==================================================--%>

	<div class="navbarBtns" style="display:none;">
		<div>
		  <button class="btn btn-back do-back-home" type="button"><%= vm.gCL( "LSHSTC_RETURN_BTN" ) %></button>
    </div>
	</div>
    <div class="desk">
      <div class="container">

        <div class="pnl">
          <div class="pnl-title"><%= vm.gCL( "LSHSTC_HYO_SHEET" ) %></div>
          <div class="pnl-body">
            <div class="grid">
              <div class="grid-row">
                <div class="fm-item gc">
                  <div class="fm-lbl">
                    <span class="lbl"><%= vm.gCL( "LSHSTC_SRCH_OPERATION" ) %></span>
                  </div>
                  <div class="fm-val">
                    <span class="text-ro"><%= vm.operationNm %></span>
                  </div>
                </div>
                <div class="fm-item gc">
                  <div class="fm-lbl">
                    <span class="lbl"><%= vm.gCL( "LSHSTC_SRCH_STATUS" ) %></span>
                  </div>
                  <div class="fm-val">
                    <span class="text-ro"><%= vm.statusNm %></span>
                  </div>
                </div>
                <div class="fm-item gc">
                  <div class="fm-lbl">
                    <span class="lbl"><%= vm.gCL( "LSHSTC_TGT_COUNT" ) %></span>
                  </div>
                  <div class="fm-val">
                    <span class="text-ro"><%= vm.targetSheetsNum %></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="pnl" style="margin-top:15px;">
          <div class="pnl-title"><%= vm.gCL( "LSHSTC_CSBULK" ) %></div>
          <div class="pnl-body">
            <div class="grid">
              <div class="grid-row">
                <div class="fm-item gc">
                  <div class="fm-lbl">
                    <span class="lbl"><%= vm.gCL( "LSHSTC_TGT_STATUS" ) %></span>
                  </div>
                  <div class="fm-val">
                    <select name="afterChangeStatus">
                    <option value=""></option>
                      <% for (ValueTextSortDto dto : vm.statusList) { %>
                      <option value="<%= dto.getValue() %>"><%= dto.getText() %></option>
                      <% } %>
                    </select>
                  </div>
                </div>
                <div class="fm-item gc" style="flex:1;">
                  <div class="fm-lbl">
                    <span class="lbl"><%= vm.gCL( "LSHSTC_TGT_DELIV" ) %></span>
                  </div>
                  <div class="fm-val">
                    <input name="delivMsg" type="text" class="block">
                  </div>
                </div>
              </div>
              <div class="centering-btns">
                <button id="EXECUTE" class="btn btn-big btn-secondary do-execute" type="button"><%= vm.gCL( "LSHSTC_BTN_STCHG" ) %></button>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

<%-- ==================================================/Main Content Area ==================================================--%>
</div><!-- /#gOperation -->
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
<jsp:include page="/view/common/VYC_Modal.jsp" flush="false" />
</fw:transit>
</div><!-- /#gBody -->
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>

var errMsg = "<%= vm.gCL( "LSHSTC_ERROR_MSG" ) %>"
var confMsg = "<%= vm.gCL( "LSHSTC_CONF_MSG" ) %>"

$(function(){
	 /**
	 ** Initialize
	**/

	// FORWARDボタンを青色に
	$('.csActionBtns [data-actioncd="FORWARD"], .csActionBtns [data-actioncd="SKIP"]').each(function(){
	  var $self = $(this);
	  if ( $self.hasClass('btn') ) {
	    $self.addClass('btn-secondary');
	  }
	});

  $('select[name="operationCd"]' ).val('<%= vm.slctedOperation %>');
  $('select[name="statusCd"]' ).val('<%= vm.slctedStatus %>');
  // $('select[name="afterChangeStatus"]' ).val('<%= vm.afterChangeStatus %>');

  var statusCd = $('select[name="statusCd"] option:selected').val();
  if( _.isEmpty(statusCd) ){
    $('.desk').hide();
  }
	 /**
	 ** Event
	**/

  $(document).on('change', 'select[name="operationCd"]', function() {
      $('.desk').hide();
      $('.opeChg').val("");
      $('.opeChg').text("");
      pageSubmit('/servlet/CsFloodServlet', 'CHANGE_OPERATION');
   });

  $(document).on('change', 'select[name="statusCd"]', function() {
      var operationNm = $('select[name="operationCd"] option:selected').text();
      addRequestParameter( 'operationNm', operationNm );
      var statusNm = $('select[name="statusCd"] option:selected').text();
      addRequestParameter( 'statusNm', statusNm );

      pageSubmit('/servlet/CsFloodServlet', 'SEARCH');

   });

  $(document).on('click', '.do-search', function(){

    //do-search実行時に毎回最新の選択評価シートとステータスを取得する
    var operationNm = $('select[name="operationCd"] option:selected').text();
    addRequestParameter( 'operationNm', operationNm );
    var statusNm = $('select[name="statusCd"] option:selected').text();
    addRequestParameter( 'statusNm', statusNm );

    pageSubmit('/servlet/CsFloodServlet', 'SEARCH');
  });

  $(document).on('click', '.do-execute', function(){

    //do-execute実行時に毎回最新の選択評価シートとステータスを取得する
    var operationNm = $('select[name="operationCd"] option:selected').text();
    addRequestParameter( 'operationNm', operationNm );
    var statusNm = $('select[name="statusCd"] option:selected').text();
    addRequestParameter( 'statusNm', statusNm );

    var submitFlg = true;
    var afterChangeStatus = $('select[name="afterChangeStatus"]' ).val();

    if(_.isEmpty(afterChangeStatus)){
      alert(errMsg);
      submitFlg = false;
    }
    if(submitFlg){
      if(confirm(confMsg)){
        pageSubmit('/servlet/CsFloodServlet', 'CHANGE_STATUS');
      }
    }
  });

});
</script>
<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
