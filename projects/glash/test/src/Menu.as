package com.demonsters.debugger.game.ui.menus
{
    import com.demonsters.assets.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.utils.*;

    public class Menu extends MenuWhiteBackground
    {
        private var _overlay:Sprite;
        private var _shader:Shader;
        private var _shaderFilter:ShaderFilter;
        private var pbFilter:Class;
        public var _strength:Number = 1;
        public var _backgroundWidth:Number = 0;
        public var _backgroundHeight:Number = 0;
        public var _greyOverlay:Boolean;
        public static const WOBBLE_DONE:String = "wobbleDone";
        public static const WOBBLEOUT_DONE:String = "wobbbleOutDone";
        public static const WOBBLE_SWITCH:String = "wobbleSwitch";
        public static const WOBBLE_START:String = "wobbleStart";
        public static const BACK:String = "back";

        public function Menu()
        {
            this.pbFilter = Menu_pbFilter;
            this._greyOverlay = false;
            this._overlay = new Sprite();
            addChildAt(this._overlay, 0);
            backgroundWhite.x = int(800 / 2);
            backgroundWhite.y = int(600 / 2);
            this._shader = new Shader(new this.pbFilter() as ByteArray);
            this._shader.data.center.value = [800 / 2, 600 / 2];
            this._shader.data.innerRadius.value = [0];
            this._shader.data.outerRadius.value = [500];
            this._shader.data.magnification.value = [this._strength];
            this._shaderFilter = new ShaderFilter(this._shader);
            filters = [this._shaderFilter];
            return;
        }// end function

        public function set greyOverlay(param1:Boolean) : void
        {
            this._greyOverlay = param1;
            return;
        }// end function

        private function updateValue() : void
        {
            this._shader.data.magnification.value = [this._strength];
            this._shaderFilter = new ShaderFilter(this._shader);
            this.filters = [this._shaderFilter];
            return;
        }// end function

        public function set backgroundWidth(param1:Number) : void
        {
            this._backgroundWidth = param1;
            backgroundWhite.width = param1;
            return;
        }// end function

        public function get backgroundWidth() : Number
        {
            return backgroundWhite.width;
        }// end function

        public function set backgroundHeight(param1:Number) : void
        {
            this._backgroundHeight = param1;
            backgroundWhite.height = param1;
            return;
        }// end function

        public function get backgroundHeight() : Number
        {
            return backgroundWhite.height;
        }// end function

        public function set strength(param1:Number) : void
        {
            this._strength = param1;
            this.updateValue();
            return;
        }// end function

        public function get strength() : Number
        {
            return this._strength;
        }// end function

        public function wobble(param1:Number, param2:Number) : void
        {
            if (this._greyOverlay)
            {
                backgroundWhite.filters = [new GlowFilter(0, 0.5, 20, 20)];
            }
            else
            {
                backgroundWhite.filters = [];
            }
            if (param1 == 0 && param2 == 0)
            {
                this._overlay.visible = false;
            }
            else
            {
                this._overlay.visible = true;
                this._overlay.graphics.clear();
                this._overlay.graphics.beginFill(0, 0.01);
                this._overlay.graphics.drawRect(0, 0, 800, 600);
                this._overlay.graphics.endFill();
            }
            dispatchEvent(new Event(Menu.WOBBLE_START, true));
            if (this._backgroundWidth < param1)
            {
                TweenMax.to(this, 0.2, {backgroundWidth:param1, backgroundHeight:param2});
            }
            TweenMax.to(this, 0.2, {delay:0, strength:0.8, ease:Quad.easeOut, onComplete:this.wobbleBack, onCompleteParams:[param1, param2]});
            return;
        }// end function

        private function wobbleBack(param1:Number, param2:Number) : void
        {
            dispatchEvent(new Event(Menu.WOBBLE_SWITCH, true));
            if (this._backgroundWidth > param1)
            {
                TweenMax.to(this, 0.2, {backgroundWidth:param1, backgroundHeight:param2});
            }
            TweenMax.to(this, 0.8, {strength:1, ease:Elastic.easeOut, easeParams:[5, 0], onComplete:this.wobbleComplete});
            return;
        }// end function

        protected function wobbleComplete() : void
        {
            this._overlay.graphics.clear();
            if (this._greyOverlay)
            {
                this._overlay.graphics.beginFill(0, 0.5);
                this._overlay.graphics.drawRect(0, 0, 800, 600);
                this._overlay.graphics.endFill();
                this._overlay.addEventListener(MouseEvent.CLICK, this.clickBack, false, 0, true);
                this._overlay.alpha = 0.01;
                TweenLite.to(this._overlay, 0.5, {alpha:1});
            }
            else
            {
                this._overlay.graphics.beginFill(0, 0.01);
                this._overlay.graphics.drawRect(0, 0, 800, 600);
                this._overlay.graphics.endFill();
                this._overlay.removeEventListener(MouseEvent.CLICK, this.clickBack);
            }
            dispatchEvent(new Event(Menu.WOBBLE_DONE, true));
            return;
        }// end function

        private function clickBack(event:MouseEvent) : void
        {
            dispatchEvent(new Event(Menu.BACK, true));
            return;
        }// end function

        protected function wobbleOutComplete() : void
        {
            dispatchEvent(new Event(Menu.WOBBLEOUT_DONE, true));
            return;
        }// end function

        public function wobbleOut(param1:Number, param2:Number) : void
        {
            TweenMax.to(this, 0.3, {backgroundWidth:param2, backgroundHeight:param1, onComplete:this.wobbleOutComplete});
            return;
        }// end function

    }
}
