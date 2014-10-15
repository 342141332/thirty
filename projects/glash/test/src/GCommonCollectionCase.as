package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.HashMap;
	import com.gearbrother.glash.common.collections.HashSet;
	import com.gearbrother.glash.display.GDisplaySprite;
	import com.gearbrother.glash.util.display.GColorUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;


	/**
	 * @author feng.lee
	 * create on 2012-10-29 下午10:43:35
	 */
	public class GCommonCollectionCase extends GMain {
		public function GCommonCollectionCase() {
			super();
		}
		
		override protected function doInit():void {
			super.doInit();

			var _collection:HashSet = new HashSet();
			_collection.addAll([new Element(1), new Element(2), new Element(3)]);
			
			trace(_collection.contains(new Element(1)) == true);
			trace(_collection.contains(new Element(4)) == false);
			trace(_collection.contains(1) == false);
			trace(_collection.contains(null) == false);
		}
	}
}

class Element {
	public var num:int;
	public var str:String;

	public function Element(num:int, str:String = "") {
		this.num = num;
		this.str = str;
	}

	public function equals(item:Element):Boolean {
		return num == item.num && str == item.str;
	}

	public function hashCode():Object {
		return num;
	}
}
