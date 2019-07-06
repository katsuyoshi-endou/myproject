<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%
	VmVTLHOM vm = AU.getSessionAttr( session, VmVTLHOM.VMID );
%>
<%------------------------------------------------------------------------------------------------------------------------------
	HTML
------------------------------------------------------------------------------------------------------------------------------%>
<% if (vm.hasRoles && vm.instantSearchScopeList.size() > 0) { %>
<div class="tlhom-instant">
	<div class="pnl">
		<div class="pnl-title"><%= vm.gCL("LTLHOM_INS_TITLE") %></div>
		<div class="pnl-body">
			<div class="rack">
				<div class="rack-row tlhom-keyword">
					<div class="rack-form">
						<div class="form-head">
							<div class="title"><%= vm.gCL("LTLHOM_INS_H_KEYWORD") %></div>
						</div>
						<div class="form-body">
							<div class="fb">
								<input type="text" class="fi fi-flex1" name="instant_query" placeholder="<%= vm.gCL("LTLHOM_INS_PLACEHOLDER") %>">
							</div>
						</div>
					</div>
				</div>
				<div class="rack-row tlhom-scopes">
					<div class="rack-form" style="padding-bottom:0;">
						<div class="form-head">
							<div class="title"><%= vm.gCL("LTLHOM_INS_H_SCOPES") %></div>
						</div>
						<div class="form-body" style="flex:1;">
							<div class="checkboxes-horizontal">
								<% for (JvDfInstantSearchDto dto : vm.instantSearchScopeList) { %>
								<div class="checkbox scope">
									<label>
										<input type="checkbox" name="scopes" value="<%= dto.getScope() %>" <%= SU.judge( dto.getCheckFlg() ) ? "checked" : "" %>>
										<i class="fa fa-check"></i>
										<span><%= vm.gCL("LTLHOM_INS_SCOPE_" + dto.getScope()) %></span>
									</label>
								</div>
								<% } %>
							</div>
						</div>
					</div>
				</div>
				<%-- for SBAW -----------------------------------
				<% if (vm.canRetireSrch) { %>
				<div class="rack-row tlhom-crrstatus">
					<div class="rack-form">
						<div class="form-head">
							<div class="title"><%= vm.gCL("LTLHOM_INS_H_CRRSTATUS") %></div>
						</div>
						<div class="form-body">
							<div class="checkboxes-horizontal">
								<div class="checkbox">
									<label>
										<input name="currentstatus_except_retire" type="checkbox" checked />
										<i class="fa fa-check"></i>
										<span><%= vm.gCL("LTLSCE_REGIST_RETIRE") %></span>
									</label>
								</div>
								<div class="checkbox">
									<label>
										<input name="currentstatus_except_remove" type="checkbox" checked />
										<i class="fa fa-check"></i>
										<span><%= vm.gCL("LTLSCE_REGIST_REMOVE") %></span>
									</label>
								</div>
							</div>
						</div>
					</div>
				</div>
				<% } %>
				-----------------------------------------------%>
				<div class="centering-btns">
					<button id="do-instant-search" type="button" class="btn btn-big btn-primary btn-center"><%= vm.gCL("LTLHOM_INS_BTN_SEARCH") %></button>
				</div>
			</div>
			
		</div>
	</div>
	<div class="pnl" style="margin-top:15px;">
		<div class="pnl-title"><%= vm.gCL("LTLHOM_MLT_TITLE") %></div>
		<div class="pnl-body">
			<div class="rack">
				<div class="rack-row tlhom-stfnos">
					<div class="rack-form">
						<div class="form-head">
							<div class="title"><%= vm.gCL("LTLHOM_INS_H_MLTSTFNO") %></div>
						</div>
						<div class="form-body">
							<textarea name="multi_stfno_list" rows="5" style="width:360px;" placeholder="<%= vm.gCL("LTLHOM_INS_MLTSTFNO_PH") %>"></textarea>
						</div>
					</div>
				</div>
				<div class="centering-btns">
					<button id="do-mltstfno-search" type="button" class="btn btn-big btn-primary btn-center"><%= vm.gCL("LTLHOM_INS_BTN_SEARCH") %></button>
				</div>
			</div>
		</div>
	</div>
</div>
<% } %>
<%--
<div class="tlhom-welcome">
	<div class="pnl">
		<div class="pnl-body">
			<div class="fb">
				<div class="fi img-holder">
					<img src="/talent/assets/img/photo/home.jpg" class="img-circle">
				</div>
				<div class="fi text-holder">
					<div class="title"><%= vm.gCL("LTLHOM_WEL_TITLE") %></div>
					<div class="caption"><%= vm.gCL("LTLHOM_WEL_CAPTION") %></div>
				</div>
			</div>
		</div>
	</div>
	<div class="fb" style="padding:30px 15px;">
		<div class="fi img-holder">
		</div>
		<div class="fi text-holder">
			<div class="desc"><%= vm.gCL("LTLHOM_WEL_DESC") %></div>
		</div>
	</div>
</div>
--%>

<%-- InPage JavaScript -------------------------------------------------------------------------------------------------------%>
<script>
$(function(){
	 /**
	 ** Initialize
	**/
	$document = $(document);
	
	 /**
	 ** Event
	**/
	$document.on('click', '#do-instant-search', function(){
		var query = $('[name="instant_query"]').val();
		makeRequestParameter('instant_query', query);
		pageSubmit("/servlet/InstantSearchServlet", "SEARCH");
	});
	
	$document.on('keydown', '[name="instant_query"]', function(ev){
		if (ev.keyCode === 13) {
			$('#do-instant-search').trigger('click');
		}
	});
	
	$document.on('click', '#do-mltstfno-search', function(){
		if (!checkBeforeMultistfnoSearch()) {
			return false;
		}
		pageSubmit("/servlet/InstantSearchServlet", "MLTSTFNO");
	});
	
});

var mslLimitMsg = '<%= vm.gCL("LTLHOM_INS_MSG_MULTI_STFNO_LIMIT") %>';
var mslInvalidMsg = '<%= vm.gCL("LTLHOM_INS_MSG_MULTI_STFNO_INVALID") %>';
function checkBeforeMultistfnoSearch() {
	var msl = $.trim($('[name="multi_stfno_list"]').val());
	var list = msl.split('\n');
	if (list.length > 100) {
		alert( mslLimitMsg );
		return false;
	}
	var isOK = true;
	list.forEach(function(d){
		if (d.length > 0 && !d.match(/^[a-zA-Z0-9_-]*$/)) {
			isOK = false;
		}
	});
	if (!isOK) { alert( mslInvalidMsg ); }
	return isOK;
}
</script>
