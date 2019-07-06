package jp.co.hisas.career.app.talent.servlet;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jp.co.hisas.career.app.common.bean.UserInfoBean;
import jp.co.hisas.career.app.talent.bean.JvProfileBean;
import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.util.log.Log;

public class ViewPictureServlet extends HttpServlet {
	
	private ServletContext ctx = null;
	
	public void init( final ServletConfig config ) {
		synchronized (this) {
			if (this.ctx == null) {
				this.ctx = config.getServletContext();
			}
		}
	}
	
	public void service( final HttpServletRequest request, final HttpServletResponse response ) throws IOException, ServletException {
		String login_no = null;
		
		try {
			/* sessionスコープのBeansを取得する */
			final HttpSession session = request.getSession( false );
			
			if (session == null) {
				this.ctx.getRequestDispatcher( "/view/error.jsp" ).forward( request, response );
			} else {
				final UserInfoBean userinfo = (UserInfoBean)session.getAttribute( "userinfo" );
				login_no = userinfo.getLogin_no();
				Log.method( login_no, "IN", "" );
				Log.performance( login_no, true, "" );
				
				/* 出力形式の設定 */
				String contentType = "";
				
				/* 顔写真情報を取得する */
				JvProfileBean jvProfileBean = (JvProfileBean)session.getAttribute( "jvProfileBean" );
				final PersonalPictureBean picturebean = jvProfileBean.jvPictureBean;
				
				byte[] picture = null;
				
				/* 写真があれば出力する */
				if (picturebean != null && picturebean.getPicture() != null) {
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
				response.setContentType( contentType );
				
				/* ファイル名の送信(attachment部分をinlineに変更すればインライン表示) */
				response.setHeader( "Content-disposition", "inline; " );
				
				final ServletOutputStream sout = response.getOutputStream();
				sout.write( picture );
				sout.close();
				
				Log.performance( login_no, false, "" );
				Log.method( login_no, "OUT", "" );
			}
		} catch (final Exception e) {
			Log.error( login_no, e );
			this.ctx.getRequestDispatcher( "/view/error.jsp" ).forward( request, response );
		}
	}
}
