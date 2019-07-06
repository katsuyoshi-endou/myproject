package jp.co.hisas.career.app.talent.servlet;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dto.JvSectTblMapDto;
import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchCsvDto;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvArg;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvHdlr;
import jp.co.hisas.career.app.talent.event.SearchTalentsEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.bean.OutLogBean;
import jp.co.hisas.career.util.property.CommonLabel;

public class JvPzCsvDownloadServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "JvPzCsv";
	private static final String FORWARD_PAGE = "/servlet/CsvDownloadServlet";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		if (SU.equals( "SECT", tray.state )) {
			Map<String, JvSectTblMapDto> sectTblMap = tray.getSessionAttr( JvSessionKey.SRCH_SECT_TBL_MAP );
			String sectPtn = AU.getRequestValue( tray.request, "sectptn" );
			String sectId = SU.extract( sectPtn, "^(.*?)_(BX|LT)$" );
			JvSectTblMapDto dto = sectTblMap.get( sectId );
			String tblObj = dto.getTblObj();
			String csvPtnId = dto.getCsvPtnId();
			
			String dlFileName = dto.getFileNm() + "_" + AU.getTimestamp( "yyyyMMddHHmmss" ) + ".csv";
			List<String> dlCsvHeader = convertComma2ColList( CommonLabel.getLabel( tray.party, "JV_SRCH_CSV_HEADER_" + csvPtnId, tray.langNo ) );
			List<List<String>> dlCsvRows = makeCsvRows_SECT( tray, sectId, tblObj, csvPtnId, dlCsvHeader.size() );
			
			AU.setReqAttr( tray.request, "dlFileName", dlFileName );
			AU.setReqAttr( tray.request, "dlCsvHeader", dlCsvHeader );
			AU.setReqAttr( tray.request, "dlCsvRows", dlCsvRows );
		}
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, null, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
	private List<List<String>> makeCsvRows_SECT( Tray tray, String sectId, String tblObj, String csvPtnId, int colCnt ) throws CareerException {
		
		SearchTalentsEvArg arg = new SearchTalentsEvArg( tray.loginNo );
		arg.sharp = "CSV_SECT";
		arg.sessionId = tray.session.getId();
		arg.party = tray.party;
		arg.sectId = sectId;
		arg.tblObj = tblObj;
		SearchTalentsEvRslt result = SearchTalentsEvHdlr.exec( arg );
		
		List<List<String>> rows = new ArrayList<List<String>>();
		
		for (int i = 0; i < result.jvSrchCsvRowList.size(); i++) {
			JvSrchCsvDto dto = result.jvSrchCsvRowList.get( i );
			List<String> colList = convertDto2SectColList( dto, colCnt );
			rows.add( colList );
		}
		return rows;
	}
	
	private List<String> convertComma2ColList( String str ) {
		if (SU.isBlank( str )) {
			return new ArrayList<String>();
		}
		List<String> result = new ArrayList<String>();
		String[] strArr = str.split( "," );
		for (int i = 0; i < strArr.length; i++) {
			result.add( strArr[i] );
		}
		return result;
	}
	
	private List<String> convertDto2SectColList( JvSrchCsvDto dto, int colCnt ) {
		List<String> result = new ArrayList<String>();
		for (int i = 1; i <= colCnt; i++) {
			String val = getDtoVal( dto, i );
			result.add( val );
		}
		return result;
	}
	
	public static String getDtoVal( JvSrchRsltListDto dto, int itemNo ) {
		String itemNo00 = SU.cnvFormat00( itemNo );
		String methodName = "getItem" + itemNo00;
		String result = null;
		try {
			Method m = dto.getClass().getDeclaredMethod( methodName, new Class[] {} );
			result = (String)m.invoke( dto, new Object[] {} );
		} catch (Exception e) {
		}
		return result;
	}
	
	public static String getDtoVal( JvSrchCsvDto dto, int itemNo ) {
		String itemNo00 = SU.cnvFormat00( itemNo );
		String methodName = "getItem" + itemNo00;
		String result = null;
		try {
			Method m = dto.getClass().getDeclaredMethod( methodName, new Class[] {} );
			result = (String)m.invoke( dto, new Object[] {} );
		} catch (Exception e) {
		}
		return result;
	}
	
}
