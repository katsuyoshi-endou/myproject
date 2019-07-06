package jp.co.hisas.career.app.talent.deliver;

import java.io.IOException;
import java.io.Serializable;

import org.apache.commons.io.IOUtils;

import com.google.gson.Gson;

import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.Tray;

public class DeliverOrder implements Serializable {
	
	public String party;
	public int langNo;
	public String sessionId;
	public String operatorGuid;
	
	public DeliverOrder(Tray tray) {
		this.init( tray );
	}
	
	public void init( Tray tray ) {
		this.party = tray.party;
		this.langNo = tray.langNo;
		this.sessionId = tray.session.getId();
		this.operatorGuid = tray.operatorGuid;
	}
	
	public static <T> T fromJson( Tray tray, Class<T> cls ) {
		Gson gson = new Gson();
		String json = getRequestBody( tray );
		T order = gson.fromJson( SU.bvl( json, "{}" ), cls );
		return order;
	}
	
	private static String getRequestBody( Tray tray ) {
		try {
			return IOUtils.toString( tray.request.getInputStream(), "UTF-8" );
		} catch (IOException e) {
			return null;
		}
	}
}
