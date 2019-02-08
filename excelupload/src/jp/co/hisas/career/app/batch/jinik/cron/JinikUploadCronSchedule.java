package jp.co.hisas.career.app.batch.jinik.cron;

import static org.quartz.CronScheduleBuilder.*;
import static org.quartz.JobBuilder.*;
import static org.quartz.TriggerBuilder.*;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

import jp.co.hisas.career.app.batch.jinik.cron.util.PropertyUtil;
import jp.co.hisas.career.app.batch.jinik.excelupload.JinikExcelFileUpdateBatch;

public class JinikUploadCronSchedule {
	
	public static void main( String[] args ) {

		String expression = PropertyUtil.getProperty( "org.quartz.cronExpression.JinikUploadTrigger", "" );
		
		JobDetail job = newJob( JinikExcelFileUpdateBatch.class ).withIdentity( "JinikUploadJob","group1" ).build();
		
		CronTrigger trigger = newTrigger().withIdentity( "JinikUploadTrigger", "group1" ).withSchedule( cronSchedule( expression )).build();

		Scheduler schedule = null;
		
		try {
			SchedulerFactory factory = new StdSchedulerFactory();
			schedule = factory.getScheduler();
			Date ft = schedule.scheduleJob( job, trigger );
			
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy年MM月dd日 E曜日 HH時mm分ss秒");
			System.out.println( job.getKey() + " は次の時間に起動します。 >> " + fmt.format( ft ) + " 、そして次のスケジュールで繰り返されます。 " + trigger.getCronExpression() );
			
			schedule.start();
		} catch( SchedulerException e ) {
			try {
				schedule.shutdown();
			} catch ( SchedulerException se ) {
				
			}
		}
	}
}
