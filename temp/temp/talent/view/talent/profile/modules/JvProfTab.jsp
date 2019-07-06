
<%@ page pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="jp.co.hisas.career.app.talent.bean.KomokuFilterBean" %>
<%@ page import="jp.co.hisas.career.util.*" %>
<%@ page import="jp.co.hisas.career.util.common.*" %>
<%@ page import="jp.co.hisas.career.app.talent.dto.*" %>
<%@ page import="jp.co.hisas.career.app.talent.dto.extra.*" %>
<%@ page import="jp.co.hisas.career.util.log.*" %>
<%@ page import="jp.co.hisas.career.util.property.*" %>
<jsp:useBean id="jvProfileBean" class="jp.co.hisas.career.app.talent.bean.JvProfileBean" scope="session" />
<%!
	String getViewStr(String str) {
		String s = PZZ010_CharacterUtil.sanitizeStrData( str ).replaceAll("\\n","<br>");
		       s = ("".equals(s)) ? "-" : s ;
		return s;
	}

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
<%
	String party = AU.getParty( session );
	int langNo = AU.getLangNo( session );

	// 原籍情報
	KomokuFilterBean kf = jvProfileBean.getKomokuFilter();

	String tab = request.getParameter( "tab" );
	List<JvProfTabSectionLayoutDto> sec = jvProfileBean.jvTabLayoutMap.get( tab );
	if (sec == null) { sec = new ArrayList<JvProfTabSectionLayoutDto>(); }
	Iterator<JvProfTabSectionLayoutDto> sectionIterator = sec.iterator();

	// 遷移元メニューフラグ
	String menuFlg = (String)request.getSession().getAttribute("menuFlg");
	boolean isBoss = "boss".equals(menuFlg);
%>

