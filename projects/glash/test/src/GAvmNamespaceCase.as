package {
	import example.myInternal;
	import example.myInternal2;
	
	import com.gearbrother.glash.GMain;

			use namespace myInternal2;

	/**
	 * @author feng.lee
	 * create on 2012-10-29 下午10:56:54
	 */
	public class GAvmNamespaceCase extends GMain {

		public function GAvmNamespaceCase() {
			super();
			
			
			var inst:Foo = new Foo;
			inst.call2();
		}

	}
}
import example.myInternal;
import example.myInternal2;

class Foo {

	myInternal function call2():void {
		trace("Using call1");
	}
	
	myInternal2 function call2():void {
		trace("Using call12");
	}
}
