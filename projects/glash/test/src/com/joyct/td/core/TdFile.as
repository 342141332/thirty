package com.joyct.td.core
{
    import flash.events.*;
    import flash.utils.*;

    public class TdFile extends EventDispatcher
    {
        private var ba:ByteArray;
        public var imageList:ImageLibs;
        public var actionList:HashMap;
        private var _ready:Boolean;
        private var _version:int;

        public function TdFile()
        {
            this.ba = new ByteArray();
            this.actionList = new HashMap();
            this.imageList = new ImageLibs();
            return;
        }// end function

        public function get version() : int
        {
            return this._version;
        }// end function

        public function set version(param1:int) : void
        {
            this._version = param1;
            return;
        }// end function

        private function writeTag() : void
        {
            return;
        }// end function

        public function gc() : void
        {
            this.imageList.gc();
            this.clear();
            return;
        }// end function

        public function clear() : void
        {
            this.ba.position = 0;
            this.actionList.clear();
            this.imageList.clear();
            return;
        }// end function

        public function loadFromBytes(param1:ByteArray) : void
        {
            this.ba.clear();
            var _loc_2:* = param1.readByte();
            var _loc_3:* = param1.readByte();
            if (_loc_2 != 84 && _loc_3 != 68)
            {
                return;
            }
            this._version = param1.readByte();
            this.readActionsFromBytes(param1, this._version);
            this.imageList.LoadFromBytes(param1, this._version);
            this.imageList.addEventListener("complete", this.onImageComplete);
            return;
        }// end function

        private function readActionsFromBytes(param1:ByteArray, param2:int) : void
        {
            var _loc_5:Action = null;
            this.actionList.clear();
            var _loc_3:* = param1.readByte();
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = new Action();
                _loc_5.loadFromBytes(param1, param2);
                this.actionList.put(_loc_5.type, _loc_5);
                _loc_4++;
            }
            return;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        private function onImageComplete(event:Event) : void
        {
            this._ready = true;
            this.imageList.removeEventListener("complete", this.onImageComplete);
			dispatchEvent(new Event(Event.COMPLETE));
        }// end function

    }
}
