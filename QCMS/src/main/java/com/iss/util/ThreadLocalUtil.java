package com.iss.util;

public class ThreadLocalUtil {
	private static final ThreadLocal<Object> threadInfo=new ThreadLocal<>();
	
	public static void setValue(Object obj){
		threadInfo.set(obj);
	}
	
	public static Object getValue(boolean isremove){
		Object obj= threadInfo.get();
		threadInfo.remove();
		return obj;
	}
	
	public static void removeValue(){
		threadInfo.remove();
	}

}
