package jp.co.hisas.career.app.talent.event;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.JvDfInstantSearchDao;
import jp.co.hisas.career.app.talent.dto.JvDfInstantSearchDto;
import jp.co.hisas.career.app.talent.garage.MyFoldGarage;
import jp.co.hisas.career.app.talent.garage.MySrchGarage;
import jp.co.hisas.career.app.talent.garage.SrchBindGarage;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log;

public class MyMenuEvHdlr extends AbstractEventHandler<MyMenuEvArg, MyMenuEvRslt> {
	
	public static MyMenuEvRslt exec( MyMenuEvArg arg ) throws CareerException {
		MyMenuEvHdlr handler = new MyMenuEvHdlr();
		return handler.call( arg );
	}
	
	public MyMenuEvRslt call( MyMenuEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected MyMenuEvRslt execute( MyMenuEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		MyMenuEvRslt result = new MyMenuEvRslt();
		try {
			
			if (SU.equals( arg.sharp, "INIT" )) {
				
				SrchBindGarage ggBd = new SrchBindGarage( daoLoginNo );
				SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
				MySrchGarage ggMs = new MySrchGarage( daoLoginNo );
				MyFoldGarage ggMf = new MyFoldGarage( daoLoginNo );
				
				List<String> roleList = ggBd.getRoleList( arg.party, daoLoginNo );
				
				result.hasRoles = roleList.size() > 0;
				result.mysrchList = ggMs.getPrivateMysearchList( arg.party, daoLoginNo );
				result.myfoldList = ggMf.getPrivateMyfolderList( arg.party, daoLoginNo );
				result.sharedMysrchList = ggMs.getSharedMysearchList( arg.party, daoLoginNo );
				result.sharedMyfoldList = ggMf.getSharedMyfolderList( arg.party, daoLoginNo );
				result.instantSearchScopeList = selectInstantSearchScopeList( daoLoginNo, arg );
				result.canRetireSrch = ggWk.judgeRetireSearchable( arg.party, daoLoginNo );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private List<JvDfInstantSearchDto> selectInstantSearchScopeList( String daoLoginNo, MyMenuEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "ins", JvDfInstantSearchDao.ALLCOLS ) );
		sql.append( "  from JV_DF_INSTANT_SEARCH ins " );
		sql.append( "       inner join ( " );
		sql.append( "         select distinct sc.PARTY, sc.SCOPE " );
		sql.append( "           from JV_DF_INSTANT_SEARCH_SCOPE sc " );
		sql.append( "                inner join JV_PROF_KOMOKU_FILTER kf " );
		sql.append( "                  on (kf.PARTY = sc.PARTY and kf.KOMOKU_ID = sc.PZ_ID) " );
		sql.append( "          where sc.PARTY = ? " );
// MOD 2017/08/07 r-hagiwara 性能対策 START
//		sql.append( "            and kf.ROLE_ID in ( select bd.ROLE_ID from JV_SRCH_BIND bd where bd.GUID = ? ) " );
		sql.append( "            and EXISTS ( select 1 from JV_SRCH_BIND bd where bd.GUID = ? and bd.ROLE_ID = kf.ROLE_ID) " );
// MOD 2017/08/07 r-hagiwara 性能対策 END
		sql.append( "            and kf.DISPLAY_MODE = 'visible' " );
		sql.append( "       ) scl " );
		sql.append( "         on (scl.PARTY = ins.PARTY and scl.SCOPE = ins.SCOPE) " );
		sql.append( " order by ins.SORT " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.party );
		paramList.add( arg.guid );
		
		JvDfInstantSearchDao dao = new JvDfInstantSearchDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
