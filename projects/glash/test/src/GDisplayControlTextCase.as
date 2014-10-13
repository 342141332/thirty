package {
	import com.gearbrother.glash.GMain;
	import com.gearbrother.glash.display.container.GContainer;
	import com.gearbrother.glash.display.control.text.GText;
	import com.gearbrother.glash.display.layout.impl.FillLayout;
	import com.gearbrother.glash.display.layout.impl.FlowLayout;
	import com.gearbrother.glash.util.display.GTextFieldUtil;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	/**
	 * @author feng.lee
	 * create on 2012-12-17 下午4:36:06
	 */
	[SWF(width = "800", height = "500", frameRate = "60")]
	public class GDisplayControlTextCase extends GCase {
		private var paneIndex:uint;

		public function GDisplayControlTextCase() {
			super();

			stage.color = 0xcccccc;
			logger.info("================ show font, before install ===============");
			_printFont();
			var loader:Loader = new Loader();
			loader.load(new URLRequest("GDisplayControlTextFontCase.swf"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _handleLoadEvent);
		}

		public function _printFont(enumerateDeviceFonts:Boolean = false):void {
			var fonts:Array = Font.enumerateFonts(false);
			for each (var font2:Font in fonts) {
				logger.debug("[font name=\"{0}\" style=\"{1}\" type=\"{2}\"]", [font2.fontName, font2.fontStyle, font2.fontType]);
			}
		}

		private function _handleLoadEvent(event:Event):void {
			logger.info("================ show font, after install ===============");
			_printFont();

			/*var t:TextField = new TextField();
			var f:TextFormat = t.defaultTextFormat;
			f.font = "Brush Script MT";
			f.size = 37;
			t.defaultTextFormat = f;
			t.x = t.y = 50;
			t.text = "Embed Gradient Render";
			t.autoSize = TextFieldAutoSize.LEFT;
			stage.addChild(t);
			
			var t2:TextField = getTextFieldAtIndex(t, 6);
			t2.appendText(" ");
			t2.autoSize = TextFieldAutoSize.NONE;
			t2.border = true;
			t2.width = 100;
			stage.addChild(t2);
			return;*/
			addChild(new OverviewPane());
//			stage.addEventListener(MouseEvent.CLICK, _handleMouseEvent);
		}

		private function _handleMouseEvent(event:MouseEvent):void {
			if (event.target == stage) {
				removeAllChildren();

				logger.info("-------------------- switch pane --------------------");
				layout = new FillLayout();
//				if (paneIndex++ % 2 == 0)
				addChild(new OverviewPane());
//				else
//					rootLayer.addChild(new SkinPane());
			}
		}
	}
}
import com.gearbrother.glash.GMain;
import com.gearbrother.glash.display.container.GContainer;
import com.gearbrother.glash.display.control.text.GRichText;
import com.gearbrother.glash.display.control.text.GText;
import com.gearbrother.glash.display.control.text.GTextInput;
import com.gearbrother.glash.display.control.text.GTextRender;
import com.gearbrother.glash.display.filter.GFilter;
import com.gearbrother.glash.display.layout.impl.FlowLayout;

import flash.display.Loader;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.MouseCursor;

class OverviewPane extends GContainer {
	public function OverviewPane() {
		super();

		layout = new FlowLayout();

		//test style
		var text:GText;
		text = new GText(new TextField());
		text.font = "MSYH";
		text.fontSize = 17;
		text.text = "Embed MSYH WEIGHT NORMAL";
		text.fontColor = 0x663399;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		text.cursor = MouseCursor.HAND;
		addChild(text);

		text = new GText(new TextField());
		text.font = "MSYH";
		text.fontSize = 17;
		text.text = "Embed MSYH BOLD";
		text.fontBold = true;
		text.fontColor = 0x663399;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		addChild(text);

		text = new GText(new TextField());
		text.font = "MSYH";
		text.fontSize = 17;
		text.text = "Embed MSYH BOLD ITALIC NO USE";
		text.fontBold = true;
		text.fontItalic = true;
		text.fontColor = 0xFF0000;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		addChild(text);

		text = new GText(new TextField());
		text.font = "UNDEFINED";
		text.fontSize = 17;
		text.text = "UNKNOWN FONT USE EMBED FALSE";
		text.fontBold = true;
		text.fontItalic = true;
		text.fontColor = 0x663399;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		addChild(text);

		text = new GText(new TextField());
		text.font = "MSYH";
		text.fontSize = 17;
		text.fontBold = true;
		text.fontColor = 0xFF0000;
		text.align = "right";
		text.text = "Embed MSYH BOLD ITALIC NO USE";
		text.wordWrap = true;
		text.multiline = true;
		text.autoSize = TextFieldAutoSize.LEFT;
		addChild(text);

		text = new GText(new TextField());
		text.font = "UNDEFINED";
		text.fontSize = 17;
		text.text = "SHOULD BE VERTICAL";
		text.fontBold = true;
		text.fontItalic = true;
		text.fontColor = 0x663399;
		text.vertical = true;
		text.align = "center";
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		addChild(text);

		text = new GText(new TextField());
		text.font = "MSYH";
		text.fontSize = 17;
		text.text = "SHOULD BE VERTICAL";
		text.fontBold = true;
		text.fontItalic = true;
		text.fontColor = 0x663399;
		text.vertical = true;
		text.align = "center";
		text.autoSize = TextFieldAutoSize.LEFT;
		text.wordWrap = false;
		addChild(text);

		//test trucate
		var textfield:TextField = new TextField();
		textfield.width = 100;
		textfield.wordWrap = false;
		textfield.multiline = false;
		textfield.autoSize = TextFieldAutoSize.NONE;
		text = new GTextInput(textfield);
		text.text = "enableTruncateToFit = true";
		text.font = "MSYH";
		text.fontSize = 17;
		text.fontColor = 0x333333;
		text.enableTruncateToFit = true;
		addChild(text);

		text = new GTextInput();
		text.autoSize = TextFieldAutoSize.NONE;
		text.width = 100;
		text.height = 50;
		text.font = "MSYH";
		text.fontSize = 17;
		text.fontColor = 0x333333;
		text.text = "enableTruncateToFit = true";
		text.enableTruncateToFit = true;
		addChild(text);

		text = new GTextInput();
		text.text = "abc";
		addChild(text);

		var richText:GRichText = new GRichText();
		richText.font = "Brush Script MT";
		richText.fontSize = 37;
		richText.fontColor = 0x333333;
		richText.text = "Embed Gradient Render\nEmbed Gradient Render";
		richText.autoSize = TextFieldAutoSize.LEFT;
		richText.textRender = new GTextRender();
		richText.tween = GRichText.textTweenScroll;
		addChild(richText);

		richText = new GRichText(new TextField());
		richText.font = "UNDEFINE";
		richText.fontSize = 17;
		richText.fontColor = 0x333333;
		richText.text = "Unembed Gradient Render";
		richText.textRender = new GTextRender();
		addChild(richText);

		richText = new GRichText(new TextField);
		richText.font = "MSYH";
		richText.fontSize = 17;
		richText.fontColor = 0x333333;
		richText.text = "Embed Gradient Render";
		richText.textRender = new GTextRender();
		richText.enableTruncateToFit = true;
		addChild(richText);

		richText = new GRichText(new TextField);
		richText.font = "Chalkduster";
		richText.fontSize = 17;
		richText.fontColor = 0x333333;
		richText.autoSize = TextFieldAutoSize.LEFT;
		richText.fontItalic = true;
		richText.text = "Vertical Embed Gradient Render";
		richText.textRender = new GTextRender(0xd8f297, 0x3f6041, Math.PI / 3);
		GFilter.getGlow(0x000000, 1, 3, 3, 5, 2).apply(richText);
		addChild(richText);
	}
}
/*
import com.gearbrother.glash.common.resource.type.GFile;
import com.gearbrother.glash.display.filter.GFilter;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextLineMetrics;
import com.gearbrother.glash.display.GNoScale;
import com.gearbrother.glash.testcase.TextPaneSkin;

class SkinPane extends GNoScale {
	[Embed(source = "../asset/font/green/0.png")]
	public var char0Clazz:Class;
	[Embed(source = "../asset/font/green/1.png")]
	public var char1Clazz:Class;
	[Embed(source = "../asset/font/green/2.png")]
	public var char2Clazz:Class;
	[Embed(source = "../asset/font/green/3.png")]
	public var char3Clazz:Class;
	[Embed(source = "../asset/font/green/4.png")]
	public var char4Clazz:Class;
	[Embed(source = "../asset/font/green/5.png")]
	public var char5Clazz:Class;
	[Embed(source = "../asset/font/green/6.png")]
	public var char6Clazz:Class;
	[Embed(source = "../asset/font/green/7.png")]
	public var char7Clazz:Class;
	[Embed(source = "../asset/font/green/8.png")]
	public var char8Clazz:Class;
	[Embed(source = "../asset/font/green/9.png")]
	public var char9Clazz:Class;

	public var text1:GRichText;
	public var text2:GRichText;

	public var divceText:GRichText;

	public var gradientText1:GRichText;
	public var gradientText2:GRichText;

	public var bmdText1:GBmdText;

	public var bmdText2:GBmdText;

	public function SkinPane() {
		var skin:TextPaneSkin = new TextPaneSkin();
		super(skin);

		text1 = new GRichText(skin.text1, this);
		text1.text = "不过yesterday78";

		text2 = new GRichText(skin.text2, this);
		text2.text = "不过yesterday78";

		divceText = new GRichText(skin.divceText);
		divceText.asBitmap = true;
		divceText.rotation = -10;

		gradientText1 = new GRichText(skin.gradientText1);
		gradientText1.textRender = GRichText.textRenderGradient; //0xdafe20 0x369e23
		GFilter.getGlow(0x000000, 1, 3, 3, 5, 2).apply(gradientText1);

		gradientText2 = new GRichText(skin.gradientText2);
		gradientText2.text = "小星星不分离\n我嗨哟";
		gradientText2.textRender = GRichText.textRenderGradient;
		gradientText2.setTextFilter(new DropShadowFilter(0, 0, 0x00FF00, 1, 4, 4, 100), 0, 1);
		GFilter.getGlow(0x000000, 1, 3, 3, 5, 2).apply(gradientText2);

		bmdText1 = new GSeparatedText(skinView["bmdText1"]);
		var fontClazz:Array = [char0Clazz, char1Clazz, char2Clazz, char3Clazz, char4Clazz, char5Clazz, char6Clazz, char7Clazz, char8Clazz, char9Clazz];
		for (var i:int = 0; i < 10; i++) {
			bmdText1.registerFontBmd((new fontClazz[i]() as Bitmap).bitmapData, String(i));
		}
		bmdText1.text = "123";
		bmdText1.reRenderTextBitmap();

		bmdText2 = new GSeparatedText(skinView["bmdText2"]);
		bmdText2.setTextFilter(new DropShadowFilter(0, 45, 0xFF0000, 1, 3, 3, 300), 0, 2);

		vectorLabel = new GLabel(skinView["vectorLabel"]);
		bmdLabel = new GLabel(skinView["bmdLabel"]);

		addEventListener(MouseEvent.CLICK, _handleMouseEvent);
	}

	private function _handleMouseEvent(event:MouseEvent):void {
		var target:* = event.target;
		if (target is GRichText) {
			var text:GRichText = target as GRichText;
			text.tween = GRichText.textTweenScroll;
			event.stopPropagation();
		}
	}
}*/
