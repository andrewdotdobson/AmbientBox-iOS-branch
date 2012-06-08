package uk.co.andrewdobson.text
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class SkyText extends Sprite
	{
		// FONT EMBEDS - PLEASE ENSURE YOU HAVE THESE FONTS IN YOUR DIRECTORY
		[Embed(source = "C:\\WINDOWS\\Fonts\\Sky Final Bold.otf", fontFamily = "SkyBold", embedAsCFF="false")]
		private var _SkyBold_str:String;
		[Embed(source = "C:\\WINDOWS\\Fonts\\Sky Final Medium.otf", fontFamily = "SkyMedium", embedAsCFF="false")]
		private var _SkyMedium_str:String;
		[Embed(source = "C:\\WINDOWS\\Fonts\\Sky Final Regular.otf", fontFamily = "SkyRegular", embedAsCFF="false")]
		private var _SkyRegular_str:String;
		
		private var _tf:TextFormat;
		private var _autosize:String;
		private var _width:Number;
		public var output:TextField;
		private var _content:String;
		private var _textColor:uint;
		
		public function SkyText(s:String = null, type:String = "regular", size:Number = 10, singleLine:Boolean = true, width:Number = 258) 
		{
			_width = width;
			content = s;
			this.mouseChildren = false;
			output = new TextField();
			addChild(output);
			output.embedFonts = true;
			output.selectable = false;
			output.autoSize = "left";
			output.antiAliasType = "advanced";
			format(type, size);
			
			
			if (!singleLine) {
				output.width = _width;
				output.multiline = true;
				output.wordWrap = true;
			}
			
			
			
			if (s != null)
			{
				writeText(s);
			}
			
		}
		
		public function writeText(s:String):void
		{
			output.htmlText = s;
			content = s;
			output.setTextFormat(_tf);
		}
		
		public function colorText(c:int):void
		{
			_tf.color = c;
			output.setTextFormat(_tf);
			
		}
		private function format(type:String, size:Number):void
		{
			//trace("reutneing text format: "+type);
			
			
			switch(type)
			{
			case "regular":			
			var tf_reg:TextFormat = new TextFormat();
			tf_reg.font = "SkyRegular";
			tf_reg.size = size;
			tf_reg.color = 0x999999;
			_tf = tf_reg;
			break;
			
			case "medium":
			var tf_med:TextFormat = new TextFormat();
			tf_med.font = "SkyMedium";
			tf_med.size = size;
			tf_med.color = 0x999999;
			_tf = tf_med;
			break;
			
			case "bold":
			var tf_bold:TextFormat = new TextFormat();
			tf_bold.font = "SkyBold";
			tf_bold.size = size;
			tf_bold.color = 0x999999;
			_tf = tf_bold;
			break;
			}
			
		}
		
		public function get tf():TextFormat { return _tf; }
		
		public function set tf(value:TextFormat):void 
		{
			//trace(value.color);
			_tf = value;
			//output.setTextFormat(value); 
		}
		
		public function get autosize():String { return _autosize; }
		
		public function set autosize(value:String):void 
		{
			_autosize = value;
			output.autoSize = value;
		}
		
		public function get content():String { return _content; }
		
		public function set content(value:String):void 
		{
			_content = value;
		}
		
		public function get textColor():uint { return _textColor; }
		
		public function set textColor(value:uint):void 
		{
			_textColor = value;
			colorText(_textColor);
		}
		
	}
	
}