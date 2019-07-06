package jp.co.hisas.career.app.talent.util;

import java.awt.Color;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;

import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectBoxtypeDto;
import jp.co.hisas.career.app.talent.dto.JvProfTabSectListtypeDto;
import jp.co.hisas.career.util.SU;

public class PDFUtil {
	
	public static final int BORDER_TLRB = Rectangle.TOP + Rectangle.LEFT + Rectangle.RIGHT + Rectangle.BOTTOM ;
	public static final int BORDER_TLR_ = Rectangle.TOP + Rectangle.LEFT + Rectangle.RIGHT                    ;
	public static final int BORDER__LR_ =                 Rectangle.LEFT + Rectangle.RIGHT                    ;
	public static final int BORDER__LRB =                 Rectangle.LEFT + Rectangle.RIGHT + Rectangle.BOTTOM ;
	
	public static PdfPCell newSectionTitle( PdfPTable table, String titleText, Font font ) throws Exception {
		return newSectionTitle( table, titleText, font, 12f );
	}
	public static PdfPCell newSectionTitle( PdfPTable table, String titleText, Font font, float paddingTop ) throws Exception {
		PdfPCell cell = newCell(titleText, font);
		cell.setColspan( table.getAbsoluteWidths().length );
		cell.setPaddingTop( paddingTop );
		cell.setPaddingBottom( 4f );
		return cell;
	}

	public static PdfPCell newSectionTitleBlackBar( String titleText, Font font, PdfPTable table ) throws Exception {
		PdfPCell cell = newCell(titleText, font);
		cell.setColspan( table.getAbsoluteWidths().length );
		cell.setPaddingTop( 1.5f );
		cell.setPaddingLeft( 6f );
		cell.setBackgroundColor( new Color( 75, 82, 82 ) );
		cell.setBorderWidthLeft( 3f );
		cell.setBorderColorLeft( new Color( 137, 54, 54 ) );
		return cell;
	}

	public static PdfPCell newCellTH( String text, Font font, int colspan, int rectangleAlign, int rectangleBorder ) throws Exception {
		return newCellTH( text, font, colspan, rectangleAlign, rectangleBorder, new Color( 235, 248, 254 ) );
	}

	public static PdfPCell newCellTH( String text, Font font, int colspan, int rectangleAlign, int rectangleBorder, Color bgColor ) throws Exception {
		PdfPCell cell;
		cell = PDFUtil.newCell(text, font, rectangleAlign );
		PDFUtil.decorateCell(cell, "th", bgColor);
		cell.setBorder( rectangleBorder );
		if ( colspan > 1 ) {
			cell.setColspan( colspan );
		}
		return cell;
	}

	public static PdfPCell newCellTD( String text, Font font, int colspan, int rectangleAlign, int rectangleBorder ) throws Exception {
		PdfPCell cell;
		cell = PDFUtil.newCell(text, font, rectangleAlign );
		PDFUtil.decorateCell(cell, "td", null);
		cell.setBorder( rectangleBorder );
		if ( colspan > 1 ) {
			cell.setColspan( colspan );
		}
		return cell;
	}

	public static PdfPCell newCellBlank( Font font, int colspan, float height ) throws Exception {
		PdfPCell cell;
		cell = newCell(" ", font);
		if (colspan > 0) {
			cell.setColspan( colspan );
		}
		if (height > 0) {
			cell.setMinimumHeight( height );
		} else {
			cell.setMinimumHeight( 13f );
		}
		return cell;
	}

// #OLYM_031W DEL START
//	public static void decorateCell( PdfPCell cell, String cellType ) {
//		// ヘッダセル
//		if ( "th".equals(cellType) ) {
//			// 背景色：グリーン
//			cell.setBackgroundColor( new Color( 212, 234, 236 ) );
//			// 枠線：上下左右・グレー
//			cell.setBorder( Rectangle.BOX );
//			cell.setBorderColor( new Color( 187, 187, 187 ) );
//			// Padding
//			//cell.setPaddingTop(1.5f);
//			cell.setPaddingLeft(2f);
//			cell.setPaddingBottom(3.5f);
//			// 行間 (固定幅, 倍率) : 固定幅＋倍率×フォントサイズ
//			cell.setLeading(0f, 1.2f);
//		}
//		else if ( "td".equals(cellType) ) {
//			// 背景色：なし
//			;
//			// 枠線：上下左右・グレー
//			cell.setBorder( Rectangle.BOX );
//			cell.setBorderColor( new Color( 187, 187, 187 ) );
//			// Padding
//			//cell.setPaddingTop(1.5f);
//			cell.setPaddingLeft(2f);
//			cell.setPaddingBottom(3.5f);
//			// 行間 (固定幅, 倍率) : 固定幅＋倍率×フォントサイズ
//			cell.setLeading(0f, 1.2f);
//		}
//	}
// #OLYM_031W DEL END
// #OLYM_031W ADD START
	public static void decorateCell( PdfPCell cell, String cellType, Color rgb ) {
		// ヘッダセル
		if ( "th".equals(cellType) ) {
			// 背景色：グリーン
			cell.setBackgroundColor( rgb );
			// 枠線：上下左右・グレー
			cell.setBorder( Rectangle.BOX );
			cell.setBorderColor( new Color( 187, 187, 187 ) );
			// Padding
			//cell.setPaddingTop(1.5f);
			cell.setPaddingLeft(2f);
			cell.setPaddingBottom(3.5f);
			// 行間 (固定幅, 倍率) : 固定幅＋倍率×フォントサイズ
			cell.setLeading(0f, 1.2f);
		}
		else if ( "td".equals(cellType) ) {
			// 背景色：なし
			;
			// 枠線：上下左右・グレー
			cell.setBorder( Rectangle.BOX );
			cell.setBorderColor( new Color( 187, 187, 187 ) );
			// Padding
			//cell.setPaddingTop(1.5f);
			cell.setPaddingLeft(2f);
			cell.setPaddingBottom(3.5f);
			// 行間 (固定幅, 倍率) : 固定幅＋倍率×フォントサイズ
			cell.setLeading(0f, 1.2f);
		}
	}
// #OLYM_031W ADD END

