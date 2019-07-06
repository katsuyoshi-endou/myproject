package jp.co.hisas.career.app.talent.event;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import jp.co.hisas.career.app.talent.bean.PersonalPictureBean;
import jp.co.hisas.career.app.talent.garage.ProfileGarage;
import jp.co.hisas.career.ejb.AbstractEventHandler;
import jp.co.hisas.career.ejb.PYF_BlobDBAccessEJB;
import jp.co.hisas.career.ejb.PYF_BlobDBAccessEJBHome;
import jp.co.hisas.career.framework.EJBHomeFactory;
import jp.co.hisas.career.framework.exception.CareerException;
import jp.co.hisas.career.util.SU;
import jp.co.hisas.career.util.common.PZZ040_SQLUtility;
import jp.co.hisas.career.util.dto.CaRegistDto;
import jp.co.hisas.career.util.log.Log;

public class LegacyEvHdlr extends AbstractEventHandler<LegacyEvArg, LegacyEvRslt> {
	
	public static LegacyEvRslt exec( LegacyEvArg arg ) throws CareerException {
		LegacyEvHdlr handler = new LegacyEvHdlr();
		return handler.call( arg );
	}
	
	public LegacyEvRslt call( LegacyEvArg arg ) throws CareerException {
		return this.callEjb( arg );
	}
	
	protected LegacyEvRslt execute( LegacyEvArg arg ) throws CareerException {
		Log.method( arg.getLoginNo(), "IN", "" );
		arg.validateArg();
		String daoLoginNo = arg.getLoginNo();
		LegacyEvRslt result = new LegacyEvRslt();
		try {
			
			if (SU.equals( "getPersonalPicture", arg.sharp )) {
				if (SU.isNotBlank( arg.tgtGuid )) {
					result.picturebean = getPersonalPicture( daoLoginNo, arg.tgtGuid );
				}
				else if (SU.isNotBlank( arg.tgtCmpaCd + arg.tgtStfNo )) {
					ProfileGarage ggPr = new ProfileGarage( daoLoginNo );
					CaRegistDto registDto = ggPr.getByCmpaStf( arg.tgtCmpaCd, arg.tgtStfNo );
					String tgtGuid = registDto == null ? null : registDto.getGuid();
					result.picturebean = getPersonalPicture( daoLoginNo, tgtGuid );
				}
			}
			
			return result;
		} catch (Exception e) {
			throw new CareerException( e.getMessage() );
		} finally {
			Log.method( arg.getLoginNo(), "OUT", "" );
		}
	}
	
	public PersonalPictureBean getPersonalPicture( final String daoLoginNo, final String tgtGuid ) throws SQLException, NamingException, Exception {
		Connection dbConn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			dbConn = PZZ040_SQLUtility.getConnection( daoLoginNo );
			PersonalPictureBean picturebean = new PersonalPictureBean( daoLoginNo );
			
			/* 写真情報を取得する */
			String sql = "SELECT KAO_SYASIN_FILENAME, KAO_SYASIN_CONTENT_TYPE, KOKAI_FLG FROM JV_PROF_PHOTO WHERE SIMEI_NO = ?";
			pstmt = dbConn.prepareStatement( sql );
			pstmt.setString( 1, tgtGuid );
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				
				/* 写真情報を格納する */
				picturebean.setName( rs.getString( "KAO_SYASIN_FILENAME" ) );
				picturebean.setContent_type( rs.getString( "KAO_SYASIN_CONTENT_TYPE" ) );
				picturebean.setKokaiFlg( rs.getString( "KOKAI_FLG" ) );
				
				/* 写真を取得する */
				// EJBHomeの取得
				final EJBHomeFactory fact = EJBHomeFactory.getInstance();
				final PYF_BlobDBAccessEJBHome blob_home = (PYF_BlobDBAccessEJBHome)fact.lookup( PYF_BlobDBAccessEJBHome.class );
				
				final PYF_BlobDBAccessEJB blob_userSession = blob_home.create();
				
				final String[] T32_P_COLUMN = { "SIMEI_NO" };
				final String[] t32_p_value = { tgtGuid };
				
				final byte[] kao_syasin = blob_userSession.SelectBLOB( daoLoginNo, "JV_PROF_PHOTO", "KAO_SYASIN", T32_P_COLUMN, t32_p_value );
				
				/* 写真を格納する */
				picturebean.setPicture( kao_syasin );
				
			} else {
				/* 写真情報がなかった場合 */
				picturebean = new PersonalPictureBean( daoLoginNo );
			}
			
			Log.method( daoLoginNo, "OUT", "" );
			
			return picturebean;
		} catch (final SQLException e) {
			Log.error( daoLoginNo, e );
			throw e;
		} catch (final NamingException ne) {
			Log.error( daoLoginNo, ne );
			throw ne;
		} catch (final Exception e) {
			Log.error( daoLoginNo, e );
			throw e;
		} finally {
			PZZ040_SQLUtility.closeConnection( daoLoginNo, dbConn, pstmt, rs );
		}
	}
	
}
