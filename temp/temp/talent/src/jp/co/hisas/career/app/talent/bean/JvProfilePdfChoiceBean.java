package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectFilterDto;

public class JvProfilePdfChoiceBean implements Serializable {
	
	/** PDFプロフィールタブセクションリスト */
	public List<JvProfTabSectFilterDto> jvPdfProfTabSectList = null;
	
	/** ノードリスト */
	public List<String> nodeList = null;
	
	public JvProfilePdfChoiceBean() {
	}
	
	public List<String> getNodeList() {
		return nodeList;
	}
	
	public void setNodeList( List<String> nodeList ) {
		this.nodeList = nodeList;
	}
	
}
