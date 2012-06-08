package views 
{
	

	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class SliderBox_st extends Sprite
	{
		[Embed(source = "../../assets/controls/slider_back.png")]
		private var SliderBackPNG:Class;
		
		[Embed(source = "../../assets/controls/slider_handle.png")]
		private var SliderHandlePNG:Class;
		
		private var background:Image
		private var handle:Image
		private var _value:Number;
		private var output:TextField;
		public function SliderBox_st(label:String = null ) 
		{
			background = Image.fromBitmap(new SliderBackPNG());
			handle = Image.fromBitmap(new SliderHandlePNG());
			
			addChild(background);
			addChild(handle);
			
			output = new TextField(background.width, background.height, "", "Verdana", 14, 0xffffff);
			
			output.text = label;
			addChild(output);
			
			addChild(handle);
			handle.addEventListener(TouchEvent.TOUCH, touchHandler);
		}
		
		private function touchHandler(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(this);
			var p:Point = t.getLocation(stage);
			//trace(this.width +""+ p.x);
			if (t.phase == TouchPhase.MOVED)
			{
				if (p.x > 0 && p.x < background.width-handle.width)
				{
					handle.x = p.x;
					value = p.x;
				}
			}
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
	}

}