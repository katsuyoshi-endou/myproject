<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.property.*"%>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%
	VmVTLSCE vm  = AU.getRequestAttr( request, "vm" );
%>
<%-- ================================================== Main Content Area ==================================================--%>

<div class="fb fb-lr">
	<div id="scsid-shozoku" class="fi fi-flex1">
		<h3 class="mgt"><%= vm.gCL("LTLSCE_DEPT_TITLE") %></h3>
		<div class="pnl" style="margin-right:30px;">
			<div class="pnl-body">
				<div class="fb fb-lr fb-middle">
					<label id="Mlt--commn_shozoku" class="fi fi-flex1 textLabel"><%= vm.getMltSearchValue( "commn_shozoku" ) %></label>
					<button type="button" id="LDA010_BASE_BELONG_BTN" class="btn">
						<i class="fa fa-external-link"></i>
						<span><%= vm.gCL("LTLSCE_BTN_DPTCHG") %></span>
					</button>
				</div>
				<input type="hidden" name="Mlt--commn_shozoku"  value='<%= vm.getMltSearchValue( "commn_shozoku" ) %>' class="scs_nm" />
				<input type="hidden" name="Mlt--commn_shozoku_cd" value='<%= vm.getMltCodeValue( "commn_shozoku" ) %>' class="scs_cd" />
				<input type="hidden" name="companyCode" value='<%= vm.getMltCodeValue( "commn_shozoku_cmpa" ) %>' class="scs_cmpa" />
				<input type="hidden" name="Mlt--commn_shozoku_cmpa" value='<%= vm.getMltCodeValue( "commn_shozoku_cmpa" ) %>' class="scs_cmpa" />
				<input type="hidden" name="Mlt--commn_shozoku_cmpa_cd" value='<%= vm.getMltCodeValue( "commn_shozoku_cmpa" ) %>' class="scs_cmpa" />
			</div>
		</div>
	</div>
	<div class="fi fi-flex1">
		<%-- for SBAW -----------------------------------
		<% if (vm.legacyKensakuDefBean.canRetireSrch) { %>
			<h3 class="mgt"><%= vm.gCL("LTLSCE_REGIST_TITLE") %></h3>
			<div class="pnl fb fb-middle" style="margin-right:30px; min-height:62px;">
				<div class="pnl-body fi fi-flex1" style="margin-top:4px;">
					<div class="checkboxes-horizontal" style="justify-content:space-around;">
						<div class="checkbox">
							<label>
								<input name="Sgl--currentstatus_except_retire" type="checkbox" checked />
								<i class="fa fa-check"></i>
								<span><%= vm.gCL("LTLSCE_REGIST_RETIRE") %></span>
							</label>
						</div>
						<div class="checkbox">
							<label>
								<input name="Sgl--currentstatus_except_remove" type="checkbox" checked />
								<i class="fa fa-check"></i>
								<span><%= vm.gCL("LTLSCE_REGIST_REMOVE") %></span>
							</label>
						</div>
					</div>
				</div>
			</div>
		<% } %>
		-----------------------------------------------%>
	</div>
</div>


<%-- ==================================================/Main Content Area ==================================================--%>
<script>
</script>
