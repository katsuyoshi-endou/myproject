package jp.co.hisas.career.app.talent.dyres;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.log.Log;

public class LabelmapDyres extends HttpServlet {
	
	protected ServletContext ctx = null;
	private static final long serialVersionUID = 1L;
	
	public void init( ServletConfig config ) {
		synchronized (this) {
			if (this.ctx == null) {
				this.ctx = config.getServletContext();
			}
		}
	}
	
	@Override
	public void service( HttpServletRequest req, HttpServletResponse res ) throws IOException, ServletException {
		try {
			Object userinfo = req.getSession( false ).getAttribute( "userinfo" );
			if (userinfo != null) {
				Tray tray = new Tray( req, res );
				AU.setReqAttr( tray.request, "tray", tray );
				String fPath = "/view/common/VYC_Labelmap.jsp";
				RequestDispatcher rd = this.ctx.getRequestDispatcher( fPath );
				rd.forward( tray.request, tray.response );
			}
			else {
				res.getWriter().write( "" );
			}
		} catch (Exception e) {
			Log.error( req, e );
		}
	}
	
}
