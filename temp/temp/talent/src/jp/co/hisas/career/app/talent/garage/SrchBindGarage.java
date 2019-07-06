package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.OneColumnDao;

public class SrchBindGarage extends Garage {
	
	public SrchBindGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public List<String> getRoleList( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select distinct ROLE_ID as text " );
		sql.append( "  from JV_SRCH_BIND bd " );
		sql.append( "       inner join CA_PARTY_COMPANY pc " );
		sql.append( "         on (pc.CMPA_CD = bd.TGT_CMPA_CD) " );
		sql.append( " where pc.PARTY = ? and bd.GUID = ? " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		
		OneColumnDao dao = new OneColumnDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
