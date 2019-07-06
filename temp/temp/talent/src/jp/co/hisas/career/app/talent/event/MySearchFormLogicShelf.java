package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.garage.MySrchFormSlfGarage;
import jp.co.hisas.career.app.talent.garage.SrchBindGarage;

public class MySearchFormLogicShelf {
	
	private String daoLoginNo;
	private MySearchFormEvRslt evRslt;
	
	public MySearchFormLogicShelf(String daoLoginNo) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new MySearchFormEvRslt();
	}
	
	protected MySearchFormEvRslt main( MySearchFormEvArg arg ) throws SQLException, NamingException {
		
		SrchBindGarage ggBD = new SrchBindGarage( daoLoginNo );
		MySrchFormSlfGarage ggFs = new MySrchFormSlfGarage( daoLoginNo );
		
		List<String> roleIdList = new ArrayList<String>();
		if (arg.isShared) {
			roleIdList.add( "Public" );
		}
		else {
			roleIdList = ggBD.getRoleList( arg.party, arg.guid );
		}
		
		evRslt.shelftypeList = ggFs.getSrchFormShelf( arg.party, roleIdList );
		
		return evRslt;
	}
	
}
