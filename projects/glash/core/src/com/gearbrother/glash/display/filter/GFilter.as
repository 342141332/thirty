package com.gearbrother.glash.display.filter {
	import com.adobe.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;

	public class GFilter {
		static public const decolor:GFilter = new GFilter(new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]));
		
		static public function getGlow(color:uint = 0x000000, alpha:int = 1.0, blurX:int = 6.0, blurY:int = 6.0, strength:int = 2, quality:int = 1.0, inner:Boolean = false, knockout:Boolean = false):GFilter {
			return new GFilter(new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout));
		}
		
		/**
		 * 获取提高亮度的ColorMatrixFilter滤镜
		 * @param value:int 亮度偏移值
		 */
		static public function getBright(value:int):GFilter {
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, value]); 	// red
			matrix = matrix.concat([0, 1, 0, 0, value]); 	// green
			matrix = matrix.concat([0, 0, 1, 0, value]); 	// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);		// alpha
			return new GFilter(new ColorMatrixFilter(matrix));
		}
		
		static public function getBlur(blurX:Number = 4, blurY:Number = 4):GFilter {
			return new GFilter(new BlurFilter(blurX, blurY));
		}
		/**
		 *灰色滤镜
		 * @return
		 *
		 */
		static public function getBlackWhiteFilter():GFilter {
			return new GFilter(new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]));
		}
		
		/**
		 *彩色滤镜
		 * @return
		 *
		 */
		static public function getMultiColoredFilter():GFilter {
			return new GFilter(new ColorMatrixFilter([3.0742, -1.8282, -0.246, 0, 0, -0.9258, 2.1718, -0.246, 0, 0, -0.9258, -1.8282, 3.754, 0, 0, 0, 0, 0, 1, 0]));
		}
		
		/**
		 * 白色字体用滤镜
		 * 食物、兵力属性等
		 * @return
		 */
		static public function getWhiteTextDropShadowFilter():DropShadowFilter {
			return new DropShadowFilter(1, 90, 0x333333, 1, 4, 4, 10);
		}
		
		private var _value:*;
		
		public function GFilter(value:*) {
			_value = value;
		}

		public function apply(displayObj:DisplayObject):void {
			var filters:Array = displayObj.filters;
			for (var i:int = 0; i < filters.length; i++) {
				var filter:BitmapFilter = filters[i];
				if (isFilterEquals(filter, _value)) {
					return;
				}
			}
			filters.push(_value);
			displayObj.filters = filters;
		}

		public function unapply(displayObj:DisplayObject):void {
			var filters:Array = displayObj.filters;
			for (var i:int = 0; i < filters.length; i++) {
				var filter:BitmapFilter = filters[i];
				if (isFilterEquals(filter, _value)) {
					filters.splice(i, 1);
					displayObj.filters = filters;
				}
			}
		}

		private function isFilterEquals(filter1:BitmapFilter, filter2:BitmapFilter):Boolean {
			if (filter1 is ColorMatrixFilter) {
				var colorMatrix:ColorMatrixFilter = filter1 as ColorMatrixFilter;
				var currentFilter:ColorMatrixFilter = filter2 as ColorMatrixFilter;
				if (currentFilter && ArrayUtil.arraysAreEqual(colorMatrix.matrix, currentFilter.matrix)) {
					return true;
				}
			} else if (filter1 is BlurFilter) {
				var blurFilter:BlurFilter = filter1 as BlurFilter;
				var blurFilter2:BlurFilter = filter2 as BlurFilter;
				if (blurFilter2 && blurFilter.blurX == blurFilter2.blurX && blurFilter.blurY == blurFilter2.blurY && blurFilter.quality == blurFilter2.quality) {
					return true;
				}
			} else if (filter1 is BevelFilter) {
				var bevelFilter1:BevelFilter = filter1 as BevelFilter;
				var bevelFilter2:BevelFilter = filter2 as BevelFilter;
				if (bevelFilter2 && bevelFilter1.angle == bevelFilter2.angle && bevelFilter1.blurX == bevelFilter2.blurX && bevelFilter1.blurY == bevelFilter2.blurY && bevelFilter1.distance == bevelFilter2.distance && bevelFilter1.highlightAlpha == bevelFilter2.highlightAlpha && bevelFilter1.highlightColor == bevelFilter2.highlightColor && bevelFilter1.knockout == bevelFilter2.knockout && bevelFilter1.quality == bevelFilter2.quality && bevelFilter1.shadowAlpha == bevelFilter2.shadowAlpha && bevelFilter1.shadowColor == bevelFilter2.shadowColor && bevelFilter1.strength == bevelFilter2.strength && bevelFilter1.type == bevelFilter2.type) {
					return true;
				}
			} else if (filter1 is DropShadowFilter) {
				var dropShadow1:DropShadowFilter = filter1 as DropShadowFilter;
				var dropShadow2:DropShadowFilter = filter2 as DropShadowFilter;
				if (dropShadow2 && dropShadow1.alpha == dropShadow2.alpha && dropShadow1.angle == dropShadow2.angle && dropShadow1.blurX == dropShadow2.blurX && dropShadow1.blurY == dropShadow2.blurY && dropShadow1.color == dropShadow2.color && dropShadow1.distance == dropShadow2.distance && dropShadow1.hideObject == dropShadow2.hideObject && dropShadow1.inner == dropShadow2.inner && dropShadow1.knockout == dropShadow2.knockout && dropShadow1.quality == dropShadow2.quality && dropShadow1.strength == dropShadow2.strength) {
					return true;
				}
			} else if (filter1 is GlowFilter) {
				var glow1:GlowFilter = filter1 as GlowFilter;
				var glow2:GlowFilter = filter2 as GlowFilter;
				if (glow2 && glow1.alpha == glow2.alpha && glow1.blurX == glow2.blurX && glow1.blurY == glow2.blurY && glow1.color == glow2.color && glow1.inner == glow2.inner && glow1.knockout == glow2.knockout && glow1.quality == glow2.quality && glow1.strength == glow2.strength) {
					return true;
				}
			} else if (filter1 is ShaderFilter) {
				var shader1:ShaderFilter = filter1 as ShaderFilter;
				var shader2:ShaderFilter = filter2 as ShaderFilter;
				if (shader2 && shader1.bottomExtension == shader2.bottomExtension && shader1.leftExtension == shader2.leftExtension && shader1.rightExtension == shader2.rightExtension
//					&& shader1.shader.byteCode == shader2.shader.byteCode
					&& shader1.shader.data == shader2.shader.data && shader1.shader.precisionHint == shader2.shader.precisionHint && shader1.topExtension == shader2.topExtension) {
					return true;
				}
			} else {
				throw new Error("unhandle filter. please check again.");
			}
			return false;
		}
	}
}