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
@Target(value = {ElementType.FIELD, ElementType.METHOD})
public @interface RpcBeanProperty {
	String name() default "";

	String desc();
}
