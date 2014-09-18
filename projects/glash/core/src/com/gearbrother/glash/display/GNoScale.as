package com.gearbrother.glash.display {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.manager.GPaintManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 重写了width,height,scaleX,scaleY，大部分组件类的基类
	 *
	 */
	public class GNoScale extends GSkinSprite {
		private var _manualWidth:Number;
		override public function get width():Number {
			return _manualWidth;
		}
		override public function set width(newValue:Number):void {
			if (_manualWidth != newValue) {
				_manualWidth = newValue;
				invalidateLayout();
			}
		}
		
		private var _manualHeight:Number;
		override public function get height():Number {
			return _manualHeight;
		}
		override public function set height(newValue:Number):void {
			if (_manualHeight != newValue) {
				_manualHeight = newValue;
				invalidateLayout();
			}
		}

		private var _manualPreferredSize:GDimension;
		public function get manualPreferredSize():GDimension {
			return _manualPreferredSize;
		}
		public function set manualPreferredSize(newValue:GDimension):void {
			_manualPreferredSize = newValue;
		}

		public function get preferredSize():GDimension {
			if (_manualPreferredSize)
				return _manualPreferredSize.clone();
			else
				return new GDimension(_manualWidth, _manualHeight);
		}

		public function get minimumSize():GDimension {
			return new GDimension(0, 0);
		}

		public function get maximumSize():GDimension {
			return new GDimension(10000, 10000);
		}
		
		private var _isLayoutValid:Boolean;
		public function get isLayoutValid():Boolean {
			return _isLayoutValid;
		}

		public function get layoutRoot():GNoScale {
			if (parent is GNoScale)
				return (parent as GNoScale).layoutRoot;
			else
				return this;
		}

		override public function set skin(newValue:DisplayObject):void {
			super.skin = newValue;
			
			if (skin) {
				width = skin.width;
				height = skin.height;
			}
			revalidateLayout();
		}

		public function GNoScale(skin:DisplayObject = null) {
			super(skin);

			if (!skin)
				width = height = 0;
		}
		
		override protected function doInit():void {
			super.doInit();

			revalidateLayout();
		}

		public function invalidateLayout():void {
			_isLayoutValid = false;
			if (parent is GNoScale) {
				var container:GNoScale = parent as GNoScale;
				if (container && container.isLayoutValid)
					container.invalidateLayout();
			}
		}

		public function revalidateLayout():void {
			invalidateLayout();
			//if has parent, notify parent, parent will manage child's resize
			GPaintManager.instance.addInvalidLayoutComponent(this);
		}

		final public function validateLayoutNow():void {
			if (!_isLayoutValid) {
				doValidateLayout();
				_isLayoutValid = true;
			}
		}

		protected function doValidateLayout():void {
			//do nothing
		}

		override public function replace(target:DisplayObject):void {
			var oldIndex:int = target.parent.getChildIndex(target);
			var oldParent:DisplayObjectContainer = target.parent;
			oldParent.removeChild(target);
			oldParent.addChildAt(this, oldIndex);
			x = target.x;
			y = target.y;
			width = target.width;
			height = target.height;
		}
		
		override protected function doDispose():void {
			revalidateLayout();
		}

		public function get $width():Number {
			return super.width;
		}

		public function set $width(newValue:Number):void {
			super.width = newValue;
		}

		public function get $height():Number {
			return super.height;
		}

		public function set $height(newValue:Number):void {
			super.height = newValue;
		}
		
		public function get $scaleX():Number {
			return super.scaleX;
		}
		
		public function get $scaleY():Number {
			return super.scaleY;
		}

		public function $addChild(newValue:DisplayObject):DisplayObject {
			return super.addChild(newValue);
		}

		public function $addChildAt(newValue:DisplayObject, index:int):DisplayObject {
			return super.addChildAt(newValue, index);
		}

		public function $removeChild(newValue:DisplayObject):DisplayObject {
			return super.removeChild(newValue);
		}

		public function $removeChildAt(index:int):DisplayObject {
			return super.removeChildAt(index);
		}

		public function $getChildAt(index:int):DisplayObject {
			return super.getChildAt(index);
		}

		public function $getChildByName(name:String):DisplayObject {
			return super.getChildByName(name);
		}

		public function $getChildIndex(child:DisplayObject):int {
			return super.getChildIndex(child);
		}
	}
}
