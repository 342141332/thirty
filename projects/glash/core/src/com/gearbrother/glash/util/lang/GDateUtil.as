package com.gearbrother.glash.util.lang {
	import com.adobe.utils.NumberFormatter;

	/**
	 * 日期类
	 *
	 */
	public final class GDateUtil {

		/**
		 * 获得当前月的天数
		 * @param d
		 *
		 */
		static public function getDayInMonth(d:Date):int {
			const days:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			var day:int = days[d.month];
			if (isLeapYear(d.fullYear))
				day++;

			return day;
		}

		/**
		 * 是否是闰年
		 * @param year
		 * @return
		 *
		 */
		static public function isLeapYear(year:int):Boolean {
			if (year % 4 == 0)
				if (year % 400 == 0)
					if (year % 3200 == 0)
						if (year % 86400 == 0)
							return false;
						else
							return true;
					else
						return false;
				else
					return true;
			else
				return false;
		}

		/**
		 * 根据字符串创建日期
		 * (yy-mm-dd)
		 * @param v
		 *
		 */
		static public function createDateFromString(v:String, timezone:Number = NaN):Date {
			v = v.replace(/-/g, "/");
			if (!isNaN(timezone)) {
				var str:String = Math.abs(timezone).toString();
				if (str.length == 1)
					str = "0" + str;

				v = v + " GMT" + (timezone >= 0 ? "+" : "-") + str + "00";
			}
			return new Date(v);
		}

		static public function formatSeconds(newValue:Number):String {
			var hour:int = newValue / 3600;
			var minute:int = (newValue - hour * 3600) / 60;
			var seconds:int = newValue - hour * 3600 - minute * 60;
			return NumberFormatter.addLeadingZero(hour) + ":" + NumberFormatter.addLeadingZero(minute) + ":" + NumberFormatter.addLeadingZero(seconds);
		}

		/**
		 *  日期格式
		 * y-m-d h:m
		 */
		static public function formatDate(newValue:Number):String {
			var date:Date = new Date();
			date.time = newValue;
			return NumberFormatter.addLeadingZero(date.fullYear)
				+ "-" + NumberFormatter.addLeadingZero(date.month + 1)
				+ "-" + NumberFormatter.addLeadingZero(date.date)
				+ " " + NumberFormatter.addLeadingZero(date.hours)
				+ ":" + NumberFormatter.addLeadingZero(date.minutes);
		}

		static public function formatMilliseconds(v:Number):String {
			return formatSeconds(v / 1000);
		}
	}
}
