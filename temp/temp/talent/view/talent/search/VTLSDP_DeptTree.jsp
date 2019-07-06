<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<%@ page import="jp.co.hisas.career.app.talent.command.PDA100Command" %>
<%@ page import="jp.co.hisas.career.app.talent.bean.DeptTreeBean" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<fw:init commandClass="<%= PDA100Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PDA100Command.KINOU_ID) %>" />
<jsp:useBean id="deptTreeBean" class="jp.co.hisas.career.app.talent.bean.DeptTreeBean" scope="session" />
<%
	Tray tray = new Tray( request, response );
	VmVTLSDP vm = new VmVTLSDP( tray );
	
	AU.setReqAttr( request, "FUNC_TITLE", vm.gCL("LTLSDP_TITLE") );
	
	// 既存選択値 復元用
	String rstrKey = "", rstrLbl = "";
	boolean isCS = SU.isNotBlank( AU.getRequestValue( request, "deptCd" ) );
	if (isCS) {
		rstrKey = AU.getRequestValue( request, "deptCd" );
		rstrLbl = AU.getRequestValue( request, "deptNm" );
	} else {
		rstrKey = AU.getRequestValue( request, "Mlt--commn_shozoku_cd" );
		rstrLbl = AU.getRequestValue( request, "Mlt--commn_shozoku" );
	}
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />

	<!-- Fancytree -->
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/jquery-ui.min.js"></script>
	<link rel="stylesheet" href="/<%= AppDef.CTX_ROOT %>/assets/vendor/fancytree/skin-win8/ui.fancytree.min.css" type="text/css">
	<script type="text/javascript" src="/<%= AppDef.CTX_ROOT %>/assets/vendor/fancytree/jquery.fancytree-all.min.js"></script>

<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<style type="text/css">
ul.fancytree-container {
  border: 0;
  outline: none;
}
span.fancytree-node {
  padding: .6em 0;
}
ul.fancytree-container li {
  padding: 0;
}
</style>
</head>
<body id="lyca" data-vmid="VmVTLSDP">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody">
<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<fw:transit kinouId="VAA100">
<%-- ================================================== Main Content Area ==================================================--%>

	<div id="gNavi">
		<div class="gnavi-body">
			<div class="area-l">
				<label class="vrt">
					<span class="lbl"><%= vm.gCL("LTLSDP_COMPANY") %></span>
					<div class="select">
						<label>
							<select id="COMPANY_CHANGE" name="companyCode">
								<%
									for( DeptTreeBean companyBean : deptTreeBean.getCompanyList() ) {
										String selected = "";
										if (companyBean.getDeptCd().equals(deptTreeBean.getCompanyCode())) {
											selected = "selected";
										}
								%>
								<option value="<%=companyBean.getDeptCd()%>" <%= selected %>><%=companyBean.getDeptName()%></option>
								<%
									}
								%>
							</select>
						</label>
					</div>
				</label>
			</div>
			<div class="area-r">
				<div class="btns">
					<button class="btn btn-delete" id="LDA100_CLEAR_BTN"><%= vm.gCL("LTLSDP_BTN_CLEAR") %></button>
					<button class="btn btn-primary btn-big" id="LDA100_REFLECT_BTN"><%= vm.gCL("LTLSDP_BTN_REFLECT") %></button>
				</div>
			</div>
		</div>
	</div><!-- /#gNavi -->

	<div class="desk">
		<div class="container">

			<div class="fb fb-middle">
				<span><%= vm.gCL("LTLSDP_TERMS") %></span>
				<input type="text" id="search" name="search" placeholder="Filter..." style="width:200px;">
				<button id="btn_filter_on"  class="btn"><%= vm.gCL("LTLSDP_BTN_FILTER_ON") %></button>
				<button id="btn_filter_off" class="btn"><%= vm.gCL("LTLSDP_BTN_FILTER_OFF") %></button>
			</div>

			<hr>

			<div class="pnl">
				<div class="pnl-body">
					<div id="tree_dept" class="fancytree fancytree-radio"></div>
				</div>
			</div>

		</div>
	</div>


