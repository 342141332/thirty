package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.PointEmitter;
	
	import flash.geom.Point;


	/**
	 * @author lifeng
	 * @create on 2013-12-19
	 */
	public class GParticleCase extends GMain {
		private var emitter:PointEmitter;
		public function GParticleCase(id:String = null) {
			super(id);
			
			emitter = new PointEmitter(stage, ParticleDisplay);
			emitter.emissionRate = 3;
			emitter.position = new Point(200, 200);
			emitter.particleLife = 2000;
			emitter.particleLifeVar = 5000;
			emitter.particleScale = 2;
			emitter.particleScaleVar = .1;
			emitter.particleGrowRatio = .7;
			emitter.particleShrinkRatio = .2;
			emitter.particleSpeed = 1;
			emitter.particleSpeedVar = 2;
			emitter.particleOmegaVar = 10;
			enableTick = true;
		}
		
		override public function tick(interval:int):void {
			emitter.update(interval);
		}
	}
}
import flash.display.Sprite;

class ParticleDisplay extends Sprite {
	public function ParticleDisplay() {
		super();
		
		graphics.beginFill(0x0000ff);
		graphics.drawCircle(2, 2, 2);
		graphics.endFill();
	}
}