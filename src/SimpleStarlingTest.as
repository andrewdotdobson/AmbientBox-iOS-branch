package  
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import net.hires.debug.Stats
	import flash.display.Sprite;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class SimpleStarlingTest extends Sprite
	{
		private var star:Starling;
		public function SimpleStarlingTest() 
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			star = new Starling(StarlingSandboxMobile, stage);
			star.start();
			
			addChild(new Stats());
		}
		
	}

}