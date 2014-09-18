package com.gearbrother.mushroomWar.test;

import java.nio.Buffer;
import java.nio.ByteBuffer;

import com.fasterxml.jackson.core.JsonProcessingException;

public class JacksonJsonTest {
	public static void main(String[] args) throws JsonProcessingException {
		ByteBuffer buffer = ByteBuffer.allocate(10);
		for (int i = 0; i < 10; i++) {
			byte b = 3;
			buffer.put(b);
		}
		output("init", buffer);
		
		buffer.position(4);
		buffer.limit(9);
		buffer.flip();
		output("flip", buffer);

		/*Constant.mapper.enable(SerializationFeature.INDENT_OUTPUT);
		Bean b = new Bean();
		for (int i = 0; i < 100; i++) {
			ArrayList<Integer> element = new ArrayList<Integer>();
			element.add(1);
			element.add(2);
			element.add(3);
			element.add(4);
			element.add(5);
		}
		System.out.println(Constant.mapper.writeValueAsString(b));*/
	}

	public static void output(String step, ByteBuffer buffer) {
		System.out.print(step + " - ");
		System.out.print("position: " + buffer.position() + ", ");
		System.out.print("limit: " + buffer.limit() + ", ");
		System.out.print("capacity: " + buffer.capacity() + ", ");
		System.out.print("code: ");
		for (int i = 0; i < buffer.capacity(); i++) {
			System.out.print(buffer.get(i));
		}
		System.out.println();
	}
}
