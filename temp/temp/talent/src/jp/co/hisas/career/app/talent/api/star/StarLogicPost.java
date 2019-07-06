package jp.co.hisas.career.app.talent.api.star;

import java.sql.SQLException;

import jp.co.hisas.career.app.talent.dao.JvTalStarredDao;
import jp.co.hisas.career.app.talent.dto.JvTalStarredDto;

public class StarLogicPost {
	
	private String daoLoginNo;
	private StarEvRslt evRslt;
	
	public StarLogicPost(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new StarEvRslt();
	}
	
	protected StarEvRslt main( StarEvArg arg ) throws SQLException {
		
		delete( arg );
		insert( arg );
		
		return evRslt;
	}
	
	private void insert( StarEvArg arg ) throws SQLException {
		JvTalStarredDao dao = new JvTalStarredDao( this.daoLoginNo );
		JvTalStarredDto dto = new JvTalStarredDto();
		dto.setGuid( arg.guid );
		dto.setParty( arg.party );
		dto.setTgtCmpaCd( arg.tgtCmpaCd );
		dto.setTgtStfNo( arg.tgtStfNo );
		dao.insert( dto );
	}
	
	private void delete( StarEvArg arg ) {
		JvTalStarredDao dao = new JvTalStarredDao( this.daoLoginNo );
		dao.delete( arg.party, arg.guid, arg.tgtCmpaCd, arg.tgtStfNo );
	}
	
}
