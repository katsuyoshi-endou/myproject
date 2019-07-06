package jp.co.hisas.career.app;

import java.lang.reflect.Field;

import jp.co.hisas.career.app.common.bean.UserInfoBean;
import jp.co.hisas.career.app.common.event.DualEvArg;
import jp.co.hisas.career.app.common.event.DualEvHdlr;
import jp.co.hisas.career.app.common.event.UserInfoEvArg;
import jp.co.hisas.career.app.common.event.UserInfoEvHdlr;
import jp.co.hisas.career.app.common.event.UserInfoEvRslt;
import jp.co.hisas.career.app.talent.mold.MySearchMold;
import jp.co.hisas.career.app.talent.util.JvSessionKey;
import jp.co.hisas.career.app.talent.vm.VmVTLHOM;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.AU;
import jp.co.hisas.career.util.AppSessionKey;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.property.ReadFile;

public class AppState {
	
	private Tray tray;
	
	public AppState(Tray tray) {
		this.tray = tray;
	}
	
	public void initialize() throws CareerException {
		
		prepareServer();
		
		clearAllSessionAttributes();
		
		updateUserInfo();
		
		execEventInit();
	}
	
	private void prepareServer() throws CareerException {
		
		/* Check DB access */
		DualEvHdlr.exec( new DualEvArg( "AppState" ) );
		
		/* Read property files and DB parameters */
		ReadFile.loadIfNotCached();
	}
	
	private void updateUserInfo() throws CareerException {
		
		/* Set Args */
		UserInfoEvArg arg = new UserInfoEvArg( tray.loginNo );
		arg.sharp = "INIT";
		arg.guid = tray.loginNo;
		
		/* Execute Event */
		UserInfoEvRslt result = UserInfoEvHdlr.exec( arg );
		
		/* Update UserInfo */
		UserInfoBean userInfo = tray.getSessionAttr( UserInfoBean.SESSION_KEY );
		userInfo.setKanjiSimei( result.careerGuidDto.getGunm() );
		String operatorFlg = result.careerGuidDto.getOperatorFlg();
		userInfo.isOperator = "1".equals( operatorFlg );
		String operatorGuid = (userInfo.isOperator) ? AU.getCareerProperty( "OPERATOR_GUID" ) : tray.loginNo;
		userInfo.setOperatorGuid( operatorGuid );
		
		/* Return to session */
		tray.session.setAttribute( UserInfoBean.SESSION_KEY, userInfo );
	}
	
	private void execEventInit() throws CareerException {
		VmVTLHOM vm = tray.getSessionAttr( VmVTLHOM.VMID );
		if (vm == null) {
			tray.session.setAttribute( VmVTLHOM.VMID, new VmVTLHOM( tray ) );
		}
	}
	
	private void clearAllSessionAttributes() {
		/* Application */
		removeSessionAttr( AppSessionKey.class.getDeclaredFields() );
		/* JinzaiViewer */
		removeSessionAttr( JvSessionKey.class.getDeclaredFields() );
		tray.session.removeAttribute( MySearchMold.SESSION_KEY );
		tray.session.removeAttribute( VmVTLHOM.VMID );
	}
	
	private void removeSessionAttr( Field[] fields ) {
		for (Field field : fields) {
			try {
				String sessionKey = (String)field.get( field.getName() );
				tray.session.removeAttribute( sessionKey );
			} catch (IllegalArgumentException e) {
			} catch (IllegalAccessException e) {
			}
		}
	}
	
}
