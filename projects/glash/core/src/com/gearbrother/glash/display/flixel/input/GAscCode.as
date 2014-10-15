package com.gearbrother.glash.display.flixel.input {

	/**
	 * @author lifeng
	 * @create on 2014-6-10
	 */
	public class GAscCode {
		static public const instance:GAscCode = new GAscCode();
		
		public var keyToCode:Object;
		
		public var codeToKey:Object;
		
		public function GAscCode() {
			keyToCode = {};
			codeToKey = {};

			var i:uint;
			
			//LETTERS
			i = 65;
			while (i <= 90)
				addKey(String.fromCharCode(i), i++);
			
			//NUMBERS
			i = 48;
			addKey("0", i++);
			addKey("1", i++);
			addKey("2", i++);
			addKey("3", i++);
			addKey("4", i++);
			addKey("5", i++);
			addKey("6", i++);
			addKey("7", i++);
			addKey("8", i++);
			addKey("9", i++);
			i = 96;
			addKey("NUMPADZERO", i++);
			addKey("NUMPADONE", i++);
			addKey("NUMPADTWO", i++);
			addKey("NUMPADTHREE", i++);
			addKey("NUMPADFOUR", i++);
			addKey("NUMPADFIVE", i++);
			addKey("NUMPADSIX", i++);
			addKey("NUMPADSEVEN", i++);
			addKey("NUMPADEIGHT", i++);
			addKey("NUMPADNINE", i++);
			addKey("PAGEUP", 33);
			addKey("PAGEDOWN", 34);
			addKey("HOME", 36);
			addKey("END", 35);
			addKey("INSERT", 45);
			
			//FUNCTION KEYS
			i = 1;
			while (i <= 12)
				addKey("F" + i, 111 + (i++));
			
			//SPECIAL KEYS + PUNCTUATION
			addKey("ESCAPE", 27);
			addKey("MINUS", 189);
			addKey("NUMPADMINUS", 109);
			addKey("PLUS", 187);
			addKey("NUMPADPLUS", 107);
			addKey("DELETE", 46);
			addKey("BACKSPACE", 8);
			addKey("LBRACKET", 219);
			addKey("RBRACKET", 221);
			addKey("BACKSLASH", 220);
			addKey("CAPSLOCK", 20);
			addKey("SEMICOLON", 186);
			addKey("QUOTE", 222);
			addKey("ENTER", 13);
			addKey("SHIFT", 16);
			addKey("COMMA", 188);
			addKey("PERIOD", 190);
			addKey("NUMPADPERIOD", 110);
			addKey("SLASH", 191);
			addKey("NUMPADSLASH", 191);
			addKey("CONTROL", 17);
			addKey("ALT", 18);
			addKey("SPACE", 32);
			addKey("UP", 38);
			addKey("DOWN", 40);
			addKey("LEFT", 37);
			addKey("RIGHT", 39);
			addKey("TAB", 9);
		}
		
		protected function addKey(keyName:String, keyCode:uint):void {
			keyToCode[keyName] = keyCode;
			codeToKey[keyCode] = keyName;
		}
	}
}
