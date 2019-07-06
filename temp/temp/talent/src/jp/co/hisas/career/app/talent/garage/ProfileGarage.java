package jp.co.hisas.career.app.talent.garage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.yaml.snakeyaml.Yaml;

import jp.co.hisas.career.app.talent.bean.KomokuFilterBean;
import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.dao.JvDfTimelinePtnDao;
import jp.co.hisas.career.app.talent.dao.JvProfTimelineDao;
import jp.co.hisas.career.app.talent.dao.JvSrchBindDao;
import jp.co.hisas.career.app.talent.dao.VPzCValueDao;
import jp.co.hisas.career.app.talent.dao.extra.GeneralMapDao;
import jp.co.hisas.career.app.talent.dao.extra.JvProfAttrExDao;
import jp.co.hisas.career.app.talent.dto.JvDfTimelinePtnDto;
import jp.co.hisas.career.app.talent.dto.JvProfTimelineDto;
import jp.co.hisas.career.app.talent.dto.JvSrchBindDto;
import jp.co.hisas.career.app.talent.dto.VPzCValueDto;
import jp.co.hisas.career.app.talent.dto.extra.JvProfAttrExDto;
import jp.co.hisas.career.app.talent.dto.extra.JvSrchRsltWkDtoEx;
import jp.co.hisas.career.app.talent.event.LegacyEvArg;
import jp.co.hisas.career.app.talent.event.LegacyEvHdlr;
import jp.co.hisas.career.app.talent.event.LegacyEvRslt;
import jp.co.hisas.career.app.talent.mold.ProfileMold;
import jp.co.hisas.career.app.talent.mold.TimelineMold;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.CaRegistDao;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dto.CaRegistDto;

public class ProfileGarage extends Garage {
	
	public ProfileGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public CaRegistDto getByCmpaStf( String cmpaCd, String stfNo ) {
		CaRegistDao dao = new CaRegistDao( daoLoginNo );
		return dao.select( cmpaCd, stfNo );
	}
	
	public PersonalPictureBean getProfileAvatar( String tgtGuid ) throws CareerException {
		LegacyEvArg arg = new LegacyEvArg( daoLoginNo );
		arg.sharp = "getPersonalPicture";
		arg.tgtGuid = tgtGuid;
		LegacyEvRslt rslt = LegacyEvHdlr.exec( arg );
		return rslt.picturebean;
	}
	
	public PersonalPictureBean getProfileAvatar( String tgtCmpaCd, String tgtStfNo ) throws CareerException {
		LegacyEvArg arg = new LegacyEvArg( daoLoginNo );
		arg.sharp = "getPersonalPicture";
		arg.tgtCmpaCd = tgtCmpaCd;
		arg.tgtStfNo = tgtStfNo;
		LegacyEvRslt rslt = LegacyEvHdlr.exec( arg );
		return rslt.picturebean;
	}
	
	public Map<String, ProfileMold> getProfiles( String party, String loginGuid, List<JvSrchRsltWkDtoEx> targetList ) {
		
		/* Profile Config */
		Map<String, Map<String, String>> config = getProfileConfig();
		Map<String, String> basicPzIds = config.get( "basic" );
		
		Map<String, JvDfTimelinePtnDto> dfTlPtnMap = getDfTimelinePtnMap();
		/** <1100_8000000, List<Timeline>> */
		Map<String, List<JvProfTimelineDto>> tlMap = getProfTimelineMap( party, loginGuid );
		
		Map<String, ProfileMold> profiles = new LinkedHashMap<String, ProfileMold>();
		
		for (JvSrchRsltWkDtoEx wkDto : targetList) {
			String c = wkDto.getTgtCmpaCd();
			String s = wkDto.getTgtStfNo();
			int sf = wkDto.getStarredFlg();
			
			Map<String, String> profileData = getProfileData( party, c, s, basicPzIds );
			ProfileMold prof = new ProfileMold();
			prof.cmpaCd = c;
			prof.stfNo = s;
			prof.isStarred = SU.judge( sf );
			prof.timeline = makeTimelineSet( dfTlPtnMap, tlMap, c, s );
			for (Entry<String, String> entry : basicPzIds.entrySet()) {
				prof.basic.put( entry.getKey(), profileData.get( entry.getValue() ) );
			}
			/* <1100_8000000, {object}> */
			profiles.put( c + "_" + s, prof );
		}
		
		return profiles;
	}
	
