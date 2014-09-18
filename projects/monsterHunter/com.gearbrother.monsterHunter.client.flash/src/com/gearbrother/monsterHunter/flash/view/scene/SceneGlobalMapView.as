package com.gearbrother.monsterHunter.flash.view.scene {
	import com.gearbrother.glash.display.GSkinSprite;
	import com.gearbrother.glash.display.GSprite;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.container.GScrollBase;
	import com.gearbrother.glash.display.control.GButtonLite;
	import com.gearbrother.glash.display.mouseMode.GDragScrollMode;
	import com.gearbrother.glash.util.math.GRandomUtil;
	import com.gearbrother.monsterHunter.flash.GameMain;
	import com.gearbrother.monsterHunter.flash.command.GameCommandMap;
	import com.gearbrother.monsterHunter.flash.event.ExploreMapEvent;
	import com.gearbrother.monsterHunter.flash.model.GameModel;
	import com.gearbrother.monsterHunter.flash.scene.EntryMapSkin;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;


	/**
	 * 游戏大地图
	 *
	 * @author feng.lee
	 * create on 2013-1-28
	 */
	public class SceneGlobalMapView extends GContainer {
		private var _entries:Array;

		private var _connectLineLayer:GSprite;

		public function SceneGlobalMapView() {
			super();

			var entryMapSkin:EntryMapSkin;
			addChild(new GSkinSprite(entryMapSkin = new EntryMapSkin()));
			addChild(_connectLineLayer = new GSprite());
			cacheAsBitmap = true;
			_entries = [];
			for (var i:int = 1; ; i++) {
				var entrySkin:DisplayObject = entryMapSkin["entry" + i];
				if (entrySkin) {
					entrySkin.parent.removeChild(entrySkin);
					var entry:EntryButton;
					_entries.push(entry = new EntryButton(entrySkin, _connectLineLayer));
					entry._label.value = GRandomUtil.integer(10, 1000) + " Hunters in";
					addChild(entry);
					if (_entries.hasOwnProperty(i - 2))
						entry.connects = [_entries[i - 2]];
				} else {
					break;
				}
			}

			addEventListener(MouseEvent.CLICK, _handleMouseEvent);
			new GDragScrollMode(this);
		}

		override protected function doInit():void {
			super.doInit();

			var entry:EntryButton;
			(entry = _entries[GameModel.instance.loginedUser.mapID] as EntryButton).selected = true;
			TweenLite.to(this, .7, {scrollH: entry.x - (stage.stageWidth >> 1), scrollV: entry.y});
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target is EntryButton) {
				GameCommandMap.instance._eventDispatcher.dispatchEvent(ExploreMapEvent.getGetEvent(_entries.indexOf(event.target)));
			}
		}
	}
}
import com.gearbrother.glash.display.GSkinSprite;
import com.gearbrother.glash.display.GSprite;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.display.graphics.DashedLine;
import com.gearbrother.glash.util.display.GSearchUtil;
import com.gearbrother.monsterHunter.flash.scene.CurrentSelect;

import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.JointStyle;
import flash.display.Shape;
import flash.text.TextField;

class EntryButton extends GSkinSprite {
	public var _label:GText;

	private var _connectLayer:GSprite;

	private var _dashedLine:DashedLine;

	/**
	 * 链接其他地点的线
	 */
	private var _connectLines:Array;

	private var _connects:Array;

	public function set connects(newValue:Array):void {
		_connects = newValue;

//		var dotLine:Shape = new Shape();
//		dotLine.graphics.lineStyle(3, 0x826445, 1, false, "normal", CapsStyle.ROUND, JointStyle.ROUND);
//		dotLine.graphics.lineTo(7, 0);
//		dotLine.graphics.lineStyle(3, 0x826445, 0, false, "normal", CapsStyle.ROUND, JointStyle.ROUND);
//		dotLine.graphics.moveTo(7, 0);
//		dotLine.graphics.lineTo(10, 0);
//		var bmd:BitmapData = new BitmapData(10, 3);
//		bmd.draw(dotLine);
		_dashedLine.lineStyle(3, 0x826445, 1);
		_dashedLine.setDash(5, 7);
		for each (var connect:EntryButton in _connects) {
			//TODO change to dottedline
//			_connectLayer.graphics.lineStyle(3);
//			_connectLayer.graphics.lineBitmapStyle(bmd, null, true, true);
//			_connectLayer.graphics.moveTo(x, y);
//			_connectLayer.graphics.lineTo(connect.x, connect.y);
//			_connectLayer.graphics.curveTo(this.x, connect.y, connect.x, connect.y);
			_dashedLine.moveTo(x, y);
			_dashedLine.curveTo(this.x, connect.y, connect.x, connect.y);
		}
	}

	private var _selectView:DisplayObject;

	override public function set selected(newValue:Boolean):void {
		super.selected = newValue;

		if (selected && !_selectView) {
			_selectView = new GSkinSprite(new CurrentSelect());
			_selectView.name = "CurrentSelect";
			addChildAt(_selectView, 0);
		} else if (!selected && _selectView) {
			removeChild(_selectView);
			_selectView = null;
		}
	}

	public function EntryButton(skin:DisplayObject, connectLayer:GSprite) {
		super(skin);

		_label = new GText(GSearchUtil.findChildByClass(skin, TextField));
		_connectLayer = connectLayer;
		_dashedLine = new DashedLine(_connectLayer.graphics);
		buttonMode = true;
		mouseChildren = false;
	}
}