<%-- ==================================================/Main Content Area ==================================================--%>
</div><%-- /contentInner --%>
</div><%-- /content --%>
</div><%-- /mainInner --%></div><%-- /main --%></div><%-- /container --%>
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
<input type="hidden" name="windowMode" value="SubWindow">
</fw:transit>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<script>
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>

$(function(){
	$document = $(document);
	
	
	 /**
	 ** Initialize
	**/
	
	// Fancytree :: Initialize the tree when page is loaded
	$("#tree_dept").fancytree({ extensions: ["filter"], filter: {mode: "hide"}, source: tree_src, checkbox: true, selectMode: 1, icons: false });
	var tree = $("#tree_dept").fancytree("getTree");
	
	
	 /**
	 ** Event
	**/
	
	<%-- 選択ボタン --%>
	$document.on('click', "#LDA100_REFLECT_BTN", function(){
		var selKey = '', selFullNm = '';
		var selectedNode = tree.getSelectedNodes()[0];
		if (selectedNode != null) {
			selKey    = selectedNode.key;
			selFullNm = selectedNode.title;
		}
		
		// carry to parent window
		var scsid = 'scsid-shozoku';
		var $parentF001 = $(window.opener.document.F001);
		$parentF001.find('#' + scsid + ' label').text( selFullNm );
		$parentF001.find('#' + scsid + ' .scs_nm').val( selFullNm );
		$parentF001.find('#' + scsid + ' .scs_cd').val( selKey );
		$parentF001.find('#' + scsid + ' .scs_cmpa').val( $('select[name="companyCode"]').val() );
		
		window.close();
	});
	
	<%-- 閉じるボタン --%>
	$("#LDA100_CLOSE_BTN").on('click', function(){
		window.close()
	});
	
	<%-- 会社プルダウン変更 --%>
	$("#COMPANY_CHANGE").on('change', function(){
		pageSubmit('/view/talent/search/VTLSDP_DeptTree.jsp', 'SEARCH');
	});
	
	<%-- 選択解除ボタン --%>
	$("#LDA100_CLEAR_BTN").on('click', function(){
		try{ tree.getSelectedNodes()[0].setSelected( false ); }catch(e){}
	});
	
	// Fancytree Filter ON
	$("#btn_filter_on").click(function(e){
		var n,
			leavesOnly = $("#leavesOnly").is(":checked"),
			match = $("input[name=search]").val();
		
		expandAll( true );
		
		if (e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === "") {
			$("input[name=search]").val("");
			tree.clearFilter();
			return;
		}
		// Pass a string to perform case insensitive matching
		n = tree.filterNodes(match, leavesOnly);
		$("#btn_filter_off").attr("disabled", false);
	}).focus();
	
	// Fancytree Filter OFF
	$("#btn_filter_off").click(function(e){
		$("input[name=search]").val("");
		tree.clearFilter();
		expandAll( true );
	}).attr("disabled", true);
	
	
	 /**
	 ** After Process
	**/
	
	// 既存選択値 復元用
	try {
		tree.getNodeByKey("<%= rstrKey %>").setSelected( true );
	} catch(e) {}
	try {
		// 初期表示時にすべて展開するかどうか
		expandAll( true );
		
		$("input[name=search]").val("<%= SU.ntb( rstrLbl ) %>");
		$("#btn_filter_on").click();
	} catch(e) {}
	
});

var tree_src = [
<%
	for (String nodeStr: deptTreeBean.getGroupNodeList()) {
		out.println( nodeStr );
	}
%>
];

function expandAll( isExpanded ) {
	$("#tree_dept").fancytree("getRootNode").visit(function(node){ node.setExpanded( isExpanded ); });
}
</script>

<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
