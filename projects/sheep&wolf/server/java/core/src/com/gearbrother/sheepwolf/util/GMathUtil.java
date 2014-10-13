package com.gearbrother.sheepwolf.util;

import java.util.List;

/**
 * @author feng.lee
 * @create on 2014-5-23
 */
public class GMathUtil {

	/**
	 * Returns the largest integer smaller or equal to the specified one which
	 * is a multiple of the specified factor.
	 */
	static public double roundDownToMultiple(double value, double factor) {
		double a = Math.abs(value) % factor;
		if (a == 0)
			return value;
		else if (value >= 0)
			return value - a;
		else
			return value - (factor - a);
	}

	/**
	 * Returns the smallest integer larger or equal to the specified one, which
	 * is a multiple of the specified factor.
	 */
	static public double roundUpToMultiple(double value, double factor) {
		double a = Math.abs(value) % factor;
		if (a == 0)
			return value;
		else if (value >= 0)
			return value + (factor - a);
		else
			return value + a;
	}

	static public Object random(Object[] array) {
		return array[random(array.length - 1)];
	}
	
	static public Object random(List<?> list) {
		return list.get(random(list.size() - 1));
	}

	static public int random(int max) {
		return random(max, 0);
	}
	
	static public double random(double max) {
		return random(max, 0);
	}

	static public int random(int max, int min) {
		return (int) (Math.random() * (max - min + 1) + min);
	}
	
	static public double random(double max, double min) {
		return Math.random() * (max - min) + min;
	}
//
//	static public Object[] random(Object[] list, int num) {
//		return list;
//	}
//
//	static public List<?> random(List<?> list, int num) {
//		return null;
//	}
//	
//	public static void main(String[] args) {
//		for (int i = 0; i < 10000; i++) {
//			System.out.println(random(1));
//		}
//	}
}