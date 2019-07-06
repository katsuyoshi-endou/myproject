package jp.co.hisas.career.app.talent.servlet;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

import jp.co.hisas.career.app.talent.bean.JvProfileBean;
import jp.co.hisas.career.app.talent.bean.JvProfilePdfBean;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectFilterDto;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.NewTokenServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.Log;
import jp.co.hisas.career.util.log.bean.OutLogBean;

public class JvProfilePdfServlet extends NewTokenServlet {
	
	private static final long serialVersionUID = 1L;
	private static final String KINOU_ID = "FTLPDF";
	private static final String FORWARD_PAGE = "/servlet/FileDownloadServlet";
	
	public String serviceMain( Tray tray ) throws CareerException {
		
		// 出力対象社員のデータ
		JvProfileBean jvProfileBean = tray.getSessionAttr( JvSessionKey.JV_PROFILE );
		
		// 出力対象セクションID
		List<String> tgtSectionIdList = getTgtSectionIdList( tray );
		
		// 出力PDFを作成
		byte[] createdPdf = this.createPdf( tray, jvProfileBean, tgtSectionIdList );
		final ByteArrayInputStream bais = new ByteArrayInputStream( createdPdf );
		
		// 出力ファイル名
		String tgtStfNo = tray.getSessionAttr( JvSessionKey.JV_PROFILE_TGT_STF_NO );
		String filename = "JugyoinInfo_" + tgtStfNo + ".pdf";
		
		tray.request.setAttribute( "STREAM", bais );
		tray.request.setAttribute( "H080_FileName", filename );
		
		// 操作ログ
		OutLogBean.outputLogSousa( tray.request, KINOU_ID, tgtStfNo, tray.state );
		
		return SU.bvl( tray.forwardUrl, FORWARD_PAGE );
	}
	
	private List<String> getTgtSectionIdList( Tray tray ) {
		List<String> tgtSectionIdList = new ArrayList<String>();
		
		JvProfileBean jvProfileBean = tray.getSessionAttr( JvSessionKey.JV_PROFILE );
		
		for (JvProfTabSectFilterDto dto : jvProfileBean.sectList) {
			tgtSectionIdList.add( dto.getSectId() );
		}
		return tgtSectionIdList;
	}
	
	private byte[] createPdf( Tray tray, JvProfileBean jvProfileBean, List<String> tgtSectionIdList ) throws CareerException {
		Log.method( tray.loginNo, "IN", "" );
		
		JvProfilePdfBean pdfBean = null;
		try {
			pdfBean = new JvProfilePdfBean( tray.loginNo, this.ctx );
			pdfBean.openPdfDocument();
			
			// PARTY
			pdfBean.party = tray.party;
			pdfBean.tgtCmpaCd = AU.getSessionAttr( tray.session, JvSessionKey.JV_PROFILE_TGT_CMPA_CD );
			pdfBean.tgtStfNo  = AU.getSessionAttr( tray.session, JvSessionKey.JV_PROFILE_TGT_STF_NO );
			// 対象社員
			pdfBean.jvProfileBean = jvProfileBean;
			// 対象セクションID
			pdfBean.tgtSectionIdList = tgtSectionIdList;
			
			// 言語No
			pdfBean.langNo = tray.langNo;
			
			pdfBean.addPdfDocument();
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		}
		
		Log.method( tray.loginNo, "OUT", "" );
		return pdfBean.closePdfDocument();
	}
}
