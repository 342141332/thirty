package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.util.display.GDisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;


	/**
	 * 带九宫格背景
	 * @author feng.lee
	 * @create on 2013-4-29
	 */
	public class GBackgroundContainer extends GContainer {
		//background
		private var _background:GBackground;

		public function get background():GBackground {
			return _background;
		}

		public function set backgroundSkin(newValue:DisplayObject):void {
			if (_background)
				removeChild(_background);
			_background = new GBackground(newValue);
			if (_background)
				if (_background.parent)
					_background.parent.removeChild(_background);
				if (_content)
					GDisplayUtil.addChildBefore(_background, _content);
				else
					addChild(_background);
		}

		private var _content:GNoScale;

		public function get content():GNoScale {
			return _content;
		}

		public function set content(newValue:GNoScale):void {
			if (_content)
				removeChild(_content);
			_content = newValue;
			if (_content)
				if (_content.parent)
					_content.parent.removeChild(_content);
				addChild(_content);
		}

		public var outerRectangle:Rectangle;

		public var innerRectangle:Rectangle;

		public function GBackgroundContainer(skin:DisplayObjectContainer = null) {
			super();

			layout = new Scale9GridLayout();
		}
	}
}
import com.gearbrother.glash.common.algorithm.GBoxsGrid;
import com.gearbrother.glash.common.geom.GDimension;
import com.gearbrother.glash.display.container.GBackgroundContainer;
import com.gearbrother.glash.display.container.GContainer;
import com.gearbrother.glash.display.layout.impl.EmptyLayout;

import flash.geom.Rectangle;

class Scale9GridLayout extends EmptyLayout {
	override public function preferredLayoutSize(target:GContainer):GDimension {
		var b:GBackgroundContainer = target as GBackgroundContainer;
		if (b.innerRectangle) {
			return new GDimension(b.outerRectangle.width - b.innerRectangle.width + b.content.preferredSize.width
				, b.outerRectangle.height - b.innerRectangle.height + b.content.preferredSize.height);
		} else {
			return new GDimension();
		}
	}

	override public function layoutContainer(target:GContainer):void {
		var b:GBackgroundContainer = target as GBackgroundContainer;
		if (b.innerRectangle) {
			b.content.x = b.innerRectangle.x;
			b.content.y = b.innerRectangle.y;
			b.content.width = b.width + b.innerRectangle.width - b.outerRectangle.width;
			b.content.height = b.height + b.innerRectangle.height - b.outerRectangle.height;
			b.background.skin.width = b.background.width = b.width;
			b.background.skin.height = b.background.height = b.height;
		}
	}
}

import com.gearbrother.glash.display.GNoScale;

import flash.display.DisplayObject;


/**
 * @author neozhang
 * @create on Oct 14, 2013
 */
class GBackground extends GNoScale {
	public function GBackground(skin:DisplayObject = null) {
		super(skin);
	}
}