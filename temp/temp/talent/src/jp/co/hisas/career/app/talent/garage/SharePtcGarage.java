package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dao.JvTrMyfoldPtcDao;
import jp.co.hisas.career.app.talent.dao.JvTrMysrchPtcDao;
import jp.co.hisas.career.app.talent.dao.extra.GeneralMapDao;
import jp.co.hisas.career.app.talent.dto.JvTrMyfoldPtcDto;
import jp.co.hisas.career.app.talent.dto.JvTrMysrchPtcDto;
import jp.co.hisas.career.util.dao.DaoUtil;

public class SharePtcGarage extends Garage {
	
	public SharePtcGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public List<Map<String, String>> getMysrchPtcList( String mysrchId, String party ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select v.EMP_ID, p.GUID, p.OWNER_FLG, p.EDITABLE_FLG, v.EMP_NAME, v.EMP_DESC, v.DEPT_NM, v.YKSK_NM " );
		sql.append( "   from ( " );
		sql.append( "          select PARTY, GUID, OWNER_FLG, CND_EDIT_FLG as EDITABLE_FLG " );
		sql.append( "            from JV_TR_MYSRCH_PTC where MYSRCH_ID = ? and PARTY = ? " );
		sql.append( "        ) p " );
		sql.append( "        inner join JV_SHARE_PARTICIPANT v " );
		sql.append( "          on (v.PARTY = p.PARTY and v.GUID = p.GUID and v.PRIM_FLG = '1') " );
		sql.append( "  order by p.OWNER_FLG desc, v.BEL_SORT, p.GUID " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( mysrchId );
		paramList.add( party );
		
		String[] cols = { "EMP_ID", "GUID", "OWNER_FLG", "EDITABLE_FLG", "EMP_NAME", "EMP_DESC", "DEPT_NM", "YKSK_NM" };
		String[] keys = { "empId", "guid", "ownerFlg", "editableFlg", "empName", "empDesc", "deptNm", "ykskNm" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		return dao.select( cols, keys, DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public JvTrMysrchPtcDto getMySearchPtc( String mysrchId, String party, String tgtGuid ) {
		JvTrMysrchPtcDao dao = new JvTrMysrchPtcDao( daoLoginNo );
		return dao.select( mysrchId, party, tgtGuid );
	}
	
	public List<Map<String, String>> getMyfoldPtcList( String myfoldId, String party ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select v.EMP_ID, p.GUID, p.OWNER_FLG, p.EDITABLE_FLG, v.EMP_NAME, v.EMP_DESC, v.DEPT_NM, v.YKSK_NM " );
		sql.append( "   from ( " );
		sql.append( "          select PARTY, GUID, OWNER_FLG, TAL_EDIT_FLG as EDITABLE_FLG " );
		sql.append( "            from JV_TR_MYFOLD_PTC where MYFOLD_ID = ? and PARTY = ? " );
		sql.append( "        ) p " );
		sql.append( "        inner join JV_SHARE_PARTICIPANT v " );
		sql.append( "          on (v.PARTY = p.PARTY and v.GUID = p.GUID and v.PRIM_FLG = '1') " );
		sql.append( "  order by p.OWNER_FLG desc, v.BEL_SORT, p.GUID " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( myfoldId );
		paramList.add( party );
		
		String[] cols = { "EMP_ID", "GUID", "OWNER_FLG", "EDITABLE_FLG", "EMP_NAME", "EMP_DESC", "DEPT_NM", "YKSK_NM" };
		String[] keys = { "empId", "guid", "ownerFlg", "editableFlg", "empName", "empDesc", "deptNm", "ykskNm" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		return dao.select( cols, keys, DaoUtil.getPstmt( sql, paramList ) );
	}
	
	public JvTrMyfoldPtcDto getMyFolderPtc( String myfoldId, String party, String tgtGuid ) {
		JvTrMyfoldPtcDao dao = new JvTrMyfoldPtcDao( daoLoginNo );
		return dao.select( myfoldId, party, tgtGuid );
	}
	
}
