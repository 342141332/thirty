package com.gearbrother.sheepwolf.rpc.codeGenerater;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanPartTransportable;
import com.gearbrother.sheepwolf.rpc.annotation.RpcBeanProperty;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethod;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethodParameter;
import com.gearbrother.sheepwolf.util.GStringUtil;

/**
 * [JSONRPC]
 * 		Convert JavaService to as3Service
 * 		Convert JavaBean to AS3Bean
 * 
 * 
 * @author feng.lee
 * @create on 2013-10-29
 */
public class GenerateRpcClientCode {
	static Logger logger = LoggerFactory.getLogger(GenerateRpcClientCode.class);
	
	static public final String SCAN_MODEL_PACKAGE = "com.gearbrother.sheepwolf.pojo";
	
	static public final String FILE_NAME_EXTENSION = "Protocol";

	/**
	 * Scans all classes accessible from the context class loader which belong to the given package and subpackages.
	 *
	 * @param packageName The base package
	 * @return The classes
	 * @throws ClassNotFoundException
	 * @throws IOException
	 */
	public static List<Class<?>> getClasses(String packageName) throws ClassNotFoundException, IOException {
	    ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
	    assert classLoader != null;
	    String path = packageName.replace('.', '/');
	    Enumeration<URL> resources = classLoader.getResources(path);
	    List<File> dirs = new ArrayList<File>();
	    while (resources.hasMoreElements()) {
	        URL resource = resources.nextElement();
	        dirs.add(new File(resource.getFile()));
	    }
	    ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
	    for (File directory : dirs) {
	        classes.addAll(findClasses(directory, packageName));
	    }
	    return classes;
	}

	/**
	 * Recursive method used to find all classes in a given directory and subdirs.
	 *
	 * @param directory   The base directory
	 * @param packageName The package name for classes found inside the base directory
	 * @return The classes
	 * @throws ClassNotFoundException
	 */
	private static List<Class<?>> findClasses(File directory, String packageName) throws ClassNotFoundException {
	    List<Class<?>> classes = new ArrayList<Class<?>>();
	    if (!directory.exists()) {
	        return classes;
	    }
	    File[] files = directory.listFiles();
	    for (File file : files) {
	        if (file.isDirectory()) {
	            assert !file.getName().contains(".");
	            classes.addAll(findClasses(file, packageName + "." + file.getName()));
	        } else if (file.getName().endsWith(".class")) {
	            classes.add(Class.forName(packageName + '.' + file.getName().substring(0, file.getName().length() - 6)));
	        }
	    }
	    return classes;
	}
	
	static public List<Class<?>> getCustomClasses() throws ClassNotFoundException, IOException {
		return getClasses(SCAN_MODEL_PACKAGE);
	}

	public static void emptyFolder(File file) throws IOException {
		if (file.isDirectory()) {
			// directory is empty, then delete it
			if (file.list().length == 0) {
			} else {
				// list all the directory contents
				String files[] = file.list();
				for (String temp : files) {
					// construct the file structure
					File fileDelete = new File(file, temp);
					// recursive delete
					emptyFolder(fileDelete);
				}
			}
		} else {
			// if file, then delete it
			file.delete();
		}
		System.out.println("Directory is deleted : " + file.getAbsolutePath());
	}

