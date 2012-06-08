package model 
{
	import flash.events.EventDispatcher;
	import views.MainView;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class ApplicationModel extends EventDispatcher
	{
		private var _gravity:Number = 0;
		private var _pitch:Number = 60;
		private var _maxVolume:Number = 1;
		private var _isAutoDJ:Boolean = false;
		private var _isCollisionSounds:Boolean = false;
		private var _isAccelerometer:Boolean = false;
		private var _mainView:MainView;
		private var _isControls:Boolean = true;
		public var cArray:Array = new Array(0x602D91, 0x2E1C92, 0x00AEC0, 0xD25322, 0xA9179A, 0xE80C79, 0xA2BD35, 0x39C24A, 0xff9900 );
		
		public function ApplicationModel() 
		{
			
		}
		
		public function get gravity():Number 
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
		}
		
		public function get pitch():Number 
		{
			return _pitch;
		}
		
		public function set pitch(value:Number):void 
		{
			_pitch = value;
		}
		
		public function get maxVolume():Number 
		{
			return _maxVolume;
		}
		
		public function set maxVolume(value:Number):void 
		{
			_maxVolume = value;
		}
		
		public function get isAutoDJ():Boolean 
		{
			return _isAutoDJ;
		}
		
		public function set isAutoDJ(value:Boolean):void 
		{
			_isAutoDJ = value;
		}
		
		public function get isCollisionSounds():Boolean 
		{
			return _isCollisionSounds;
		}
		
		public function set isCollisionSounds(value:Boolean):void 
		{
			_isCollisionSounds = value;
		}
		
		public function get isAccelerometer():Boolean 
		{
			return _isAccelerometer;
		}
		
		public function set isAccelerometer(value:Boolean):void 
		{
			_isAccelerometer = value;
		}
		
		public function get mainView():MainView 
		{
			return _mainView;
		}
		
		public function set mainView(value:MainView):void 
		{
			_mainView = value;
		}
		
		public function get isControls():Boolean 
		{
			return _isControls;
		}
		
		public function set isControls(value:Boolean):void 
		{
			_isControls = value;
		}
		
	}

}