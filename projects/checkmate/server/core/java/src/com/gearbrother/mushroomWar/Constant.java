package com.gearbrother.mushroomWar;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Constant {
	public static final ObjectMapper mapper = new ObjectMapper();
	
	public static void main(String[] args) throws JsonProcessingException {
		ObjectMapper m = new ObjectMapper();
		m.setSerializerFactory(new RpcBeanSerializerFactory(null));
	}
}
