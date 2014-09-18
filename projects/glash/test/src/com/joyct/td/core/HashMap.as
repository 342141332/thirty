package com.joyct.td.core
{
    import flash.utils.*;

    public class HashMap extends Object
    {
        private var _keys:Array = null;
        private var props:Dictionary = null;

        public function HashMap()
        {
            this.clear();
            return;
        }// end function

        public function clear() : void
        {
            this.props = new Dictionary();
            this._keys = new Array();
            return;
        }// end function

        public function containsKey(param1:Object) : Boolean
        {
            return this.props[param1] != null;
        }// end function

        public function containsValue(param1:Object) : Boolean
        {
            var _loc_4:uint = 0;
            var _loc_2:Boolean = false;
            var _loc_3:* = this.size();
            if (_loc_3 > 0)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    if (this.props[this._keys[_loc_4]] == param1)
                    {
                        _loc_2 = true;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_2;
        }// end function

        public function getValue(param1:Object) : Object
        {
            return this.props[param1];
        }// end function

        public function put(param1:Object, param2:Object) : Object
        {
            var _loc_3:Object = null;
            if (this.containsKey(param1))
            {
                _loc_3 = this.getValue(param1);
                this.props[param1] = param2;
            }
            else
            {
                this.props[param1] = param2;
                this._keys.push(param1);
            }
            return _loc_3;
        }// end function

        public function remove(param1:Object) : Object
        {
            var _loc_3:int = 0;
            var _loc_2:Object = null;
            if (this.containsKey(param1))
            {
                delete this.props[param1];
                _loc_3 = this._keys.indexOf(param1);
                if (_loc_3 > -1)
                {
                    this._keys.splice(_loc_3, 1);
                }
            }
            return _loc_2;
        }// end function

        public function putAll(param1:HashMap) : void
        {
            var _loc_3:Array = null;
            var _loc_4:uint = 0;
            this.clear();
            var _loc_2:* = param1.size();
            if (_loc_2 > 0)
            {
                _loc_3 = param1.keys();
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    this.put(_loc_3[_loc_4], param1.getValue(_loc_3[_loc_4]));
                    _loc_4 = _loc_4 + 1;
                }
            }
            return;
        }// end function

        public function size() : uint
        {
            return this._keys.length;
        }// end function

        public function isEmpty() : Boolean
        {
            return this.size() < 1;
        }// end function

        public function values() : Array
        {
            var _loc_3:uint = 0;
            var _loc_1:* = new Array();
            var _loc_2:* = this.size();
            if (_loc_2 > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1.push(this.props[this._keys[_loc_3]]);
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_1;
        }// end function

        public function keys() : Array
        {
            return this._keys;
        }// end function

    }
}
