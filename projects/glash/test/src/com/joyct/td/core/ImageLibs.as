package com.joyct.td.core
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ImageLibs extends EventDispatcher
    {
        private var num:int = 0;
        private var maxNo:int = 0;
        private var _top:int = 0;
        private var _left:int = 0;
        private var _bottom:int = 0;
        private var _width:int = 0;
        private var _height:int = 0;
        private var list:HashMap;
        private var loadIndex:int = 0;

        public function ImageLibs()
        {
            this.list = new HashMap();
            return;
        }// end function

        public function clear() : void
        {
            this.num = 0;
            this.list.clear();
            this.maxNo = 0;
            this.loadIndex = 0;
            this._width = 0;
            this._height = 0;
            this._left = 0;
            var _loc_1:int = 0;
            this._bottom = 0;
            this._top = _loc_1;
            return;
        }// end function

        public function addImage(param1:Bitmap) : void
        {
            return;
        }// end function

        private function getCutBitmapData(param1:BitmapData, param2:Rectangle) : BitmapData
        {
            var _loc_3:* = new BitmapData(param2.width, param2.height);
            _loc_3.copyPixels(param1, param2, new Point(0, 0));
            return _loc_3;
        }// end function

        public function removeImage(param1:Array) : void
        {
            return;
        }// end function

        public function get(param1:int) : Object
        {
            return this.list.getValue(param1);
        }// end function

        public function size() : int
        {
            return this.list.size();
        }// end function

        public function keys() : Array
        {
            return this.list.keys();
        }// end function

        public function LoadFromBytes(param1:ByteArray, param2:int = 0) : void
        {
            var _loc_5:Array = null;
            var _loc_6:MyLoader = null;
            var _loc_7:int = 0;
            var _loc_8:ByteArray = null;
            this.clear();
            this.num = param1.readByte();
            this.maxNo = param1.readByte();
            this._width = param1.readShort();
            this._height = param1.readShort();
            this._top = param1.readShort();
            this._bottom = param1.readShort();
            if (param2 > 1)
            {
                this._left = param1.readShort();
            }
            else
            {
                this._left = this._width / 2;
            }
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this.num)
            {
                
                _loc_5 = [];
                _loc_6 = new MyLoader();
                _loc_7 = param1.readByte();
                _loc_6.index = _loc_7;
                _loc_6.left = param1.readShort();
                _loc_6.top = param1.readShort();
                _loc_6.bottom = param1.readShort();
                _loc_3 = param1.readInt();
                _loc_8 = new ByteArray();
                param1.readBytes(_loc_8, 0, _loc_3);
                _loc_6.loadBytes(_loc_8);
                _loc_6.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
                _loc_4++;
            }
            return;
        }// end function

        private function onLoadComplete(event:Event) : void
        {
            var _loc_5:Event = null;
            var _loc_2:* = LoaderInfo(event.currentTarget).loader as MyLoader;
            var _loc_3:* = _loc_2.content as Bitmap;
            var _loc_4:* = _loc_2.index;
            this.list.put(_loc_4, [_loc_3.bitmapData, _loc_2.left, _loc_2.top, _loc_2.bottom]);
            _loc_2.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
            _loc_2.unload();
            _loc_2 = null;
            var _loc_6:ImageLibs = this;
            var _loc_7:* = this.loadIndex + 1;
            _loc_6.loadIndex = _loc_7;
            if (this.loadIndex == this.num)
            {
                _loc_5 = new Event("complete");
                dispatchEvent(_loc_5);
            }
            return;
        }// end function

        public function get top() : int
        {
            return this._top;
        }// end function

        public function get bottom() : int
        {
            return this._bottom;
        }// end function

        public function get width() : int
        {
            return this._width;
        }// end function

        public function get height() : int
        {
            return this._height;
        }// end function

        public function get left() : int
        {
            return this._left;
        }// end function

        public function set left(param1:int) : void
        {
            this._left = param1;
            return;
        }// end function

        public function gc() : void
        {
            var _loc_3:BitmapData = null;
            var _loc_1:* = this.list.keys();
            var _loc_2:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_1.length)
            {
                
                _loc_2 = _loc_1[_loc_4];
                _loc_3 = this.list.getValue(_loc_2)[0] as BitmapData;
                _loc_3.dispose();
                _loc_3 = null;
                _loc_4++;
            }
            return;
        }// end function

    }
}
