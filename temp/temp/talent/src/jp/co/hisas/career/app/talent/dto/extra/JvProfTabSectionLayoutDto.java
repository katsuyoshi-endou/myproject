package jp.co.hisas.career.app.talent.dto.extra;

import java.io.Serializable;
import java.util.List;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectAddontypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectBoxtypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;

public class JvProfTabSectionLayoutDto implements Serializable {

	/**
	 * プロフィールタブセクションDTO
	 */
	private JvProfTabSectDto jvProfTabSectDto;
	/**
	 * ボックスタイプセクションオブジェクト
	 */
	private List<JvProfTabSectBoxtypeDto> boxtypeSection;
	/**
	 * リストタイプセクションオブジェクト
	 */
	private List<JvProfTabSectListtypeDto> listtypeSection;
	/**
	 * アドオンタイプセクションオブジェクト
	 */
	private List<JvProfTabSectAddontypeDto> addontypeSection;


	public JvProfTabSectDto getJvProfTabSectDto() {
		return jvProfTabSectDto;
	}

	public void setJvProfTabSectDto(JvProfTabSectDto jvProfTabSectDto) {
		this.jvProfTabSectDto = jvProfTabSectDto;
	}

	public List<JvProfTabSectBoxtypeDto> getBoxtypeSection() {
		return boxtypeSection;
	}

	public void setBoxtypeSection(List<JvProfTabSectBoxtypeDto> boxtypeSection) {
		this.boxtypeSection = boxtypeSection;
	}

	public List<JvProfTabSectListtypeDto> getListtypeSection() {
		return listtypeSection;
	}

	public void setListtypeSection(List<JvProfTabSectListtypeDto> listtypeSection) {
		this.listtypeSection = listtypeSection;
	}

	public List<JvProfTabSectAddontypeDto> getAddontypeSection() {
		return addontypeSection;
	}

	public void setAddontypeSection( List<JvProfTabSectAddontypeDto> addontypeSection ) {
		this.addontypeSection = addontypeSection;
	}

}

