package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class OpenButton extends Sprite
	{
		[Embed(source="../assets/controls/pulldown2.png")]
		private var handle:Class;
		
		public function OpenButton() 
		{
			addChild(new handle());
		}
		
		
		
		
	}

}