package com.gearbrother.monsterHunter.flash.model {
	import com.gearbrother.glash.common.resource.type.GFile;
	import com.gearbrother.glash.mvc.model.GBean;
	import com.gearbrother.monsterHunter.flash.view.scene.SceneExploreMapView;
	
	import flash.display.Sprite;
	import flash.geom.Point;


	/**
	 * @author feng.lee
	 * create on 2012-8-28 下午1:37:57
	 */
	public class ExploreMapModel extends GBean {
		static public const SETTLE_NODE:String = "PveMap::SETTLE_NODE";

		public function get settleable():Boolean {
			return true;
		}

		public var backgoundSrc:GFile;

		public var id:*;

		public var name:String;

		public var desc:String;

		public var monsters:Array;
		
		public var hunters:Array;

		public function get sceneView():Class {
			return SceneExploreMapView;
		}

		public function get sceneSound():GFile {
			return null;
		}

		public function ExploreMapModel() {
			monsters = [];
			hunters = [];
		}
	}
}
