package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.bean.DeptTreeBean;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.DeptDao;
import jp.co.hisas.career.util.dto.DeptDto;
import jp.co.hisas.career.util.log.Log;

public class DeptTreeEvHdlr extends AbstractEventHandler<DeptTreeEvArg, DeptTreeEvRslt> {
	
	private String loginNo;
	private int listIdx;
	
	/**
	 * Called from Servlet or Command Class.
	 */
	public static DeptTreeEvRslt exec( DeptTreeEvArg arg ) throws CareerException {
		DeptTreeEvHdlr handler = new DeptTreeEvHdlr();
		return handler.call( arg );
	}
	
	public DeptTreeEvRslt call( DeptTreeEvArg arg ) throws CareerException {
		DeptTreeEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected DeptTreeEvRslt execute( DeptTreeEvArg arg ) throws CareerException {
		
		arg.validateArg();
		
		this.loginNo = arg.getLoginNo();
		
		DeptTreeEvRslt result = new DeptTreeEvRslt();
		
		try {
			
			List<DeptDto> allCompanies = getAllCompanies( arg.party );
			if (allCompanies.size() == 0) {
				return result;
			}
			
			if (SU.matches( arg.state, "INIT|SEARCH" )) {
				
				if (SU.isBlank( arg.companyCode )) {
					DeptDto firstCompany = allCompanies.get( 0 );
					result.deptTreeBean = makeDeptTree( allCompanies, firstCompany );
				} else {
					DeptDto selectedCompany = findDeptDto( allCompanies, arg.companyCode );
					result.deptTreeBean = makeDeptTree( allCompanies, selectedCompany );
				}
				
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private DeptTreeBean makeDeptTree( List<DeptDto> allCompanies, DeptDto companyDeptDto ) throws SQLException {
		DeptTreeBean deptTreeBean = new DeptTreeBean();
		deptTreeBean.companyList = makeCompanyList( allCompanies );
		deptTreeBean.deptName    = companyDeptDto.getDeptNm();
		deptTreeBean.deptCd      = companyDeptDto.getCmpaCd();
		deptTreeBean.companyCode = companyDeptDto.getCmpaCd();
		String startGroupCode    = companyDeptDto.getDeptCd();
		List<DeptDto> deptDtoList = getDeptDtoListByCompany( companyDeptDto.getCmpaCd() );
		listIdx = 0;
		deptTreeBean.groupNodeList = getGroupNodeList( deptDtoList, startGroupCode );
		return deptTreeBean;
	}
	
	private DeptDto findDeptDto( List<DeptDto> searchCompanyList, String companyCode ) {
		DeptDto result = null;
		for (DeptDto deptDto : searchCompanyList) {
			if (deptDto.getCmpaCd().equals( companyCode )) {
				result = deptDto;
				break;
			}
		}
		return result;
	}
	
	private List<DeptDto> getAllCompanies( String party ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select" + DeptDao.ALLCOLS );
		sql.append( "  from DEPT d " );
		sql.append( " where HIERARCHY = 0 " );
		sql.append( "   and exists ( select 'X' from CA_PARTY_COMPANY p where p.CMPA_CD = d.CMPA_CD and p.PARTY = ? ) " );
		sql.append( " order by LPAD_SORT " );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( party );
		
		DeptDao dao = new DeptDao( this.loginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<DeptDto> getDeptDtoListByCompany( String companyCode ) throws SQLException {
		
		StringBuilder sql = new StringBuilder();
		sql.append( "select " + DeptDao.ALLCOLS );
		sql.append( "  from (select * from DEPT where CMPA_CD = ?) DEPT start with PARENT_DEPT_CD = 'root' " );
		sql.append( " connect by PRIOR DEPT_CD = PARENT_DEPT_CD " );
		sql.append( " order siblings by LPAD_SORT " );
		// Don't use order by here.
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( companyCode );
		
		DeptDao dao = new DeptDao( this.loginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	// 会社リストを作る
	private List<DeptTreeBean> makeCompanyList( List<DeptDto> SearchCompanyList ) {
		
		List<DeptTreeBean> companyList = new ArrayList<DeptTreeBean>();
		
		for (DeptDto CondTabSect : SearchCompanyList) {
			String sectionID = CondTabSect.getCmpaCd();
			String sectionName = CondTabSect.getDeptNm();
			companyList.add( new DeptTreeBean( sectionID, sectionName ) );
		}
		
		return companyList;
	}
	
	/**
	 * 所属ノードリストを作る
	 */
	private List<String> getGroupNodeList( List<DeptDto> deptDtoList, String orginParentDeptCd ) {
		List<String> nodeList = new ArrayList<String>();
		try {
			boolean commaFlg = false;
			while (listIdx < deptDtoList.size()) {
				DeptDto ingDept = deptDtoList.get( listIdx );
				String deptCd       = ingDept.getDeptCd();
				String deptName     = ingDept.getDeptNm();
				String deptFullNm   = ingDept.getFullDeptNm();
				String parentDeptCd = ingDept.getParentDeptCd();
				
				listIdx++;
				
				boolean isIdxInSafe    = listIdx < deptDtoList.size();
				boolean nextParentIsMe = (isIdxInSafe) ? deptCd.equals( deptDtoList.get( listIdx ).getParentDeptCd() ) : false;
				
				if (!parentDeptCd.equals( orginParentDeptCd ) && !parentDeptCd.equals( "root" )) {
					// 親が違う場合
					listIdx--;
					break;
					
				} else if (isIdxInSafe && nextParentIsMe) {
					// 次のレコードの親が自分の場合
					nodeList.add( getNodeStr( deptName, deptFullNm, deptCd, commaFlg, true ) );
					nodeList.addAll( getGroupNodeList( deptDtoList, deptCd ) );
					nodeList.add( "]}" );
				} else {
					nodeList.add( getNodeStr( deptName, deptFullNm, deptCd, commaFlg, false ) );
				}
				commaFlg = true;
			}
		} catch (Exception e) {
		}
		return nodeList;
	}
	
	private String getNodeStr( String deptName, String deptFullNm, String deptCd, boolean commaFlg, boolean childFlg ) {
		
		String nodeStr = "";
		
		if (commaFlg && childFlg) {
			nodeStr = ",{title: '" + deptName + "', abcde: '" + deptFullNm + "', key: '" + deptCd + "',children:[";
			
		} else if (commaFlg && !childFlg) {
			nodeStr = ",{title: '" + deptName + "', abcde: '" + deptFullNm + "', key: '" + deptCd + "'}";
			
		} else if (!commaFlg && childFlg) {
			nodeStr = "{title: '" + deptName + "', abcde: '" + deptFullNm + "', key: '" + deptCd + "',children:[";
			
		} else if (!commaFlg && !childFlg) {
			nodeStr = "{title: '" + deptName + "', abcde: '" + deptFullNm + "', key: '" + deptCd + "'}";
			
		}
		
		return nodeStr;
	}
	
}
