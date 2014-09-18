package com.gearbrother.glash.display.container {
	import com.gearbrother.glash.display.GDisplayConst;
	import com.gearbrother.glash.display.layout.impl.HorizontalLayout;
	
	import org.osmf.layout.HorizontalAlign;


	/**
	 * 横排子容器容器
	 * @author feng.lee
	 * @create on 2013-2-13
	 */
	public class GHBox extends GContainer {
		public function set padding(newValue:int):void {
			(layout as HorizontalLayout).padding = newValue;
		}

		public function GHBox() {
			super();

			layout = new HorizontalLayout(GDisplayConst.ALIGN_CENTER);
		}
	}
}
