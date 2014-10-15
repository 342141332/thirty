package com.riaidea.text.plugins {
	import com.riaidea.text.*;
	import com.riaidea.text.plugins.*;

	public class ReplaceSpritePlugin extends Object implements IRTFPlugin {
		private var __target:RichTextField;
		private var __shortcuts:Array;
		private var __enabled:Boolean;

		public function ReplaceSpritePlugin() {
			__shortcuts = [];
			__enabled = false;
		}

		public function setup(target:RichTextField):void {
			__target = target;
			enabled = true;
		}

		public function get enabled():Boolean {
			return __enabled;
		}

		public function set enabled(v:Boolean):void {
			__enabled = v;
			if (__target != null) {
				if (__enabled) {
					__target.addEventListener(RichTextFieldEvent.APPEND_TEXT, onAppendText, false, 0, true);
				} else {
					__target.removeEventListener(RichTextFieldEvent.APPEND_TEXT, onAppendText);
				}
			}
		}

		public function addShortcut(shortcut:Array):void {
			__shortcuts = __shortcuts.concat(shortcut);
		}

		private function onAppendText(event:RichTextFieldEvent):void {
			convertShortcut(event.currentTarget as RichTextField, event.oldContentLength);
		}

		private function convertShortcut(rtf:RichTextField, oldLength:int):void {
			if (rtf.contentLength - oldLength < 0) {
				return;
			}
			var scanAt:int = 0;
			while (scanAt < __shortcuts.length) {
				var shortcutInfo:Object = __shortcuts[scanAt];
				var shortCutLength:int = (shortcutInfo.shortcut as String).length;
				var lastIndex:int = rtf.content.lastIndexOf(shortcutInfo.shortcut);
				while (lastIndex >= oldLength) {
					rtf.replace(lastIndex, lastIndex + shortCutLength, "", [{src: shortcutInfo.src}]);
					lastIndex = rtf.content.lastIndexOf(shortcutInfo.shortcut);
				}
				scanAt++;
			}
		}
	}
}
