<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %><%@ page import="jp.co.hisas.career.app.AppDef" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.vm.*" %>
<jsp:useBean id="oneMenu" class="jp.co.hisas.career.app.common.bean.CareerMenuBean" scope="session" />
<%
	Tray tray = new Tray( request, response );
	VmVSHSHT vm = new VmVSHSHT( tray );
%>

	<jsp:include page="/view/common/VYC_Modal.jsp" flush="false" />

	<div class="modal-body-src">
		<div class="CsDeliv">
			<div class="closearea"><a class="close" href="#"><i class="fa fa-close"></i></a></div>
			<div class="modal-header">
				<h4><%= vm.gCL( "LHD010_DELIV_TITLE" ) %></h4>
				<p><%= vm.gCL( "LHD010_DELIV_DESC" ) %></p>
			</div>
			<div class="modal-body">
				<textarea class="block" name="deliv_msg" rows="5"></textarea>
			</div>
			<div class="modal-footer">
				<button id="modal-submit-btn" type="button" class="btn btn-primary">OK</button>
			</div>
		</div>
	</div>
