package jp.co.hisas.career.app.talent.event;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.extra.JvWkInstantHitExDao;
import jp.co.hisas.career.app.talent.dto.extra.JvWkInstantHitExDto;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log;

public class InstantSearchEvHdlr extends AbstractEventHandler<InstantSearchEvArg, InstantSearchEvRslt> {
	
	public static InstantSearchEvRslt exec( InstantSearchEvArg arg ) throws CareerException {
		InstantSearchEvHdlr handler = new InstantSearchEvHdlr();
		return handler.call( arg );
	}
	
	public InstantSearchEvRslt call( InstantSearchEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected InstantSearchEvRslt execute( InstantSearchEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		InstantSearchEvRslt result = new InstantSearchEvRslt();
		try {
			
			if (SU.equals( "SEARCH", arg.sharp )) {
				
				InstantSearchLogicSearch logic = new InstantSearchLogicSearch( arg.getLoginNo() );
				result = logic.main( arg );
			}
			else if (SU.equals( "MLTSTFNO", arg.sharp )) {
				
				InstantSearchLogicMltsearch logic = new InstantSearchLogicMltsearch( arg.getLoginNo() );
				result = logic.main( arg );
			}
			else if (SU.equals( "LOAD_HIT", arg.sharp )) {
				
				result.hitPzList = loadHitPZ( daoLoginNo, arg );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private List<JvWkInstantHitExDto> loadHitPZ( String daoLoginNo, InstantSearchEvArg arg ) {
		
		// eid: 1100E800000
		// pznm: from CCP_LABEL on after process
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvWkInstantHitExDao.ALLCOLS );
		sql.append( "  from (" );
		sql.append( "         select min(ih.QUERY_SEQ) as QUERY_SEQ, ih.QUERY, ih.TGT_CMPA_CD||'E'||ih.TGT_STF_NO as TGT_EID, ih.PZ_ID, null as PZ_NAME, ih.PZ_VAL" );
		sql.append( "           from JV_TR_INSTANT_HIT ih " );
		sql.append( "          where SESSION_ID = ? " );
		sql.append( "          group by ih.QUERY, ih.TGT_CMPA_CD, ih.TGT_STF_NO, ih.PZ_ID, ih.PZ_VAL " );
		sql.append( "       ) " );
		sql.append( " order by TGT_EID, QUERY_SEQ, PZ_ID " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		
		JvWkInstantHitExDao dao = new JvWkInstantHitExDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
