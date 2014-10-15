package com.joyct.td.core
{
    import com.greensock.events.*;
    import com.greensock.loading.*;
    import flash.utils.*;

    public class PackageManager extends Object
    {
        private var iLoader:LoaderMax;
        private var cache:Object;
        private var efun:Function;
        private var pfun:Function;
        private var multiLoad:Boolean;
        public var pauseGC:Boolean = true;

        public function PackageManager()
        {
            this.iLoader = new LoaderMax({name:"mainQueue", onProgress:this.progressHandler, onComplete:this.completeHandler, onError:this.errorHandler, onChildComplete:this.ChildCompleteHandle, auditSize:false});
            this.cache = {};
            this.cache.data = new Object();
            this.cache.effect = new Object();
            this.cache.bullet = new Object();
            Game.getInstance().frameTimer.add(24 * 300, 0, this.gc);
            return;
        }// end function

        function progressHandler(event:LoaderEvent) : void
        {
            var _loc_2:* = Math.ceil(this.iLoader.rawProgress * 100);
            if (this.pfun)
            {
                this.pfun(_loc_2);
            }
            return;
        }// end function

        private function ChildCompleteHandle(event:LoaderEvent) : void
        {
            var _loc_2:* = String(event.target.name).split("@");
            var _loc_3:* = _loc_2[0];
            var _loc_4:* = _loc_2[1];
            var _loc_5:* = event.target.content as ByteArray;
            this.cache[_loc_3][_loc_4].loaded = true;
            this.cache[_loc_3][_loc_4].loading = false;
            var _loc_6:* = new TdFile();
            new TdFile().loadFromBytes(_loc_5);
            this.cache[_loc_3][_loc_4].data = _loc_6;
            return;
        }// end function

        function errorHandler(event:LoaderEvent) : void
        {
            var _loc_2:* = String(event.target.name).split("@");
            var _loc_3:* = _loc_2[0];
            var _loc_4:* = _loc_2[1];
            this.cache[_loc_3][_loc_4].loaded = false;
            this.cache[_loc_3][_loc_4].loading = false;
            this.cache[_loc_3][_loc_4].data = null;
            return;
        }// end function

        function completeHandler(event:LoaderEvent) : void
        {
            if (this.efun)
            {
                this.efun();
            }
            this.efun = null;
            this.pfun = null;
            return;
        }// end function

        public function getAni(param1:String, param2:String) : Object
        {
            var _loc_3:* = this.cache[param1][param2];
            if (!_loc_3)
            {
                _loc_3 = {category:param1, name:param2, loaded:false, loading:false, ref:0};
                this.cache[param1][param2] = _loc_3;
            }
            return _loc_3;
        }// end function

        public function loadMultiPak(param1:Array, param2:Function, param3:Function) : void
        {
            var _loc_6:Object = null;
            this.multiLoad = true;
            this.efun = param3;
            this.pfun = param2;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            while (_loc_5 < param1.length)
            {
                
                if (param1[_loc_5] < 1)
                {
                    _loc_4++;
                }
                else
                {
                    _loc_6 = this.getAni(param1[_loc_5][0], param1[_loc_5][1]);
                    if (_loc_6.loaded == false && _loc_6.loading == false)
                    {
                        this.addFile(_loc_6);
                    }
                    else
                    {
                        _loc_4++;
                    }
                }
                _loc_5++;
            }
            if (_loc_4 == param1.length)
            {
                this.completeHandler(null);
            }
            else
            {
                this.iLoader.load();
            }
            return;
        }// end function

        public function loadPak(param1:Object) : void
        {
            this.multiLoad = false;
            this.addFile(param1);
            this.iLoader.load();
            return;
        }// end function

        private function addFile(param1:Object) : void
        {
            var _loc_2:* = Version.getUrl("images/" + param1.category + "/" + param1.name + ".pak");
            this.cache[param1.category][param1.name].loading = true;
            this.iLoader.append(new BinaryDataLoader(_loc_2, {name:param1.category + "@" + param1.name}));
            return;
        }// end function

        public function incRef(param1:Object) : void
        {
            var _loc_2:* = param1;
            var _loc_3:* = param1.ref + 1;
            _loc_2.ref = _loc_3;
            if (param1.rtime)
            {
                delete param1.rtime;
            }
            return;
        }// end function

        public function decRef(param1:Object) : void
        {
            var _loc_2:int = 0;
            var _loc_3:* = param1;
            var _loc_4:* = param1.ref - 1;
            _loc_3.ref = _loc_4;
            if (param1.ref <= 0)
            {
                _loc_2 = new Date().getTime() / 1000;
                param1.rtime = _loc_2;
            }
            return;
        }// end function

        private function gc() : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            if (this.pauseGC)
            {
                return;
            }
            var _loc_1:* = new Date().getTime() / 1000;
            for (_loc_3 in this.cache.data)
            {
                
                _loc_2 = this.cache.data[_loc_3];
                if (_loc_2.rtime && _loc_1 - _loc_2.rtime > 60)
                {
                    this.freeAnimation(_loc_2);
                    delete this.cache.data[_loc_3];
                }
            }
            return;
        }// end function

        private function freeAnimation(param1:Object) : void
        {
            if (!param1.loaded)
            {
                return;
            }
            var _loc_2:* = param1.data;
            _loc_2.gc();
            _loc_2 = null;
            return;
        }// end function

    }
}
