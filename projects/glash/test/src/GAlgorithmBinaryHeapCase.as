package {
	import com.gearbrother.glash.common.algorithm.GBinaryHeap;
	import com.gearbrother.glash.util.math.GMathUtil;
	import com.gearbrother.glash.util.math.GRandomUtil;
	
	import flash.system.System;

	/**
	 *
	 * @author 	Neo.Zhang
	 * @create 	2014-9-11 下午4:40:51
	 *
	 */
	public class GAlgorithmBinaryHeapCase extends GCase {
		public function GAlgorithmBinaryHeapCase() {
			super();
			
			var heap:GBinaryHeap = new GBinaryHeap(
				function(a:*, b:*):int {
					return a.value - b.value;
				}
			);
			for (var i:int = 0; i < 200; i++) {
				heap.push({"value": GRandomUtil.integer(0, 10000)});
			}
			while (heap.size) {
				var head:Object = heap.pop();
				trace(head.value, heap.size ? heap.content[0].value : undefined);
			}
			System.exit(0);
		}
	}
}
