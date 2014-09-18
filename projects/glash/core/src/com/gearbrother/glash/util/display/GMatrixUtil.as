package com.gearbrother.glash.util.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;

	/**
	 * 
	 * @author feng.lee
	 * 
	 */
	final public class GMatrixUtil {
		/**
		 * 获得对象到另一个对象的Matrix
		 *
		 * @param obj
		 * @param contain
		 * @return
		 *
		 */
		static public function getMatrixAt(obj:DisplayObject, container:DisplayObject):Matrix {
			if (obj == container)
				return new Matrix();

			if (obj.stage) {	//有stage
				var m1:Matrix = obj.transform.concatenatedMatrix;
				var m2:Matrix = container.transform.concatenatedMatrix;
				m2.invert();
				m1.concat(m2);
			} else {
				m1 = obj.transform.matrix;
				var cur:DisplayObject = obj.parent;
				while (cur != container) {
					if (!cur)
						return null;

					m1.concat(cur.transform.matrix);

					if (cur != cur.parent)
						cur = cur.parent;
					else
						return null;
				}
			}
			return m1;
		}
	}
}
