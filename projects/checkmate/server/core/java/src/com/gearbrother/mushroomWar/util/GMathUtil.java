package com.gearbrother.mushroomWar.util;

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

	static public long roundDownToMultiple(long value, long factor) {
		long a = Math.abs(value) % factor;
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

	static public long roundUpToMultiple(long value, long factor) {
		long a = Math.abs(value) % factor;
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
	
	static public double random(double max) {
		return random(max, 0);
	}
	
	static public double random(double max, double min) {
		return Math.random() * (max - min) + min;
	}
	
	static public int random(int max) {
		return random(max, 0);
	}

	static public int random(int a, int b) {
		//TODO 溢出
		return (int) (Math.random() * (a - b + 1) + b);
	}
	
	static public long random(long max) {
		return random(max, 0L);
	}

	static public long random(long max, long min) {
		return (long) (((max - min + 1) + min) * Math.random());
	}
	
	static public int distance(int x1, int y1, int x2, int y2) {
		return (int) Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(x2 - y2, 2));
	}

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