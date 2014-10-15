package com.gearbrother.glash.util.math {
	import flash.utils.Dictionary;
	
	import org.as3commons.lang.ArrayUtils;


	/**
	 * 随机类
	 *
	 */
	public final class GRandomUtil {
		private static var randomHistory:Dictionary = new Dictionary(); //随机数历史记录

		/**
		 * 获得一个范围内的双精度小数
		 *
		 * @param min	最小值
		 * @param max	最大值
		 * @param duplicate	是否可重复
		 * @return
		 *
		 */
		static public function dec(min:Number, max:Number, duplicate:Boolean = true):Number {
			var r:Number;
			r = min + Math.random() * (max - min);
			if (!duplicate) {
				while (randomHistory[r])
					r = min + Math.random() * (max - min);

				randomHistory[r] = true;
			}


			return r;
		}

		/**
		 * 获得一个范围内的有符号整数
		 *
		 * @param min	最小值
		 * @param max	最大值
		 * @param duplicate	是否可重复
		 * @return
		 *
		 */
		static public function integer(min:int, max:int, duplicate:Boolean = true):int {
			var r:int;
			r = min + Math.round(Math.random() * (max - min));
			if (!duplicate) {
				while (randomHistory[r])
					r = min + Math.random() * (max - min);

				randomHistory[r] = true;
			}

			return r;
		}

		/**
		 * 清除随机数历史记录。重新开始取数。
		 *
		 */
		static public function clearHistory():void {
			for (var key:* in randomHistory) {
				delete randomHistory[key];
			}
		}
		
		static public function number(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}

		/**
		 * 生成固定长度的随机字符串
		 *
		 * @param len	长度
		 * @return
		 *
		 */
		static public function string(len:int):String {
			var result:String = "";
			for (var i:int = 0; i < len; i++) {
				result += String.fromCharCode(integer(65, 122));
			}
			return result;
		}

		/**
		 * 随机排序
		 *
		 * @param arr	数组
		 *
		 */
		static public function randomSort(arr:Array):Array {
			return arr.sort(randomFunction);
		}

		private static function randomFunction(n1:*, n2:*):int {
			return (Math.random() < 0.5) ? -1 : 1;
		}

		/**
		 * 随机选择多个数
		 * @param arr
		 * @param num
		 * @return
		 *
		 */
		static public function chooseMuti(arr:Array, num:int):Array {
			var a:Array = randomSort(arr.concat());
			return a.slice(0, num);
		}

		/**
		 * 以均等的几率从多个参数中选择一个
		 *
		 * @param reg	数组
		 * @return
		 *
		 */
		static public function choose(reg:Array):* {
			return reg[int(Math.random() * reg.length)];
		}

		/**
		 * 随机切分数字，生成一个数组。这个数组的总和等于原数字。
		 * 用于生成满足约束的随机数列。
		 *
		 * @param amount	总和
		 * @param n	数量，必须为2的N次方
		 * @return
		 *
		 */
		static public function randomSeparate(amount:Number, n:int):Array {
			var a:int = Math.log(n) / Math.LN2;
			var arr:Array = [amount];
			while (a > 0) {
				var newArr:Array = [];
				for (var i:int = 0; i < arr.length; i++) {
					var v1:Number = Math.random() * arr[i];
					var v2:Number = arr[i] - v1;
					newArr.push(v1, v2);
				}
				arr = newArr;

				a--;
			}
			return arr;
		}

		/**
		 * 另一种切分数字的方式，对数量无限制
		 * @param amount
		 * @param n
		 * @return
		 *
		 */
		static public function randomSeparate2(amount:Number, n:int):Array {
			var r:Array = [];
			var c:Number = 0;
			for (var i:int = 0; i < n; i++) {
				var v:Number = Math.random();
				r.push(v);
				c += v;
			}

			for (i = 0; i < n; i++)
				r[i] = r[i] * amount / c;

			return r;
		}

// ============================================================================================= //
		/**
		 * Return the picked index from a weighted list.
		 *
		 * @param weights an Array containing Numbers, ints, or uints. All values should be
		 * non-negative.
		 * @param a random function that returns (0 <= value < 1), if null then Math.random() will
		 * be used.
		 */
		static public function getWeightedIndex(weights:Array, randomFn:Function = null):int {
			var sum:Number = 0;
			for each (var n:Number in weights) {
				sum += n;
			}
			if (sum < 0) {
				return -1;
			}
			var pick:Number = ((randomFn == null) ? Math.random() : randomFn()) * sum;
			for (var ii:int = 0; ii < weights.length; ii++) {
				pick -= Number(weights[ii]);
				if (pick < 0) {
					return ii;
				}
			}

			// since we're dealing with floats, it's possible that a rounding error left us here
			return 0; // TODO: largest weighted? Re-pick?
		}

		/**
		 * Picks a random object from the supplied array of values. Even weight is given to all
		 * elements of the array.
		 *
		 * @return a randomly selected item or undefined if the array is null or of length zero.
		 */
		static public function pickRandom(values:Array, randomFn:Function = null):* {
			if (values == null || values.length == 0) {
				return undefined;
			} else {
				var rand:Number = (randomFn == null) ? Math.random() : randomFn();
				return values[Math.floor(rand * values.length)];
			}
		}

		static public function pickRandomNum(values:Array, pickNum:int = 1):Array {
			if (values == null || values.length < pickNum) {
				return values || [];
			} else {
				var res:Array = [];
				values = ArrayUtils.clone(values);
				for (var i:uint = 0; i < pickNum; i++) {
					var ran:* = pickRandom(values);
					res.push(ran);
					values.splice(values.indexOf(ran), 1);
				}
				return res;
			}
		}
	}
}
