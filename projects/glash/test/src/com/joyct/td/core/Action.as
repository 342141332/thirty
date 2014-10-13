package com.joyct.td.core
{
    import flash.utils.*;

    public class Action extends Object
    {
        public var type:int = 0;
        public var indexs:Array;
        public var speed:int = 0;
        public var repeat:int = 0;
        public var px:int = 0;
        public var py:int = 0;
        public static const STAND:int = 0;
        public static const ATTACK:int = 1;
        public static const WALK:int = 2;
        public static const DIE:int = 3;

        public function Action() : void
        {
            this.indexs = [];
            return;
        }// end function

        public function loadFromBytes(param1:ByteArray, param2:int) : void
        {
            this.type = param1.readByte();
            var _loc_3:* = param1.readByte();
            this.indexs = [];
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                this.indexs.push(param1.readByte());
                _loc_4++;
            }
            this.speed = param1.readByte();
            this.repeat = param1.readByte();
            if (param2 == 0)
            {
                this.px = param1.readShort();
                this.py = param1.readShort();
            }
            return;
        }// end function

    }
}
