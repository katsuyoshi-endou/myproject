package jp.co.hisas.career.app.talent.servlet;

import jp.co.hisas.career.app.common.event.CaRegistEvArg;
import jp.co.hisas.career.app.common.event.CaRegistEvHdlr;
import jp.co.hisas.career.app.common.event.CaRegistEvRslt;
import jp.co.hisas.career.app.talent.deliver.SearchResultDeliver;
import jp.co.hisas.career.app.talent.event.JvProfileEvRslt;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.app.talent.vm.VmVTLHOM;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.dto.CaRegistDto;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class JvProfileServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "VJA010";
	private static final String FORWARD_PAGE = "/view/talent/profile/VTLPRF_Profile.jsp";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		String tgtCmpaCd = null, tgtStfNo = null, tgtRoleId = null;
		
		if (SU.matches( tray.state, "SELF" )) {
			
			tgtRoleId = "Ordinary";
			CaRegistDto cpmDto = getTgtGnskInfo( tray );
			tgtCmpaCd = cpmDto.getCmpaCd();
			tgtStfNo = cpmDto.getStfNo();
			
			VmVTLHOM.updateVmState( tray, "SELF", "" );
		}
		else if (SU.matches( tray.state, "SHOW|SLIDE" )) {
			
			int wkIdx = calcWkIdx( tray );
			
			JvProfileEvRslt rslt = SearchResultDeliver.getRsltWkByWkIdx( tray, wkIdx );
			tgtRoleId = rslt.wkProfile.get( "ROLE_ID" );
			tgtCmpaCd = rslt.wkProfile.get( "TGT_CMPA_CD" );
			tgtStfNo  = rslt.wkProfile.get( "TGT_STF_NO" );
			
			tray.request.setAttribute( "jvProfilePagingHasPrev", (1 < wkIdx) ? "true" : "" );
			tray.request.setAttribute( "jvProfilePagingHasNext", (wkIdx < rslt.wkIdxMax) ? "true" : "" );
			
			// PDF出力選択画面から遷移してきた場合の為、インデックスをセッションに保持
			tray.session.setAttribute( JvSessionKey.TGT_SRCH_IDX, Integer.toString( wkIdx ) );
		}
		
		/* Carry to Command class via Request */
		tray.request.setAttribute( "jvProfileTgtCmpaCd", tgtCmpaCd );
		tray.request.setAttribute( "jvProfileTgtStfNo",  tgtStfNo );
		tray.request.setAttribute( "jvProfileTgtRoleId", tgtRoleId );
		
		// For PDF
		tray.session.setAttribute( JvSessionKey.JV_PROFILE_TGT_CMPA_CD, tgtCmpaCd );
		tray.session.setAttribute( JvSessionKey.JV_PROFILE_TGT_STF_NO, tgtStfNo );
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, tgtStfNo, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
	private int calcWkIdx( Tray tray ) {
		int newSrchIdx = 1;
		int crrWkIdx = SU.toInt( AU.getReqSesVal( tray.request, JvSessionKey.TGT_SRCH_IDX ), 1 );
		if (SU.matches( tray.state, "SHOW|RESTORE" )) {
			// Keep search index.
			return crrWkIdx;
		}
		else if (SU.equals( tray.state, "SLIDE" )) {
			// 「前の人」「次の人」
			String prevOrNext = AU.getRequestValue( tray.request, "prev_or_next" );
			if (SU.equals( prevOrNext, "prev" )) {
				newSrchIdx = crrWkIdx - 1;
			}
			if (SU.equals( prevOrNext, "next" )) {
				newSrchIdx = crrWkIdx + 1;
			}
		}
		return newSrchIdx;
	}
	
	private CaRegistDto getTgtGnskInfo( Tray tray ) throws CareerException {
		
		/* Set Args */
		CaRegistEvArg arg = new CaRegistEvArg( tray.loginNo );
		arg.sharp = "GET_GNSK_REGIST";
		arg.guid = tray.loginNo;
		
		/* Execute Event */
		CaRegistEvRslt result = CaRegistEvHdlr.exec( arg );
		
		return result.caRegistDto;
	}
	
}