	public Map<String, Map<String, String>> getProfileAttrMap( String party, String loginGuid, List<JvSrchRsltWkDtoEx> targetList, int wkIdxBetweenA, int wkIdxBetweenB ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select wk.TGT_CMPA_CD ||'E'|| wk.TGT_STF_NO as empId, pa.ATTR_ID as attrId, nvl(PZ.PERSON_ZOKUSEI_VALUE, '-') as attrVal" );
		sql.append( "   from V_PZ_C_VALUE pz" );
		sql.append( "        inner join CA_PARTY_COMPANY pc" );
		sql.append( "          on (pc.CMPA_CD = pz.KENMU_NO and pc.PARTY = ?)" );
		sql.append( "        inner join JV_SRCH_RSLT_WK wk" );
		sql.append( "          on (wk.PARTY = pc.PARTY and wk.GUID = ? and wk.TGT_CMPA_CD = pz.KENMU_NO and wk.TGT_STF_NO = pz.PERSON_ID)" );
		sql.append( "        inner join JV_SRCH_BIND bd" );
		sql.append( "          on (bd.TGT_CMPA_CD = pz.KENMU_NO and bd.TGT_STF_NO = pz.PERSON_ID and bd.GUID = wk.GUID)" );
		sql.append( "        inner join JV_PROF_KOMOKU_FILTER kf" );
		sql.append( "          on (kf.PARTY = pc.PARTY and bd.ROLE_ID = kf.ROLE_ID and pz.PERSON_ZOKUSEI_ID = kf.KOMOKU_ID and kf.DISPLAY_MODE = 'visible')" );
		sql.append( "        inner join JV_DF_PROF_ATTR_PZ_MAP pa" );
		sql.append( "          on (pa.PZ_ID = pz.PERSON_ZOKUSEI_ID)" );
		sql.append( "  where wk.WK_IDX between ? and ?" );
		sql.append( "  order by 1, 2" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		paramList.add( wkIdxBetweenA + "" );
		paramList.add( wkIdxBetweenB + "" );
		
		JvProfAttrExDao dao = new JvProfAttrExDao( this.daoLoginNo );
		List<JvProfAttrExDto> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		Map<String, Map<String, String>> profAttrMap = makeProfAttrMap( list );
		return profAttrMap;
	}
	
	private Map<String, Map<String, String>> makeProfAttrMap( List<JvProfAttrExDto> list ) {
		Map<String, List<JvProfAttrExDto>> map = AU.toMap( list, "empId" );
		Map<String, Map<String, String>> result = new HashMap<String, Map<String, String>>();
		for (Entry<String, List<JvProfAttrExDto>> e : map.entrySet()) {
			String empId = e.getKey();
			List<JvProfAttrExDto> dtoList = e.getValue();
			Map<String, String> attrs = new HashMap<String, String>();
			for (JvProfAttrExDto dto : dtoList) {
				attrs.put( dto.getAttrId(), dto.getAttrVal() );
			}
			result.put( empId, attrs );
		}
		return result;
	}
	
	public Map<String, String> getSrchRsltWkByWkIdx( String sessionId, String wkIdx ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select * from JV_SRCH_RSLT_WK" );
		sql.append( "  where SESSION_ID = ? and WK_IDX = ?" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		paramList.add( wkIdx );
		
		String[] cols = { "TGT_CMPA_CD", "TGT_STF_NO", "ROLE_ID" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		Map<String, String> pkRecord = dao.selectByPK( cols, DaoUtil.getPstmt( sql, paramList ) );
		return pkRecord;
	}
	
	public int getSrchRsltWkIdxMax( String sessionId ) {
		StringBuilder sql = new StringBuilder();
		sql.append( " select max(WK_IDX) as WK_IDX_MAX from JV_SRCH_RSLT_WK" );
		sql.append( "  where SESSION_ID = ?" );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( sessionId );
		
		String[] cols = { "WK_IDX_MAX" };
		
		GeneralMapDao dao = new GeneralMapDao( this.daoLoginNo );
		Map<String, String> pkRecord = dao.selectByPK( cols, DaoUtil.getPstmt( sql, paramList ) );
		return SU.toInt( pkRecord.get( "WK_IDX_MAX" ), 0 );
	}
	
	private Set<TimelineMold> makeTimelineSet( Map<String, JvDfTimelinePtnDto> dfTlPtnMap, Map<String, List<JvProfTimelineDto>> tlMap, String cmpaCd, String stfNo ) {
		Set<TimelineMold> timelineSet = new LinkedHashSet<TimelineMold>();
		List<JvProfTimelineDto> timelineList = tlMap.get( cmpaCd + "_" + stfNo );
		if (timelineList == null) {
			return timelineSet;
		}
		for (JvProfTimelineDto dto : timelineList) {
			TimelineMold tl = new TimelineMold();
			JvDfTimelinePtnDto df = dfTlPtnMap.get( dto.getTlPtnCd() );
			tl.seqNo = dto.getSeqNo();
			tl.date = dto.getTlDate();
			tl.ptnCd = dto.getTlPtnCd();
			tl.icon = df.getIcon();
			tl.color = df.getColor();
			tl.label = df.getLabel();
			tl.title = dto.getTitle();
			tl.note = dto.getNote();
			timelineSet.add( tl );
		}
		return timelineSet;
	}
	
	private Map<String, Map<String, String>> getProfileConfig() {
		String yamlDoc = AU.getYamlDocument( "sp-profile.yaml" );
		Yaml yaml = new Yaml();
		@SuppressWarnings("unchecked")
		Map<String, Map<String, String>> list = (Map<String, Map<String, String>>)yaml.load( yamlDoc );
		return list;
	}
	
	private Map<String, String> getProfileData( String party, String cmpaCd, String stfNo, Map<String, String> pzIds ) {
		
		String roleId = getRoleFromBind( cmpaCd, stfNo );
		
		/* KomokuFilter */
		KomokuFilterBean kf = new KomokuFilterBean( party, roleId );
		
		/* Raw PZ Box Map <PZID, PZVAL> */
		List<String> pzIdList = new ArrayList<String>( pzIds.values() );
		Map<String, String> rawBoxMap = getPzBoxValueMap( cmpaCd, stfNo, pzIdList );
		
		Map<String, String> filteredPzBoxMap = makeFilteredPzBoxMap( rawBoxMap, kf );
		
		return filteredPzBoxMap;
	}
	
	private String getRoleFromBind( String tgtCmpaCd, String tgtStfNo ) {
		JvSrchBindDao dao = new JvSrchBindDao( this.daoLoginNo );
		JvSrchBindDto dto = dao.select( this.daoLoginNo, tgtCmpaCd, tgtStfNo );
		return dto != null ? dto.getRoleId() : "";
	}
	
	private Map<String, String> getPzBoxValueMap( String tgtCmpaCd, String tgtStfNo, List<String> pzIdList ) {
		
		/* PZ Box Value Map <PZID, PZVAL> */
		Map<String, String> pzBoxValMap = new HashMap<String, String>();
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + VPzCValueDao.ALLCOLS + " from " );
		sql.append( "  ( " );
		sql.append( "    select PERSON_ID,KENMU_NO,PERSON_ZOKUSEI_ID,START_DATE,END_DATE,PERSON_ZOKUSEI_VALUE" );
		sql.append( "          ,UPDATE_PERSON_ID,UPDATE_FUNCTION,UPDATE_DATE,UPDATE_TIME" );
		sql.append( "      from V_PZ_C_VALUE " );
		sql.append( "     where PERSON_ID = ? and KENMU_NO = ? " );
		sql.append( "       and PERSON_ZOKUSEI_ID in (" + SU.convListToSqlInVal( pzIdList ) + ") ");
		sql.append( "  ) " );
		sql.append( "order by 1,2,3 " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( tgtStfNo );
		paramList.add( tgtCmpaCd );
		
		List<VPzCValueDto> vPzCValueDtoList;
		VPzCValueDao dao = new VPzCValueDao( this.daoLoginNo );
		vPzCValueDtoList = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		
		for (final VPzCValueDto valueDto : vPzCValueDtoList) {
			pzBoxValMap.put( valueDto.getPersonZokuseiId(), valueDto.getPersonZokuseiValue() );
		}
		
		return pzBoxValMap;
	}
	
	private Map<String, String> makeFilteredPzBoxMap( Map<String, String> rawBoxMap, KomokuFilterBean kf ) {
		Map<String, String> boxMap = new HashMap<String, String>();
		for (Entry<String, String> entry : rawBoxMap.entrySet()) {
			String pzId = entry.getKey();
			if (kf.isVisible( pzId )) {
				String filteredValue = kf.getFilterValue( entry.getKey(), entry.getValue() );
				boxMap.put( entry.getKey(), filteredValue );
			}
		}
		return boxMap;
	}
	
	private Map<String, JvDfTimelinePtnDto> getDfTimelinePtnMap() {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + JvDfTimelinePtnDao.ALLCOLS );
		sql.append( "  from JV_DF_TIMELINE_PTN " );
		sql.append( " order by 1,2 " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		
		JvDfTimelinePtnDao dao = new JvDfTimelinePtnDao( this.daoLoginNo );
		List<JvDfTimelinePtnDto> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		return AU.toMap1to1( list, "tlPtnCd" );
	}
	
	private Map<String, List<JvProfTimelineDto>> getProfTimelineMap( String party, String loginGuid ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "tl", JvProfTimelineDao.ALLCOLS ) );
		sql.append( "  from JV_PROF_TIMELINE tl ");
		sql.append( "       inner join JV_SRCH_RSLT_WK wk ");
		sql.append( "         on (PARTY = ? and GUID = ? and wk.UPD_USER = ? ");
		sql.append( "         and wk.TGT_CMPA_CD = tl.CMPA_CD and wk.TGT_STF_NO = tl.STF_NO) ");
		sql.append( " order by CMPA_CD, STF_NO, SEQ_NO ");
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( loginGuid );
		paramList.add( loginGuid );
		
		JvProfTimelineDao dao = new JvProfTimelineDao( this.daoLoginNo );
		List<JvProfTimelineDto> list = dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
		Map<String, List<JvProfTimelineDto>> result = new HashMap<String, List<JvProfTimelineDto>>();
		List<JvProfTimelineDto> tmpList = null;
		String befKey = null;
		for (JvProfTimelineDto dto : list) {
			String key = dto.getCmpaCd() + "_" + dto.getStfNo();
			if (key.equals( befKey )) {
				result.put( key, tmpList );
			} else {
				tmpList = new ArrayList<JvProfTimelineDto>();
			}
			tmpList.add( dto );
			befKey = key;
		}
		return result;
	}
	
}
