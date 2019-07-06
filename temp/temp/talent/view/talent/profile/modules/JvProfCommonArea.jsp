<%@ page pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="jp.co.hisas.career.app.*" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.util.dto.*" %><%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<%----------------------------------------------------------------------------------------------- Java Method Layer --%>
<%!
	String getViewStr(String str, Boolean isDisplay) {
		// ※isDisplay: visible or hyphen
		if(!isDisplay) {
			return "<br/>"; // 行すべてが空白になると表示が潰れるため改行を表示
		}
		String s = PZZ010_CharacterUtil.sanitizeStrData( str ).replaceAll("\\n","<br>");
		       s = ("".equals(s)) ? "-" : s ;
		return s;
	}
%>
<%------------------------------------------------------------------------------------------------------ Java Layer --%>
<%@ page import="jp.co.hisas.career.app.talent.dto.extra.*" %>
<jsp:useBean id="jvProfileBean" class="jp.co.hisas.career.app.talent.bean.JvProfileBean" scope="session" />
<%
	List<JvProfTabSectionLayoutDto> sec = jvProfileBean.jvTabLayoutMap.get( "COMMON-BOX" );
	sec = (sec != null) ? sec : new ArrayList<JvProfTabSectionLayoutDto>();
	Iterator<JvProfTabSectionLayoutDto> sectionIterator = sec.iterator();
	
	String party = AU.getParty( session );
	int langNo = AU.getLangNo( session );
	String tgtCmpaCd = AU.getRequestAttr( request, "jvProfileTgtCmpaCd" );
	String tgtStfNo  = AU.getRequestAttr( request, "jvProfileTgtStfNo" );
%>
<%------------------------------------------------------------------------------------------ Additional Style Layer --%>
<%------------------------------------------------------------------------------------------------------ HTML Layer --%>

	<div class="ope-board">
		<hr>
		<div class="tl-prof-common container">
			<div class="photoFrame">
			<% if(AU.matchesCareerProperty( "USE_PICTURE_CLICK_ACTION", "YES" )) { %>
				<img src="/<%= AppDef.CTX_ROOT %>/api/profile/avatar?c=<%= tgtCmpaCd %>&s=<%= tgtStfNo %>" onclick="chgPicture(this)">
				<script>
					function chgPicture(that) {
						var isDummy = that.src.match(/photo\/dummy.gif$/) == "photo\/dummy.gif";
						if (isDummy) {
							that.src = "/<%= AppDef.CTX_ROOT %>/api/profile/avatar?c=<%= tgtCmpaCd %>&s=<%= tgtStfNo %>";
						} else {
							that.src = "/<%= AppDef.CTX_ROOT %>/assets/img/photo/dummy.gif";
						}
					}
				</script>
			<% } else { %>
				<img src="/<%= AppDef.CTX_ROOT %>/api/profile/avatar?c=<%= tgtCmpaCd %>&s=<%= tgtStfNo %>">
			<% } %>
			</div>
			<div class="commonbox-pnl whitebd">
<%
	/* 写真右のCOMMON-BOX生成 */
	while (sectionIterator.hasNext()) {
		JvProfTabSectionLayoutDto layoutDto = sectionIterator.next();
		JvProfTabSectDto sectDto = layoutDto.getJvProfTabSectDto();
		String crrLayoutType = sectDto.getLayoutType();
		String sectClass = SU.isBlank( sectDto.getClasses() ) ? "" : "class=\""+sectDto.getClasses()+"\"";
		// セクションの幅調整はstyle属性に記述する必要あり
		String sectStyle = "";
		if (SU.isNotBlank( sectDto.getWidth() ) || SU.isNotBlank( sectDto.getStyle() )) {
			String styleInner = "";
			if (SU.isNotBlank( sectDto.getWidth() )) {
				styleInner = "width:" + sectDto.getWidth() + ";";
			}
			sectStyle = "style=\"" + styleInner + sectDto.getStyle() + "\"";
		}
		    List<JvProfTabSectBoxtypeDto> cellList = null;
		Iterator<JvProfTabSectBoxtypeDto> cellIte  = null;
		if ("Box".equals(crrLayoutType)) {
			cellList = layoutDto.getBoxtypeSection();
			cellIte  = cellList.iterator();
		}
%>
	<div id="<%= sectDto.getSectId() %>" <%= sectClass %> <%= sectStyle %>>
	
<%		if ("Box".equals(crrLayoutType)) { %>
		<div class="mod-table ami">
			<table>
			<%
				int crrRowNo = 1;
				int prvRowNo = 1;
			%>
						<tr>
			<%
				while (cellIte.hasNext()) {
					JvProfTabSectBoxtypeDto cellDto = cellIte.next();
					crrRowNo = cellDto.getRowNo().intValue();
					String colspanStr = (cellDto.getColspan() == 0) ? "" : "colspan=\""+cellDto.getColspan()+"\"";
					String cellText   = "";
					String cellClass  = SU.isBlank( cellDto.getClasses() ) ? "" : "class=\""+cellDto.getClasses()+"\"";
					String cellWidth  = SU.isBlank( cellDto.getWidth()   ) ? "" : "width=\""+cellDto.getWidth()+"\"";
					String cellStyle  = SU.isBlank( cellDto.getStyle()   ) ? "" : "style=\""+cellDto.getStyle()+"\"";
					if ("label".equals(cellDto.getLabelOrData())) {
						cellText = CommonLabel.getLabelWithHelp(party, cellDto.getParamId(), langNo);
					} else if ("data".equals(cellDto.getLabelOrData())) {
						cellText = getViewStr(jvProfileBean.getCValue(cellDto.getParamId()), true);
					}
					if (crrRowNo != prvRowNo) {
			%>
						</tr>
						<tr>
			<%
					}
			%>
							<<%= cellDto.getTagName() %> <%= colspanStr %> <%= cellClass %> <%= cellWidth %> <%= cellStyle %>><%= cellText %></<%= cellDto.getTagName() %>>
			<%
					prvRowNo = crrRowNo;
				}
			%>
						</tr>
			</table>
		</div><!-- /outputTable -->
<%		} //end of Box %>
	</div><!-- /#<%= sectDto.getSectId() %> -->
<%
	} //end of while
%>
			</div><!-- /.whitebd -->
		</div><!-- /.tl-prof-common -->
		<hr>
	</div><!-- /.ope-board -->
<%------------------------------------------------------------------------------------------------ JavaScript Layer --%>
