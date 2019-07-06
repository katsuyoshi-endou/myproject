package jp.co.hisas.career.app.talent.bean;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.common.PZZ010_CharacterUtil;
import jp.co.hisas.career.util.property.CommonLabel;

public class JvSrchRsltBean {
	
	public JvSrchRsltBean(String loginNo) {
//		this.loginNo = loginNo;
	}
	
	public static String sanitize( String str ) {
		return PZZ010_CharacterUtil.sanitizeStrData( str );
	}
	
	public static Map<Integer, JvSrchRsltListDto> getJvSrchRsltList( HttpServletRequest request, HttpSession session ) {
		Map<Integer, JvSrchRsltListDto> jvSrchRsltList = null;
		jvSrchRsltList = AU.getSessionAttr( session, JvSessionKey.VDD020_LIST );
		return jvSrchRsltList;
	}
	
	public static String getVal( JvSrchRsltListDto dto, int itemNo ) {
		String itemNo00 = SU.cnvFormat00( itemNo );
		String methodName = "getItem" + itemNo00;
		String result = null;
		try {
			Method m = dto.getClass().getDeclaredMethod( methodName, new Class[] {} );
			result = (String)m.invoke( dto, new Object[] {} );
		} catch (Exception e) {
		}
		return sanitize( result );
	}
	
	public static int getPtnColLimit( String colsPtn ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put( "X", 0 );
		map.put( "A", 40 );
		map.put( "B", 15 );
		map.put( "C", 15 );
		map.put( "D", 17 );
		map.put( "E", 20 );
		map.put( "F", 53 );
		map.put( "G", 18 );
		map.put( "H", 24 );
		map.put( "I", 16 );
		return map.get( colsPtn );
	}
	
	public static String getPtnTableWidth( String colsPtn ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put( "X", getWidth( "X" ) );
		map.put( "A", getWidth( "A" ) );
		map.put( "B", getWidth( "B" ) );
		map.put( "C", getWidth( "C" ) );
		map.put( "D", getWidth( "D" ) );
		map.put( "E", getWidth( "E" ) );
		map.put( "F", getWidth( "F" ) );
		map.put( "G", getWidth( "G" ) );
		map.put( "H", getWidth( "H" ) );
		map.put( "I", getWidth( "I" ) );
		return "width:" + map.get( colsPtn ) + "px;";
	}
	
	public static String getPtnTableWidth( String party, String colsPtn, int langNo ) {
		Map<String, Integer> map = new HashMap<String, Integer>();
		map.put( "X", getWidth( party, "X", langNo ) );
		map.put( "A", getWidth( party, "A", langNo ) );
		map.put( "B", getWidth( party, "B", langNo ) );
		map.put( "C", getWidth( party, "C", langNo ) );
		map.put( "D", getWidth( party, "D", langNo ) );
		map.put( "E", getWidth( party, "E", langNo ) );
		map.put( "F", getWidth( party, "F", langNo ) );
		map.put( "G", getWidth( party, "G", langNo ) );
		map.put( "H", getWidth( party, "H", langNo ) );
		map.put( "I", getWidth( party, "I", langNo ) );
		return "width:" + map.get( colsPtn ) + "px;";
	}

	private static int getWidth( String colsPtn ) {
		return SU.toInt( CommonLabel.getLabel( "JV_SRCH_LIST_WIDTH_PTN_" + colsPtn ), 3000 );
	}
	
	private static int getWidth( String party, String colsPtn, int langNo ) {
		return SU.toInt( CommonLabel.getLabel( party, "JV_SRCH_LIST_WIDTH_PTN_" + colsPtn, langNo ), 3000 );
	}

	public static String getHeaderLabelTag( String party, String colsPtn ) {
		return CommonLabel.getLabel( party, "LTLSRL_HEADER_PTN_" + colsPtn );
	}

	public static String getHeaderLabelTag( String party, String colsPtn, int langNo ) {
		return CommonLabel.getLabel( party, "LTLSRL_HEADER_PTN_" + colsPtn, langNo );
	}
}
