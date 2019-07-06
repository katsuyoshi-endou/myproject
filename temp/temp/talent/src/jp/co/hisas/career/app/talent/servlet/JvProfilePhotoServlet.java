package jp.co.hisas.career.app.talent.servlet;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;

import javax.servlet.ServletOutputStream;

import jp.co.hisas.career.app.common.event.CaRegistEvArg;
import jp.co.hisas.career.app.common.event.CaRegistEvHdlr;
import jp.co.hisas.career.app.common.event.CaRegistEvRslt;
import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.event.LegacyEvArg;
import jp.co.hisas.career.app.talent.event.LegacyEvHdlr;
import jp.co.hisas.career.app.talent.event.LegacyEvRslt;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.framework.trans.ResponsedServlet;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.dto.CaRegistDto;

public class JvProfilePhotoServlet extends ResponsedServlet {
	
	@Override
	public void serviceMain( Tray tray ) throws Exception {
		
		boolean hasPicture = false;
		String contentType = "";
		PersonalPictureBean picturebean = null;
		byte[] picture = null;
		
		String cmpaCd = AU.getRequestValue( tray.request, "c" );
		String stfNo  = AU.getRequestValue( tray.request, "s" );
		
		CaRegistDto registDto = getCaRegist( tray, cmpaCd, stfNo );
		if (registDto != null) {
			picturebean = getPersonalPictureBean( tray, registDto.getGuid() );
			hasPicture = (picturebean != null && picturebean.getPicture() != null);
		}
		
		/* 写真があれば出力する */
		if (hasPicture) {
			/* 出力形式の設定 */
			contentType = picturebean.getContent_type();
			picture = picturebean.getPicture();
		} else {
			final ByteArrayOutputStream baos = new ByteArrayOutputStream();
			
			/* ファイル読み込み用バッファ */
			final byte[] buffer = new byte[4096];
			
			final FileInputStream fin = new FileInputStream( this.ctx.getRealPath( "/assets/img/photo/dummy.gif" ) );
			int size;
			
			while ((size = fin.read( buffer )) != -1) {
				baos.write( buffer, 0, size );
			}
			
			fin.close();
			baos.close();
			
			/* 出力形式の設定 */
			contentType = "image/gif";
			
			picture = baos.toByteArray();
		}
		tray.response.setContentType( contentType );
		
		/* ファイル名の送信(attachment部分をinlineに変更すればインライン表示) */
		tray.response.setHeader( "Content-disposition", "inline; " );
		
		final ServletOutputStream sout = tray.response.getOutputStream();
		sout.write( picture );
		sout.close();
	}
	
	private CaRegistDto getCaRegist( Tray tray, String cmpaCd, String stfNo ) throws CareerException {
		CaRegistEvArg arg = new CaRegistEvArg( tray.loginNo );
		arg.sharp = "GET_BY_CMPA_STF";
		arg.cmpaCd = cmpaCd;
		arg.stfNo = stfNo;
		CaRegistEvRslt rslt = CaRegistEvHdlr.exec( arg );
		return rslt.caRegistDto;
	}
	
	private PersonalPictureBean getPersonalPictureBean( Tray tray, String tgtGuid ) throws Exception {
		
		LegacyEvArg arg = new LegacyEvArg( tray.loginNo );
		arg.sharp = "getPersonalPicture";
		arg.tgtGuid = tgtGuid;
		LegacyEvRslt rslt = LegacyEvHdlr.exec( arg );
		
		return rslt.picturebean;
	}
	
}
