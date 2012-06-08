package uk.co.andrewdobson.kuler 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	// uses http://code.google.com/p/colormunch/ - you'll need this package in your class libraries
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class KulerKonnector extends EventDispatcher
	{
		private var _key:String = "97871412B68A70BDB13BCC781666EA4C";
		private var _baseurl:String = "http://kuler-api.adobe.com/";
		private var _requestString:String;
		private var _xml:XML;
		
		public function KulerKonnector() 
		{
			var u:String = 	_baseurl + 
							"rss/get.cfm?listType=" +
							"random" +
							"&key=" + _key ;
							
			var loader:URLLoader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, xmlLoadHandler);
			loader.load(new URLRequest(u));
			
			//search
			//rss/search.cfm?searchQuery=[searchQuery]&startIndex=[startIndex]&itemsPerPage=[itemsPerPage]&key=[key]
			//rss/get.cfm?listType=[listType]&startIndex=[startIndex]&itemsPerPage=[itemsPerPage]&timeSpan=[timeSpan]&key=[key]
		}
		
		private function xmlLoadHandler(e:Event):void
		{
			//_xml = e.target.data;
			trace(e.target.data);
		}
		
	}
	
}