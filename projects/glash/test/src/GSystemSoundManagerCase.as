package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.common.collections.ArrayList;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.media.GSoundChannel;
	
	import flash.events.MouseEvent;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	

	/**
	 * @author feng.lee
	 * create on 2012-5-26 下午11:43:12
	 */
	[SWF(width = "800", height = "500", frameRate = "60")]
	public class GSystemSoundManagerCase extends GMain {
		private var sounds:ArrayList = new ArrayList();
		
		private var index:int = 0;
		
		private var channel:GSoundChannel;

		public function GSystemSoundManagerCase() {
			super();

			channel = new GSoundChannel();
			sounds[0] = new URLRequest("../asset/sound/button.mp3");
			sounds[1] = new URLRequest("../asset/sound/f8i746.MP3");
			stage.addEventListener(MouseEvent.CLICK, handleMouseEvent);
		}
		
		private function handleMouseEvent(event:MouseEvent):void {
			if (index == sounds.length)
				index = 0;
			channel.playURL(sounds[index++], -1, 1, 1);
		}
	}
}
