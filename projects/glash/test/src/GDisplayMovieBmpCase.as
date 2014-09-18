package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.ext.GBmdDefinition;
	import com.gearbrother.glash.common.oper.ext.GDefinition;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.debug.FPStatus;
	import com.gearbrother.glash.display.GDisplayBitmap;
	import com.gearbrother.glash.display.GMovieBitmap;
	import com.gearbrother.glash.display.GNoScale;
	import com.gearbrother.glash.display.layout.impl.EmptyLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.display.paper.display.item.GPaperMovieBitmap;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;


	/**
	 * @author feng.lee
	 * create on 2012-9-13 上午11:19:11
	 */
	[SWF(width = "800", height = "600", frameRate="60")]
	public class GDisplayMovieBmpCase extends GMain {
		private var _children:Array;
		
		public function GDisplayMovieBmpCase() {
			super();
			
			var lastIndex:int = loaderInfo.loaderURL.lastIndexOf("/", loaderInfo.loaderURL.lastIndexOf("/") - 1);
			GFile.pathPrefix = loaderInfo.loaderURL.substring(0, lastIndex);
			rootLayer.mouseEnabled = false;
//			rootLayer.layout = new FlowLayout();
			_children = [];
			stage.color = 0xcccccc;
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.CLICK, handleClick);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, handleDClick);
		}

		public function handleClick(e:MouseEvent):void {
			for (var i:int = 0; i < 100; i++) {
				var label:String = GRandomUtil.pickRandom(["Rest", "Move", "Injured", "Cheer", "Attack"]);
				var avator:GMovieBitmap = new GMovieBitmap(12);
				avator.definition = new GBmdDefinition(new GDefinition(new GFile("asset/avatar/" + GRandomUtil.integer(1, 10) + ".swf"), label), 0, true, true);
				avator.x = stage.stageWidth * Math.random();
				avator.y = stage.stageHeight * Math.random();
				_children.push(stage.addChild(avator));
			}
		}

		public function handleDClick(e:MouseEvent):void {
			while (_children.length) {
				var child:DisplayObject = _children.shift();
				child.parent.removeChild(child);
			}
		}
	}
}
