package com.gearbrother.sheepwolf.rpc.ioHandler.codec;

import java.nio.charset.Charset;

import org.apache.mina.core.buffer.IoBuffer;
import org.apache.mina.core.session.IoSession;
import org.apache.mina.filter.codec.ProtocolEncoderAdapter;
import org.apache.mina.filter.codec.ProtocolEncoderOutput;
import org.apache.mina.filter.codec.prefixedstring.PrefixedStringEncoder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;


public class RpcEncoder extends ProtocolEncoderAdapter {
	private final static Logger LOGGER = LoggerFactory.getLogger(RpcEncoder.class);

    public final static int DEFAULT_PREFIX_LENGTH = 4;

    public final static int DEFAULT_MAX_DATA_LENGTH = 1024 * 200;

    private final Charset charset;

    private int prefixLength = DEFAULT_PREFIX_LENGTH;

    private int maxDataLength = DEFAULT_MAX_DATA_LENGTH;
    
    private ObjectMapper objectMapper;

    public RpcEncoder(Charset charset, int prefixLength, int maxDataLength) {
        this.charset = charset;
        this.prefixLength = prefixLength;
        this.maxDataLength = maxDataLength;
        this.objectMapper = new ObjectMapper();
        this.objectMapper.setAnnotationIntrospector(new RpcAnnotationIntrospector());
    }

    public RpcEncoder(Charset charset, int prefixLength) {
        this(charset, prefixLength, DEFAULT_MAX_DATA_LENGTH);
    }

    public RpcEncoder(Charset charset) {
        this(charset, DEFAULT_PREFIX_LENGTH);
    }

    public RpcEncoder() {
    	this(Charset.forName("utf-8"));
//        this(Charset.defaultCharset());
    }

    /**
     * Sets the number of bytes used by the length prefix
     *
     * @param prefixLength the length of the length prefix (1, 2, or 4)
     */
    public void setPrefixLength(int prefixLength) {
        if (prefixLength != 1 && prefixLength != 2 && prefixLength != 4) {
            throw new IllegalArgumentException("prefixLength: " + prefixLength);
        }
        this.prefixLength = prefixLength;
    }

    /**
     * Gets the length of the length prefix (1, 2, or 4)
     *
     * @return length of the length prefix
     */
    public int getPrefixLength() {
        return prefixLength;
    }

    /**
     * Sets the maximum number of bytes allowed for encoding a single String
     * (including the prefix)
     * <p>
     * The encoder will throw a {@link IllegalArgumentException} when more bytes
     * are needed to encode a String value.
     * The default value is {@link PrefixedStringEncoder#DEFAULT_MAX_DATA_LENGTH}.
     * </p>
     *
     * @param maxDataLength maximum number of bytes allowed for encoding a single String
     */
    public void setMaxDataLength(int maxDataLength) {
        this.maxDataLength = maxDataLength;
    }

    /**
     * Gets the maximum number of bytes allowed for encoding a single String     *
     *
     * @return maximum number of bytes allowed for encoding a single String (prefix included)
     */
    public int getMaxDataLength() {
        return maxDataLength;
    }

    public void encode(IoSession session, Object message, ProtocolEncoderOutput out) throws Exception {
        String value = objectMapper.writeValueAsString(message);
        LOGGER.debug("encode {}", value);
        IoBuffer buffer = IoBuffer.allocate(value.length()).setAutoExpand(true);
        buffer.putPrefixedString(value, prefixLength, charset.newEncoder());
        if (buffer.position() > maxDataLength) {
            throw new IllegalArgumentException("Data length: " + buffer.position());
        }
        buffer.flip();
        out.write(buffer);
    }
}
