package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.util.display.GPen;


	/**
	 * @author lifeng
	 * @create on 2014-1-8
	 */
	public class GDisplayPenCase extends GMain {
		private var _pen:GPen;
		
		public function GDisplayPenCase(id:String = null) {
			super(id);
			
			var percent:Number = .5;
			_pen = new GPen(this.graphics);
			_pen.clear();
			_pen.lineStyle(0, 0, 0);
			_pen.beginFill(0x000000, .3);
			var slice:int = 360 * .9;
			_pen.drawSlice(360 - slice, Math.max(width >> 1, height >> 1), -90 + slice, width >> 1, height >> 1);
		}
	}
}
