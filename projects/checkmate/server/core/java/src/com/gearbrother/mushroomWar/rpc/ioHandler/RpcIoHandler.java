package com.gearbrother.mushroomWar.rpc.ioHandler;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.gearbrother.mushroomWar.model.ISession;
import com.gearbrother.mushroomWar.pojo.MinaSessionImpl;
import com.gearbrother.mushroomWar.pojo.RpcCallResponse;
import com.gearbrother.mushroomWar.pojo.World;
import com.gearbrother.mushroomWar.rpc.annotation.RpcServiceMethod;
import com.gearbrother.mushroomWar.rpc.service.bussiness.UserService;
import com.gearbrother.mushroomWar.util.GStringUtil;

/**
 * @author feng.lee
 * @create on 2013-8-21
 */
public class RpcIoHandler extends IoHandlerAdapter implements ApplicationContextAware {
	static Logger logger = LoggerFactory.getLogger(RpcIoHandler.class);
	
	static final public Map<Long, IoSession> sessions = new HashMap<Long, IoSession>();
	
	static final public String SESSION_KEY = "SESSION_KEY";

	private ApplicationContext applicationContext;
	
	public Map<String, Method> servicePorts;
	
	private World world;

	public World getWorld() {
		return world;
	}

	public void setWorld(World world) {
		this.world = world;
	}

	@Override
	public void setApplicationContext(ApplicationContext arg0) throws BeansException {
		this.applicationContext = arg0;

		servicePorts = new HashMap<String, Method>();
		Map<String, Object> beans = applicationContext.getBeansWithAnnotation(Service.class);
		Set<String> keys = beans.keySet();
		for (Iterator<String> iterator = keys.iterator(); iterator.hasNext();) {
			String key = (String) iterator.next();
			Object bean = beans.get(key);
			if (UserService.class.getPackage().getName() == bean.getClass().getPackage().getName()) {
				Method[] methods = bean.getClass().getMethods();
				for (int i = 0; i < methods.length; i++) {
					Method method = methods[i];
					if (method.getAnnotation(RpcServiceMethod.class) != null) {
						servicePorts.put(GStringUtil.lowerFirstChar(bean.getClass().getSimpleName()) + "." + method.getName(), method);
					}
				}
			}
		}
	}

	/**
	 * [PROTOCOL]
	 * 				--> {"id": "23sdbd332s", "method": "warService.subtract", "params": [42, 23]}
	 * 				<-- {"id": "23sdbd332s", "status": 200, "result": {}}
	 **/
	@Override
	public void messageReceived(IoSession session, Object message) throws Exception {
		ObjectNode node = (ObjectNode) message;
		// get nodes
		//JsonNode jsonPrcNode = node.get("version");
		String callID = node.get("id").asText();
		String serviceName = node.get("method").textValue();
		String[] methods = serviceName.split("\\.");
		JsonNode argus = node.get("argus");
		int defaultArgusSize = 1;
		Object[] paramValues = new Object[argus.size() + defaultArgusSize];
		paramValues[0] = session.getAttribute(SESSION_KEY);//new MinaSessionImpl(session);
		Method method = servicePorts.get(serviceName);//Method method = bean.getClass().getMethod(methods[1], paramTypes);
		Class<?>[] types = method.getParameterTypes();
		for (int i = 0; i < types.length - defaultArgusSize; i++) {
			Class<?> type = types[i + defaultArgusSize];
			if (type == boolean.class || type == Boolean.class)
				paramValues[i + defaultArgusSize] = argus.get(i).booleanValue();
			else if (type == short.class || type == Short.class)
				paramValues[i + defaultArgusSize] = argus.get(i).shortValue();
			else if (type == int.class || type == Integer.class)
				paramValues[i + defaultArgusSize] = argus.get(i).intValue();
			else if (type == long.class || type == Long.class)
				paramValues[i + defaultArgusSize] = argus.get(i).longValue();
			else if (type == float.class || type == Float.class)
				paramValues[i + defaultArgusSize] = argus.get(i).floatValue();
			else if (type == double.class || type == Double.class)
				paramValues[i + defaultArgusSize] = argus.get(i).doubleValue();
			else if (type == String.class) {
				JsonNode argu = argus.get(i);
				paramValues[i + defaultArgusSize] = (argu != null ? argu.textValue() : argu);
			} else if (type == JsonNode.class)
				paramValues[i + defaultArgusSize] = argus.get(i);
			else if (type == ArrayNode.class)
				paramValues[i + defaultArgusSize] = argus.get(i);
			else
				throw new Error("unsupport type " + type);
		}
		Object serviceBean = applicationContext.getBean(methods[0]);
		RpcCallResponse response = new RpcCallResponse();
		response.uuid = callID;
		try {
			Object result = method.invoke(serviceBean, paramValues);
			if (result != null)
				response.result = result;
		} catch (Exception e) {
			response.isFailed = true;
			response.result = e.toString();
			e.printStackTrace();
		}
		session.write(response);
		super.messageReceived(session, message);
	}

	@Override
	public void sessionOpened(IoSession session) throws Exception {
		super.sessionOpened(session);
		
		logger.info("***");
		logger.info("	session is created from {}", session.getLocalAddress());
		logger.info("***");
		session.setAttribute(SESSION_KEY, new MinaSessionImpl(session, world));
	}
	
	@Override
	public void sessionClosed(IoSession session) throws Exception {
		ISession s = (ISession) session.getAttribute(SESSION_KEY);
		s.close();
		session.removeAttribute(SESSION_KEY);
		
		logger.info("***");
		logger.info("	session is closed from {}", session.getLocalAddress());
		logger.info("***");
		super.sessionClosed(session);
	}
	
	@Override
	public void exceptionCaught(IoSession session, Throwable cause) throws Exception {
		super.exceptionCaught(session, cause);
	}
}
