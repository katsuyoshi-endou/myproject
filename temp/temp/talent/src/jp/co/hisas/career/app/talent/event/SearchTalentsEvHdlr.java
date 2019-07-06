package jp.co.hisas.career.app.talent.event;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.dao.JvProfTabSectDao;
import jp.co.hisas.career.app.talent.dao.JvSectTblMapDao;
import jp.co.hisas.career.app.talent.dao.JvSrchRsltListDao;
import jp.co.hisas.career.app.talent.dao.extra.JvSrchCsvDao;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.app.talent.dto.JvSectTblMapDto;
import jp.co.hisas.career.app.talent.dto.JvSrchRsltListDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchCsvDto;
import jp.co.hisas.career.app.talent.garage.SrchRsltWkGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.OneColumnDao;
import jp.co.hisas.career.util.log.Log;

public class SearchTalentsEvHdlr extends AbstractEventHandler<SearchTalentsEvArg, SearchTalentsEvRslt> {
	
	public static SearchTalentsEvRslt exec( SearchTalentsEvArg arg ) throws CareerException {
		SearchTalentsEvHdlr handler = new SearchTalentsEvHdlr();
		return handler.call( arg );
	}
	
	public SearchTalentsEvRslt call( SearchTalentsEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected SearchTalentsEvRslt execute( SearchTalentsEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		SearchTalentsEvRslt result = new SearchTalentsEvRslt();
		try {
			
			SrchRsltWkGarage ggWk = new SrchRsltWkGarage( daoLoginNo );
			
			if (SU.equals( "ALL", arg.sharp )) {
				
				ggWk.clearResultWk( arg.getLoginNo() );
				ggWk.makeWorkAll( arg.sessionId, arg.party, arg.guid );
				ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
			}
			else if (SU.equals( "STAR", arg.sharp )) {
				
				ggWk.clearResultWk( arg.getLoginNo() );
				ggWk.makeWorkStarred( arg.sessionId, arg.party, arg.guid );
				ggWk.updateWkIdx( arg.sessionId, arg.party, arg.guid );
			}
			else if (SU.equals( "CSV_SECT", arg.sharp )) {
				
				result.jvSrchCsvRowList = getCsvSectRowList( daoLoginNo, arg );
			}
			else if (SU.equals( "CSV_FIXED", arg.sharp )) {
				if (arg.isSrch) {
					result.csvRowList = getCsvFixedRowList( daoLoginNo, arg );
				} else {
					result.csvRowList = getCsvFixedPcupRowList( daoLoginNo, arg );
				}
			}
			else if (SU.equals( "CSV_ADDED", arg.sharp )) {
				
				result.csvRowList = getCsvAddedRowList( daoLoginNo, arg );
				result.visibleColList = columnsVisibleInBind( daoLoginNo, arg.party, daoLoginNo, arg.addedItems );
			}
			else if (SU.equals( "CSV_PREPARE", arg.sharp )) {
				
				result.tabSects = getVisibleTabSections( daoLoginNo, arg );
				result.sectTblMap = getSectTblMap( daoLoginNo, arg );
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private List<JvSrchCsvDto> getCsvSectRowList( String daoLoginNo, SearchTalentsEvArg arg ) {
		
		String view = arg.tblObj;
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvSrchCsvDao.ALLCOLS );
		sql.append( "  from JV_SRCH_RSLT_WK wk " );
		sql.append( "       inner join JV_PROF_TAB_SECT_ON so " );
		sql.append( "         on (so.PARTY = wk.PARTY and so.ROLE_ID = wk.ROLE_ID and so.SECT_ID = ?) " );
		sql.append( "       inner join " + view + " v " );
		sql.append( "         on (v.CMPA_CD = wk.TGT_CMPA_CD and v.STF_NO = wk.TGT_STF_NO) " );
		sql.append( " where wk.SESSION_ID = ? " );
		sql.append( "   and wk.PARTY = ? " );
		sql.append( "   and wk.GUID = ? " );
		sql.append( "   and wk.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "   and wk.ROLE_ID in (select ROLE_ID from JV_PROF_KOMOKU_FILTER where KOMOKU_ID = 'srchlist_csv_download_btn' and DISPLAY_MODE = 'visible') " );
		sql.append( " order by v.sort " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sectId );
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		paramList.add( arg.getLoginNo() );
		paramList.add( arg.party );
		
		JvSrchCsvDao dao = new JvSrchCsvDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<JvSrchRsltListDto> getCsvFixedRowList( String daoLoginNo, SearchTalentsEvArg arg ) {
		
		String view = "JV_SRCH_RSLT_LIST_PTN_" + arg.colsPtn;
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvSrchRsltListDao.ALLCOLS );
		sql.append( "  from JV_SRCH_RSLT_WK wk " );
		sql.append( "       inner join " + view + " v " );
		sql.append( "         on (v.CMPA_CD = wk.TGT_CMPA_CD and v.STF_NO = wk.TGT_STF_NO) " );
		sql.append( " where wk.SESSION_ID = ? " );
		sql.append( "   and wk.PARTY = ? " );
		sql.append( "   and wk.GUID = ? " );
		sql.append( "   and wk.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "   and v.CSV_AVAIL_FLG = '1' " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		paramList.add( daoLoginNo );
		paramList.add( arg.party );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<JvSrchRsltListDto> getCsvFixedPcupRowList( String daoLoginNo, SearchTalentsEvArg arg ) {
		
		String view = "JV_SRCH_RSLT_LIST_PTN_" + arg.colsPtn;
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvSrchRsltListDao.ALLCOLS );
		sql.append( "  from JV_SRCH_PCUP wk " );
		sql.append( "       inner join " + view + " v " );
		sql.append( "         on (v.CMPA_CD = wk.TGT_CMPA_CD and v.STF_NO = wk.TGT_STF_NO) " );
		sql.append( " where wk.GUID = ? " );
		sql.append( "   and wk.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "   and v.CSV_AVAIL_FLG = '1' " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( daoLoginNo );
		paramList.add( arg.party );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<JvSrchRsltListDto> getCsvAddedRowList( String daoLoginNo, SearchTalentsEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + JvSrchRsltListDao.ALLCOLS );
		sql.append( "  from JV_SRCH_RSLT_WK wk " );
		sql.append( "       inner join JV_SRCH_RSLT_LIST_PTN_Y v " );
		sql.append( "         on (v.ROLE_ID = wk.ROLE_ID and v.CMPA_CD = wk.TGT_CMPA_CD and v.STF_NO = wk.TGT_STF_NO) " );
		sql.append( " where wk.SESSION_ID = ? " );
		sql.append( "   and wk.PARTY = ? " );
		sql.append( "   and wk.GUID = ? " );
		sql.append( "   and wk.TGT_CMPA_CD in (select CMPA_CD from CA_PARTY_COMPANY where PARTY = ?) " );
		sql.append( "   and v.CSV_AVAIL_FLG = '1' " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.sessionId );
		paramList.add( arg.party );
		paramList.add( daoLoginNo );
		paramList.add( arg.party );
		
		JvSrchRsltListDao dao = new JvSrchRsltListDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<JvProfTabSectDto> getVisibleTabSections( String daoLoginNo, SearchTalentsEvArg arg ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + SU.addPrefixOnDaoAllCols( "ts", JvProfTabSectDao.ALLCOLS ) );
		sql.append( "  from JV_PROF_TAB_SECT ts " );
		sql.append( "       inner join ( " );
		sql.append( "         select tf.tab_id, min(tf.HYOJI_JUNJO) as JUNJO, sf.SECT_ID " );
		sql.append( "           from JV_PROF_TAB_FILTER tf " );
		sql.append( "                inner join JV_PROF_TAB_SECT_FILTER sf " );
		sql.append( "                  on (sf.PARTY = tf.PARTY and sf.ROLE_ID = tf.ROLE_ID and sf.TAB_ID = tf.TAB_ID) " );
		sql.append( "          where tf.DISPLAY_MODE = 'ON' " );
		sql.append( "            and sf.ON_OFF = 'ON' " );
		sql.append( "            and tf.PARTY = ? " );
		sql.append( "            and exists (select 1 from JV_SRCH_RSLT_WK b where b.SESSION_ID= ? and b.GUID = ? and b.ROLE_ID = tf.ROLE_ID) " );
		sql.append( "          group by tf.tab_id, sf.SECT_ID " );
		sql.append( "       ) sub " );
		sql.append( "         on (sub.TAB_ID = ts.TAB_ID and sub.SECT_ID = ts.SECT_ID) " );
		sql.append( " where ts.LAYOUT_TYPE in ('Box', 'List') " );
		sql.append( " order by sub.JUNJO, ts.SORT " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.party );
		paramList.add( arg.sessionId );
		paramList.add( daoLoginNo );
		
		JvProfTabSectDao dao = new JvProfTabSectDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<String> columnsVisibleInBind( String daoLoginNo, String party, String guid, List<String> komokuIdList ) {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select distinct k.KOMOKU_ID as text " );
		sql.append( "  from JV_PROF_KOMOKU_FILTER k " );
		sql.append( " where k.PARTY = ? " );
		sql.append( "   and k.KOMOKU_ID in (" + SU.convListToSqlInVal( komokuIdList ) + ")" );
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
		
		OneColumnDao kfDao = new OneColumnDao( daoLoginNo );
		return kfDao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private Map<String, JvSectTblMapDto> getSectTblMap( String daoLoginNo, SearchTalentsEvArg arg ) {
		JvSectTblMapDao dao = new JvSectTblMapDao( daoLoginNo );
		List<JvSectTblMapDto> list = dao.selectAllSectionsByParty( arg.party );
		return AU.toMap1to1( list, "filSectId" );
	}
}
