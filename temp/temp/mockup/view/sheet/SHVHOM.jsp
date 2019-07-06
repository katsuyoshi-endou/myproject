<%------------------------------------------------------------------------------------------------------------------------------
	System Required
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
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
<%@ page import="jp.co.hisas.career.app.sheet.command.PME010Command" %>
<fw:init commandClass="<%= PME010Command.class %>" kinouTitle="<%= CommonParameter.getFuncName(PME010Command.KINOU_ID) %>" />
<%!
	
%>
<%
	AU.setReqAttr( request, "FUNC_TITLE", CommonLabel.getLabel( "LME010_TITLE" ) );
	
	List<CareerMenuActiveDto> careerMenuList = AU.getSessionAttr( session, AppSessionKey.CAREER_MENU_LIST );
	String careerMenuPtn = AU.getSessionAttr( session, AppSessionKey.CAREER_MENU_PTN );
	
	// お知らせ 外部HTML
	String externalhtmlPath = CommonParameter.getValue( CommonParameter.BUNRUI_BASE, "MENU_EXTERNAL_HTML_PATH_" + careerMenuPtn );
	boolean isExternalHtml = SU.isNotEmpty( externalhtmlPath );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<!DOCTYPE html>
<html class="FullHeight">
<head>
<jsp:include page="/view/common/VYC_MetaCssJs.jsp" flush="false" />
<%-- InPage CSS --------------------------------------------------------------------------------------------------------------%>
<style type="text/css">
</style>
</head>
<body id="lyca" data-vmid="VmVSHHOM">
<div id="gApp">
<jsp:include page="/view/common/VYC_GlobalHeader.jsp" flush="false" />
<div id="gBody" class="hasSidebar">
<%-- Sidebar -----------------------------------------------------------------------------------------------------------------%>

	<div id="gSidebar">
		<div class="sidebar-menu">
			<% for (CareerMenuActiveDto dto : careerMenuList) { %>
				<% if (SU.isBlank( dto.getMenuPath() )) { %>
					<div class="sb-title">
						<span class="lbl"><%= dto.getMenuLabel() %></span>
					</div>
				<% } else { %>
					<a href="#" class="sb-item js-menu" data-menuId="<%= dto.getMenuId() %>">
						<i class="fa fa-circle"></i>
						<span><%= dto.getMenuLabel() %></span>
					</a>
				<% } %>
			<% } %>
		</div>
	</div><!-- /#gSidebar -->

<%-- Form & Content ----------------------------------------------------------------------------------------------------------%>
<div id="gOperation">
<fw:transit kinouId="VME010">
<%-- ================================================== Right Content Area =================================================--%>


	<div class="desk">
		<div class="container">
			<div id="us-render-notification"></div>
			
			<div class="pnl">
				<div class="pnl-body">
					<div id="external-tgt"></div>
				</div>
			</div>
		</div>
	</div><!-- /.desk -->


<input type="hidden" name="selectedMenuId" value="">


<%-- ==================================================/Main Content Area ==================================================--%>
<input type="hidden" name="state" value="">
<input type="hidden" name="tokenNo" value="<%= session.getAttribute("tokenNo") %>">
</fw:transit>
</div><!-- /#gOperation -->
</div><!-- /#gBody -->
<%-- - - - - - - - - Underscore.js Template Layout Layer - - - - - - - - --%>
<script id="us-template-notification" type="text/template">
	{{ if (list.length > 0) { }}
	<div class="mk-notification-digest pnl">
		<div class="pnl-title">
			{{= label.title }}
		</div>
		<div class="pnl-body no-padd">
			<div class="n10n__list">
				{{ _.each(list, function(n){ }}
				<div class="n10n__item">
					<div class="n10n__text">{{= n.n10nText }}</div>
					<div class="n10n__sentat">{{= n.sentAt }}</div>
					<button class="n10n__dismiss btn btn-icon" data-seq="{{= n.n10nSeq }}">
						<i class="fa fa-times-circle"></i>
					</button>
				</div>
				{{ }); }}
			</div>
		</div>
	</div>
	{{ } }}
</script>
<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
var extPath = '<%= externalhtmlPath %>';
$(function(){
	 /**
	 ** Initialize
	**/
	$.ajax({
		method: "GET",
		url: extPath,
		cache: false
	})
	.done(function(result) {
		$('#external-tgt').html(result);
	});
	
	
	 /**
	 ** Event
	**/
	// メニューリンク クリック
	$(document).on('click', '.js-menu', function(ev){
		ev.preventDefault();
		document.F001.selectedMenuId.value = $(this).attr('data-menuId');
		pageSubmit('/servlet/MenuTransServlet', 'INIT');
	});
	
	// 通知 既読
	$(document).on('click', '.n10n__dismiss', function(){
		var $self = $(this);
		var seq = $self.attr('data-seq');
		$self.find('i').remove();
		
		App.Ajax.POST('MkNotificationServlet', '', {seq: seq}, function(result){
			$self.closest('.n10n__item').slideUp();
		});
	});
	
});

function __startup() {
	
	App.Ajax.GET('MkNotificationServlet', '', {}, function(result){
		var _data = {};
		_data["label"] = { title: App.LabelMap["LSHHOM_NOTIFY_TITLE"] };
		_data["list"] = result;
		usTemplateRender('#us-template-notification', '#us-render-notification', _data);
	});
	
};
</script>

<%-- GlobalFooter ------------------------------------------------------------------------------------------------------------%>
<jsp:include page="/view/common/VYC_GlobalFooter.jsp" flush="false" />
</div><!-- /#gApp -->
</body>
</html>
