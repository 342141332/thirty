package com.gearbrother.sheepwolf.util;

import java.util.List;

/**
 * @author feng.lee
 * @create on 2013-11-19
 */
public class GStringUtil {
	public static String lowerFirstChar(String newValue) {
		String firstChar = newValue.substring(0, 1);
		return firstChar.toLowerCase() + newValue.substring(1, newValue.length());
	}
	
	public static String upperFirstChar(String newValue) {
		String firstChar = newValue.substring(0, 1);
		return firstChar.toUpperCase() + newValue.substring(1, newValue.length());
	}
	
	static public String join(List<String> input, String delimiter, boolean noWrapEnd) {
	    StringBuilder sb = new StringBuilder();
	    for(String value : input) {
	        sb.append(value);
	        sb.append(delimiter);
	    }
	    int length = sb.length();
	    if(length > 0 && noWrapEnd) {
	        // Remove the extra delimiter
	        sb.setLength(length - delimiter.length());
	    }
	    return sb.toString();
	}
}
