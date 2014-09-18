package com.gearbrother.glash.display.control {
	import com.gearbrother.glash.common.oper.ext.GSoundOper;
	import com.gearbrother.glash.display.animation.GAnimation;
	
	import flash.geom.ColorTransform;
	
	import org.as3commons.lang.ICloneable;

	/**
	 * @author feng.lee
	 * create on 2012-9-26 下午3:26:05
	 */
	public class GButtonState implements ICloneable {
		/**
		 * 将未设置的状态置为默认值
		 */
		static public var resetToDefault:Boolean = true;

		/**
		 * 鼠标状态对应的颜色变化
		 */
		public var colorTransform:ColorTransform;

		/**
		 * 鼠标状态对应的filters变化
		 */
		public var filters:Array;

		/**
		 * 鼠标状态对应的skin变化
		 */
		public var skin:*;

		/**
		 * 鼠标状态对应的Oper
		 */
		public var oper:GAnimation;

		/**
		 * 鼠标状态对应的声音
		 */
		public var sound:*;

		/**
		 * 文字样式
		 */
		public var textFormat:*;

		/**
		 * 是否重置默认文字样式。设置后中途修改文字将不会恢复原本的颜色。
		 */
		public var overrideDefaultTextFormat:Boolean = false;
		
		public function GButtonState() {
		}

		public function parse(target:GButtonLite):void {
//			if (skin)
//				target.skin = skin;

			if (colorTransform != null)
				target.transform.colorTransform = colorTransform;
			else if (resetToDefault)
				target.transform.colorTransform = new ColorTransform();

			if (filters != null)
				target.filters = filters;
			else if (resetToDefault)
				target.filters = [];

			if (oper) {
				if (oper is GAnimation && !(oper as GAnimation).target)
					(oper as GAnimation).target = target;

				oper.execute();
			}

			if (sound) {
				if (!(sound is GSoundOper))
					sound = new GSoundOper(sound);

				(sound as GSoundOper).execute();
			}

			/*if (target is GButtonBase && (target as GButtonBase).label) {
				var textField:GRichText = (target as GButtonBase).label;
				if (textFormat) {
					var t:TextFormat;
					if (textFormat is TextFormat)
						t = textFormat as TextFormat;
					else
						t = GObjectUtil.createObject(TextFormat, textFormat);
				}
			}*/
		}

		/**
		 * 复制
		 * @return
		 *
		 */
		public function clone():* {
			var clone:GButtonState = new GButtonState();
			clone.colorTransform = this.colorTransform;
			clone.filters = this.filters;
			clone.skin = this.skin;
			clone.oper = this.oper;
			return clone;
		}
	}
}