	public static void main(String[] args) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException, ClassNotFoundException, IOException, IntrospectionException, NoSuchFieldException {
		//generate AS3 service code
		List<Class<?>> allClasses = getClasses(SCAN_MODEL_PACKAGE);
		for (Iterator<?> iterator = allClasses.iterator(); iterator.hasNext();) {
			Class<?> class1 = (Class<?>) iterator.next();
			if (class1.getAnnotation(RpcBeanPartTransportable.class) == null)
				iterator.remove();
		}
		List<Class<?>> classes = getClasses("com.gearbrother.sheepwolf.rpc.service.bussiness");
		File as3ServiceFolder;
		if ("Windows 7".equals(System.getProperties().get("os.name")))
			as3ServiceFolder = new File("D:\\neo\\work\\client\\workspace\\com.gearbrother.sheep&wolf.client.flash.core\\src\\com\\gearbrother\\sheepwolf\\rpc\\service\\bussiness\\");
		else
			as3ServiceFolder = new File("/Users/lifeng/workspace/gearbrother2/com.gearbrother.sheep&wolf.client.flash.core/src/com/gearbrother/sheepwolf/rpc/service/bussiness/");
		emptyFolder(as3ServiceFolder);
		for (int k = 0; k < classes.size(); k++) {
			Class<?> serviceClazz = classes.get(k);
			RpcBeanTemplate as3ServiceClass = new RpcBeanTemplate(serviceClazz);
			FileOutputStream s = new FileOutputStream(new File(as3ServiceFolder, serviceClazz.getSimpleName() + ".as"));
			as3ServiceClass.writeActionScript3RpcService(s);
			s.close();
		}

		//generate AS3 RpcProtocols
		classes = getClasses("com.gearbrother.sheepwolf.pojo");
		File as3ProtocolFolder;
		if ("Windows 7".equals(System.getProperties().get("os.name")))
			as3ProtocolFolder = new File("D:\\neo\\work\\client\\workspace\\com.gearbrother.sheep&wolf.client.flash.core\\src\\com\\gearbrother\\sheepwolf\\rpc\\protocol\\bussiness\\");
		else
			as3ProtocolFolder = new File("/Users/lifeng/workspace/gearbrother2/com.gearbrother.sheep&wolf.client.flash.core/src/com/gearbrother/sheepwolf/rpc/protocol/bussiness");
		emptyFolder(as3ProtocolFolder);
		FileOutputStream s2 = new FileOutputStream(new File(as3ProtocolFolder, "Protocol.as"));
		List<String> cases = new ArrayList<String>();
		List<String> clazzConstants = new ArrayList<String>();
		for (int i = 0; i < classes.size(); i++) {
			Class<?> clazz = classes.get(i);
			if (clazz.getAnnotation(RpcBeanPartTransportable.class) != null) {
				String constant = clazz.getSimpleName();
				cases.add(
						"			protocols[" + constant +  "] = " + classes.get(i).getSimpleName() + FILE_NAME_EXTENSION + ";\n"); 
				clazzConstants.add(
						"		static public const " + constant +  ":String = \"" + classes.get(i).getName() + "\";\n");
			}
		}
		String code =
			"package com.gearbrother.sheepwolf.rpc.protocol.bussiness {\n" +
			"	import com.gearbrother.sheepwolf.rpc.protocol.*;\n" +
			"\n" +
			"	/**\n" +
			"	 * Don't modify manually\n" +
			"	 *\n" +
			"	 * @generated by tool\n" +
			"	 * @create on " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n" +
			"	 */\n" +
			"	public class Protocol {\n" +
			GStringUtil.join(clazzConstants, "", false) +
			"" +
			"		static public const protocols:Object = new Object();\n" +
			"		{\n" +
			GStringUtil.join(cases, "", false) +
			"		}\n" +
			"	}\n" +
			"}\n";
		s2.write(code.getBytes("utf-8"));
		s2.close();

		//generate AS3 RpcBean code
		File javaProtocolFolder;
		if ("Windows 7".equals(System.getProperties().get("os.name")))
			javaProtocolFolder = new File("D:\\neo\\mine\\project\\server\\workspace\\com.gearbrother.sheep&wolf.server.java.core\\src\\com\\gearbrother\\sheepwolf\\rpc\\protocol\\bussiness\\");
		else
			javaProtocolFolder = new File("/Users/lifeng/workspace/gearbrother2/com.gearbrother.sheep&wolf.server.java.core/src/com/gearbrother/sheepwolf/rpc/protocol/bussiness");
		emptyFolder(javaProtocolFolder);
		for (int i = 0; i < classes.size(); i++) {
			Class<?> modelClass = classes.get(i);
			if (modelClass.getAnnotation(RpcBeanPartTransportable.class) != null) {
				RpcBeanTemplate as3Class = new RpcBeanTemplate(modelClass);
				
				FileOutputStream s = new FileOutputStream(new File(as3ProtocolFolder, modelClass.getSimpleName() + FILE_NAME_EXTENSION + ".as"));
				as3Class.writeActionScript3RpcBean(s);
				s.close();
//				as3Class.writeActionScript3RpcBean(System.out);
				
				if (modelClass.getAnnotation(RpcBeanPartTransportable.class).isPartTransport()) {
					s = new FileOutputStream(new File(javaProtocolFolder, modelClass.getSimpleName() + FILE_NAME_EXTENSION + ".java"));
					as3Class.writeJavaRpcBean(s);
					s.close();
//					as3Class.writeJavaRpcBean(System.out);
				}
			}
		}
	}
}
class RpcBeanTemplate {
	static Logger logger = LoggerFactory.getLogger(RpcBeanTemplate.class);
	
	private Class<?> _source;
	
	private List<RpcPropertyTemplate> _properties;

	public RpcBeanTemplate() {
	}
	
