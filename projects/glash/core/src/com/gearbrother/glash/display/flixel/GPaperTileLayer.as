package com.gearbrother.glash.display.flixel {
	import com.gearbrother.glash.common.geom.GDimension;
	import com.gearbrother.glash.common.oper.ext.GFile;
	import com.gearbrother.glash.util.camera.Camera;
	import com.gearbrother.glash.util.math.GMathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GPaperTileLayer extends GPaperLayer {
		protected var _layer:IGPaperTile;
		protected var _pool:Object;
		protected var _overviewUrl:GFile;
		protected var _overviewScaling:Number;

		public function GPaperTileLayer(camera:Camera, layer:IGPaperTile, overviewUrl:GFile, overviewScaling:int) {
			super(camera);

//			_boxsGrid = new BoxsGrid2(paper.camera.bound, layer.getTileSize(0).width, layer.getTileSize(0).height);
			_layer = layer;
			_pool = {};
			_overviewUrl = overviewUrl;
			_overviewScaling = overviewScaling;
			opaqueBackground = 0x0;
			cacheAsBitmap = true;
		}

		override public function tick(interval:int):void {
			var tileSize:GDimension = _layer.getTileSize(camera.zoom);
//			_boxsGrid.reset(tileSize.width, tileSize.height);

			var p:Rectangle = camera.screenRect.clone();
//			p.inflate(exScreenRect, exScreenRect);
			p = p.intersection(camera.bound);
			var vaildLeft:int = GMathUtil.roundDownToMultiple(p.x, tileSize.width);
			var vaildRight:int = GMathUtil.roundUpToMultiple(p.x + p.width, tileSize.width);
			var vaildTop:int = GMathUtil.roundDownToMultiple(p.y, tileSize.height);
			var vaildBottom:int = GMathUtil.roundUpToMultiple(p.y + p.height, tileSize.height);
			for (var vaildX:int = vaildLeft; vaildX < vaildRight; vaildX += tileSize.width) {
				for (var vaildY:int = vaildTop; vaildY < vaildBottom; vaildY += tileSize.height) {
					var file:GFile = _layer.getTile(vaildX, vaildY, camera.zoom);
					if (_pool[file.src] == null) {
						var bmp:TileBmp = new TileBmp(vaildX, vaildY, camera.zoom, _layer, _overviewUrl, _overviewScaling);
						addChild(bmp);
						_pool[file.src] = bmp;
					}
				}
			}

			super.tick(interval);
		}
	}
}
import com.gearbrother.glash.GMain;
import com.gearbrother.glash.common.geom.GDimension;
import com.gearbrother.glash.common.oper.GOper;
import com.gearbrother.glash.common.oper.GOperEvent;
import com.gearbrother.glash.common.oper.ext.GFile;
import com.gearbrother.glash.common.oper.ext.GLoadOper;
import com.gearbrother.glash.display.GBitmap;
import com.gearbrother.glash.display.flixel.IGPaperTile;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;



/**
 * 位图地图背景块
 * @author feng.lee
 * create on 2012-7-4 下午12:03:33
 */
class TileBmp extends GBitmap {
	public var zoom:int;
	
	private var _tile:IGPaperTile;
	
	private var _tmpBmp:BitmapData;
	
	private var _source:BitmapData;
	public function set source(v:BitmapData):void {
		if (_tmpBmp) {
			_tmpBmp.dispose();
			_tmpBmp = null;
		}
		bitmapData = _source = v;
	}

	private var _load:GLoadOper;
	private function set load(value:GLoadOper):void {
		if (_load != value) {
			if (_load) {
				_load.removeEventListener(GOperEvent.OPERATION_COMPLETE, handleLoadEvent);
			}
			_load = value;
			if (_load) {
				_load.addEventListener(GOperEvent.OPERATION_COMPLETE, handleLoadEvent);
			}
		}
	}
	private var _overviewLoad:GLoadOper;
	private function set overviewload(value:GLoadOper):void {
		if (_overviewLoad != value) {
			if (_overviewLoad) {
				_overviewLoad.removeEventListener(GOperEvent.OPERATION_COMPLETE, handleLoadEvent);
			}
			_overviewLoad = value;
			if (_overviewLoad) {
				_overviewLoad.addEventListener(GOperEvent.OPERATION_COMPLETE, handleLoadEvent);
			}
		}
	}

	private var _overviewFile:GFile;

	private var _overviewScaling:Number;

	public function TileBmp(x:int, y:int, zoom:int, tile:IGPaperTile, overviewUrl:GFile, overviewScaling:int) {
		super();

		this.x = x;
		this.y = y;
		this.zoom = zoom;
		_tile = tile;
		_overviewFile = overviewUrl;
		_overviewScaling = overviewScaling;
//		load = GMain.instance.pool.getInstance(_tile.getTile(x, y, zoom)) as GFile;
//		overviewload = GMain.instance.pool.getInstance(_overviewFile) as GFile;
//		bitmapData = new BitmapData(_tile.getTileSize(zoom).width, _tile.getTileSize(zoom).height, false, GColorUtil.randomColor());
	}
	
	private function handleLoadEvent(event:GOperEvent):void {
		var target:GLoadOper = event.target as GLoadOper;
		switch (target.resultType) {
			case GOper.RESULT_TYPE_SUCCESS:
				if (target == _load) {
					source = (target.content as Bitmap).bitmapData;
				} else if (target == _overviewLoad) {
					if (!_source) {
						var overviewBmd:BitmapData = target.content.bitmapData;
						var size:GDimension = _tile.getTileSize(zoom);
						var cutRect:Rectangle = new Rectangle(x / _overviewScaling, y / _overviewScaling, size.width / _overviewScaling, size.height / _overviewScaling);
						var cutBmd:BitmapData = new BitmapData(cutRect.width, cutRect.height, false);
						cutBmd.copyPixels(overviewBmd, cutRect, new Point);
						_tmpBmp = new BitmapData(size.width, size.height, false);
						var matrix:Matrix = new Matrix();
						matrix.scale(_overviewScaling, _overviewScaling);
						_tmpBmp.draw(cutBmd, matrix);
						cutBmd.dispose();
						bitmapData = _tmpBmp;
					}
				} else {
					throw new Error("unknown target");
				}
				break;
			case GOper.RESULT_TYPE_ERROR:
				break;
		}
	}

	override protected function doDispose():void {
		load = null;
		overviewload = null;
		if (_tmpBmp)
			_tmpBmp.dispose();
		
		super.doDispose();
	}
}