	/**
	 * テーブル項目を初期化する
	 * 
	 * @param widthPercentage 横幅
	 * @param widths カラム毎の横幅
	 * @return 新規テーブル項目
	 * @throws Exception 予期せぬエラーが発生。
	 */
	public static PdfPTable newTable( float widthPercentage, float[] widths ) throws Exception {
		PdfPTable table = new PdfPTable( widths.length );
		table.setHorizontalAlignment( Rectangle.ALIGN_CENTER );
		table.getDefaultCell().setBorder( Rectangle.NO_BORDER );
		table.getDefaultCell().setPadding( 0f ); // 敷き詰めるために重要
		table.setWidthPercentage( widthPercentage );
		table.setWidths( widths );
		return table;
	}

	/**
	 * セルを生成する。
	 * 
	 * @param str 文字列
	 * @param font フォント
	 * @return 新規セル項目
	 * @throws Exception 予期せぬエラーが発生。
	 */
	public static PdfPCell newCell( String str, Font font ) throws Exception {
		return newCell( str, font, Rectangle.ALIGN_LEFT );
	}
//// #OLYM_031W DEL START
//	public static PdfPCell newCell( String str, Font font, int rectangleAlign ) throws Exception {
//		PdfPCell cell = new PdfPCell( new Paragraph( str, font ) );
//		cell.setHorizontalAlignment( rectangleAlign );
//		cell.setBorder( Rectangle.NO_BORDER );
//		cell.setMinimumHeight( 13f );
//		cell.setPadding( 0.2f );
//		return cell;
//	}
//// #OLYM_031W DEL START
// #OLYM_031W ADD START
	public static PdfPCell newCell( String str, Font font, int rectangleAlign ) throws Exception {
		return newCell( str, font, rectangleAlign, 1);
	}

		public static PdfPCell newCell( String str, Font font, int rectangleAlign, int colspan ) throws Exception {
			PdfPCell cell = new PdfPCell( new Paragraph( str, font ) );
			cell.setHorizontalAlignment( rectangleAlign );
			cell.setBorder( Rectangle.NO_BORDER );
			cell.setMinimumHeight( 13f );
			cell.setPadding( 0.2f );
			if ( colspan > 1 ) {
				cell.setColspan( colspan );
			}
			return cell;
		}
// #OLYM_031W ADD END

	/**
	 * Image型に変換可能かどうかを調べる。
	 * 
	 * @param picturebean 顔写真
	 * @return true:変換可能、false:変換不可能
	 * @throws Exception 予期せぬエラーが発生。
	 */
	public static boolean isImageFile( PersonalPictureBean picturebean ) throws Exception {
		// 顔写真のレコードが存在しない、または顔写真が存在しない
		if ( picturebean == null || picturebean.getPicture() == null || picturebean.getPicture().length == 0 ) {
			return false;
		}
		try {
			// Image型に変換できるかチェック
			@SuppressWarnings("unused")
			Image kaoShashin = Image.getInstance( picturebean.getPicture() );
		} catch ( IOException ioe ) {
			return false;
		}
		return true;
	}

	/**
	 * Boxタイプリストを渡してカラム数を算出し幅を均等に割ったfloat配列を返す。
	 */
	public static float[] getColsInfoBoxtype( List<JvProfTabSectBoxtypeDto> boxtypeList ) {
		int colCnt = 1;
		Map<Integer, Integer> wMap = new HashMap<Integer, Integer>();
		for (JvProfTabSectBoxtypeDto dto : boxtypeList) {
			if (colCnt < dto.getColNo()) {
				colCnt = dto.getColNo();
			}
			if (SU.matches( dto.getWidth(), "^[0-9]?[0-9]%$" )) {
				int percent = SU.toInt( SU.extract( dto.getWidth(), "^([0-9]?[0-9])%$" ), 0 );
				wMap.put( dto.getColNo(), percent );
			}
		}
		return getWidthFloats( colCnt, wMap );
	}
	
	/**
	 * Listタイプリストを渡してカラム数を算出し幅を均等に割ったfloat配列を返す。
	 */
	public static float[] getColsInfoListtype( List<JvProfTabSectListtypeDto> listtypeList ) {
		int colCnt = 1;
		Map<Integer, Integer> wMap = new HashMap<Integer, Integer>();
		for (JvProfTabSectListtypeDto dto : listtypeList) {
			if (colCnt < dto.getColNo()) {
				colCnt = dto.getColNo();
			}
			if (SU.matches( dto.getWidth(), "^[0-9]?[0-9]%$" )) {
				int percent = SU.toInt( SU.extract( dto.getWidth(), "^([0-9]?[0-9])%$" ), 0 );
				wMap.put( dto.getColNo(), percent );
			}
		}
		return getWidthFloats( colCnt, wMap );
	}
	
	public static float[] getWidthFloats( int colCnt, Map<Integer, Integer> wMap ) {
		float[] results = new float[colCnt];
		float all = 100;
		for (int w : wMap.values()) {
			all = all - w;
		}
		float f = all / (colCnt - wMap.size()); // 幅指定なしは均等割り
		for (int i = 0; i < colCnt; i++) {
			if (wMap.get( i + 1 ) != null) {
				results[i] = wMap.get( i + 1 );
			} else {
				results[i] = f;
			}
		}
		return results;
	}

}