	public RpcBeanTemplate(Class<?> source) throws IntrospectionException {
		_source = source;
		_properties = new ArrayList<RpcPropertyTemplate>();
		Field[] fields = _source.getFields();
		for (int k = 0; k < fields.length; k++) {
			Field javaField = fields[k];
			RpcBeanProperty annotation = javaField.getAnnotation(RpcBeanProperty.class);
			if (annotation != null) {
				_properties.add(new RpcPropertyTemplate(javaField, annotation));
			}
		}
		BeanInfo beanInfo = Introspector.getBeanInfo(_source);
		PropertyDescriptor[] propertyDesc = beanInfo.getPropertyDescriptors();
		for (int i = 0; i < propertyDesc.length; i++) {
			Method readMethod = propertyDesc[i].getReadMethod();
			if (readMethod != null) {
				RpcBeanProperty annotation = readMethod.getAnnotation(RpcBeanProperty.class);
				if (annotation != null) {
					_properties.add(new RpcPropertyTemplate(propertyDesc[i].getName(), readMethod, annotation));
				}
			}
		}
	}
	
	public void writeActionScript3RpcService(OutputStream stream) throws UnsupportedEncodingException, IOException {
		List<RpcBeanMethodTemplate> rpcMethods = new ArrayList<RpcBeanMethodTemplate>();
		Method[] methods = _source.getMethods();
		ArrayList<String> exportedMethods = new ArrayList<String>();
		mLoop: for (int i = 0; i < methods.length; i++) {
			Method method = methods[i];
			RpcServiceMethod annotation = method.getAnnotation(RpcServiceMethod.class);
			if (annotation != null) {
				if (exportedMethods.contains(method.getName())) {
					logger.warn("Can't export \"" + _source.getName() + "." + method.getName() + "(), Because ActionScript3's class can't contain mulite \"" + method.getName() + "\" method");
					continue;
				} else {
					exportedMethods.add(method.getName());
				}
				RpcBeanMethodTemplate rpcMethod = new RpcBeanMethodTemplate(method, annotation);
				List<String> paramNames = new ArrayList<String>();
				Annotation[][] parametersAnnotations = method.getParameterAnnotations();
				Type[] genericParameterTypes = method.getGenericParameterTypes();
				for (int j = 0; j < parametersAnnotations.length; j++) {
					Annotation[] parameterAnnotations = parametersAnnotations[j];
					for (int l = 0; l < parameterAnnotations.length; l++) {
						Annotation paramAnnotation = parameterAnnotations[l];
						if (paramAnnotation instanceof RpcServiceMethodParameter) {
							RpcServiceMethodParameter paramAnnotationInstance = (RpcServiceMethodParameter) paramAnnotation;
							RpcBeanMethodParamTemplate methodParam = new RpcBeanMethodParamTemplate();
							if (genericParameterTypes[j] instanceof Class) {
								methodParam.type = new RpcType((Class<?>) genericParameterTypes[j]);
							} else {
								logger.error("Can't export \"" + _source.getSimpleName() + "." + method.getName() + "\"(\"" + genericParameterTypes[j] + "\" " + paramAnnotationInstance.name() + "), because \"RpcService\"'s parameters only accept primitive type in java(\"boolean, double, float, int, long, String\")\", and \"JsonNode\" or \"ArrayNode\"");
								continue mLoop;
								//methodParam.type = new RpcType((ParameterizedType) genericParameterTypes[j]);
							}
							if (paramAnnotationInstance.name() != "")
								methodParam.name = paramAnnotationInstance.name();
							else
								methodParam.name = method.getName();
							methodParam.comment = paramAnnotationInstance.desc();
							rpcMethod.params.add(methodParam);
							paramNames.add(methodParam.name);
						}
					}
				}
				RpcBeanMethodParamTemplate successCallback = new RpcBeanMethodParamTemplate();
				successCallback.name = "successCallback";
				successCallback.type = new RpcType("Function");
				successCallback.defaultValue = "null";
				successCallback.comment = "成功回调";
				rpcMethod.params.add(successCallback);
				RpcBeanMethodParamTemplate errorCallback = new RpcBeanMethodParamTemplate();
				errorCallback.name = "errorCallback";
				errorCallback.type = new RpcType("Function");
				errorCallback.defaultValue = "null";
				errorCallback.comment = "失败回调";
				rpcMethod.params.add(errorCallback);
				rpcMethod.content = "			return call(\"" + GStringUtil.lowerFirstChar(_source.getSimpleName()) + "." + method.getName() + "\", [" + GStringUtil.join(paramNames, ", ", true) + "], successCallback, errorCallback);\n";
				rpcMethods.add(rpcMethod);
			}
		}
		writeActionScript3Service(stream, false, "com.gearbrother.sheepwolf.rpc.service.bussiness", Arrays.asList(new String[] {"	import com.gearbrother.sheepwolf.rpc.service.*;\n"}), _source.getSimpleName(), "RpcService", new ArrayList<RpcPropertyTemplate>(), rpcMethods);
	}
	
