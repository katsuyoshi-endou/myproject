package jp.co.hisas.career.app.talent.garage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.bean.LegacyKensakuDefBean;
import jp.co.hisas.career.app.talent.dao.KensakuCategoryDao;
import jp.co.hisas.career.app.talent.dao.KensakuKigoDao;
import jp.co.hisas.career.app.talent.dao.KensakuKomokuDao;
import jp.co.hisas.career.app.talent.dto.KensakuCategoryDto;
import jp.co.hisas.career.app.talent.dto.KensakuKigoDto;
import jp.co.hisas.career.app.talent.dto.KensakuKomokuDto;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.CodeMasterDao;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.PersonZokuseiTeigiDao;
import jp.co.hisas.career.util.dao.useful.OneColumnDao;
import jp.co.hisas.career.util.dto.CodeMasterDto;
import jp.co.hisas.career.util.dto.PersonZokuseiTeigiDto;

public class LegacySrchCndGarage extends Garage {
	
	public LegacySrchCndGarage(String daoLoginNo) {
		super( daoLoginNo );
	}
	
	public LegacyKensakuDefBean getSrchCndLgcDef( String party, String guid, boolean isShared ) throws SQLException, NamingException {
		SrchBindGarage ggBD = new SrchBindGarage( guid );
		List<String> roleIdList = new ArrayList<String>();
		if (isShared) {
			roleIdList.add( "Public" );
		} else {
			roleIdList = ggBD.getRoleList( party, guid );
		}
		return makeLegacyDefByRoleList( party, roleIdList );
	}
	
	public LegacyKensakuDefBean makeLegacyDefByRoleList( String party, List<String> roleIdList ) {
		
		final LegacyKensakuDefBean legacyKensakuDefBean = new LegacyKensakuDefBean();
		
		// 退職者を除く
		legacyKensakuDefBean.canRetireSrch = judgeRetireSearchable( party, roleIdList );
		
		// 検索カテゴリ
		List<KensakuCategoryDto> kCategoryDtoList = selectKensakuCategoryByRoleId( party, roleIdList );
		for (final KensakuCategoryDto dto : kCategoryDtoList) {
			legacyKensakuDefBean.addKensakuCategoryDtoList( dto );
		}
		
		// 検索項目
		List<KensakuKomokuDto> kKomokuDtoList = selectKensakuKomokuByRoleId( party, roleIdList );
		for (final KensakuKomokuDto dto : kKomokuDtoList) {
			legacyKensakuDefBean.putKomokuByCategoryMap( dto.getKensakuCategoryId(), dto );
		}
		
		// 検索記号
		KensakuKigoDao kKigoDao = new KensakuKigoDao( daoLoginNo );
		List<KensakuKigoDto> kKigoDtoList = kKigoDao.selectKensakuKigoAll();
		for (final KensakuKigoDto dto : kKigoDtoList) {
			legacyKensakuDefBean.putKensakuKigoDtoListMap( dto.getKensakuKomokuId(), dto );
		}
		
		// コードマスタ
		CodeMasterDao cMasterDao = new CodeMasterDao( daoLoginNo );
		List<CodeMasterDto> cMasterDtoList = cMasterDao.selectCodeMasterAll();
		for (final CodeMasterDto dto : cMasterDtoList) {
			legacyKensakuDefBean.putCodeMasterDtoListMap( dto.getMasterId(), dto );
		}
		
		// 人属性定義
		PersonZokuseiTeigiDao pZokuseiTeigiDao = new PersonZokuseiTeigiDao( daoLoginNo );
		List<PersonZokuseiTeigiDto> pZokuseiTeigiDtoList = pZokuseiTeigiDao.selectPersonZokuseiAll();
		for (final PersonZokuseiTeigiDto dto : pZokuseiTeigiDtoList) {
			legacyKensakuDefBean.putPersonZokuseiTeigiDtoMap( dto.getPersonZokuseiId(), dto );
		}
		
		return legacyKensakuDefBean;
	}
	
	/**
	 * 閲覧可能範囲として紐付けられている社員の中にあるすべてのロールを参照し、
	 * 'retire_searchable' が 'visible' であるものが１つでもあれば true を返す。
	 */
	private boolean judgeRetireSearchable( String party, List<String> roleIdList ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( " select count(*) " );
		sql.append( "   from JV_PROF_KOMOKU_FILTER k " );
		sql.append( "  where k.PARTY = ? " );
		sql.append( "    and k.KOMOKU_ID = 'retire_searchable' " );
		sql.append( "    and k.DISPLAY_MODE = 'visible' " );
		sql.append( "    and k.ROLE_ID in ( " + SU.convListToSqlInVal( roleIdList ) + " ) " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		
		OneColumnDao dao = new OneColumnDao( daoLoginNo );
		return dao.checkExistDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<KensakuCategoryDto> selectKensakuCategoryByRoleId( String party, List<String> roleIdList ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "SELECT " + KensakuCategoryDao.ALLCOLS );
		sql.append( "   from KENSAKU_CATEGORY kc " );
		sql.append( "  where kc.PARTY = ? " );
		sql.append( "    and kc.KENGEN_ID = 'Default' " ); // 固定値前提・列役割廃止
		sql.append( "    and exists ( " );
		sql.append( "             select kk.KENSAKU_CATEGORY_ID " );
		sql.append( "               from KENSAKU_KOMOKU kk " );
		sql.append( "                    inner join JV_PROF_KOMOKU_FILTER kf " );
		sql.append( "                      on (kf.PARTY = kk.PARTY and kf.KOMOKU_ID = kk.PERSON_ZOKUSEI_ID and kf.DISPLAY_MODE = 'visible') " );
		sql.append( "              where kk.PARTY = ? " );
		sql.append( "                and kf.ROLE_ID in ( " + SU.convListToSqlInVal( roleIdList ) + " ) " );
		sql.append( "                and kk.KENSAKU_CATEGORY_ID = kc.KENSAKU_CATEGORY_ID " );
		sql.append( "        ) " );
		sql.append( "  order by kc.HYOJI_JYUNJYO " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		paramList.add( party );
		
		KensakuCategoryDao dao = new KensakuCategoryDao( this.daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<KensakuKomokuDto> selectKensakuKomokuByRoleId( String party, List<String> roleIdList ) {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + SU.addPrefixOnDaoAllCols( "kk", KensakuKomokuDao.ALLCOLS ) );
		sql.append( "  from KENSAKU_KOMOKU kk " );
		sql.append( "       inner join JV_PROF_KOMOKU_FILTER kf " );
		sql.append( "         on (kf.PARTY = kk.PARTY " );
		sql.append( "         and kf.KOMOKU_ID = kk.PERSON_ZOKUSEI_ID " );
		sql.append( "         and kf.ROLE_ID in ( " + SU.convListToSqlInVal( roleIdList ) + " ) " );
		sql.append( "         and kf.DISPLAY_MODE = 'visible') " );
		sql.append( " where kk.PARTY = ? " );
		sql.append( " order by kk.HYOJI_JYUNJYO " );
		
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		
		KensakuKomokuDao dao = new KensakuKomokuDao( this.daoLoginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
}
