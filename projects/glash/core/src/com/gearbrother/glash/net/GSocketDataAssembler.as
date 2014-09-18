package com.gearbrother.glash.net {
	
	import flash.net.*;
	import flash.utils.*;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class GSocketDataAssembler implements IGSocketDataAssembler {
		public static const logger:ILogger = getLogger(GSocketDataAssembler);
		
		protected var _receiveData:ByteArray;
		protected var _hasReadHeader:Boolean;
		protected var _headerLength:uint;
		protected var _messageLength:uint;
		protected var _messageMaxLength:uint;
		protected var _includeLengthSection:Boolean;

		public function GSocketDataAssembler(headerLength:uint = 4, maxLength:uint = 65535, includeLengthSection:Boolean = true) {
			_receiveData = new ByteArray();
			_headerLength = headerLength;
			_messageMaxLength = maxLength;
			_hasReadHeader = false;
			_includeLengthSection = includeLengthSection;
		}

		public function reset():void {
			_receiveData.clear();
			_hasReadHeader = false;
		}

		public function assemble(socket:Socket):int {
			if (_hasReadHeader == false) {
				if (socket.bytesAvailable >= _headerLength) {
					if (_headerLength == 4) {
						_messageLength = socket.readInt();
					} else if (_headerLength == 2) {
						_messageLength = socket.readUnsignedShort();
					} else if (_headerLength == 1) {
						_messageLength = socket.readUnsignedByte();
					} else {
						throw new Error("just support 1/2/4 bytes length message header");
					}
					if (_includeLengthSection == true) {
						_messageLength = _messageLength - _headerLength;
					}
					_hasReadHeader = true;
				} else {
					return GDataAssembleResult.RESULT_WAIT;
				}
			} else if (_messageLength <= _messageMaxLength) {
				if (_messageLength == 0) {
					_hasReadHeader = false;
					logger.debug("zero length message");
					return GDataAssembleResult.RESULT_FAILED;
				}
				if (socket.bytesAvailable >= _messageLength) {
					_receiveData.clear();
					_hasReadHeader = false;
					if (_includeLengthSection == true) {
						_receiveData.writeUnsignedInt(_messageLength + _headerLength);
						var bytes:ByteArray = new ByteArray();
						socket.readBytes(bytes, 0, _messageLength);
						_receiveData.writeBytes(bytes);
						_receiveData.position = 0;
					} else {
						socket.readBytes(_receiveData, 0, _messageLength);
					}
					return GDataAssembleResult.RESULT_OK;
				} else {
					return GDataAssembleResult.RESULT_WAIT;
				}
			} else {
				_hasReadHeader = false;
				logger.debug("beyond the admitted max message length: " + _messageMaxLength);
				return GDataAssembleResult.RESULT_FAILED;
			}
			return GDataAssembleResult.RESULT_CONTINUE;
		}

		public function getAssembledDatas():ByteArray {
			return _receiveData;
		}
	}
}
