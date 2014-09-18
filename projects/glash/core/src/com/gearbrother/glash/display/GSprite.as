package com.gearbrother.glash.display {
	import com.gearbrother.glash.util.display.GDisplayUtil;

	/**
	 * 这个类实现了光标和提示接口，以及属性变化事件
	 * 建议全部可视对象都以此类作为基类
	 *
	 * @author feng.lee
	 * create on 2012-8-21 下午4:58:33
	 */
	public class GSprite extends GDisplaySprite {
		public function GSprite() {
			super();
		}

		public function removeAllChildren():void {
			GDisplayUtil.removeAllChildren(this);
		}
	}
}
