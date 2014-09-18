package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.common.oper.GOperPool;
	import com.gearbrother.glash.common.oper.ext.GAliasFile;
	import com.gearbrother.glash.common.oper.ext.GFile;
	
	import flash.utils.getTimer;


	/**
	 * @author feng.lee
	 * create on 2012-6-8 下午1:49:52
	 */
	public class GCommonPoolCase extends GMain {
		public function GCommonPoolCase() {
			super();
		}

		override protected function doInit():void {
			super.doInit();

			var pool:GOperPool = new GOperPool();
			var t1:int = getTimer();
			for (var i:int = 0; i < 100000; i++) {
				var instance1:GOper = pool.getInstance(new GAliasFile("asset/1.png", GFile.TYPE_IMAGE));
			}
			trace(getTimer() - t1);
			var instance2:GFile = pool.getInstance(new GFile("asset/1.png", GFile.TYPE_IMAGE)) as GFile;
			var instance3:GFile = pool.getInstance(new GFile("asset/1.png", GFile.TYPE_BINARY)) as GFile;
			if (instance1 != instance2)
				throw new Error("case failed");
			if (instance1 == instance3)
				throw new Error("case failed");
		}
	}
}