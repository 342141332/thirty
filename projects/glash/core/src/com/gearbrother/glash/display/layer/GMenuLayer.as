package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.display.layout.impl.PreferredLayout;


	/**
	 * @author lifeng
	 * @create on 2013-9-14
	 */
	public class GMenuLayer extends GContainer {
		public function GMenuLayer() {
			super();
			
			layout = new PreferredLayout();
		}
	}
}