	public void writeActionScript3RpcBean(OutputStream stream) throws UnsupportedEncodingException, IOException, ClassNotFoundException, IntrospectionException {
		writeActionScript3(stream, true, "com.gearbrother.sheepwolf.rpc.protocol.bussiness", Arrays.asList(new String[] {"	import com.gearbrother.sheepwolf.rpc.protocol.*;\n"}), _source.getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION, "RpcProtocol", _properties, Arrays.asList(new RpcBeanMethodTemplate[] {}));
	}

	public void writeActionScript3Service(OutputStream stream, boolean isBean, String pkg, List<String> imports, String clazzName, String extendsName, List<RpcPropertyTemplate> properties, List<RpcBeanMethodTemplate> methods) throws UnsupportedEncodingException, IOException {
		String s = 
				"package " + pkg + " {\n" +
				GStringUtil.join(imports, "", false) +
				"	import com.gearbrother.sheepwolf.rpc.channel.RpcSocketChannel;\n" +
				"\n" +
				"	/**\n" +
				"	 * Don't modify manually\n" +
				"	 *\n" +
				"	 * @generated by tool\n" +
				"	 * @create on " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n" +
				"	 */\n" +
				"	public class " + clazzName + (extendsName == null ? "" : " extends " + extendsName) + " {\n" +
				formatProperties(properties) +
				(properties.size() > 0 ? "\n" : "") +
				"		public function " + clazzName + "(channel:RpcSocketChannel) {\n" +
				"			super(channel);\n" +
				"		}\n" +
				(methods.size() > 0 ? "\n" : "")
				+ formatMethodsToActionScript(methods) +
				"	}\n" +
				"}\n";
		stream.write(s.getBytes("utf-8"));
	}

