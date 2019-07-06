package jp.co.hisas.career.app.talent.api.shareptc.find;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dao.extra.GeneralMapDao;
import jp.co.hisas.career.util.dao.DaoUtil;

public class SharePtcFindLogicGet {
	
	private String daoLoginNo;
	private SharePtcFindEvRslt evRslt;
	
	public SharePtcFindLogicGet(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new SharePtcFindEvRslt();
	}
	
	protected SharePtcFindEvRslt main( SharePtcFindEvArg arg ) {
		
		evRslt.findResult = getFindResult( arg.party, arg.queryMap );
		
		return evRslt;
	}
	
	private List<Map<String, String>> getFindResult( String party, Map<String, String> queryMap ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select EMP_ID, GUID, PRIM_FLG, EMP_NAME, EMP_DESC, DEPT_NM, YKSK_NM " );
		sql.append( "   from ( " );
		sql.append( "          select * " );
		sql.append( "            from JV_SHARE_PARTICIPANT " );
		sql.append( "           where PARTY = ? " );
		sql.append( "             and EMP_NAME like ? " );
		sql.append( "             and DEPT_NM like ? " );
		sql.append( "             and YKSK_NM like ? " );
		sql.append( "           order by BEL_SORT, EMP_ID " );
		sql.append( "        )" );
		sql.append( "  where ROWNUM <= 100 " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( "%" + queryMap.get( "name" ) + "%" );
		paramList.add( "%" + queryMap.get( "dept" ) + "%" );
		paramList.add( "%" + queryMap.get( "yksk" ) + "%" );
		
		String[] cols = { "EMP_ID", "GUID", "PRIM_FLG", "EMP_NAME", "EMP_DESC", "DEPT_NM", "YKSK_NM" };
		String[] keys = { "empId", "guid", "primFlg", "empName", "empDesc", "dept", "yksk" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		return dao.select( cols, keys, DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
