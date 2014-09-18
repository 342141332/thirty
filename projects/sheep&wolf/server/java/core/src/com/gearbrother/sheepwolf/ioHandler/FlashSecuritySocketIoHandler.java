package com.gearbrother.sheepwolf.ioHandler;

import org.apache.mina.core.buffer.IoBuffer;
import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;

public class FlashSecuritySocketIoHandler extends IoHandlerAdapter {
	static final public String xml = "<cross-domain-policy>\n<allow-access-from domain=\"*\" to-ports=\"*\"/>\n</cross-domain-policy>";

	@Override
	public void messageReceived(IoSession session, Object message) throws Exception {
		byte[] bytes = xml.getBytes("utf-8");
		IoBuffer buf = IoBuffer.allocate(bytes.length + 1);
		buf.put(bytes);
		buf.put((byte) 0x0);
		buf.flip();
		session.write(buf);
		super.messageReceived(session, message);
	}
}
