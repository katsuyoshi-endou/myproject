package jp.co.hisas.career.app.talent.servlet;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
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

import org.apache.commons.io.IOUtils;

import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;
import jp.co.hisas.career.util.log.bean.OutLogBean;


public class JvPzPdfDownloadServlet extends HttpServlet {
	
	private ServletContext	ctx	= null;
	
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
			Log.method( login_no, "IN", "" );
			Log.performance( login_no, true, "" );
			
			final HttpSession session = request.getSession( false );
			if (session == null) {
				this.ctx.getRequestDispatcher( "/view/error.jsp" ).forward( request, response );
			} else {
				
				// 出力ファイル名
				String outputFileName = "thefilename.pdf";
				
				// ダウンロード
				this.fileOutput( response, outputFileName, null );
				
				/* 操作ログ */
				OutLogBean.outputLogSousa( request, "PDF_DL", "test", "state" );
				
				Log.performance( login_no, false, "" );
				Log.method( login_no, "OUT", "" );
			}
		} catch (final Exception e) {
			Log.error( login_no, e );
			request.setAttribute( "Exception", e );
			this.ctx.getRequestDispatcher( "/view/error.jsp" ).forward( request, response );
		}
	}
	
	private void fileOutput( final HttpServletResponse response, String outputFileName, byte[] outputFile ) throws IOException {
		
		// contentTypeを出力
		response.setContentType( "application/octet-stream" );
		
		// ファイル名の送信
		outputFileName = SU.bvl( outputFileName, "out.pdf" );
		response.setHeader( "Content-Disposition", "attachment; filename=\"" + outputFileName + "\"" );
		
		BufferedInputStream in = null;
		in = new BufferedInputStream( new FileInputStream( "C:\\tmp\\sample.pdf" ) );
		
		final byte[] buffer = new byte[4096];
		final ServletOutputStream out = response.getOutputStream();
		final ByteArrayInputStream bais = new ByteArrayInputStream( IOUtils.toByteArray( in ) );
		
		if (bais != null) {
			int size;
			while ((size = bais.read( buffer )) != -1) {
				out.write( buffer, 0, size );
			}
			bais.close();
		}
		in.close();
		out.close();
		response.flushBuffer();
		
		return;
	}
	
}
