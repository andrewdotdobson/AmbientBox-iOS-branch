package uk.co.andrewdobson.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Andy
	 */
	public class SimpleXMLLoader extends EventDispatcher
	{
		public var xml:XML;
		private var loader:URLLoader;
		public static const XML_LOADED:String = "xmlloaded";
		
		public function SimpleXMLLoader(u:String = null) 
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoaded);
			if (u != null || u!= "") {
				loadXML(u);
			}
			
		}
		
		private function xmlLoaded(e:Event):void
		{
			xml = new XML(e.target.data);
			dispatchEvent(new Event(XML_LOADED));
		}
		
		public function loadXML(s:String):void
		{
			loader.load(new URLRequest(s));
		}
	}
	
}