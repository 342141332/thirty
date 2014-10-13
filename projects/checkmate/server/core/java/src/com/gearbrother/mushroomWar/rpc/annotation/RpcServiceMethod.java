package com.gearbrother.mushroomWar.rpc.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author feng.lee
 * @create on 2013-10-29
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface RpcServiceMethod  {
	String name() default "";
	
	String desc();
}
