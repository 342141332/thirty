package com.gearbrother.glash.display {
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperHandler;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;


	/**
	 *
	 * 素材控制类,通过外部类控制行为,设入的skin来实现表现.
	 * skin类型可以为多种,如果是GFile,GSprite会下载后装配Skin
	 *
	 * @author feng.lee
	 *
	 */
	public class GSkinSprite extends GSprite {
		private var _skin:DisplayObject;

		public function get skin():DisplayObject {
			return _skin;
		}

		public function set skin(newValue:DisplayObject):void {
			var oldSkin:DisplayObject = _skin;
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			//新设置内容的时候，获取内容的坐标
			if (!parent) {
				this.x = newValue.x;
				this.y = newValue.y;

				newValue.x = newValue.y = 0;
				this.visible = newValue.visible;
				newValue.visible = true;
				//this.name = skin.name;
			}

			if (oldSkin == null) {
				//在最后才加入舞台
				if (newValue.parent) {
					oldParent = newValue.parent;
					oldIndex = newValue.parent.getChildIndex(newValue);
				}
			} else {
				removeChild(oldSkin);
			}

			if (oldParent)
				oldParent.addChildAt(this, oldIndex);

			if (newValue)
				super.addChild(newValue);

			if (newValue is InteractiveObject)
				(newValue as InteractiveObject).mouseEnabled = false;

			_skin = newValue;
		}

		private var _libsHandler:GPropertyPoolOperHandler;
		public function get libsHandler():GPropertyPoolOperHandler {
			return _libsHandler;
		}
		public function get libs():Array {
			return _libsHandler ? _libsHandler.value : null;
		}
		public function set libs(newValue:Array):void {
			_libsHandler ||= new GPropertyPoolOperHandler(null, this);
			_libsHandler.succHandler = _handleLibsSuccess;
			_libsHandler.value = newValue;
		}
		protected function _handleLibsSuccess(res:*):void {}

		/**
		 *
		 * @param skin can be "resource type" or "DisplayObject", "Class", "BitmapData" or "GSkin"
		 * @param container
		 *
		 */
		public function GSkinSprite(skin:DisplayObject = null) {
			super();

			if (_skin != skin)
				this.skin = skin;
		}

		/**
		 * 替换一个元件并放置在原来的位置
		 * @param target
		 *
		 */
		public function replace(target:DisplayObject):void {
			this.transform.colorTransform = target.transform.colorTransform;
			this.transform.matrix = target.transform.matrix;
			this.filters = target.filters;
			this.blendMode = target.blendMode;
			this.visible = target.visible;
			this.name = target.name;
			this.scrollRect = target.scrollRect;
			this.scale9Grid = target.scale9Grid;

			var oldIndex:int = target.parent.getChildIndex(target);
			var oldParent:DisplayObjectContainer = target.parent;
			oldParent.removeChild(target);
			oldParent.addChildAt(this, oldIndex);
		}

		/*public function replace(target:DisplayObject):void {
			var oldIndex:int;
			var oldParent:DisplayObjectContainer;
			//新设置内容的时候，获取内容的坐标
			this.x = target.x;
			this.y = target.y;
			//在最后才加入舞台
			if (target.parent) {
				oldParent = target.parent;
				oldIndex = target.parent.getChildIndex(target);
			}
			oldParent.addChildAt(this, oldIndex);
			oldParent.removeChild(target);
		}*/

		/**
		 * 将皮肤的属性转移到对象本身
		 *
		 */
		public function moveContentProperty():void {
			if (!skin)
				return;

			this.transform.matrix = this.skin.transform.matrix;
			this.transform.colorTransform = this.skin.transform.colorTransform;
			this.scrollRect = this.skin.scrollRect;
			this.blendMode = this.skin.blendMode;
			this.filters = this.skin.filters;

			this.skin.transform.matrix = new Matrix();
			this.skin.transform.colorTransform = new ColorTransform();
			this.skin.scrollRect = null;
			this.skin.blendMode = BlendMode.NORMAL;
			this.skin.filters = null;
		}
	}
}
