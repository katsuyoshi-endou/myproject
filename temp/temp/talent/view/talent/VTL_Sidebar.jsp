<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fw" uri="/xml/framework.tld" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*"%>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%@ page import="jp.co.hisas.career.app.talent.vm.*" %>
<%@ page import="jp.co.hisas.career.app.talent.command.PTLMENCommand" %>
<fw:init commandClass="<%= PTLMENCommand.class %>" />
<%
	VmVTLHOM vm = AU.getSessionAttr( session, VmVTLHOM.VMID );
%>

<div id="gSidebar">

	<div class="sidebar-menu">
		<a href="#" class="sb-item js-menu" data-path="/servlet/JvProfileServlet" data-state="SELF">
			<i class="fa fa-user"></i><span><%= vm.gCL("LTLHOM_MYPRF") %></span>
		</a>
		<% if (vm.hasRoles) { %>
		<a href="#" class="sb-item js-menu" data-path="/servlet/ShowResultServlet" data-state="ALL">
			<i class="fa fa-users"></i><span><%= vm.gCL("LTLHOM_ALL") %></span>
		</a>
		<a href="#" class="sb-item js-menu" data-path="/servlet/ShowResultServlet" data-state="STAR">
			<i class="fa fa-star"></i><span><%= vm.gCL("LTLHOM_STAR") %></span>
		</a>
		<% } %>
		
		<%-- MySearch (Private) --%>
		<% if (vm.hasRoles) { %>
			<div class="sb-title">
				<span class="lbl"><%= vm.gCL("LTLHOM_MYSRCH") %></span>
				<a href="#" class="new js-menu" data-path="/view/talent/search/VTLSCE_SearchCondEdit.jsp" data-state="NEW"><%= vm.gCL("LTLHOM_MYSRCH_NEW") %></a>
			</div>
			<% for (JvTrMysrchDto dto : vm.mysrchList) { %>
				<a href="#" class="sb-item js-menu" data-path="/servlet/SearchTalentsServlet" data-state="SEARCH" data-myid="<%= dto.getMysrchId() %>">
					<i class="fa fa-search"></i>
					<span><%= vm.escx( dto.getMysrchNm() ) %></span>
				</a>
			<% } %>
		<% } %>
		
		<%-- MyFolder (Private) --%>
		<% if (vm.hasRoles) { %>
			<div class="sb-title">
				<span class="lbl"><%= vm.gCL("LTLHOM_MYFOLD") %></span>
				<a href="#" class="new js-menu" data-path="/view/talent/search/VTLFDE_FolderEdit.jsp" data-state="NEW"><%= vm.gCL("LTLHOM_MYFOLD_NEW") %></a>
			</div>
			<% for (JvTrMyfoldDto dto : vm.myfoldList) { %>
				<a href="#" class="sb-item js-menu" data-path="/servlet/ShowResultServlet" data-state="FOLDER" data-myid="<%= dto.getMyfoldId() %>">
					<i class="fa fa-folder"></i>
					<span><%= vm.escx( dto.getMyfoldNm() ) %></span>
				</a>
			<% } %>
		<% } %>
		
		<%-- MySearch (Shared) --%>
		<% if (vm.hasRoles) { %>
			<div class="sb-title">
				<span class="lbl"><%= vm.gCL("LTLHOM_SHERESRCH") %></span>
				<a href="#" class="new js-menu is-shared" data-path="/view/talent/search/VTLSCE_SearchCondEdit.jsp" data-state="NEW"><%= vm.gCL("LTLHOM_SHERESRCH_NEW") %></a>
			</div>
			<% for (JvTrMysrchDto dto : vm.sharedMysrchList) { %>
				<a href="#" class="sb-item js-menu is-shared" data-path="/servlet/SearchTalentsServlet" data-state="SEARCH" data-myid="<%= dto.getMysrchId() %>">
					<i class="fa fa-search"></i>
					<span><%= vm.escx( dto.getMysrchNm() ) %></span>
				</a>
			<% } %>
		<% } %>
		
		<%-- MyFolder (Shared) --%>
		<% if (vm.hasRoles) { %>
			<div class="sb-title">
				<span class="lbl"><%= vm.gCL("LTLHOM_SHEREFOLD") %></span>
				<a href="#" class="new js-menu is-shared" data-path="/view/talent/search/VTLFDE_FolderEdit.jsp" data-state="NEW"><%= vm.gCL("LTLHOM_SHEREFOLD_NEW") %></a>
			</div>
			<% for (JvTrMyfoldDto dto : vm.sharedMyfoldList) { %>
				<a href="#" class="sb-item js-menu is-shared" data-path="/servlet/ShowResultServlet" data-state="FOLDER" data-myid="<%= dto.getMyfoldId() %>">
					<i class="fa fa-folder"></i>
					<span><%= vm.escx( dto.getMyfoldNm() ) %></span>
				</a>
			<% } %>
		<% } %>
	</div>

	<script>
	__MsgMap = {};
	__MsgMap["LTLHOM_MSG_NEW_SRCH_LIMIT"] = '<%= vm.gCL("LTLHOM_MSG_NEW_SRCH_LIMIT") %>';
	__MsgMap["LTLHOM_MSG_NEW_FOLD_LIMIT"] = '<%= vm.gCL("LTLHOM_MSG_NEW_FOLD_LIMIT") %>';
	$(function(){
		Talent.Menu.showActiveState('<%= vm.activeState %>', '<%= vm.activeSeqNo %>');
	});
	</script>

</div><!-- /#gSidebar -->
