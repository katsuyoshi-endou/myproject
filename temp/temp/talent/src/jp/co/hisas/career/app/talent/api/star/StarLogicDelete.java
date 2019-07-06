package jp.co.hisas.career.app.talent.api.star;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.dao.JvTalStarredDao;

public class StarLogicDelete {
	
	private String daoLoginNo;
	private StarEvRslt evRslt;
	
	public StarLogicDelete(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new StarEvRslt();
	}
	
	protected StarEvRslt main( StarEvArg arg ) throws SQLException {
		
		delete( arg );
		
		return evRslt;
	}
	
	private void delete( StarEvArg arg ) {
		JvTalStarredDao dao = new JvTalStarredDao( this.daoLoginNo );
		dao.delete( arg.party, arg.guid, arg.tgtCmpaCd, arg.tgtStfNo );
	}
	
}
