package {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import com.gearbrother.glash.util.lang.GStringUtils;


	/**
	 * @author feng.lee
	 * create on 2012-5-24 下午5:09:03
	 */
	public class GCommonStringCase extends Sprite {
		public function GCommonStringCase() {
			trace(GStringUtils.substitute("[${enemy}${name}(${id}, ${confID}), hp=${currentHp} / ${fullHp}, pos=${pos}]"
				, {
					enemy: "-"
					, name: "peter"
					, id: "123"
					, confID: "42134"
					, currentHp: "330"
					, fullHp: "530"
					, anger: 500
					, dead: false
					, pos: new Point(2, 3)}));
		}
	}
}
