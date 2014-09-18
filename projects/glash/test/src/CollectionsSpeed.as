package jd 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author XXL
	 */
	public class CollectionsSpeed extends Sprite 
	{
		private var _txt:TextField;
		
		public function CollectionsSpeed() 
		{
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.multiline = _txt.wordWrap = true;
			_txt.width = 800;
			addChild(_txt);
			_txt.text = "CollectionsSpeed:\nASC2.0 " + Capabilities.version + " IsDebugPlayer:" + Capabilities.isDebugger;
			
			addEventListener(MouseEvent.CLICK, fun);
		}
		
		private function fun(e:MouseEvent):void 
		{
			var i:int;
			var j:int;
			var len:int = 20;
			var REPS:int = 1000000;
			var time:int;
			var result:int;
			var str:String = "CollectionsSpeed:REPS:" + REPS + " Len:" + len + "\nASC2.0 " + Capabilities.version + " IsDebugPlayer:" + Capabilities.isDebugger + "\n";
			
			var object:Object = { };
			var dicWea:Dictionary = new Dictionary(true);
			var dicNow:Dictionary = new Dictionary(false);
			var arrays:Array = [];
			var arrayL:Array = new Array(len);
			var vector:Vector.<int> = new Vector.<int>();
			var vecFix:Vector.<int> = new Vector.<int>(true);
			var byteAr:ByteArray = new ByteArray();
			var bytePo:ByteArray = new ByteArray();
			for (j = 0; j < len; j++)
			{
				object[j] = j;
				dicWea[j] = j;
				dicNow[j] = j;
				arrays[j] = j;
				arrayL[j] = j;
				vector[j] = j;
				vecFix[j] = j;
				byteAr[j] = j;
				bytePo.writeInt(j);
			}
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					
				}
			}
			str += "Empty For i j:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = object[j];
				}
			}
			str += "object(int):" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				result = object["0"];
				result = object["1"];
				result = object["2"];
				result = object["3"];
				result = object["4"];
				result = object["5"];
				result = object["6"];
				result = object["7"];
				result = object["8"];
				result = object["9"];
				result = object["10"];
				result = object["11"];
				result = object["12"];
				result = object["13"];
				result = object["14"];
				result = object["15"];
				result = object["16"];
				result = object["17"];
				result = object["18"];
				result = object["19"];
			}
			str += "object(string key):" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = ifElseTree(j);
				}
			}
			str += "ifElseTree:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = ifElseTreeInline(j);
				}
			}
			str += "ifElseTreeInline:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = doSwitch(j);
				}
			}
			str += "doSwitch:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = doSwitchInline(j);
				}
			}
			str += "doSwitchInline:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = dicWea[j];
				}
			}
			str += "Dictionary(true):" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = dicNow[j];
				}
			}
			str += "Dictionary(false):" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = arrays[j];
				}
			}
			str += "Array:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = arrayL[j];
				}
			}
			str += "Array Length Fix:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = vector[j];
				}
			}
			str += "Vector:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = vecFix[j];
				}
			}
			str += "Vector(Fix):" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = byteAr[j];
				}
			}
			str += "ByteArray:" + (getTimer() - time) + "\n";
			
			time = getTimer();
			for (i = 0; i < REPS; i++)
			{
				for (j = 0; j < len; j++)
				{
					result = byteArrayFun(j, bytePo);
				}
			}
			str += "ByteArrayReadInt:" + (getTimer() - time) + "\n";
			
			_txt.text = str;
		}
		
		static private function doSwitch(key:int):int
		{
			switch(key)
			{
				case 0:return 0;
				case 1:return 1;
				case 2:return 2;
				case 3:return 3;
				case 4:return 4;
				case 5:return 5;
				case 6:return 6;
				case 7:return 7;
				case 8:return 8;
				case 9:return 9;
				case 10:return 10;
				case 11:return 11;
				case 12:return 12;
				case 13:return 13;
				case 14:return 14;
				case 15:return 15;
				case 16:return 16;
				case 17:return 17;
				case 18:return 18;
				case 19:return 19;
			}
			return -1;
		}
		
		[Inline]
		static private function doSwitchInline(key:int):int
		{
			switch(key)
			{
				case 0:return 0;
				case 1:return 1;
				case 2:return 2;
				case 3:return 3;
				case 4:return 4;
				case 5:return 5;
				case 6:return 6;
				case 7:return 7;
				case 8:return 8;
				case 9:return 9;
				case 10:return 10;
				case 11:return 11;
				case 12:return 12;
				case 13:return 13;
				case 14:return 14;
				case 15:return 15;
				case 16:return 16;
				case 17:return 17;
				case 18:return 18;
				case 19:return 19;
			}
			return -1;
		}
		
		[Inline]
		static private function byteArrayFun(key:int, bytes:ByteArray):int
		{
			bytes.position = key * 4;
			return bytes.readInt();
		}
		
		[Inline]
		static private function ifElseTreeInline(key:int):int
		{
			if (key < 10)
			{
				if (key < 5)
				{
					if (key < 2)
					{
						if (key == 0)
						{
							return 0;
						}
						else
						{
							return 1;
						}
					}
					else
					{
						if (key == 2)
						{
							return 2;
						}
						else if (key == 3)
						{
							return 3;
						}
						else
						{
							return 4;
						}
					}
				}
				else
				{
					if (key < 7)
					{
						if (key == 5)
						{
							return 5;
						}
						else
						{
							return 6;
						}
					}
					else
					{
						if (key == 7)
						{
							return 7;
						}
						else if (key == 8)
						{
							return 8;
						}
						else
						{
							return 9;
						}
					}
				}
			}
			else
			{
				if (key < 17)
				{
					if (key == 15)
					{
						return 15;
					}
					else
					{
						return 16;
					}
				}
				else
				{
					if (key == 17)
					{
						return 17;
					}
					else if (key == 18)
					{
						return 18;
					}
					else
					{
						return 19;
					}
				}
			}
			return -1;
		}
		
		static private function ifElseTree(key:int):int
		{
			if (key < 10)
			{
				if (key < 5)
				{
					if (key < 2)
					{
						if (key == 0)
						{
							return 0;
						}
						else
						{
							return 1;
						}
					}
					else
					{
						if (key == 2)
						{
							return 2;
						}
						else if (key == 3)
						{
							return 3;
						}
						else
						{
							return 4;
						}
					}
				}
				else
				{
					if (key < 7)
					{
						if (key == 5)
						{
							return 5;
						}
						else
						{
							return 6;
						}
					}
					else
					{
						if (key == 7)
						{
							return 7;
						}
						else if (key == 8)
						{
							return 8;
						}
						else
						{
							return 9;
						}
					}
				}
			}
			else
			{
				if (key < 17)
				{
					if (key == 15)
					{
						return 15;
					}
					else
					{
						return 16;
					}
				}
				else
				{
					if (key == 17)
					{
						return 17;
					}
					else if (key == 18)
					{
						return 18;
					}
					else
					{
						return 19;
					}
				}
			}
			return -1;
		}
		
	}

}