<%------------------------------------------------------------------------------------------------------------------------------
	Java Code for This JSP
------------------------------------------------------------------------------------------------------------------------------%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*"%>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*"%>
<%@ page import="jp.co.hisas.career.app.talent.bean.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%
	VmVTLSCE vm  = AU.getRequestAttr( request, "vm" );
%>
<%-- ================================================== Main Content Area ==================================================--%>

<div class="shelfForm">

	<h3 class="mgt"><%= vm.gCL("LTLSCE_SHELF_TITLE") %></h3>

	<div class="guidanceMessage">
		<ul>
			<li><%= vm.gCL( "LTLSCE_SHELF_GUIDE" ) %></li>
		</ul>
	</div>

<%
	// Section Loop
	for (List<JvProfTabSectListtypeDto> list : vm.shelftypeMap.values()) {
		String sectId = list.get( 0 ).getSectId();
%>
	<div id="<%= sectId %>" class="pnl shelf">
		<div class="pnl-title"><%= vm.gCL( sectId ) %></div>
		<div class="pnl-body shelf-pzlist grid grid-wrap">
		<%
			for (JvProfTabSectListtypeDto dto : list) {
				String headerId  = dto.getHeaderLabelId();
				String headerLbl = vm.gCL( headerId );
				String helpLbl   = vm.gCL( headerId + "_PZS_HELP" );
		%>
			<div class="slf-pz gc g6x fm-item">
				<div class="slf-pz-head fm-lbl">
					<div class="lbl"><%= headerLbl %></div>
					<div class="help">
						<% if (SU.isNotBlank( helpLbl )) { %>
						<a href="#" data-toggle="tooltip" title="<%= helpLbl %>"><i class="fa fa-info-circle"></i></a>
						<% } %>
					</div>
				</div>
				<div class="slf-pz-body fm-val">
					<%	// qsf: Query of Shelf
						String reqNm     = "qsf--" + dto.getSectId() + "--" + dto.getDataParamId();
						String reqNmKigo = "qsfk--" + dto.getSectId() + "--" + dto.getDataParamId();
						String phLbl = vm.gCL( dto.getHeaderLabelId() + "_PZS_PH" );
					%>
					<div class="shelfBox fb">
						<input class="shelfQuery" type="text" name="<%= reqNm %>" value="" placeholder="<%= phLbl %>" maxlength="40">
						<div class="select">
							<label>
								<select class="shelfKigo" name="<%= reqNmKigo %>">
									<option value="eq"><%= vm.gCL( "LTLSCE_SHELF_KIGO_EQ" ) %></option>
									<option value="ne"><%= vm.gCL( "LTLSCE_SHELF_KIGO_NE" ) %></option>
									<option value="lk"><%= vm.gCL( "LTLSCE_SHELF_KIGO_LK" ) %></option>
									<option value="gt"><%= vm.gCL( "LTLSCE_SHELF_KIGO_GT" ) %></option>
									<option value="lt"><%= vm.gCL( "LTLSCE_SHELF_KIGO_LT" ) %></option>
								</select>
							</label>
						</div>
					</div>
				</div>
			</div>
		<%
			}
		%>
		</div><!-- /.shelf-pzlist -->
	</div><!-- /.shelf -->
<%
	}
%>
</div><!-- /.shelfForm -->


<%-- ==================================================/Main Content Area ==================================================--%>
<script>
var shelfConds = <%= AU.toJson( vm.savedShelfCond ) %>;
_.each(shelfConds, function(o, sectId){
  _.each(o, function(queryset, pzId){
    try {
      var match = queryset.match(/^(.*)\[(..)\]/);
      var query = match[1];
      var kigo  = match[2];
      $('[name="qsf--'+sectId+'--'+pzId+'"]').val(query);
      $('[name="qsfk--'+sectId+'--'+pzId+'"]').val(kigo);
    } catch(e) {}
  });
});
</script>
