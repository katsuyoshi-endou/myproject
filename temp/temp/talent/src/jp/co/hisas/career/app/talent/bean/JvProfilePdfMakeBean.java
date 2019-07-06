package jp.co.hisas.career.app.talent.bean;

import java.awt.Color;
import java.util.List;

import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;

import jp.co.hisas.career.app.talent.dto.JvProfTabSectBoxtypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.app.talent.dto.extra.JvProfTabSectionLayoutDto;
import jp.co.hisas.career.app.talent.util.PDFUtil;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.property.CommonLabel;

public class JvProfilePdfMakeBean {
	
	/** タイトルフォント */
	public Font titleFont;
	/** セクション名フォント */
	public Font sectionNameFont;
	/** コメント用フォント */
	public Font commentFont;
	/** 表(見出し)フォント */
	public Font tableHeaderFont;
	/** 表(内容)フォント */
	public Font tableDataFont;
	
	/** TableWidth */
	public float width;
	
	/** 顔写真 **/
	public Image kaoShashin;
	
	/** 出力対象 社員データ */
	public JvProfileBean jvProfileBean;
	
	/** PARTY */
	public String party;
	
	/** 言語No */
	public int langNo;
	
	/**
	 * コンストラクタ
	 */
	public JvProfilePdfMakeBean(Font titleFont, Font sectionNameFont, Font commentFont, Font tableHeaderFont, Font tableDataFont
							  , float width, Image kaoShashin, JvProfileBean jvProfileBean, String party, int langNo) {
		this.titleFont       = titleFont;
		this.sectionNameFont = sectionNameFont;
		this.commentFont     = commentFont;
		this.tableHeaderFont = tableHeaderFont;
		this.tableDataFont   = tableDataFont;
		this.width           = width;
		this.kaoShashin      = kaoShashin;
		this.jvProfileBean   = jvProfileBean;
		this.party           = party;
		this.langNo          = langNo;
	}
	
	 /* ---------------------------------------- セクション毎のレイアウトを作成 ---------------------------------------- */
	
	/**
	 * タイトルのセルを取得する
	 */
	public PdfPCell getTitleCell( String labelId, PdfPTable nestTable, Font font ) throws Exception {
		
		String sectionName = "■" + getLabel( labelId );
		return PDFUtil.newSectionTitle( nestTable, sectionName, font );
		
	}
	
	/**
	 * PDFタイトルのレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_TITLE() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 100f } );
		
		/* タイトルのセルを取得する */
		childTable.addCell( getTitleCell( "LAA010_TITLE", childTable, titleFont ) );
		
		childTable.addCell( newCellBlank( childTable, 20f ) );
		
