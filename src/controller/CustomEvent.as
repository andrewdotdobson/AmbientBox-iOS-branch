package controller 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class CustomEvent extends Event
	{
		public static const STARLING_READY:String = "starlingready";
		public function CustomEvent() 
		{
			super(type, true, true);
		}
		
	}

}