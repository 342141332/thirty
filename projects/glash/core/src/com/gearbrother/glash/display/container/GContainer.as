package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.layout.interfaces.IGLayoutManager;
	
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.level.DEBUG;


	/**
	 * 容器
	 *
	 * 子容器应该加到content内而不是自身，否则无法布局。skin也会在content内，无法作为背景存在。
	 * 这个容器的大小是由layout控制,transition控制缓动
	 *
	 */
	public class GContainer extends GScrollBase {
		static public const logger:ILogger = getLogger(GContainer);

		protected var _cachedPreferredSize:GDimension;

		override public function get preferredSize():GDimension {
			if (manualPreferredSize) {
				return manualPreferredSize.clone();
			} else if (_cachedPreferredSize) {
				return _cachedPreferredSize.clone();
			} else {
				_cachedPreferredSize = _layout.preferredLayoutSize(this);
				return _cachedPreferredSize.clone();
			}
		}

		//================================ layout ================================//
		private var _layout:IGLayoutManager;

		public function set layout(layout:IGLayoutManager):void {
			if (_layout != layout) {
				if (layout.hasUsed)
					throw new Error("layout has already been used for container");
				_layout = layout;
				layout.hasUsed = true;
				revalidateLayout();
			}
		}

		public function get layout():IGLayoutManager {
			return _layout;
		}

		public function GContainer() {
			super();

			layout = new EmptyLayout();
		}

		public function append(child:DisplayObject, constraint:Object = null):DisplayObject {
			if (child is GNoScale == false)
				throw new Error("child only is instance of GNoScale");
			_layout.addLayoutComponent(child as GNoScale, constraint);
			return super.addChild(child);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if (child is GNoScale == false)
				throw new Error("child only is instance of GNoScale");
			_layout.addLayoutComponent(child as GNoScale);
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			throw new Error("unsupport");
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			layout.removeLayoutComponent(child as GNoScale);
			return super.removeChild(child);
		}

		override public function invalidateLayout():void {
			_cachedPreferredSize = null;

			super.invalidateLayout();
		}

		override protected function doValidateLayout():void {
			//first, validate children
			_layout.layoutContainer(this);
			//then, layout children
			for each (var child:GNoScale in _children) {
				child.validateLayoutNow();
			}
			super.doValidateLayout();
		}
	}
}