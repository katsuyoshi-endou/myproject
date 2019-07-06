<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.sheet.dto.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.util.*" %>
<%@ page import="jp.co.hisas.career.app.sheet.event.*" %>
<%
	CsSingleSheet jsp = AU.getSessionAttr( session, CsSessionKey.CS_SINGLE_SHEET );
	CsProgressEventResult result = AU.getSessionAttr( session, CsSessionKey.CS_PROGRESS );
	List<String> opeList = result.opSets.get( jsp.sheetInfo.getParty() );
	String opeCd = jsp.sheetInfo.getOperationCd();
%>
	<div class="csmd-status-summary">
	<% for (String fgCd : result.fgSets.get( opeCd )) { %>
		<div class="sheet-status">
			<table class="sheet-status-layout">
				<tr>
					<% for (String sgCd : result.sgSets.get( opeCd+fgCd )) { %>
					<td style="width:23%;">
						<table class="sheet-status-col" data-operationCd="<%= opeCd %>" data-formGrpCd="<%= fgCd %>">
							<tr>
								<th class="sheet-status-th">
									<%= result.opeFgSgMap.get( opeCd+fgCd+sgCd ).get( 0 ).getStatusGrpNm() %>
								</th>
							</tr>
							<% for (String stCd : result.stSets.get( opeCd+fgCd+sgCd )) { %>
							<%
								CsxSheetStatusProgressDto cntDto = result.sheetCountMap.get( opeCd+fgCd+stCd );
								CsxSheetStatusProgressDto holdDto = AU.nvl( result.sheetHoldMap.get( opeCd+fgCd+stCd ), new CsxSheetStatusProgressDto() );
								String statusNm  = cntDto.getStatusNm();
								String sheetCnt  = (0 == cntDto.getSheetCount()) ? "-" : cntDto.getSheetCount().toString();
								String clsIsZero = (  cntDto.getSheetCount() == 0    ) ? "isZero" : "";
								String clsIsHold = ( holdDto.getSheetCount() != null ) ? "isHold" : "";
								String boxId     = opeCd + "-" + fgCd + "-" + stCd;
							%>
								<tr data-statusCd="<%= stCd %>">
									<td><i class="fa"></i><%= statusNm %></td>
								</tr>
							<% } %>
						</table>
					</td>
					<% } %>
				</tr>
			</table>
		</div>
	<% } %>
	</div><!-- /.status-summary -->
