package jp.co.hisas.career.app.talent.api.labels;

import java.util.Map;

import com.google.gson.Gson;

import jp.co.hisas.career.app.talent.api.Butler;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.Tray;
import jp.co.hisas.career.util.property.CommonLabel;

public class LabelsButler extends Butler {
	
	public LabelsButler(Tray tray) {
		super( tray );
	}
	
	@Override
	public String takeGET() throws CareerException {
		
		Map<String, String> labels = CommonLabel.getLabelsWithRegex( tray.party, tray.langNo, "^LTL.*$" );
		
		Gson gson = new Gson();
		return gson.toJson( labels );
	}
	
}
