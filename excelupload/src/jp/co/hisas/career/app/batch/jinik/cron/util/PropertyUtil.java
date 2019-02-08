package jp.co.hisas.career.app.batch.jinik.cron.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class PropertyUtil {
	
	private static final String INIT_FILE_PATH = "properties/quartz.properties";
	
	private static final Properties properties;
	
	private PropertyUtil() throws Exception {
		
	}

	static {
		properties = new Properties();
		
		try {

			properties.load( Files.newBufferedReader( Paths.get( INIT_FILE_PATH ), StandardCharsets.UTF_8 ));

		} catch( IOException e ) {
			
		}
	}

	public static String getProperty( final String key ) {

		return getProperty( key, "" );
	}

	public static String getProperty( final String key, final String defaultValue ) {

		return properties.getProperty( key, defaultValue );
	}
}
