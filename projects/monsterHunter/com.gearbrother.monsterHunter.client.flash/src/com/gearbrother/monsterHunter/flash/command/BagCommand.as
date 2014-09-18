package com.gearbrother.monsterHunter.flash.command {
	import com.gearbrother.glash.common.utils.GHandler;
	import com.gearbrother.monsterHunter.flash.event.BagEvent;
	import com.gearbrother.monsterHunter.flash.view.window.MyBagWindowView;

	/**
	 * @author feng.lee
	 * create on 2013-2-27
	 */
	public class BagCommand extends GameCommand {
		public var event:BagEvent;
		
		public function BagCommand() {
			super();
		}
		
		override public function execute():void {
			switch (event.type) {
				case BagEvent.GET:
					service.getBagItems(handleResponse);
					break;
			}
		}
		
		override public function result(body:Object):void {
			super.result(body);
			
			switch (event.type) {
				case BagEvent.GET:
					new MyBagWindowView().open();
					break;
			}
		}
	}
}
