package com.gearbrother.mushroomWar.rpc.error;

/**
 * @author feng.lee
 * @create on 2013-11-27
 */
public class RpcException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public int code;
	
	public Object[] argus;
	
	public String message;
	
	public RpcException() {
	}
	
	public RpcException(String message) {
		this.message = message;
	}
	
	public RpcException(int code, Object[] argus) {
		this.code = code;
		this.argus = argus;
	}
	
	@Override
	public String toString() {
		if (message != null) {
			return message;
		} else {
			return super.toString();
		}
	}
}