<%-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
     Section Loop
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = --%>
<%
	while (sectionIterator.hasNext()) {
		JvProfTabSectionLayoutDto layoutDto = sectionIterator.next();
		JvProfTabSectDto sectDto = layoutDto.getJvProfTabSectDto();
		String crrLayoutType = sectDto.getLayoutType();
		String sectClsIn = SU.ntb( sectDto.getClasses() );
		String sectClass = "class=\"sect " + sectClsIn + "\"";
		// セクションの幅調整はstyle属性に記述する必要あり
		String sectStyle = "";
		if (SU.isNotBlank( sectDto.getWidth() ) || SU.isNotBlank( sectDto.getStyle() )) {
			String styleInner = "";
			if (SU.isNotBlank( sectDto.getWidth() )) {
				styleInner = "width:" + sectDto.getWidth() + ";";
			}
			sectStyle = "style=\"" + styleInner + sectDto.getStyle() + "\"";
		}
		String sectionLabelText = CommonLabel.getLabelWithHelp(party, sectDto.getLabelId(), langNo);
		boolean isSectionTitle2nd = !"".equals(sectionLabelText);
		    List<JvProfTabSectBoxtypeDto> cellList = null;
		Iterator<JvProfTabSectBoxtypeDto> cellIte  = null;
		    List<JvProfTabSectListtypeDto> columList = null;
		Iterator<JvProfTabSectListtypeDto> listIteTh = null;
		Iterator<JvProfTabSectListtypeDto> listIteTd = null;
		Iterator<JvProfTabSectListtypeDto> listIteThSub    = null;
		Iterator<JvProfTabSectListtypeDto> listIteThSubChk = null;
		    List<JvProfTabSectAddontypeDto> addonList = null;
		         JvProfTabSectAddontypeDto addonDto = null;
		boolean isThSub = false;
		if ("Title".equals(crrLayoutType)) {
			;
		} else if ("Guidance".equals(crrLayoutType)) {
			;
		} else if ("Box".equals(crrLayoutType)) {
			cellList = layoutDto.getBoxtypeSection();
			cellIte  = cellList.iterator();
		} else if ("List".equals(crrLayoutType)) {
			columList    = layoutDto.getListtypeSection();
			listIteTh    = columList.iterator();
			listIteTd    = columList.iterator();
			listIteThSub    = columList.iterator();
			listIteThSubChk = columList.iterator();
			while (listIteThSubChk.hasNext()) {
				JvProfTabSectListtypeDto hSubDto = listIteThSubChk.next();
				String hSubLabelId = hSubDto.getSubHeaderLabelId();
				if ( !"".equals(hSubLabelId) ) {
					// SubHeader系の列になにか値が入っていたらON
					isThSub = true;
					break;
				}
			}
		} else if ("Addon".equals(crrLayoutType)) {
			addonList = layoutDto.getAddontypeSection();
			if (addonList != null && addonList.size() > 0) {
				addonDto = addonList.get(0);
			}
		}
%>
	<div id="<%= sectDto.getSectId() %>" <%= sectClass %> <%= sectStyle %>>

		<%-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     TYPE: Title
		 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --%>
<%		if ("Title".equals(crrLayoutType)) { %>
		<h2 class="sectionTitleFirst"><%= sectionLabelText %></h2>
<%		} //end of Title %>

		<%-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     TYPE: Guidance
		 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --%>
<%		if ("Guidance".equals(crrLayoutType)) { %>
		<div class="guidanceMessage">
			<ul><li><%= sectionLabelText %></li></ul>
		</div><!-- /guidanceMessage -->
<%		} //end of Guidance %>

		<%-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     TYPE: Box
		 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --%>
<%		if ("Box".equals(crrLayoutType)) { %>
<%			if (isSectionTitle2nd) {	%>
		<h3 class="sectionTitleSecond"><%= sectionLabelText %></h3>
<%			}	%>
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
		</div><!-- /.mod-table -->
<%		} //end of Box %>

		<%-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     TYPE: List
		 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --%>
<%		if ("List".equals(crrLayoutType)) { %>
<%			if (isSectionTitle2nd) {	%>
		<h3 class="sectionTitleSecond"><%= sectionLabelText %></h3>
<%			}	%>
		<div class="mod-table ami">
			<table>
				<thead>
					<tr>
					<%
						while (listIteTh.hasNext()) {
							JvProfTabSectListtypeDto d = listIteTh.next();
							String  hLabelText = CommonLabel.getLabelWithHelp(party, d.getHeaderLabelId(), langNo);
							String  hClass     = SU.isBlank( d.getClasses()     ) ? "" : "class=\""+d.getClasses()+"\"" ;
							String  hWidth     = SU.isBlank( d.getWidth()       ) ? "" : "width=\""+d.getWidth()+"\"" ;
							String  hStyle     = SU.isBlank( d.getHeaderStyle() ) ? "" : "style=\""+d.getHeaderStyle()+"\"" ;
							if (!"".equals(d.getHeaderLabelId())) {
					%>
						<th <%= hClass %> <%= hWidth %> <%= hStyle %>><%= hLabelText %></th>
					<%
							}
						}
					%>
					</tr>
					<% if (isThSub) { %>
					<tr>
					<%
						// SUB HEADER (No ATTR & No Style)
						while (listIteThSub.hasNext()) {
							JvProfTabSectListtypeDto d = listIteThSub.next();
							String  hSubLabelText  = CommonLabel.getLabelWithHelp(party, d.getSubHeaderLabelId(), langNo);
							if (!"".equals(d.getSubHeaderLabelId())) {
					%>
						<th><%= hSubLabelText %></th>
					<%
							}
						}
					%>
					</tr>
					<% } %>
				</thead>
				<tbody>
					<%
						String[] komokuIdArr = new String[columList.size()];
						String[] classArr    = new String[columList.size()];
						String[] styleArr    = new String[columList.size()];
						for (int i=0; i<columList.size(); i++) {
							JvProfTabSectListtypeDto d = listIteTd.next();
							komokuIdArr[i] = SU.isBlank( d.getDataParamId() ) ? "" : d.getDataParamId() ;
							classArr[i]    = SU.isBlank( d.getClasses()     ) ? "" : "class=\""+d.getClasses()+"\"";
							styleArr[i]    = SU.isBlank( d.getDataStyle()   ) ? "" : "style=\""+d.getDataStyle()+"\"";
						}
						int maxRow = jvProfileBean.getMaxNumberTcValue(komokuIdArr);
						for (int i=0; i<=maxRow; i++) {
							//件数制限入れるならここ
							if (jvProfileBean.isExistsNumber(komokuIdArr, i)) {
					%>
					<tr>
					<% for (int j=0; j<columList.size(); j++) { %>
						<td <%= classArr[j] %> <%= styleArr[j] %> ><%= getViewStr(jvProfileBean.getTcValue(komokuIdArr[j], i), true) %></td>
					<% } %>
					</tr>
					<%
							}
						}
					%>
			</table>
		</div><!-- /.mod-table -->
<%		} //end of List %>

		<%-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		     TYPE: Addon
		 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --%>
<%		if ("Addon".equals(crrLayoutType)) { %>
<%			if (isSectionTitle2nd) {	%>
		<h3 class="sectionTitleSecond"><%= sectionLabelText %></h3>
<%			}	%>
		<% String pagePath = "/view/talent/profile/addons/" + addonDto.getAddonId() + ".jsp"; %>
		<jsp:include page="<%= pagePath %>" flush="false" />
<%		} //end of Addon %>

	</div><!-- /#<%= sectDto.getSectId() %> -->
<%
	} //end of while
%>