	public void writeActionScript3(OutputStream stream, boolean isBean, String pkg, List<String> imports, String clazzName, String extendsName, List<RpcPropertyTemplate> properties, List<RpcBeanMethodTemplate> methods) throws UnsupportedEncodingException, IOException {
		List<String> constructors = new ArrayList<String>();
		for (RpcPropertyTemplate rpcProperty : properties) {
			if (rpcProperty.type.type instanceof Class<?>) {
				if (RpcType.isPrimitive((Class<?>) rpcProperty.type.type)) {
					//do nothing
				} else if (((Class<?>) rpcProperty.type.type).isArray()) {
					Class<?> innerType = rpcProperty.type.getInnerType(rpcProperty.type.type);
					if (RpcType.isPrimitive(innerType)) {
						//do nothing
					} else {
						constructors.add(
								"				if (prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "])\n" +
								"					prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "] = prototype2Protocol(prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "]);\n");
					}
				} else {
					constructors.add(
							"				if (prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "])\n" +
							"					prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "] = prototype2Protocol(prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "]);\n");
				}
			} else if (rpcProperty.type.type instanceof ParameterizedType) {
				Class<?> innerType = rpcProperty.type.getInnerType(rpcProperty.type.type);
				if (RpcType.isPrimitive(innerType)) {
					//do nothing
				} else {
					constructors.add(
							"				if (prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "])\n" +
							"					prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "] = prototype2Protocol(prototype[" + RpcPropertyTemplate.toConstant(rpcProperty.name) + "]);\n");
				}
			} else {
				throw new Error("unknown type");
			}
		}
		String s = 
				"package " + pkg + " {\n" +
				GStringUtil.join(imports, "", false) +
				"\n" +
				"	/**\n" +
				"	 * Don't modify manually\n" +
				"	 *\n" +
				"	 * @generated by tool\n" +
				"	 * @create on " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n" +
				"	 */\n" +
				"	public class " + clazzName + (extendsName == null ? "" : " extends " + extendsName) + " {\n" +
				formatProperties(properties) +
				(properties.size() > 0 ? "\n" : "") +
				(
						isBean ?
						"		public function " + clazzName + "(prototype:Object = null) {\n" +
						"			super(prototype);\n" +
						"\n" +
						"			if (prototype) {\n" +
						GStringUtil.join(constructors, "", false) +
						"			}\n" +
						"		}\n"
						:
						"		public function " + clazzName + "() {\n" +
						"			super();\n" +
						"		}\n"
				) + 
				(methods.size() > 0 ? "\n" : "")
				+ formatMethodsToActionScript(methods) +
				"	}\n" +
				"}\n";
		stream.write(s.getBytes("utf-8"));
	}
	
	public String formatProperties(List<RpcPropertyTemplate> properties) {
		List<String> res = new ArrayList<String>();
		for (int i = 0; i < properties.size(); i++) {
			RpcPropertyTemplate property = properties.get(i);
			res.add(property.toAsString());
		}
		return GStringUtil.join(res, "\n", true);
	}

	public String formatMethodsToActionScript(List<RpcBeanMethodTemplate> methods) {
		List<String> res = new ArrayList<String>();
		for (int i = 0; i < methods.size(); i++) {
			RpcBeanMethodTemplate method = methods.get(i);
			res.add(method.toAsString());
		}
		return GStringUtil.join(res, "\n", true);
	}
	
	public void writeJavaRpcBean(OutputStream stream) throws UnsupportedEncodingException, IOException, IntrospectionException, ClassNotFoundException {
		List<RpcBeanMethodTemplate> rpcMethods = new ArrayList<RpcBeanMethodTemplate>();
		RpcBeanMethodTemplate parseBeanMethod = new RpcBeanMethodTemplate();
		parseBeanMethod.name = "parseBean";
		parseBeanMethod.returnType = _source.getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION;
		parseBeanMethod.content = "";
		RpcBeanMethodParamTemplate param = new RpcBeanMethodParamTemplate();
		param.name = "bean";
		param.type = new RpcType(_source.getName());
		parseBeanMethod.params.add(param);
		rpcMethods.add(parseBeanMethod);
		RpcBeanMethodTemplate removeAllPropertiesMethod = new RpcBeanMethodTemplate();
		removeAllPropertiesMethod.name = "removeAllProperties";
		removeAllPropertiesMethod.returnType = "void";
		removeAllPropertiesMethod.desc = "清除所有属性，导出JSON时将不会导出任何属性，用来减少消息大小";
		rpcMethods.add(removeAllPropertiesMethod);
		for (int i = 0; i < _properties.size(); i++) {
			RpcPropertyTemplate property = _properties.get(i);
			String getCode;
			if (property.readMethod != null)
				getCode = property.readMethod.getName() + "()";
			else if (property.field != null)
				getCode = property.field.getName();
			else
				throw new Error();
//			if (property.type.type instanceof Class) {
//				Class<?> typeClass = (Class<?>) property.type.type;
//				if (RpcType.isPrimitive(typeClass) || typeClass == Object.class) {
//					parseBeanMethod.content += "		set" + GStringUtil.upperFirstChar(property.name) + "(bean." + getCode + ");\n";
//				} else if (typeClass.getAnnotation(RpcBeanPartTransportable.class) != null) {
//					parseBeanMethod.content += ""
//							+ "		if (bean." + getCode + " != null) {\n"
//							+ "			set" + GStringUtil.upperFirstChar(property.name) + "(new " + typeClass.getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION + "().parseBean(bean." + getCode + "));\n"
//							+ "		} else {\n"
//							+ "			set" + GStringUtil.upperFirstChar(property.name) + "(null);\n"
//							+ "		}\n";
//				} else if (typeClass.isArray()) {
//					throw new Error("unsupport Array, please use List");
//				} else {
//					parseBeanMethod.content += "		set" + GStringUtil.upperFirstChar(property.name) + "(bean." + getCode + ");\n";
//				}
//			} else if (property.type.type instanceof ParameterizedType) {
//				parseBeanMethod.content += "		set" + GStringUtil.upperFirstChar(property.name) + "(bean." + getCode + ");\n";
//			}
			parseBeanMethod.content += "		set" + GStringUtil.upperFirstChar(property.name) + "(bean." + getCode + ");\n";
			if (removeAllPropertiesMethod.content == null)
				removeAllPropertiesMethod.content = "";
			removeAllPropertiesMethod.content += "		remove" + GStringUtil.upperFirstChar(property.name) + "Property();\n";
		}
		parseBeanMethod.content += "		return this;\n";
		parseBeanMethod.throwString = "throws InstantiationException, IllegalAccessException, SecurityException, NoSuchMethodException, IllegalArgumentException, InvocationTargetException"; 
		ArrayList<String> imports = new ArrayList<String>();
		imports.add("import java.util.*;\n");
		imports.add("import java.lang.reflect.Method;\n");
		imports.add("import java.lang.reflect.InvocationTargetException;\n");
		imports.add("import com.gearbrother.sheepwolf.pojo.*;\n");
		imports.add("import com.gearbrother.sheepwolf.rpc.protocol.RpcProtocol;\n");
		String s = 
				"package com.gearbrother.sheepwolf.rpc.protocol.bussiness;\n" +
				"\n" +
				"" + GStringUtil.join(imports, "", false) + (imports.size() > 0 ? "\n" : "") +
				"/**\n" +
				" * Don't modify manually\n" +
				" *\n" +
				" * @generated by tool\n" +
				" * @see " + _source.getName() + "\n" +
				" * @create on " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) + "\n" +
				" */\n" +
				"public class " + _source.getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION + " extends RpcProtocol {\n" +
				"	/**\n" +
				"	 *\n" +
				"	 */\n" +
				"	private static final long serialVersionUID = 1L;\n" +
				"\n" +
				formatJavaProperties(_properties) +
				(_properties.size() > 0 ? "\n" : "") +
				"	public " + _source.getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION + "() {\n" +
				"		super();\n" +
				"\n" +
				"		put(\"$class\", \"" + _source.getName() + "\");\n" +
				"	}\n" +
				(rpcMethods.size() > 0 ? "\n" : "") +
				formatMethodsToJava(rpcMethods) +
				"}\n";
		stream.write(s.getBytes("utf-8"));
	}
	
	public String formatJavaProperties(List<RpcPropertyTemplate> properties) throws ClassNotFoundException, IOException {
		List<String> res = new ArrayList<String>();
		for (int i = 0; i < properties.size(); i++) {
			RpcPropertyTemplate property = properties.get(i);
			res.add(property.toJavaString());
		}
		return GStringUtil.join(res, "\n", true);
	}

	public String formatMethodsToJava(List<RpcBeanMethodTemplate> methods) {
		List<String> res = new ArrayList<String>();
		for (int i = 0; i < methods.size(); i++) {
			RpcBeanMethodTemplate method = methods.get(i);
			res.add(method.toJavaString());
		}
		return GStringUtil.join(res, "\n", true);
	}
}
class RpcPropertyTemplate {
	public Field field;
	
