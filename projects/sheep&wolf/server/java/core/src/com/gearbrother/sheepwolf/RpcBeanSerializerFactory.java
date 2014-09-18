package com.gearbrother.sheepwolf;

import java.util.List;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.cfg.SerializerFactoryConfig;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.fasterxml.jackson.databind.ser.BeanSerializerFactory;

public class RpcBeanSerializerFactory extends BeanSerializerFactory {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected RpcBeanSerializerFactory(SerializerFactoryConfig config) {
		super(config);
	}
	
	@Override
	protected void removeIgnorableTypes(SerializationConfig config,
			BeanDescription beanDesc, List<BeanPropertyDefinition> properties) {
		// TODO Auto-generated method stub
		super.removeIgnorableTypes(config, beanDesc, properties);
	}
	
	@Override
	protected void removeSetterlessGetters(SerializationConfig config,
			BeanDescription beanDesc, List<BeanPropertyDefinition> properties) {
		// TODO Auto-generated method stub
		super.removeSetterlessGetters(config, beanDesc, properties);
	}
}
