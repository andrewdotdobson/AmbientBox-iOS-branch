package controller 
{
import flash.events.EventDispatcher;
import flash.events.Event;

public class EventDispatcherExtension extends EventDispatcher {
private static var _instance:EventDispatcherExtension;


public static const READY:String = "starlingready";

public function EventDispatcherExtension() {
if (_instance) {
throw new Error( "Singleton pattern can only be accessed through Singleton.getInstance()" );
}
}

public static function getInstance():EventDispatcherExtension {
if(!_instance) _instance = new EventDispatcherExtension();
return _instance;
}
}
}

// usage

/*EventDispatcherExtension.getInstance().addEventListener(EventDispatcherExtension.PORTFOLIO, savePortfolio);
EventDispatcherExtension.getInstance().addEventListener(EventDispatcherExtension.CONTACT, saveContact);
EventDispatcherExtension.getInstance().addEventListener(EventDispatcherExtension.BOOKMARKS, saveBookmarks);

EventDispatcherExtension.getInstance()._aPortfolio = this.aLinkList;
EventDispatcherExtension.getInstance().dispatchEvent(new Event(EventDispatcherExtension.PORTFOLIO));

trace( EventDispatcherExtension.getInstance()._aPortfolio );*/