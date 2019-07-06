package jp.co.hisas.career.app.talent.event;

import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.dao.JvSrchRsltWkDao;
import jp.co.hisas.career.app.talent.dao.KomokuFilterDao;
import jp.co.hisas.career.app.talent.dto.KomokuFilterDto;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.log.Log;

public class ResultListEvHdlr extends AbstractEventHandler<ResultListEvArg, ResultListEvRslt> {
	
	public static ResultListEvRslt exec( ResultListEvArg arg ) throws CareerException {
		ResultListEvHdlr handler = new ResultListEvHdlr();
		return handler.call( arg );
	}
	
	public ResultListEvRslt call( ResultListEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected ResultListEvRslt execute( ResultListEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		ResultListEvRslt result = new ResultListEvRslt();
		try {
			
			if (SU.equals( "SHOW", arg.sharp )) {
				result.stfCnt = getStfCnt( daoLoginNo, arg );
				result.recordCnt = getRecordCnt( daoLoginNo, arg );
				result.canCsvDownload = judgeCsvDownloadable( daoLoginNo, arg.party, daoLoginNo );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private StringBuilder getInnerJoinSql( ResultListEvArg arg ) {
		
		String view = "JV_SRCH_RSLT_LIST_PTN_" + arg.colsPtn;
		
		StringBuilder sql = new StringBuilder();
		sql.append( " inner join " + view + " v " );
		sql.append( "   on (v.CMPA_CD = wk.TGT_CMPA_CD and v.STF_NO = wk.TGT_STF_NO) " );
		return sql;
	}
	
	private int getStfCnt( String daoLoginNo, ResultListEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select count('X') " );
		sql.append( "  from ( " );
		sql.append( "         select distinct wk.TGT_CMPA_CD, wk.TGT_STF_NO " );
		sql.append( "           from JV_SRCH_RSLT_WK wk " );
		sql.append( getInnerJoinSql( arg ) );
		sql.append( "          where wk.SESSION_ID = ? " );
		sql.append( "            and wk.PARTY = ? " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		return dao.selectCountDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private int getRecordCnt( String daoLoginNo, ResultListEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select count('X') " );
		sql.append( "  from JV_SRCH_RSLT_WK wk " );
		sql.append( getInnerJoinSql( arg ) );
		sql.append( " where wk.SESSION_ID = ? " );
		sql.append( "   and wk.PARTY = ? " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		
		JvSrchRsltWkDao dao = new JvSrchRsltWkDao( daoLoginNo );
		return dao.selectCountDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	/**
	 * 閲覧可能範囲として紐付けられている社員の中にあるすべてのロールを参照し、
	 * 'srchlist_csv_download_btn' が 'visible' であるものが１つでもあれば true を返す。
	 */
	private boolean judgeCsvDownloadable( String daoLoginNo, String party, String guid ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + KomokuFilterDao.ALLCOLS );
		sql.append( "  from JV_PROF_KOMOKU_FILTER k " );
		sql.append( " where k.PARTY = ? " );
		sql.append( "   and k.KOMOKU_ID = 'srchlist_csv_download_btn' " );
		sql.append( "   and k.DISPLAY_MODE = 'visible' " );
// MOD 2017/08/07 r-hagiwara 性能対策 START
//		sql.append( "   and k.ROLE_ID in ( " );
//		sql.append( "         select b.ROLE_ID from JV_SRCH_BIND b " );
//		sql.append( "          where b.GUID = ? " );
		sql.append( "   and EXISTS ( " );
		sql.append( "         select 1 from JV_SRCH_BIND b " );
		sql.append( "          where b.GUID = ? " );
		sql.append( "            and b.ROLE_ID = k.ROLE_ID " );
// MOD 2017/08/07 r-hagiwara 性能対策 END
		sql.append( "            and exists ( " );
		sql.append( "                  select 'X' from CA_PARTY_COMPANY p " );
		sql.append( "                   where p.PARTY = k.PARTY " );
		sql.append( "                     and p.CMPA_CD = b.TGT_CMPA_CD " );
		sql.append( "                ) " );
		sql.append( "       ) " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( guid );
		
		KomokuFilterDao kfDao = new KomokuFilterDao( daoLoginNo );
		List<KomokuFilterDto> list = kfDao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		return (list.size() > 0);
	}
	
}
