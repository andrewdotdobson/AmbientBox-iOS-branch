package uk.co.andrewdobson.text
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	/**
	 * ...
	 * @author Andrew DObson
	 */
	public class QuickText extends Sprite
	{
		[Embed(source = "C:\\WINDOWS\\Fonts\\ARIAL.TTF", fontFamily = "arial")]
		private var _arial_str:String;
		private var output:TextField;
		public function QuickText(s:String = null, tf:String = "title", singleLine:Boolean = true) 
		{
			this.mouseChildren = false;
			output = new TextField();
			output.embedFonts = true;
			output.selectable = false;
			output.autoSize = "left";
			output.antiAliasType = "advanced";
			output.defaultTextFormat = format(tf);
			if (!singleLine) {
				output.width = 258;
				output.multiline = true;
				output.wordWrap = true;
			}
			
			addChild(output);
			
			if (s != null)
			{
				writeText(s);
			}
		}
		
		public function writeText(s:String):void
		{
			output.htmlText = s;
		}
		
		public function colorText(c:int):void
		{
			output.textColor = c;
		}
		private function format(s:String):TextFormat
		{
			var tf:TextFormat;
			
			switch(s)
			{
			case "title":
			
			var tf_head:TextFormat = new TextFormat();
			tf_head.font = "arial";
			tf_head.size = 25;
			tf_head.color = 0x999999;
			tf = tf_head;
			break;
			
			case "artist":
			var tf_body:TextFormat = new TextFormat();
			tf_body.font = "arial";
			tf_body.size = 19;
			tf_body.color = 0xAAAAAA;
			tf = tf_body;
			break;
			
			case "type":
			var tf_type:TextFormat = new TextFormat();
			tf_type.font = "arial";
			tf_type.size = 15;
			tf_type.color = 0xAAAAAA;
			tf = tf_type;
			break;
			
			case "button":
			var tf_link:TextFormat = new TextFormat();
			tf_link.font = "arial";
			tf_link.size = 15;
			tf_link.color = 0xffffff;
			tf = tf_link;
			break;
			
			case "h1":
			var tf_h1:TextFormat = new TextFormat();
			tf_h1.font = "arial";
			tf_h1.size = 45;
			tf_h1.bold = true;
			tf_h1.color = 0x666666;
			tf = tf_h1;
			break;
			}

			return tf;
			
		}
		
	}
	
}