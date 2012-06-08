package  
{

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ColorArgb;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class Orb extends Sprite 
	{
		
		
		[Embed(source="../assets/ball_base.png")]
		private var ballbasepng:Class;
		
		[Embed(source = "../assets/ball_dot.png")]
		private var dotpng:Class;
		
		private var ballbase:Image;
		private var dot:Image;
		private var _color:uint;
		private var _isActive:Boolean = true;
		private var _id:Number;
	
		public function Orb(pid:Number, baseColor:uint = 0xff9900) 
		{
			id = pid;
			_color = baseColor;						
			
			ballbase = Image.fromBitmap(new ballbasepng());
			dot = Image.fromBitmap(new dotpng());
			addChild(ballbase);
			addChild(dot);
			
			dot.color = _color;
				
			pivotX = width >> 1;
			pivotY = width >> 1;
			
		
			
		}
		
	
		
		public function colorDot(c:uint):void
		{
			dot.color = c;
		}

		public function switchActive():void
		{
			if (!isActive)
			{
				dot.color = 0x333333;
			} else {
				dot.color = color;
			}
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			switchActive();
		}
		
		public function get id():Number 
		{
			return _id;
		}
		
		public function set id(value:Number):void 
		{
			_id = value;
		}

	}

}