	public Method readMethod;
	
	public String name;
	
	public String desc;
	
	public RpcType type;

	public RpcPropertyTemplate(Field field, RpcBeanProperty annotation) {
		this.field = field;
		if (annotation.name().length() > 0)
			name = annotation.name();
		else
			name = field.getName();
		desc = annotation.desc();
		if (field.getGenericType() instanceof Class) {
			type = new RpcType((Class<?>) field.getGenericType());
		} else if (field.getGenericType() instanceof ParameterizedType) {
			type = new RpcType((ParameterizedType) field.getGenericType());
		} else {
			throw new Error("unknown type");
		}
	}
	
	public RpcPropertyTemplate(String name, Method readMethod, RpcBeanProperty annotation) {
		this.readMethod = readMethod;
		if (annotation.name().length() > 0)
			name = annotation.name();
		else
			this.name = name;
		desc = annotation.desc();
		if (readMethod.getGenericReturnType() instanceof Class) {
			type = new RpcType((Class<?>) readMethod.getGenericReturnType());
		} else if (readMethod.getGenericReturnType() instanceof ParameterizedType) {
			type = new RpcType((ParameterizedType) readMethod.getGenericReturnType());
		} else {
			throw new Error("unknown type");
		}
	}

	public String toAsString() {
		String constant = toConstant(name);
		return
				"		/**\n" +
				"		 * " + desc + "\n" +
				"		 */\n" +
				"		static public const " + constant + ":String = \"" + name + "\";\n" + 	
				"\n" +
				"		/**\n" +
				"		 * get " + desc + "\n" +
				"		 */\n" +
				"		public function get " + name + "():" + type.toAs3Type() + " {\n"+ 	
				"			return getProperty(" + constant + ");\n"+ 	
				"		}\n"+ 	
				"\n" +
				"		/**\n" +
				"		 * set " + desc + "\n" +
				"		 */\n" +
				"		public function set " + name + "(newValue:" + type.toAs3Type() + "):void {\n"+ 	
				"			setProperty(" + constant + ", newValue);\n"+ 	
				"		}\n";
	}
	
	static public String toConstant(String name) {
		int index = 0;
		while (index < name.length()) {
			char c = name.charAt(index);
			if (Character.isUpperCase(c)) {
				name = name.substring(0, index) + "_" + name.substring(index, name.length());
				index++;
			}
			index++;
		}
		return name.toUpperCase();
	}
	
	public String toJavaString() throws ClassNotFoundException, IOException {
		String constant = toConstant(name);
		return
				"	/**\n" +
				"	 * " + desc + "\n"+
				"	 */\n" +
				"	static final String " + constant + " = \"" + name + "\";\n" +
				"	/**\n" +
				"	 * get " + desc + "\n"+
				"	 */\n" +
				"	public " + type.toJavaType() + " get" + GStringUtil.upperFirstChar(name) + "()" + " {\n" + 
				"		return ("  + type.toJavaTypeObject(type.type) + ") get(" + constant + ");\n" + 	
				"	}\n" + 
				"	/**\n" +
				"	 * set " + desc + "\n"+
				"	 */\n" +
				"	public void set" + GStringUtil.upperFirstChar(name) + "(" + type.toJavaType() + " value) {\n" + 	
				"		put(" + constant + ", value);\n" + 	
				"	}\n" +
				"	public boolean has" + GStringUtil.upperFirstChar(name) + "Property() {\n" +
				"		return containsKey(" + constant + ");\n" +
				"	}\n" +
				"	public void remove" + GStringUtil.upperFirstChar(name) + "Property() {\n" +
				"		remove(" + toConstant(name) + ");\n" +
				"	}\n";
	}
}
class RpcBeanMethodTemplate {
	public String name;
	
