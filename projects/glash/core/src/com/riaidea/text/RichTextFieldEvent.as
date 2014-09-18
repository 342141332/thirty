package com.riaidea.text
{
    import flash.events.*;

    public class RichTextFieldEvent extends Event
    {
        protected var __oldLength:int = -1;
        public static const APPEND_TEXT:String = "appendText";

        public function RichTextFieldEvent(type:String, oldLength:int, bubble:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubble, cancelable);
            this.__oldLength = oldLength;
        }

        public function get oldContentLength() : int
        {
            return this.__oldLength;
        }
    }
}