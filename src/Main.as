package 
{
	import controller.ApplicationController;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import model.ApplicationModel;
	import net.hires.debug.Stats;
	import starling.core.Starling;
	import views.MainView;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class Main extends Sprite 
	{
		private var star:Starling;
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			var m:ApplicationModel = new ApplicationModel();
			var c:ApplicationController = new ApplicationController(m);
			var v:MainView = new MainView(m, c);
			addChild(v);
						
			
			//addChild(new Stats());
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}