	public String content;
	
	public String throwString;
	
	public String desc;

	public String returnType;
	
	public List<RpcBeanMethodParamTemplate> params;

	public Method method;
	
	public RpcBeanMethodTemplate() {
		params = new ArrayList<RpcBeanMethodParamTemplate>();
	}
	
	public RpcBeanMethodTemplate(Method method, RpcServiceMethod annotation) {
		this();

		this.method = method;
		name = "".equals(annotation.name()) ? method.getName() : annotation.name();
		desc = annotation.desc();
		returnType = "RpcServiceCall";
	}

	public String toAsString() {
		List<String> paramComments = new ArrayList<String>();
		List<String> paramCodes = new ArrayList<String>();
		for (Iterator<?> iterator = params.iterator(); iterator.hasNext();) {
			RpcBeanMethodParamTemplate param = (RpcBeanMethodParamTemplate) iterator.next();
			paramCodes.add(param.toAsString());
			paramComments.add("		 * @" + param.name + " " + param.comment);
		}
		return
				"		/**\n" +
				"		 * " + desc + "\n" +
				(paramComments.size() > 0 ? "		 *\n" : "") +
				GStringUtil.join(paramComments, "\n", false) +
				"		 */\n" +
				"		public function " + name + "(" + GStringUtil.join(paramCodes, ", ", true) + "):" + returnType + " {\n" +
				content +
				"		}\n";
	}
	
	public String toJavaString() {
		List<String> paramComments = new ArrayList<String>();
		List<String> paramCodes = new ArrayList<String>();
		for (Iterator<?> iterator = params.iterator(); iterator.hasNext();) {
			RpcBeanMethodParamTemplate param = (RpcBeanMethodParamTemplate) iterator.next();
			paramCodes.add(param.toJavaString());
			paramComments.add("		 * @" + param.name + " " + param.comment);
		}
		return
				"	/**\n" +
				"	 * " + desc + "\n" +
				(paramComments.size() > 0 ? "		 *\n" : "") +
				GStringUtil.join(paramComments, "\n", false) +
				"	 */\n" +
				"	public " + returnType + " " + name + "(" + GStringUtil.join(paramCodes, ", ", true) + ") " + (throwString != null ? (throwString + " ") : "") + "{\n" +
				(content == null ? "" : content) +
				"	}\n";
	}
}
class RpcBeanMethodParamTemplate {
	public String name;
	
	public RpcType type;
	
	public String defaultValue;
	
	public String comment;
	
	public String toAsString() {
		return name + ":" + type.toAs3Type() + (defaultValue != null ? " = " + defaultValue : "");
	}

	public String toJavaString() {
		return type.toJavaType() + " " + name;
	}
}
class RpcType {
	public String typeString;
	
	public Type type;
	
	public Class<?> getInnerType(Type type) {
		if (type instanceof Class) {
			if (isPrimitive((Class<?>) type))
				return (Class<?>) type;
			else if (Object.class == type)
				return (Class<?>) type;
			else if (void.class == type)
				return (Class<?>) type;
			else if (((Class<?>) type).isArray())
				return getInnerType(((Class<?>) type).getComponentType());
			else
				return (Class<?>) type;
		} else if (type instanceof ParameterizedType) {
			Type rawType = ((ParameterizedType) type).getRawType();
			if ((List.class == rawType || Set.class == rawType) && ((ParameterizedType) type).getActualTypeArguments().length == 1) {
				return getInnerType(((ParameterizedType) type).getActualTypeArguments()[0]);
			} else if (Map.class == rawType || HashMap.class == rawType) {
				return getInnerType(((ParameterizedType) type).getActualTypeArguments()[1]);
			} else {
				throw new Error("unknown type");
			}
		} else {
			throw new Error("unknown type");
		}
	}
	
	public RpcType() {
	}
	
	public RpcType(Type type) {
		this.type = type;
	}
	
	public RpcType(String string) {
		typeString = string;
	}

