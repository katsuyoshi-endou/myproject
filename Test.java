package test;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Test {
	
	/**
	 * @param args
	 */
	public static void main( String[] args ) {
		subFunction2();
	}
	
	public static void subFunction1() {
		
		String tagA = "[[";
		String tagB = "]]";
		String tagA2 = tagA.replace(tagA, "(");
		String tagB2 = tagB.replace(tagB, ")");

//		String regex = "\\[[.+?\\]]";
//		String regex = "\\(\\[\\[.+?\\]\\]\\)";
		String regex = "\\(" + tagA2 + ".+?" + tagB2 + "\\)";

		String target = "[[http://www.google.co.jp]]".replace(tagA, tagA2).replace(tagB, tagB2);
//		String target = "[[aaaa]]";
//		String target = "[[[[aaaa]]]]".replace(tagA, tagA2).replace(tagB, tagB2);
//		String target = "[[[[aaaa]]]]".replaceFirst(tagA, tagA2).replaceAll("]]$", tagB2);
//		String target = "[[[[aaaa]]]]".replaceFirst("\\[\\[", "(").replaceAll( "\\]\\]$", ")" );

		ArrayList<String> answer = new ArrayList<String>();

		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher("[[[[aaaa]]]]");

		while (matcher.find()) {
			answer.add(matcher.group(1));
		}

		for(String a : answer){

			if(a.length() == 0){
				System.out.println("見えない文字が囲まれています");
			}else{
				System.out.println(a.replace("<", "").replace(">", ""));
			}
		}
	}

	public static void subFunction2() {
		String target = "あいうえお[[http://www.google.co.jp]]かきくけこ[[[[[http://www.yahoo.co.jp]]]]さしすせそ";
//		String target = "あいうえお[[http://www.google.co.jp]]かきくけこ[[http://www.yahoo.co.jp]]";
//		String target = "[[[[[http://www.yahoo.co.jp]]]]]";

		int index = 0;
		String url = "";
		String notUrl = "";
		boolean found = false;
		while( index < target.length()) {
			if( found ) {
				if( target.charAt( index ) == ']' && target.charAt( index + 1 ) == ']' ) {
					index += 2;
					found = !found;
					notUrl += convURLToAnchor( url );
					url = "";
					continue;
				} else if (( target.charAt( index ) == '['  && target.charAt( index + 1 ) == '[' ) || ( target.charAt( index ) == '['  && target.charAt( index - 1 ) == '[' )) {
					index += 1;
					continue;
				} else {
					url += target.charAt( index );
				}
				
			} else {
				if( target.charAt( index ) == '['  && target.charAt( index + 1 ) == '[' ) {
					index += 2;
					found = !found;
					continue;
				} else {
					notUrl += target.charAt( index );
				}
			}
			index++;
		}
		
		System.out.println( "URL : " + url );
		System.out.println( "NO URL : " + notUrl );
	}

	private static String convURLToAnchor( String url ) {
		
		String format = "<a target=\"_blank\" href=\"{0}\">{0}</a>";

		return format.replace( "{0}", url );
	}
}
