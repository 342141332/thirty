package com.gearbrother.sheepwolf.rpc.ioHandler.codec;

import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.NopAnnotationIntrospector;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;

/**
 * @author feng.lee
 * @create on 2014-6-25
 */
public class RpcAnnotationIntrospector extends NopAnnotationIntrospector {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public RpcAnnotationIntrospector() {
		super();
	}
	
	@Override
	public boolean hasIgnoreMarker(AnnotatedMember m) {
		return m.getAnnotation(RpcBeanProperty.class) == null;
	}
}