	public String toAs3Type() {
		if (typeString != null) {
			return typeString;
		} else if (type instanceof Class) {
			if (int.class == type)
				return "int";
			else if (Integer.class == type)
				return "int";
			else if (long.class == type)
				return "Number";
			else if (Long.class == type)
				return "Number";
			else if (double.class == type)
				return "Number";
			else if (Double.class == type)
				return "Number";
			else if (Number.class == type)
				return "Number";
			else if (float.class == type)
				return "Number";
			else if (Float.class == type)
				return "Number";
			else if (short.class == type)
				return "int";
			else if (Short.class == type)
				return "int";
			else if (boolean.class == type)
				return "Boolean";
			else if (Boolean.class == type)
				return "Boolean";
			else if (String.class == type)
				return "String";
			else if (JsonNode.class == type)
				return "Object";
			else if (ArrayNode.class == type)
				return "Array";
			else if (void.class == type)
				return "void";
			else if (((Class<?>) type).getAnnotation(RpcBeanPartTransportable.class) != null)
				return ((Class<?>) type).getSimpleName() + GenerateRpcClientCode.FILE_NAME_EXTENSION;
			else if (((Class<?>) type).isArray())
				return "Array";
			else if (Object.class == type)
				return "Object";
			else if (((Class<?>) type).isInterface())
				return "Object";
			else
				return "Object";
//				throw new Error("unknown type");
		} else if (type instanceof ParameterizedType) {
			if (((ParameterizedType) type).getRawType() == List.class || ((ParameterizedType) type).getRawType() == Set.class) {
				return "Array";
			} else if (((ParameterizedType) type).getRawType() == Map.class
					|| ((ParameterizedType) type).getRawType() == HashMap.class) {
				return "Object";
			} else {
				throw new Error("unknown type");
			}
		} else {
			throw new Error("unknown type");
		}
	}
	
	public static boolean isPrimitive(Class<?> type) {
		if (int.class == type || Integer.class == type)
			return true;
		else if (long.class == type || Long.class == type)
			return true;
		else if (double.class == type || Double.class == type)
			return true;
		else if (float.class == type || Float.class == type)
			return true;
		else if (short.class == type || Short.class == type)
			return true;
		else if (boolean.class == type || Boolean.class == type)
			return true;
		else if (String.class == type)
			return true;
		return false;
	}
	
	public String toJavaType() {
		if (typeString != null) {
			return typeString;
		} else if (type != null)
			return _toJavaType(type);
		else
			throw new Error("unknown type");
	}
	
	private String _toJavaType(Type type) {
		if (type instanceof Class) {
			if (isPrimitive((Class<?>) type))
				return ((Class<?>) type).getName();
			else if (Object.class == type)
				return "Object";
			else if (void.class == type)
				return "void";
			else if (((Class<?>) type).getAnnotation(RpcBeanPartTransportable.class) != null)
				return ((Class<?>) type).getSimpleName();
			else if (((Class<?>) type).isArray())
				return _toJavaType(((Class<?>) type).getComponentType()) + "[]";
			else
				return ((Class<?>) type).getName();
//				throw new Error("unknown type");
		} else if (type instanceof ParameterizedType) {
			return type.toString();
			/*
			Type rawType = ((ParameterizedType) type).getRawType();
			if (List.class == rawType && ((ParameterizedType) type).getActualTypeArguments().length == 1)
				return "List<" + _toJavaType(((ParameterizedType) type).getActualTypeArguments()[0]) + ">";
			else
				throw new Error("unknown type");
			*/
		} else {
			throw new Error("unknown type");
		}
	}

	public String toJavaTypeObject(Type type) {
		if (type instanceof Class) {
			if (int.class == type || Integer.class == type)
				return "Integer";
			else if (long.class == type || Long.class == type)
				return "Long";
			else if (double.class == type || Double.class == type)
				return "Double";
			else if (float.class == type || Float.class == type)
				return "Float";
			else if (short.class == type || Short.class == type)
				return "Integer";
			else if (boolean.class == type || Boolean.class == type)
				return "Boolean";
			else if (String.class == type)
				return "String";
			else if (Object.class == type)
				return "Object";
			else if (void.class == type)
				return "void";
			else if (((Class<?>) type).getAnnotation(RpcBeanPartTransportable.class) != null)
				return ((Class<?>) type).getSimpleName();
			else if (((Class<?>) type).isArray())
				return _toJavaType(((Class<?>) type).getComponentType()) + "[]";
			else
				return ((Class<?>) type).getName();
//				throw new Error("unknown type");
		} else if (type instanceof ParameterizedType) {
			return type.toString();
			/*
			Type rawType = ((ParameterizedType) type).getRawType();
			if (List.class == rawType && ((ParameterizedType) type).getActualTypeArguments().length == 1)
				return "List<" + toJavaTypeObject(((ParameterizedType) type).getActualTypeArguments()[0]) + ">";
			else
				throw new Error("unknown type");
			*/
		} else {
			throw new Error("unknown type");
		}
	}
}