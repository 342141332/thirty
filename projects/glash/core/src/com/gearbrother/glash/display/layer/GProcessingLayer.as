package com.gearbrother.glash.display.layer {
	import com.gearbrother.glash.common.oper.GOper;
	import com.gearbrother.glash.display.layout.impl.CenterLayout;
	import com.gearbrother.glash.display.propertyHandler.GPropertyPoolOperProcessingListener;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	/**
	 * 素材加载, 数据加载, 操作.. 等待框
	 * 初始化资源加载等待框
	 * 为了避免数据频繁交换而造成等待框频繁闪现造成的视觉疲劳，定为0.5秒前只屏蔽操作，0.5秒后显示等待框.这样只要数据在0.5秒前返回便不会出现等待框.
	 *
	 * @author feng.lee
	 * create on 2012-6-11 下午8:22:33
	 * @see com.gearbrother.glash.common.resource.GResourceLoader
	 */
	public class GProcessingLayer extends GAlertLayer implements GPropertyPoolOperProcessingListener {
		static public const logger:ILogger = getLogger(GProcessingLayer);
		
		private var _opers:Array;
		public function get opers():Array {
			return _opers;
		}

		public function GProcessingLayer() {
			super();

			maskColor = 0x000000;
			maskAlpha = .1;

			layout = new CenterLayout();
			_opers = [];
		}

		public function addOper(newValue:GOper):void {
			_opers.push(newValue);
			if (newValue.state == GOper.STATE_END) {
				//do nothing
			} else {
				refresh(0);
			}
		}
		
		public function removeOper(newValue:GOper):void {
			var at:int = _opers.indexOf(newValue);
			_opers.splice(at, 1);
		}
	}
}
