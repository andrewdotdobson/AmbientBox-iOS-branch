package  
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ColorArgb;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class ParticleEmitter extends ParticleDesignerPS
	{
	
		[Embed(source = "../assets/particle/particle.pex", mimeType = "application/octet-stream")]
		private static const ParticleConfig:Class;
		
		[Embed(source = "../assets/particle/texture.png")]
		private static const ParticleTexture:Class;
		
		private var _color:uint;
		public function ParticleEmitter(baseColor:uint = 0xff9900) 
		
		{
			_color = baseColor;			
			//trace("basecolor: " + baseColor.toString(16));
			var psConfig:XML = XML(new ParticleConfig());
            var psTexture:Texture = Texture.fromBitmap(new ParticleTexture());
			
			super(psConfig, psTexture);
			

		}
			
		public function colorParticles(c:uint, a:uint):void
		{
			
			var red:uint = (c >> 16) & 0xff;
			var green:uint = (c >> 8) & 0xff;
			var blue:uint = c & 0xff;
			
		//	particles.startColor = new ColorArgb(red, green, blue, 0.7);
		//	particles.endColor = new ColorArgb(red, green, blue, 0.1);
			
		}

		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
		}

	}

}