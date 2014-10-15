package com.gearbrother.mushroomWar.rpc.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author feng.lee
 * @create on 2013-11-8
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(value = {ElementType.TYPE})
public @interface RpcBeanPartTransportable {
	String name() default "";

	String desc() default "";
	
	boolean isPartTransport() default false;
}
