package views 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class DotButton extends Sprite
	{
		[Embed(source = "../../assets/ball_dot.png")]
		private var dotpng:Class;
		private var _isActive:Boolean = true;
		private var _c:uint;
		private var dot:Bitmap;
		public function DotButton(c:uint = 0xff9900) 
		{
			dot = new dotpng();
			_c = c;
			color(_c);
			addChild(dot);
		}
		
		private function color(c:uint):void
		{
			var ct:ColorTransform = new ColorTransform();
			ct.color = c;
			this.transform.colorTransform = ct;
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			if (!_isActive)
			{
				color(0xcccccc);
			} else {
				color(_c);
			}
		}
		
	}

}