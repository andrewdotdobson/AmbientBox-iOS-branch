package controller 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import model.ApplicationModel;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class ApplicationController extends EventDispatcher
	{
		private var _m:ApplicationModel;
		public function ApplicationController(m:ApplicationModel = null) 
		{
			_m = m;
			_m.addEventListener(Event.CHANGE, updateViewFromPanel);
		}
		
		
		public function updateViewFromPanel(e:Event):void
		{
			
		}
		
	}

}