package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Focus extends Sprite {
		public function Focus() {
			getSprite();
			getSprite(200, 0);

			var _tf:TextField = new TextField();
			_tf.type = 'input';
			_tf.border = true;
			_tf.x = 200;
			_tf.y = 200;
			_tf.addEventListener(FocusEvent.FOCUS_IN, handler_focusin);
			_tf.addEventListener(FocusEvent.FOCUS_OUT, handler_focusout);
			addChild(_tf);
		}

		private var _sprite:Sprite;

		private function getSprite($x:int = 0, $y:int = 0):Sprite {
			var _sprite:Sprite = new Sprite();
			_sprite.graphics.beginFill(0);
			_sprite.graphics.drawRect(0, 0, 100, 100);
			_sprite.graphics.endFill();
			_sprite.x = $x;
			_sprite.y = $y;
			_sprite.useHandCursor = true;
//			_sprite.buttonMode = true;
			_sprite.addEventListener(MouseEvent.CLICK, __onMouseClick);
			this.addChild(_sprite);
			_sprite.addEventListener(FocusEvent.FOCUS_OUT, handler_focusout);
			_sprite.addEventListener(FocusEvent.FOCUS_IN, handler_focusin);
			_sprite.addEventListener(MouseEvent.CLICK, handler_click);
			return _sprite;
		}
		
		private function __onMouseClick(e:Event):void {
			var cTarget:Sprite = e.currentTarget as Sprite;
			cTarget.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_IN));
		}

		private function handler_focusout(evt:FocusEvent):void {
			trace('focusout,target:', evt.target, ',relatedTarget:', evt.relatedObject);
		}

		private function handler_focusin(evt:FocusEvent):void {
			trace('focusin,target:', evt.target, ',relatedTarget:', evt.relatedObject);
		}

		private function handler_click(evt:MouseEvent):void {
			trace('click');
		}
	}
}
