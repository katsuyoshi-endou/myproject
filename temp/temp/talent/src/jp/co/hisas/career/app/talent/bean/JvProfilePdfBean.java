package jp.co.hisas.career.app.talent.bean;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfWriter;

import jp.co.hisas.career.app.talent.dto.extra.JvProfTabSectionLayoutDto;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.app.talent.util.PDFUtil;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.log.Log;

public class JvProfilePdfBean {
	
	public String loginNo;
	
	private Document document;
	
	private ByteArrayOutputStream	baos;
	
	/** BaseFont */
	public BaseFont bf;
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
	
	/** 顔写真データがない場合のダミー画像ファイルパス */
	public String DUMMY_IMAGE_PATH	= "";
	
	/** 出力対象 会社コード */
	public String tgtCmpaCd;
	/** 出力対象 社員番号 */
	public String tgtStfNo;
	/** 出力対象 社員データ */
	public JvProfileBean jvProfileBean;
	/** 出力対象 セクションID */
	public List<String> tgtSectionIdList;
	/** PARTY */
	public String party;
	/** 言語No */
	public int langNo;
	
	public JvProfilePdfBean(String login_no, ServletContext ctx) throws ClassCastException, NamingException, Exception {
		this.initPDFData( login_no, ctx );
	}
	
	public void initPDFData( final String login_no, ServletContext ctx ) throws NamingException, ClassCastException, Exception {
		try {
			// メソッドトレース開始
			Log.method( login_no, "IN", "" );
			
			this.loginNo = login_no;
			this.document = new Document( PageSize.A4, 36, 36, 14, 14 );
			this.baos = new ByteArrayOutputStream();
			
			// フォントの定義
			bf = BaseFont.createFont( "HeiseiKakuGo-W5", "UniJIS-UCS2-H", false ); // ゴシック
			
			titleFont = new Font( bf, 15, Font.BOLD );
			sectionNameFont = new Font( bf, 7, Font.BOLD );
			commentFont = new Font( bf, 7 );
			tableHeaderFont = new Font( bf, 7, Font.BOLD );
			tableDataFont = new Font( bf, 7 );
			
			width = 100f;
			
			// 顔写真データがない場合のダミー画像ファイルパス
			this.DUMMY_IMAGE_PATH = ctx.getRealPath( "/assets/img/photo/dummy.gif" );
			
			// メソッドトレース終了
			Log.method( login_no, "OUT", "" );
			
		} catch (final ClassCastException cce) {
			Log.error( login_no, cce );
			throw cce;
		} catch (final Exception e) {
			Log.error( login_no, e );
			throw e;
		}
	}
	
	public void openPdfDocument() throws DocumentException, IOException {
		
		this.document.setMargins( 18, 18, 10, 18 );
		
		PdfWriter writer;
		writer = PdfWriter.getInstance( this.document, this.baos );
		
		this.document.open();
		
		PdfContentByte cb = writer.getDirectContent();
		cb.saveState();
	}
	
	public byte[] closePdfDocument() {
		this.document.close();
		return this.baos.toByteArray();
	}
	
	 /* ---------------------------------------- 対象セクション ---------------------------------------- */
	
	public void addPdfDocument() throws Exception {
		
		/**
		 * マスタ設定により、セクションの表示モードがONの場合はセクション内の項目の表示モードが全てONになる為、
		 * 項目フィルタを使用したラベルの表示コントロールは考慮しません。
		 */
		
		JvProfilePdfMakeBean pdfMakeBean = new JvProfilePdfMakeBean( titleFont, sectionNameFont, commentFont, tableHeaderFont, tableDataFont, width, newPersonalPhotoImage(), jvProfileBean, party, langNo);
		
		this.document.add( pdfMakeBean.makeTableLayout_TITLE() );
		
		if (jvProfileBean.jvTabLayoutMap.containsKey( "COMMON-BOX" )) {
			List<JvProfTabSectionLayoutDto> commonBox = jvProfileBean.jvTabLayoutMap.get( "COMMON-BOX" );
			this.document.add( pdfMakeBean.makeTableLayout_KYOTU( commonBox ) );
		}
		
		for (String tabId : jvProfileBean.jvTabLayoutMap.keySet()) {
			if (SU.equals( "COMMON-BOX", tabId )) {
				continue;
			}
			List<JvProfTabSectionLayoutDto> layoutList = jvProfileBean.jvTabLayoutMap.get( tabId );
			this.document.add( pdfMakeBean.makeTableLayout_AUTO( layoutList, tgtSectionIdList ) );
		}
	}

	public Image newPersonalPhotoImage() throws Exception {
		
		Image kaoShashin;
		
		PersonalPictureBean picturebean = getJvPictureBean();
		
		// 写真があれば出力する。
		if (PDFUtil.isImageFile( picturebean )) {
			// 出力形式の設定
			kaoShashin = Image.getInstance( picturebean.getPicture() );
		} else {
			final ByteArrayOutputStream baosImg = new ByteArrayOutputStream();
			
			// ファイル読み込み用バッファ
			final byte[] buffer = new byte[4096];
			
			final FileInputStream fin = new FileInputStream( this.DUMMY_IMAGE_PATH );
			int size;
			
			while ((size = fin.read( buffer )) != -1) {
				baosImg.write( buffer, 0, size );
			}
			fin.close();
			baosImg.close();
			
			kaoShashin = Image.getInstance( baosImg.toByteArray() );
		}
		return kaoShashin;
	}
	
	private PersonalPictureBean getJvPictureBean() throws CareerException {
		ProfileGarage ggPr = new ProfileGarage( this.loginNo );
		return ggPr.getProfileAvatar( this.tgtCmpaCd, this.tgtStfNo );
	}
	
}
