package com.gearbrother.glash.display.control.text {
	import com.gearbrother.glash.display.IGScrollable;
	import com.gearbrother.glash.display.event.GDisplayEvent;
	import com.riaidea.text.RichTextField;
	
	import flash.text.TextFormat;


	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-8-18 下午2:53:59
	 *
	 */
	public class GRichTextField extends RichTextField implements IGScrollable {
		public function get minScrollH():int {
			return 0;
		}
		
		public function get maxScrollH():int {
			return Math.max(0, textfield.textHeight - height);
		}
		
		public function get scrollH():int {
			return textfield.scrollH;
		}

		public function set scrollH(newValue:int):void {
			textfield.scrollH = newValue;
		}

		public function get scrollHPageSize():int {
			return height;
		}
		
		public function get minScrollV():int {
			return 1;
		}
		
		public function get maxScrollV():int {
			return textfield.maxScrollV; 
		}

		public function get scrollV():int {
			return textfield.scrollV;
		}

		public function set scrollV(newValue:int):void {
			textfield.scrollV = newValue;
		}

		public function get scrollVPageSize():int {
			return 10;
		}
		
		public function GRichTextField() {
			super();
			
			type = RichTextField.DYNAMIC;
			autoScroll = true;
		}
		
		override public function clear():void {
			super.clear();
			
			dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
		}
		
		override public function append(newText:String, newSprites:Array=null, autoWordWrap:Boolean=false, format:TextFormat=null):void {
			super.append(newText, newSprites, autoWordWrap, format);
			
			dispatchEvent(new GDisplayEvent(GDisplayEvent.SCROLL_CHANGE));
		}
	}
}
