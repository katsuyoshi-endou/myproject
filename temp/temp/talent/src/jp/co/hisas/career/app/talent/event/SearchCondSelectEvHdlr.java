package jp.co.hisas.career.app.talent.event;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.bean.SearchCondSelectBean;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.util.dao.DaoUtil;
import jp.co.hisas.career.util.dao.HierCodeMasterDao;
import jp.co.hisas.career.util.dto.HierCodeMasterDto;
import jp.co.hisas.career.util.log.Log;

public class SearchCondSelectEvHdlr extends AbstractEventHandler<SearchCondSelectEvArg, SearchCondSelectEvRslt> {
	
	private String loginNo;
	private int listIdx;
	
	/**
	 * Called from Servlet or Command Class.
	 */
	public static SearchCondSelectEvRslt exec( SearchCondSelectEvArg arg ) throws CareerException {
		SearchCondSelectEvHdlr handler = new SearchCondSelectEvHdlr();
		return handler.call( arg );
	}
	
	public SearchCondSelectEvRslt call( SearchCondSelectEvArg arg ) throws CareerException {
		SearchCondSelectEvRslt result = null;
		Log.method( arg.getLoginNo(), "IN", "" );
		if (Log.isDebugMode()) {
			result = this.execute( arg );
		} else {
			result = this.callEjb( arg );
		}
		Log.method( arg.getLoginNo(), "OUT", "" );
		return result;
	}
	
	protected SearchCondSelectEvRslt execute( SearchCondSelectEvArg arg ) throws CareerException {
		
		arg.ValueCheck();
		this.loginNo = arg.getLoginNo();
		SearchCondSelectEvRslt result = new SearchCondSelectEvRslt();
		try {
			SearchCondSelectBean searchCondSelectBean = new SearchCondSelectBean();
			
			/* masterID */
			searchCondSelectBean.masterID = arg.masterId;
			
			/* masterName */
			searchCondSelectBean.masterName = arg.masterName;
			
			/* child Node List */
			listIdx = 0;
			List<HierCodeMasterDto> SearchCondSectList = getJvSearchCondSectList( arg );
			searchCondSelectBean.childNodeList = getChildNodeList( SearchCondSectList );
			
			result.searchCondSelectBean = searchCondSelectBean;
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	private List<HierCodeMasterDto> getJvSearchCondSectList( SearchCondSelectEvArg arg ) throws SQLException {
		
		/* Dynamic SQL */
		StringBuilder sql = new StringBuilder();
		sql.append( "  select " + HierCodeMasterDao.ALLCOLS );
		sql.append( "    from HIER_CODE_MASTER " );
		sql.append( "   start with MASTER_ID = ? " );
		sql.append( "     and PARENT_MASTER_CODE is null " );
		sql.append( " connect by prior MASTER_CODE = PARENT_MASTER_CODE" );
		sql.append( "   order siblings by LPAD_SORT ASC" );
		
		/* Parameter List */
		ArrayList<String> paramList = new ArrayList<String>();
		paramList.add( arg.masterId );
		
		HierCodeMasterDao dao = new HierCodeMasterDao( this.loginNo );
		return dao.selectDynamic( DaoUtil.getPstmt( sql, paramList ) );
	}
	
	private List<String> getChildNodeList( List<HierCodeMasterDto> searchCondSectList ) {
		
		List<String> nodeList = new ArrayList<String>();
		
		if (searchCondSectList.size() != 0) {
			nodeList.add( getNodeStr( "全選択", "", false, true ) );
			nodeList.addAll( makeChildNodeList( searchCondSectList, searchCondSectList.get( 0 ).getParentMasterCode() ) );
			nodeList.add( "]}" );
		}
		return nodeList;
	}
	
	private List<String> makeChildNodeList( List<HierCodeMasterDto> SearchCondSectList, String orginParentDeptCd ) {
		
		List<String> nodeList = new ArrayList<String>();
		boolean commaFlg = false;
		
		while (listIdx < SearchCondSectList.size()) {
			String masterCd = SearchCondSectList.get( listIdx ).getMasterCode();
			String masterName = SearchCondSectList.get( listIdx ).getMasterName();
			String parentMastertCd = SearchCondSectList.get( listIdx ).getParentMasterCode();
			
			listIdx++;
			
			// 親が違う場合
			if (!parentMastertCd.equals( orginParentDeptCd )) {
				listIdx--;
				break;
				
				// 次のレコードの親が自分の場合
			} else if ((listIdx < SearchCondSectList.size()) && (masterCd.equals( SearchCondSectList.get( listIdx ).getParentMasterCode() ))) {
				nodeList.add( getNodeStr( masterName, masterCd, commaFlg, true ) );
				nodeList.addAll( makeChildNodeList( SearchCondSectList, masterCd ) );
				nodeList.add( "]}" );
				
			} else {
				nodeList.add( getNodeStr( masterName, masterCd, commaFlg, false ) );
			}
			commaFlg = true;
		}
		return nodeList;
	}
	
	private String getNodeStr( String masterName, String masterKey, boolean commaFlg, boolean childFlg ) {
		
		String nodeStr = "";
		
		if (commaFlg && childFlg) {
			nodeStr = ",{title: '" + masterName + "', key: '" + masterKey + "', expanded: true, children:[";
			
		} else if (commaFlg && !childFlg) {
			nodeStr = ",{title: '" + masterName + "', key: '" + masterKey + "'}";
			
		} else if (!commaFlg && childFlg) {
			nodeStr = "{title: '" + masterName + "', key: '" + masterKey + "', expanded: true, children:[";
			
		} else if (!commaFlg && !childFlg) {
			nodeStr = "{title: '" + masterName + "', key: '" + masterKey + "'}";
		}
		
		return nodeStr;
	}
	
}
