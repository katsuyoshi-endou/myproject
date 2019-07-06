package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jp.co.hisas.career.app.talent.bean.JvProfileBean;
import jp.co.hisas.career.app.talent.bean.KomokuFilterBean;
import jp.co.hisas.career.app.talent.dao.JvProfTabSectAddontypeDao;
import jp.co.hisas.career.app.talent.dao.JvProfTabSectBoxtypeDao;
import jp.co.hisas.career.app.talent.dao.JvProfTabSectDao;
import jp.co.hisas.career.app.talent.dao.JvProfTabSectFilterDao;
import jp.co.hisas.career.app.talent.dao.JvProfTabSectListtypeDao;
import jp.co.hisas.career.app.talent.dao.JvTabJsDao;
import jp.co.hisas.career.app.talent.dao.VPzCValueDao;
import jp.co.hisas.career.app.talent.dao.VPzTcValueDao;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectAddontypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectBoxtypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectFilterDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.app.talent.dto.JvTabJsDto;
import jp.co.hisas.career.app.talent.dto.VPzCValueDto;
import jp.co.hisas.career.app.talent.dto.VPzTcValueDto;
import jp.co.hisas.career.app.talent.dto.extra.JvProfTabSectionLayoutDto;
import jp.co.hisas.career.framework.exception.CareerRuntimeException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.useful.OneColumnDao;

public class JvProfileLogicLoad {
	
	private String daoLoginNo;
	private JvProfileEvRslt evRslt;
	
	public JvProfileLogicLoad( String daoLoginNo ) {
		this.daoLoginNo = daoLoginNo;
		this.evRslt = new JvProfileEvRslt();
	}
	
	protected JvProfileEvRslt main( JvProfileEvArg arg ) throws SQLException {
		
		JvProfileBean jvProfileBean = new JvProfileBean();
		
		/* RoleID */
		jvProfileBean.roleId = arg.tgtRoleId;
		
		/* Tab List */
		jvProfileBean.tabList = getTabList( daoLoginNo, arg );
		
		/* Section List */
		jvProfileBean.sectList = getJvPdfProfTabSectList( daoLoginNo, arg.party, arg.tgtRoleId );
		
		/* KomokuFilter */
		KomokuFilterBean kf = new KomokuFilterBean( arg.party, arg.tgtRoleId );
		jvProfileBean.komokuFilter = kf;
		
		/* PZ Box Value Map <PZID, PZVAL> */
		Map<String, String> pzBoxValueMap = getPzBoxValueMap( daoLoginNo, arg );
		jvProfileBean.pzBoxValMap = pzBoxValueMap;
		
		/* PZ List Value Map <PZID, <ROWNO, PZVAL>> */
		Map<String, Map<Integer, String>> pzListValueMap = getPzListValueMap( daoLoginNo, arg );
		jvProfileBean.pzListValMap = pzListValueMap;
		
		/* Tab Layout Map */
		Map<String, List<JvProfTabSectionLayoutDto>> tabLayoutMap = getTabLayoutMap( daoLoginNo, arg, jvProfileBean.tabList );
		jvProfileBean.jvTabLayoutMap = tabLayoutMap;
		
		/* Jv Tab Js List */
		jvProfileBean.jvTabJsList = getJvTabJsList( daoLoginNo, jvProfileBean.tabList );
		
		evRslt.jvProfileBean = jvProfileBean;
		
		return evRslt;
	}
	
	private List<String> getTabList( String daoLoginNo, JvProfileEvArg arg ) throws SQLException {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select TAB_ID as text " );
		sql.append( "  from JV_PROF_TAB_FILTER " );
		sql.append( " where PARTY = ? " );
		sql.append( "   and ROLE_ID = ? " );
		sql.append( "   and DISPLAY_MODE = 'ON' " );
		sql.append( "order by HYOJI_JUNJO " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.party );
		paramList.add( arg.tgtRoleId );
		
		OneColumnDao dao = new OneColumnDao( daoLoginNo );
		List<String> result = dao.selectDynamic(  DaoUtil.getPstmt( sql, paramList )  );
		
		return result;
	}
	
	private List<JvProfTabSectFilterDto> getJvPdfProfTabSectList( String daoLoginNo, String party, String roleId ) throws SQLException {
		JvProfTabSectFilterDao dao = new JvProfTabSectFilterDao( daoLoginNo );
		return dao.selectAllowedSections( party, roleId );
	}
	
