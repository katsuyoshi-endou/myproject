package jp.co.hisas.career.app.talent.api.pool;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.extra.JvSrchRsltWkDaoEx;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.util.dao.DaoUtil;

public class PoolLogicGet {
	
	private String daoLoginNo;
	private PoolEvRslt evRslt;
	
	public PoolLogicGet(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new PoolEvRslt();
	}
	
	protected PoolEvRslt main( PoolEvArg arg ) throws SQLException {
		
		ProfileGarage ggPf = new ProfileGarage( daoLoginNo );
		
		List<JvSrchRsltWkDtoEx> list = getSearchResult( arg );
		
		evRslt.resultList = list;
		evRslt.profileAttrMap = ggPf.getProfileAttrMap( arg.party, arg.guid, list, arg.wkIdxBetweenA, arg.wkIdxBetweenB );
		
		return evRslt;
	}
	
	private List<JvSrchRsltWkDtoEx> getSearchResult( PoolEvArg arg ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select w.TGT_CMPA_CD as tgtCmpaCd, w.TGT_STF_NO as tgtStfNo, w.WK_IDX as wkIdx " );
		sql.append( "     , decode(null, st.GUID, 0, 1) as starredFlg " );
		sql.append( "  from JV_SRCH_RSLT_WK w " );
		sql.append( "       left outer join JV_TAL_STARRED st " );
		sql.append( "         on (st.PARTY = w.PARTY and st.GUID = w.GUID and st.TGT_CMPA_CD = w.TGT_CMPA_CD and st.TGT_STF_NO = w.TGT_STF_NO) " );
		sql.append( " where w.SESSION_ID = ? " );
		sql.append( "   and w.PARTY = ? " );
		sql.append( "   and w.WK_IDX between ? and ? " );
		sql.append( " order by w.WK_IDX " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		paramList.add( arg.wkIdxBetweenA + "" );
		paramList.add( arg.wkIdxBetweenB + "" );
		
		JvSrchRsltWkDaoEx dao = new JvSrchRsltWkDaoEx( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