		return childTable;
	}
	
	/**
	 * PDF上部の共通表示基礎部分のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_KYOTU( List<JvProfTabSectionLayoutDto> commonBox ) throws Exception {
		if (commonBox == null || commonBox.size() == 0) {
			return null;
		}
		JvProfTabSectionLayoutDto dto = commonBox.get( 0 );
		List<JvProfTabSectBoxtypeDto> boxtypeList = dto.getBoxtypeSection();
		
		PdfPTable parentTable;
		PdfPTable photoTable, commonTable;
		
		/* 第1セクション（左） 共通表示部 写真・基礎情報の領域定義 */
		parentTable = PDFUtil.newTable( width, new float[] { 22f, 78f } );
		
		/* 第1セクション（左） 共通表示部 写真のレイアウトを構築する */
		photoTable = makeTableLayout_Photo();
		parentTable.addCell( photoTable );
		
		/* 第1セクション（右） 共通表示部 基礎情報のレイアウトを構築する */
		commonTable = PDFUtil.newTable( width, PDFUtil.getColsInfoBoxtype( boxtypeList ) );
		
		for (JvProfTabSectBoxtypeDto box : boxtypeList) {
			boolean isLabel = SU.equals( "label", box.getLabelOrData() );
			String paramId = box.getParamId();
			if (isLabel) {
				commonTable.addCell( newCellTH( getLabel( paramId ), box.getColspan() ) );
			} else {
				commonTable.addCell( newCellTD( getPZCValue( paramId ), box.getColspan() ) );
			}
		}
		
		parentTable.addCell( commonTable );
		
		return parentTable;
	}
	
	/**
	 * 共通表示項目の顔写真のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_Photo() throws Exception {
		PdfPTable nestTable = PDFUtil.newTable( width, new float[] { 100f } );
		
		this.kaoShashin.scaleAbsolute( 80f, 80f );
		PdfPCell imageCell = new PdfPCell( this.kaoShashin, false );
		imageCell.setHorizontalAlignment( Rectangle.ALIGN_CENTER );
		imageCell.setBorder( Rectangle.NO_BORDER );
		imageCell.setBorderWidth( 0.1f );
		nestTable.addCell( imageCell );
		return nestTable;
	}
	
	/**
	 * 原籍情報のレイアウトを構築する
	 * @param tgtSectionIdList 
	 */
	public PdfPTable makeTableLayout_AUTO( List<JvProfTabSectionLayoutDto> layoutList, List<String> tgtSectionIdList ) throws Exception {
		PdfPTable sheet = PDFUtil.newTable( width, new float[] { 100f } );
		PdfPTable table;
		if (layoutList == null || layoutList.size() == 0) {
			return null;
		}
		for (JvProfTabSectionLayoutDto section : layoutList) {
			JvProfTabSectDto sect = section.getJvProfTabSectDto();
			String sectId = sect.getSectId();
			if (!tgtSectionIdList.contains( sectId )) {
				continue;
			}
			String layoutType = sect.getLayoutType();
			if (SU.equals( layoutType, "Title" )) {
				table = PDFUtil.newTable( width, new float[] { 100f } );
				sheet.addCell( newCellBlank() );
				sheet.addCell( newCellBlank() );
				sheet.addCell( PDFUtil.newSectionTitleBlackBar( getLabel( sectId ), sectionNameFont, table ) );
			}
			if (SU.equals( layoutType, "Box" )) {
				List<JvProfTabSectBoxtypeDto> boxtypeList = section.getBoxtypeSection();
				
				table = PDFUtil.newTable( width, PDFUtil.getColsInfoBoxtype( boxtypeList ) );
				
				table.addCell( getTitleCell( sectId, table, sectionNameFont ) );
				
				for (JvProfTabSectBoxtypeDto box : boxtypeList) {
					boolean isLabel = SU.equals( "label", box.getLabelOrData() );
					String paramId = box.getParamId();
					if (isLabel) {
						table.addCell( newCellTH( getLabel( paramId ), box.getColspan() ) );
					} else {
						table.addCell( newCellTD( getPZCValue( paramId ), box.getColspan() ) );
					}
				}
				sheet.addCell( table );
			}
			if (SU.equals( layoutType, "List" )) {
				List<JvProfTabSectListtypeDto> listtypeList = section.getListtypeSection();
				
				table = PDFUtil.newTable( width, PDFUtil.getColsInfoListtype( listtypeList ) );
				
				table.addCell( getTitleCell( sectId, table, sectionNameFont ) );
				
				String[] headArray = new String[listtypeList.size()];
				String[] pzidArray = new String[listtypeList.size()];
				for (int i = 0; i < listtypeList.size(); i++) {
					JvProfTabSectListtypeDto dto = listtypeList.get( i );
					headArray[i] = dto.getHeaderLabelId();
					pzidArray[i] = dto.getDataParamId();
				}
				for (String headId : headArray) {
					table.addCell( newCellTH( getLabel( headId ) ) );
				}
				addCellsPZTCValue( table, pzidArray, false );
				sheet.addCell( table );
			}
		}
		
		return sheet;
	}
	
	/**
	 * 身上基本項目のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_MINOU( String tabId ) throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 15f, 19f, 15f, 24f, 15f, 13f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( tabId + "-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0101" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kaigai_keiken" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0103" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_retire_date" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0105" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kyusei" ) ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0201" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_saiyou_kbn" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0203" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_retire_riyu" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0205" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kosekisei" ) ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0301" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kumiaiin_kbn" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0303" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_shokei_kbn" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0305" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_nen_k" ) ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0401" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_birth_date" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0403" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kokuseki" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0405" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_nen_r" ) ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0501" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_nenko" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0503" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_notes_address" ) ) );
		if ("TAB02".equals( tabId )) {
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_L0505" ) ) );
			childTable.addCell( newCellTD( getPZCValue( "sinjo_kihon_kisonenkin_no" ) ) );
		} else if ("TAB03".equals( tabId )) {
			childTable.addCell( newCellBlank( 2 ) );
		}
		
		return childTable;
		
	}
	
	/**
	 * 障害情報のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHOGI( String tabId ) throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "sinjo_shogi_sbt", "sinjo_shogi_tokyu" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 33f, 67f } );
		childTable = PDFUtil.newTable( width, new float[] { 37f, 64f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( tabId + "-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT03_LCOL02" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 本人住所のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_JUSHO_HNN() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 14.5f, 55f, 15f, 15.5f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB04-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT02_L0101" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT02_L0102" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT02_L0103" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT02_L0104" ), new Color( 255, 255, 204 ) ) );
		
		childTable.addCell( newCellTD( getPZCValue( "jusho_honin_yuubin_bango" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_honin_jusho" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_honin_denwa_bango" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_honin_jukyo_sbt" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * 緊急連絡先住所のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_JUSHO_KNK() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 15f, 15f, 15f, 15f, 15f, 15f, 6f, 7f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB04-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0101" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0102" ), 7, new Color( 255, 255, 204 ) ) );
		
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_yuubin_bango" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_jusho" ), 7 ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0301" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_denwa_bango" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0303" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_simei_kanji" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0305" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_simei_kana" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT03_L0307" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kinky_tudukigara" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * 住民税納付住所のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_JUSHO_JMZ() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 14.5f, 85.5f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB04-SECT04", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT04_L0101" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT04_L0102" ), new Color( 255, 255, 204 ) ) );
		
		childTable.addCell( newCellTD( getPZCValue( "jusho_jmhyo_yuubin_bango" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_jmhyo_jusho" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * 持家住所のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_JUSHO_MCI() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 100f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB04-SECT05", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT05_L0101" ), new Color( 255, 255, 204 ) ) );
		
		childTable.addCell( newCellTD( getPZCValue( "jusho_mchie_jusho" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * 国内家族住所のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_JUSHO_KKN() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 15f, 15f, 15f, 15f, 15f, 15f, 6f, 7f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB04-SECT06", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0101" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0102" ), 7, new Color( 255, 255, 204 ) ) );
		
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_yuubin_bango" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_jusho" ), 7 ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0301" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_denwa_bango" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0303" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_simei_kanji" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0305" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_simei_kana" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB04-SECT06_L0307" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTD( getPZCValue( "jusho_kazok_tudukigara" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * 家族(基本情報)のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_KAZOK_KHN() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "kazok_simei_kanji", "kazok_simei_kana", "kazok_simei_eiji", "kazok_tudukigara", "kazok_nenrei", "kazok_birth_date", "kazok_shokugyo" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 82f, 18f } );
		
		childTable = PDFUtil.newTable( width, new float[] { 16f, 16f, 16f, 13f, 6, 13f, 21f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB05-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL01" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL02" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL03" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL04" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL05" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL06" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT02_LCOL07" ), new Color( 255, 255, 204 ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 家族(扶養情報等)のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_KAZOK_FYO() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "kazok_simei_kanji", "kazok_simei_kana", "kazok_simei_eiji", "kazok_dokyo_kbn", "kazok_fuyo_shotokuzei", "kazok_fuyo_kenpo", "kazok_shogi_sbt" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 79f, 21f } );
		
		childTable = PDFUtil.newTable( width, new float[] { 17f, 17f, 17f, 13f, 15, 13f, 11f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB05-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL01" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL02" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL03" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL04" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL05" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL06" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB05-SECT03_LCOL07" ), new Color( 255, 255, 204 ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 管理学歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_GAKRK_KNR() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 27f, 62f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB06-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT02_L0101" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "gkrek_kanrigakureki" ) ) );
		childTable.addCell( newCellBlank() );
		
		return childTable;
		
	}
	
	/**
	 * 学歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_GAKRK() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "gkrek_sotugyo_nengetu", "gkrek_gakkou", "gkrek_senko_nm", "gkrek_senko_gakka", "gkrek_shugaku_keitai", "gkrek_saishu_gakureki_kbn" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 27f, 21f, 19f, 11f, 10f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB06-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL05" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB06-SECT03_LCOL06" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
	}
	
	/**
	 * 教育研修のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_KYOIK() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "kyoik_juko_date", "kyoik_kosi_kbn", "kyoik_kyoikukenshu_nm", "kyoik_s1_nintei_ten" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 100f } );
		childTable = PDFUtil.newTable( width, new float[] { 23f, 6f, 71f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB07-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB07-SECT02_L0101" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "kyoik_s1_nintei_ten_total" ) ) );
		childTable.addCell( newCellBlank() );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		childTable = PDFUtil.newTable( width, new float[] { 16f, 9f, 55f, 20f } );
		
		childTable.addCell( newCellTH( getLabel( "TAB07-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB07-SECT03_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB07-SECT03_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB07-SECT03_LCOL04" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		
		return parentTable;
		
	}
	
	/**
	 * 公的資格のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SIKAK_KTK() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "sikak_koteki_shutoku_date", "sikak_koteki_naiyo" };
		
		childTable = PDFUtil.newTable( width, new float[] { 12f, 88f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB08-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB08-SECT02_LCOL01" ), new Color( 255, 255, 204 ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB08-SECT02_LCOL02" ), new Color( 255, 255, 204 ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 社内技能検定のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHANI_GNO() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "sikak_shanai_shutoku_date", "sikak_shanai_naiyo" };
		
		childTable = PDFUtil.newTable( width, new float[] { 12f, 88f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB08-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB08-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB08-SECT03_LCOL02" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * TOEIC最高得点のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_TOEIC() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 12f, 12f, 76f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB09-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB09-SECT02_L0101" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB09-SECT02_L0102" ) ) );
		childTable.addCell( newCellBlank() );
		
		childTable.addCell( newCellTD( getPZCValue( "eiken_toeic_juken_date" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "eiken_toeic_tensu" ) ) );
		childTable.addCell( newCellBlank() );
		
		return childTable;
		
	}
	
	/**
	 * 社内英語検定のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHANI_EIG() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "eiken_shanai_juken_date", "eiken_shanai_naiyo", "eiken_shanai_tensu" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 60f, 40f } );
		childTable = PDFUtil.newTable( width, new float[] { 20f, 49f, 31f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB09-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB09-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB09-SECT03_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB09-SECT03_LCOL03" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 保有している技能・専門分野のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_GINOU_HYU() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "ginou_hoyu_ctgr1_nm", "ginou_hoyu_ctgr2_nm", "ginou_hoyu_ctgr3_nm", "ginou_hoyu_keiken_nensu", "ginou_hoyu_level", "ginou_hoyu_geneki_kbn", "ginou_hoyu_tuyomi" };
		
		childTable = PDFUtil.newTable( width, new float[] { 3f, 14f, 14f, 14f, 15f, 27f, 8f, 5f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB10-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL05" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL06" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL07" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT02_LCOL08" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, true );
		
		return childTable;
		
	}
	
	/**
	 * 今期担当する技能・専門分野のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_GINOU_KNK() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "ginou_konki_ctgr1_nm", "ginou_konki_ctgr2_nm", "ginou_konki_ctgr3_nm", "ginou_konki_main_skill" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 56f, 44f } );
		childTable = PDFUtil.newTable( width, new float[] { 5f, 25f, 25f, 25f, 20f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB10-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT03_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT03_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT03_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT03_LCOL05" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, true );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 今後担当する技能・専門分野のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_GINOU_KNG() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "ginou_kongo_ctgr1_nm", "ginou_kongo_ctgr2_nm", "ginou_kongo_ctgr3_nm" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 45f, 55f } );
		childTable = PDFUtil.newTable( width, new float[] { 6f, 31f, 31f, 31f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB10-SECT04", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT04_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT04_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT04_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB10-SECT04_LCOL04" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, true );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 職務履歴一覧のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHOKM() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "shokm_kikan", "shokm_theme", "shokm_shozoku", "shokm_gaiyo", "shokm_member" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 21f, 21f, 33f, 13f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB11-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT02_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT02_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT02_LCOL05" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 使用ツール・環境のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_TOOL() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 15f, 75f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB11-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB11-SECT03_L0101" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shokm_tool" ) ) );
		
		return childTable;
		
	}
	
	/**
	 * キャリアプランモラールサーベイのレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_CARER() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] labelidArray = new String[] { "TAB14-SECT02_LCOL01", "TAB14-SECT02_LCOL02", "TAB14-SECT02_LCOL03", "TAB14-SECT02_LCOL04", "TAB14-SECT02_LCOL05", "TAB14-SECT02_LCOL06", "TAB14-SECT02_LCOL07", "TAB14-SECT02_LCOL08", "TAB14-SECT02_LCOL09", "TAB14-SECT02_LCOL010", "TAB14-SECT02_LCOL011" };
		String[] pzidArray = new String[] { "carer_survey_taishoki", "carer_survey_gyomu_situ", "carer_survey_gyomu_ryo", "carer_survey_ojt", "carer_survey_housin", "carer_survey_nitteikanri", "carer_survey_ikengusin", "carer_survey_siki", "carer_survey_kyoryokudo", "carer_survey_sinraikankei", "carer_survey_sogo_cmnt" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 70f, 30f } );
		childTable = PDFUtil.newTable( width, new float[] { 33f, 22f, 22f, 22f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB14-SECT02", childTable, sectionNameFont ) );
		
		this.addCellsTransLabelPZTCValue( childTable, labelidArray, pzidArray );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 表彰のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_HYOSH() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "hyosh_hyosho_date", "hyosh_naiyo" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 89f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB15-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB15-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB15-SECT02_LCOL02" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 入社前職歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHKRK_NSM() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "nsmae_kinmu_s_date", "nsmae_kinmu_e_date", "nsmae_kaisha" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 11f, 78f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB16-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB16-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB16-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB16-SECT02_LCOL03" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 休職歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHKRK_KYU() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "kyshk_s_date", "kyshk_e_date", "kyshk_naiyo" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 11f, 78f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB17-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB17-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB17-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB17-SECT02_LCOL03" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 年休のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_NENKY() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "nenky_s_date", "nenky_e_date", "nenky_fuyo_nissu", "nenky_kurikosi_nissu", "nenky_shoka_nissu" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 57f, 43f } );
		childTable = PDFUtil.newTable( width, new float[] { 19f, 19f, 20f, 20f, 20f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB18-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB18-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB18-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB18-SECT02_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB18-SECT02_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB18-SECT02_LCOL05" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 所属・役職のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHOZK() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "shozk_recent_haturei_date", "shozk_recent_kenmu", "shozk_recent_gensk_kaisha", "shozk_recent_shozoku", "shozk_recent_yakushoku", "shozk_recent_kinmuchi", "shozk_recent_kainin_date", "shozk_recent_shanai_kobo" };
		
		childTable = PDFUtil.newTable( width, new float[] { 9f, 5f, 17f, 28f, 11f, 10f, 11f, 8f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB19-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL05" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL06" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL07" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT02_LCOL08" ) ) );
		
		int maxRowSize = this.jvProfileBean.getMaxNumberTcValue( pzidArray );
		String preVal = "";
		
		// 行ループ(1開始)
		for (int rowNo = 1; rowNo <= maxRowSize; rowNo++) {
			if (!this.jvProfileBean.isExistsNumber( pzidArray, rowNo )) {
				continue;
			}
			// 列ループ
			for (int j = 0; j < pzidArray.length; j++) {
				String val = this.jvProfileBean.getTcValue( pzidArray[j], rowNo );
				val = this.getPdfViewStr( val );
				if (j == 0) {
					// [0]:発令年月日 上方と同様データの場合は空欄を表示
					val = (preVal.equals( val )) ? "" : val;
					if (!"".equals( val )) {
						// 空欄が続く場合を想定して、直前格納値に空欄を収めないようにする
						preVal = val;
					}
				}
				childTable.addCell( newCellTD( val ) );
			}
		}
		
		return childTable;
		
	}
	
	/**
	 * 所属・役職(2004年9月まで)のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHOZK_KAK() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "shozk_past_haturei_date", "shozk_past_kenmu", "shozk_past_gensk_kaisha", "shozk_past_shozoku", "shozk_past_sikaku", "shozk_past_kinmuchi", "shozk_past_kainin_date" };
		
		childTable = PDFUtil.newTable( width, new float[] { 9f, 5f, 17f, 33f, 15f, 10f, 11f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB19-SECT03", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL04" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL05" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL06" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB19-SECT03_LCOL07" ) ) );
		
		int maxRowSize = this.jvProfileBean.getMaxNumberTcValue( pzidArray );
		String preVal = "";
		
		// 行ループ(1開始)
		for (int rowNo = 1; rowNo <= maxRowSize; rowNo++) {
			if (!this.jvProfileBean.isExistsNumber( pzidArray, rowNo )) {
				continue;
			}
			// 列ループ
			for (int j = 0; j < pzidArray.length; j++) {
				String val = this.jvProfileBean.getTcValue( pzidArray[j], rowNo );
				val = this.getPdfViewStr( val );
				if (j == 0) {
					// [0]:発令年月日 上方と同様データの場合は空欄を表示
					val = (preVal.equals( val )) ? "" : val;
					if (!"".equals( val )) {
						// 空欄が続く場合を想定して、直前格納値に空欄を収めないようにする
						preVal = val;
					}
				}
				childTable.addCell( newCellTD( val ) );
			}
		}
		
		return childTable;
		
	}
	
	/**
	 * 役員歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_YAKIN() throws Exception {
		
		PdfPTable childTable;
		String[] pzidArray = new String[] { "yakin_haturei_date", "yakin_kainin_tate", "yakin_kaisha", "yakin_yakuin" };
		
		childTable = PDFUtil.newTable( width, new float[] { 11f, 11f, 37f, 40f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB20-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB20-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB20-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB20-SECT02_LCOL03" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB20-SECT02_LCOL04" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		return childTable;
		
	}
	
	/**
	 * 資格歴のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SIKAK() throws Exception {
		
		PdfPTable parentTable;
		PdfPTable childTable;
		String[] pzidArray = new String[] { "skkrk_shokaku_nendo", "skkrk_shikaku", "skkrk_shikaku_zaii_nen" };
		
		parentTable = PDFUtil.newTable( width, new float[] { 45f, 55f } );
		childTable = PDFUtil.newTable( width, new float[] { 33f, 32.5f, 33.5f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB21-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB21-SECT02_LCOL01" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB21-SECT02_LCOL02" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB21-SECT02_LCOL03" ) ) );
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	/**
	 * 職制歴(2004年4月以降)のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_SHOKS() throws Exception {
		
		PdfPTable childTable;
		
		childTable = PDFUtil.newTable( width, new float[] { 17f, 12f, 17f, 12f, 42f } );
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( "TAB22-SECT02", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0101" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shkse_3so_boss_kikan" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0103" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shoks_3so_boss_date_first" ) ) );
		childTable.addCell( newCellBlank() );
		
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0201" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shkse_4so_boss_kikan" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0203" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shoks_4so_boss_date_first" ) ) );
		childTable.addCell( newCellBlank() );
		
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0301" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shkse_5so_boss_kikan" ) ) );
		childTable.addCell( newCellTH( getLabel( "TAB22-SECT02_L0303" ) ) );
		childTable.addCell( newCellTD( getPZCValue( "shoks_5so_boss_date_first" ) ) );
		childTable.addCell( newCellBlank() );
		
		return childTable;
		
	}
	
	/**
	 * MBO-S・評価のレイアウトを構築する
	 */
	public PdfPTable makeTableLayout_MBOSH( String tabId ) throws Exception {
		
		PdfPTable parentTable = null;
		PdfPTable childTable = null;
		String[] pzidArray = null;
		
		if ("TAB23".equals( tabId )) {
			parentTable = PDFUtil.newTable( width, new float[] { 46f, 54f } );
			childTable = PDFUtil.newTable( width, new float[] { 25f, 13f, 20f, 20f, 22f } );
			pzidArray = new String[] { "mbohk_taishoki_nm", "mbohk_sikaku", "mbohk_shoyo_hyoka_nm_hon", "mbohk_shoky_hyoka_nm_hon", "mbohk_shoyo_shukkinritu" };
		} else if ("TAB24".equals( tabId )) {
			parentTable = PDFUtil.newTable( width, new float[] { 46f, 54f } );
			childTable = PDFUtil.newTable( width, new float[] { 25f, 13f, 20f, 20f, 22f } );
			pzidArray = new String[] { "mbohk_taishoki_nm", "mbohk_sikaku", "mbohk_shoyo_hyoka_nm_etc", "mbohk_shoky_hyoka_nm_etc", "mbohk_shoyo_shukkinritu" };
		} else if ("TAB25".equals( tabId )) {
			parentTable = PDFUtil.newTable( width, new float[] { 27f, 73f } );
			childTable = PDFUtil.newTable( width, new float[] { 42f, 21.5f, 36.5f } );
			pzidArray = new String[] { "mbohk_taishoki_nm", "mbohk_sikaku", "mbohk_shoyo_shukkinritu" };
		}
		
		/* セクションタイトルのセルを取得する */
		childTable.addCell( getTitleCell( tabId + "-SECT01", childTable, sectionNameFont ) );
		
		childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL01" ) ) );
		if ("TAB23".equals( tabId )) {
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL03" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL04" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL05" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL06" ) ) );
		} else if ("TAB24".equals( tabId )) {
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL04" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL05" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL06" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL07" ) ) );
		} else if ("TAB25".equals( tabId )) {
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL03" ) ) );
			childTable.addCell( newCellTH( getLabel( tabId + "-SECT02_LCOL04" ) ) );
		}
		
		this.addCellsPZTCValue( childTable, pzidArray, false );
		
		parentTable.addCell( childTable );
		parentTable.addCell( newCellBlank() );
		
		return parentTable;
		
	}
	
	 /* ---------------------------------------- Utils ---------------------------------------- */
	
	public PdfPCell newCellTH( String text ) throws Exception {
		return PDFUtil.newCellTH( text, tableHeaderFont, 1, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB );
	}
	
	public PdfPCell newCellTH( String text, int colspan ) throws Exception {
		return PDFUtil.newCellTH( text, tableHeaderFont, colspan, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB );
	}
	
	public PdfPCell newCellTH( String text, Color bgColor ) throws Exception {
		return PDFUtil.newCellTH( text, tableHeaderFont, 1, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB, bgColor );
	}
	
	public PdfPCell newCellTH( String text, int colspan, Color bgColor ) throws Exception {
		return PDFUtil.newCellTH( text, tableHeaderFont, colspan, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB, bgColor );
	}
	
	public PdfPCell newCellTD( String text ) throws Exception {
		return PDFUtil.newCellTD( text, tableDataFont, 1, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB );
	}
	
	public PdfPCell newCellTD( String text, int colspan ) throws Exception {
		return PDFUtil.newCellTD( text, tableDataFont, colspan, Rectangle.ALIGN_LEFT, PDFUtil.BORDER_TLRB );
	}
	
	public PdfPCell newCellBlank() throws Exception {
		return PDFUtil.newCellBlank( tableDataFont, 0, 0 );
	}
	
	public PdfPCell newCellBlank( int colspan ) throws Exception {
		return PDFUtil.newCellBlank( tableDataFont, colspan, 0 );
	}
	
	public PdfPCell newCellBlank( PdfPTable tableForColspan, float height ) throws Exception {
		int colspan = (tableForColspan != null) ? tableForColspan.getAbsoluteWidths().length : 0;
		return PDFUtil.newCellBlank( tableDataFont, colspan, height );
	}
	
	/**
	 * CCP_LABELテーブルからラベル文字列を取得する。
	 */
	public String getLabel( String labelId ) {
		String str;
		str = CommonLabel.getLabel( this.party, labelId, this.langNo );
		str = this.getPdfViewStr( str );
		return str;
	}
	
	/**
	 * 個人属性データ(C)を取得する。
	 */
	public String getPZCValue( String zokuseiId ) {
		String val = this.jvProfileBean.getCValue( zokuseiId );
		val = this.getPdfViewStr( val );
		return val;
	}
	
	public String getPdfViewStr( String str ) {
		str = (str == null) ? "" : str;
		str = str.replaceAll( "<br\\s?/?>", "\n" );
		str = str.replaceAll( "<BR\\s?/?>", "\n" );
		str = str.replaceAll( "</?.*?>", "" );
		return str;
	}
	
	/**
	 * 個人属性データ(TC)をテーブルに追加する。
	 */
	public void addCellsPZTCValue( PdfPTable nestTable, String[] pzidArray, boolean rowNoDisplayFlg ) throws Exception {
		
		int maxRowSize = this.jvProfileBean.getMaxNumberTcValue( pzidArray );
		
		// 行ループ(1開始)
		for (int rowNo = 1; rowNo <= maxRowSize; rowNo++) {
			if (!this.jvProfileBean.isExistsNumber( pzidArray, rowNo )) {
				continue;
			}
			// 列ループ
			for (int j = 0; j < pzidArray.length; j++) {
				if (rowNoDisplayFlg && (j == 0)) {
					nestTable.addCell( newCellTH( Integer.toString( rowNo ) ) );
				}
				String val = this.jvProfileBean.getTcValue( pzidArray[j], rowNo );
				val = this.getPdfViewStr( val );
				nestTable.addCell( newCellTD( val ) );
			}
		}
		
	}
	
	/**
	 * ラベルと個人属性データ(TC)を行列変換したものをテーブルに追加する。(データ表示部分は最高3列の前提)
	 */
	public void addCellsTransLabelPZTCValue( PdfPTable nestTable, String[] labelidArray, String[] pzidArray ) throws Exception {
		
		int maxColSize = 4;
		int colCnt;
		
		// 行ループ
		for (int rowNo = 0; rowNo < labelidArray.length; rowNo++) {
			colCnt = 0;
			// 列ループ
			for (int colNo = 0; colNo < maxColSize; colNo++) {
				if (colNo == 0) {
					nestTable.addCell( newCellTH( getLabel( labelidArray[rowNo] ) ) );
					colCnt++;
					continue;
				}
				if (!this.jvProfileBean.isExistsNumber( pzidArray, colNo )) {
					continue;
				}
				String val = this.jvProfileBean.getTcValue( pzidArray[rowNo], colNo );
				val = this.getPdfViewStr( val );
				if (rowNo == 0) {
					nestTable.addCell( newCellTH( val ) );
				} else {
					nestTable.addCell( newCellTD( val ) );
				}
				colCnt++;
			}
			if (colCnt != maxColSize) {
				nestTable.addCell( newCellBlank( maxColSize - colCnt ) );
			}
		}
		
	}
	
}