	private Map<String, List<JvProfTabSectionLayoutDto>> getTabLayoutMap( String daoLoginNo, JvProfileEvArg arg, List<String> tabList ) {
		
		/* Tab Layout Map <TAB_ID, SectionLayoutList> */
		Map<String, List<JvProfTabSectionLayoutDto>> tabLayoutMap = new LinkedHashMap<String, List<JvProfTabSectionLayoutDto>>();
		
		String tablistStr = convListToSqlInVal( tabList );
		
		/* Parameter List */
		ArrayList<String> dummyParamList = new ArrayList<String>();
		
		/* Dynamic SQL - Sect */
		StringBuilder sqlSect = new StringBuilder();
		sqlSect.append( "select " + SU.addPrefixOnDaoAllCols( "S", JvProfTabSectDao.ALLCOLS ) );
		sqlSect.append( "  from JV_PROF_TAB_SECT S " );
		sqlSect.append( "       inner join JV_PROF_TAB_SECT_FILTER F " );
		sqlSect.append( "         on (S.TAB_ID = F.TAB_ID and S.SECT_ID = F.SECT_ID) " );
		sqlSect.append( " where S.TAB_ID in (" + tablistStr + ") " );
		sqlSect.append( "   and F.PARTY = '" + arg.party + "' and F.ROLE_ID = '" + arg.tgtRoleId + "' " );
		sqlSect.append( "   and F.ON_OFF = 'ON' " );
		sqlSect.append( " order by S.TAB_ID, S.SORT, S.SECT_ID " );
		
		/* Dynamic SQL - Box */
		StringBuilder sqlBox = new StringBuilder();
		sqlBox.append( "select " + SU.addPrefixOnDaoAllCols( "B", JvProfTabSectBoxtypeDao.ALLCOLS ) );
		sqlBox.append( "  from JV_PROF_TAB_SECT_BOXTYPE B " );
		sqlBox.append( "       inner join JV_PROF_TAB_SECT S " );
		sqlBox.append( "         on (S.SECT_ID = B.SECT_ID and S.TAB_ID in (" + tablistStr + ") ) " );
		sqlBox.append( " order by B.SECT_ID, B.ROW_NO, B.COL_NO " );
		
		/* Dynamic SQL - List */
		StringBuilder sqlList = new StringBuilder();
		sqlList.append( "select " + SU.addPrefixOnDaoAllCols( "L", JvProfTabSectListtypeDao.ALLCOLS ) );
		sqlList.append( "  from JV_PROF_TAB_SECT_LISTTYPE L " );
		sqlList.append( "       inner join JV_PROF_TAB_SECT S " );
		sqlList.append( "         on (S.SECT_ID = L.SECT_ID and S.TAB_ID in (" + tablistStr + ") ) " );
		sqlList.append( " order by L.SECT_ID, L.COL_NO " );
		
		/* Dynamic SQL - Addon */
		StringBuilder sqlAddon = new StringBuilder();
		sqlAddon.append( "select " + SU.addPrefixOnDaoAllCols( "A", JvProfTabSectAddontypeDao.ALLCOLS ) );
		sqlAddon.append( "  from JV_PROF_TAB_SECT_ADDONTYPE A " );
		sqlAddon.append( "       inner join JV_PROF_TAB_SECT S " );
		sqlAddon.append( "         on (S.SECT_ID = A.SECT_ID and S.TAB_ID in (" + tablistStr + ") ) " );
		sqlAddon.append( " order by A.SECT_ID, A.ADDON_ID " );
		
		List<JvProfTabSectDto> allSectionList;
		List<JvProfTabSectBoxtypeDto> allBoxList;
		List<JvProfTabSectListtypeDto> allListList;
		List<JvProfTabSectAddontypeDto> allAddonList;
		try {
			// select JV_PROF_TAB_SECT
			JvProfTabSectDao daoSect = new JvProfTabSectDao( daoLoginNo );
			allSectionList = daoSect.selectDynamic( DaoUtil.getPstmt( sqlSect, dummyParamList ) );
			Map<String, List<JvProfTabSectDto>> allSectMap = AU.toMap( allSectionList, "tabId" );
			
			// select JV_PROF_TAB_SECT_BOXTYPE
			JvProfTabSectBoxtypeDao daoBox = new JvProfTabSectBoxtypeDao( daoLoginNo );
			allBoxList = daoBox.selectDynamic( DaoUtil.getPstmt( sqlBox, dummyParamList ) );
			Map<String, List<JvProfTabSectBoxtypeDto>> allBoxMap = AU.toMap( allBoxList, "sectId" );
			
			// select JV_PROF_TAB_SECT_LISTTYPE
			JvProfTabSectListtypeDao daoList = new JvProfTabSectListtypeDao( daoLoginNo );
			allListList = daoList.selectDynamic( DaoUtil.getPstmt( sqlList, dummyParamList ) );
			Map<String, List<JvProfTabSectListtypeDto>> allListMap = AU.toMap( allListList, "sectId" );
			
			// select JV_PROF_TAB_ADDON_LISTTYPE
			JvProfTabSectAddontypeDao daoAddon = new JvProfTabSectAddontypeDao( daoLoginNo );
			allAddonList = daoAddon.selectDynamic( DaoUtil.getPstmt( sqlAddon, dummyParamList ) );
			Map<String, List<JvProfTabSectAddontypeDto>> allAddonMap = AU.toMap( allAddonList, "sectId" );
			
			for (Map.Entry<String, List<JvProfTabSectDto>> entry : allSectMap.entrySet()) {
				String tabId = entry.getKey();
				List<JvProfTabSectDto> dtoList = entry.getValue();
				List<JvProfTabSectionLayoutDto> layList = new ArrayList<JvProfTabSectionLayoutDto>();
				for (JvProfTabSectDto sect : dtoList) {
					JvProfTabSectionLayoutDto lay = new JvProfTabSectionLayoutDto();
					lay.setJvProfTabSectDto( sect );
					lay.setBoxtypeSection( allBoxMap.get( sect.getSectId() ) );
					lay.setListtypeSection( allListMap.get( sect.getSectId() ) );
					lay.setAddontypeSection( allAddonMap.get( sect.getSectId() ) );
					layList.add( lay );
				}
				tabLayoutMap.put( tabId, layList );
			}
			
		} catch (Exception e) {
			throw new CareerRuntimeException( e );
		}
		return tabLayoutMap;
	}
	
