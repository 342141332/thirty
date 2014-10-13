package com.joyct.td.core
{
    import flash.display.*;

    public class Animation extends Sprite
    {
        public var iSetting:JSetting;
        private var iAction:Object;
        private var imgLib:ImageLibs;
        private var bitmap:Bitmap;
        private var iData:Object;
        private var pakName:String = "";

        public function Animation()
        {
            mouseEnabled = false;
            mouseChildren = false;
            this.iSetting = new JSetting();
            this.bitmap = new Bitmap();
            this.bitmap.smoothing = true;
            addChild(this.bitmap);
            return;
        }// end function

        public function realHeight() : int
        {
            if (this.ready)
            {
                return this.iData.data.imageList.top;
            }
            return 0;
        }// end function

        public function load(param1:String, param2:String) : void
        {
            this.pakName = param1 + "@" + param2;
            if (this.iData)
            {
                Game.getInstance().aniManager.decRef(this.iData);
                this.iData = null;
            }
            this.iData = Game.inst.aniManager.getAni(param1, param2);
            Game.getInstance().aniManager.incRef(this.iData);
            if (this.iData.loaded == false && this.iData.loading == false)
            {
                Game.inst.aniManager.loadPak(this.iData);
            }
            return;
        }// end function

        private function reload() : void
        {
            var _loc_1:* = this.pakName.split("@");
            this.load(_loc_1[0], _loc_1[1]);
            return;
        }// end function

        public function unload() : void
        {
            if (this.iData && this.iData.loaded)
            {
                Game.getInstance().aniManager.decRef(this.iData);
                this.iData = null;
                this.bitmap.bitmapData = null;
                this.bitmap = null;
            }
            return;
        }// end function

        public function nextframe() : void
        {
            if (this.iData.loaded == false && this.iData.loading == false)
            {
                this.reload();
            }
            this.iSetting.nextFrame(this.iAction);
            return;
        }// end function

        public function get ready() : Boolean
        {
            if (this.iData)
            {
                if (this.iData.data)
                {
                    if (this.iData.data.ready)
                    {
                        return true;
                    }
                    return false;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }// end function

        public function draw(param1:Boolean = false) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Array = null;
            var _loc_4:* = undefined;
            if (this.ready == false)
            {
                return;
            }
            if (x == 0 && y == 0)
            {
                x = -this.iData.data.imageList.left;
                if (param1)
                {
                    scaleX = -1;
                    x = x + this.iData.data.imageList.width;
                }
                y = -this.iData.data.imageList.height + this.iData.data.imageList.bottom;
            }
            if (this.iSetting.ending)
            {
                return;
            }
            if (this.iSetting.currFrameDelay != 0)
            {
                return;
            }
            this.iAction = this.iData.data.actionList.getValue(this.iSetting.action);
            if (this.iAction && this.iSetting)
            {
                _loc_2 = this.iAction.indexs[this.iSetting.currFrame];
                _loc_3 = this.iData.data.imageList.get(_loc_2) as Array;
                if (_loc_3 == null)
                {
                    return;
                }
                _loc_4 = _loc_3[0];
                if (_loc_4 == null)
                {
                    return;
                }
                this.bitmap.bitmapData = _loc_4;
                this.bitmap.x = _loc_3[1];
                this.bitmap.y = _loc_3[2];
            }
            return;
        }// end function

    }
}
