package com.gearbrother.mushroomWar.view.layer {
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GHBox;
	import com.gearbrother.glash.display.layout.impl.BorderLayout;
	
	import flash.events.MouseEvent;


	/**
	 * @author lifeng
	 * @create on 2013-11-26
	 */
	public class UiLayer extends GContainer {
		public var top:GContainer;

		public var right:GContainer;

		public var bottom:GContainer;

		public var left:GContainer;

		public function UiLayer() {
			super();

			layout = new BorderLayout();
			append(top = new GContainer(), BorderLayout.NORTH);
			append(right = new GContainer(), BorderLayout.EAST);
			append(bottom = new GContainer(), BorderLayout.SOUTH);
			bottom.layout = new BorderLayout();
			append(left = new GContainer(), BorderLayout.WEST);
		}
	}
}