	private Map<String, String> getPzBoxValueMap( String daoLoginNo, JvProfileEvArg arg ) {
		
		/* PZ Box Value Map <PZID, PZVAL> */
		Map<String, String> pzBoxValMap = new HashMap<String, String>();
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + VPzCValueDao.ALLCOLS + " from " );
		sql.append( "  ( " );
		sql.append( "    select PERSON_ID,KENMU_NO,PERSON_ZOKUSEI_ID,START_DATE,END_DATE,PERSON_ZOKUSEI_VALUE" );
		sql.append( "          ,UPDATE_PERSON_ID,UPDATE_FUNCTION,UPDATE_DATE,UPDATE_TIME" );
		sql.append( "      from V_PZ_C_VALUE where PERSON_ID = ? and KENMU_NO = ? " );
		sql.append( "  ) " );
		sql.append( "order by 1,2,3 " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.tgtStfNo );  paramList.add( arg.tgtCmpaCd );
		
		List<VPzCValueDto> vPzCValueDtoList;
		VPzCValueDao dao = new VPzCValueDao( daoLoginNo );
		vPzCValueDtoList = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		for (final VPzCValueDto valueDto : vPzCValueDtoList) {
			pzBoxValMap.put( valueDto.getPersonZokuseiId(), valueDto.getPersonZokuseiValue() );
		}
		
		return pzBoxValMap;
	}
	
	private Map<String, Map<Integer, String>> getPzListValueMap( String daoLoginNo, JvProfileEvArg arg ) {
		
		/* PZ List Value Map <PZID, <ROWNO, PZVAL>> */
		Map<String, Map<Integer, String>> pzListValMap = new HashMap<String, Map<Integer, String>>();
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select PERSON_ID as personId,KENMU_NO as kenmuNo,PERSON_ZOKUSEI_ID as personZokuseiId,ROW_NO as rowNo,PERSON_ZOKUSEI_VALUE as personZokuseiValue " );
		sql.append( "       ,'' as updatePersonId,'' as updateFunction,'' as updateDate,'' as updateTime " );
		sql.append( "  from V_PZ_TC_VALUE where PERSON_ID = ? and KENMU_NO = ? " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.tgtStfNo );
		paramList.add( arg.tgtCmpaCd );
		
		List<VPzTcValueDto> vPzCValueDtoList;
		VPzTcValueDao dao = new VPzTcValueDao( daoLoginNo );
		vPzCValueDtoList = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		for (final VPzTcValueDto valueDto : vPzCValueDtoList) {
			String pzid = valueDto.getPersonZokuseiId();
			boolean mapExists = pzListValMap.containsKey( pzid );
			if (mapExists) {
				Map<Integer, String> rows = pzListValMap.get( pzid );
				rows.put( valueDto.getRowNo(), valueDto.getPersonZokuseiValue() );
			} else {
				Map<Integer, String> rows = new HashMap<Integer, String>();
				rows.put( valueDto.getRowNo(), valueDto.getPersonZokuseiValue() );
				pzListValMap.put( pzid, rows );
			}
		}
		
		return pzListValMap;
	}
	
	private String convListToSqlInVal( List<String> inList ) {
		if (inList == null || inList.size() == 0) {
			return "''";
		}
		StringBuilder sql = new StringBuilder();
		for (int i=0; i<inList.size(); i++) {
			if (i==0) {
				sql.append( "'" + inList.get( i ) + "'" );
			}
			else {
				sql.append( ",'" + inList.get( i ) + "'" );
			}
		}
		return sql.toString();
	}
	
	private List<JvTabJsDto> getJvTabJsList( String daoLoginNo, List<String> tabList ) {
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( " select" + JvTabJsDao.ALLCOLS );
		sql.append( "   from JV_TAB_JS " );
		sql.append( "  where TAB_ID IN( ?" );
		
		if (tabList.size() == 0) {
			paramList.add( null );
		} else {
			for (int i = 0; i < tabList.size(); i++) {
				if (i > 0) {
					sql.append( ", ?" );
				}
				paramList.add( tabList.get( i ) );
			}
		}
		sql.append( ")" );
		
		sql.append( "  order by 1,2 " );
		
		JvTabJsDao dao = new JvTabJsDao( daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
}
