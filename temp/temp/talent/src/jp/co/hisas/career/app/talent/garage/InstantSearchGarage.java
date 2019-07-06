package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;

import jp.co.hisas.career.app.talent.dao.JvTrQuickHistDao;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;

public class InstantSearchGarage extends Garage {
	
	public InstantSearchGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public void insertInstantSearchHistory( String party, String guid, String[] scopes, String query ) {
		
		if (scopes == null || scopes.length == 0) { return; }
		if (SU.isBlank( query )) { return; }
		
		String commaScopes = SU.join( scopes, "," );
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_TR_INSTANT_SEARCH_HIST ");
		sql.append( "values (to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS'), ?, ?, ?, ?) ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( guid );
		paramList.add( commaScopes );
		paramList.add( query );
		
		JvTrQuickHistDao dao = new JvTrQuickHistDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
