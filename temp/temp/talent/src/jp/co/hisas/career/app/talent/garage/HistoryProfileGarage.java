package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;

import jp.co.hisas.career.app.talent.dao.JvTrProfViewHistDao;
import jp.co.hisas.career.util.dao.DaoUtil;

public class HistoryProfileGarage extends Garage {
	
	public HistoryProfileGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public void insertProfileViewHistory( String party, String guid, String tgtCmpaCd, String tgtStfNo ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "insert into JV_TR_PROF_VIEW_HIST ");
		sql.append( "select NEXT_SEQ, ?, ?, ?, ?, to_char(sysdate, 'YYYY/MM/DD HH24:MI:SS') ");
		sql.append( "  from (select nvl(max(SEQ_NO),0)+1 as NEXT_SEQ from JV_TR_PROF_VIEW_HIST) t ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( guid );
		paramList.add( tgtCmpaCd );
		paramList.add( tgtStfNo );
		
		JvTrProfViewHistDao dao = new JvTrProfViewHistDao( daoLoginNo );
		dao.executeDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
