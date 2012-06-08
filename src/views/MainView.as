package views 
{
	import com.greensock.TweenMax;
	import controller.ApplicationController;
	import controller.EventDispatcherExtension;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;
	import model.ApplicationModel;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import starling.core.Starling;
	import starling.display.Stage;
	import uk.co.andrewdobson.utils.Utils;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class MainView extends Sprite
	{
		private var star:Starling;
		private var s:Stage;
		private var _m:ApplicationModel;
		private var _c:ApplicationController;
		private var sb:SoundBox;
		private var starlingSandbox:StarlingSandboxMobile;
		private var mp:MinimalPanel;
		
		private var autoDJTimer:Timer;
		
		private var accl:Accelerometer;
		private const FACTOR:Number = 0.25;
		
		public function MainView(m:ApplicationModel, c:ApplicationController) 
		{
			_m = m;
			_c = c;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			_m.addEventListener(Event.CHANGE, updateViews);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			star = new Starling(StarlingSandboxMobile, this.stage);
		
			star.start();
			
			
			//initSound();
			mp = new MinimalPanel(_m);
			mp.y = 400;
			//mp.x = 100;
			addChild(mp);

			Starling.current.stage.addEventListener("starlingready", ready);
			Starling.current.stage.addEventListener("collided", onCollide);
			//init accelerometer
			if (Accelerometer.isSupported)
			{
			//	initAccelerometer();
			mp.disableAccel();
			} else {
				mp.disableAccel();
			}
			//init autoDJ
			autoDJTimer = new Timer(60000);
			autoDJTimer.addEventListener(TimerEvent.TIMER, autoDJ);
		}
		
		private function onCollide(e:*):void 
		{
			sb.triggerHitSound();
		}
		
		private function ready(e:*):void
		{
			s = Starling.current.stage;
			starlingSandbox = s.getChildAt(0) as StarlingSandboxMobile;
			starlingSandbox.setModel(_m);
			initSound();
			this.addEventListener(Event.ENTER_FRAME, oef);
		}
		
		private function oef(e:Event):void 
		{
			//enterframe loop. This function tracks the positions of each body and alters the sounds respectively.
			var c:Number = 37.25;
			var target:int;
			for (var i:uint; i < starlingSandbox.ballArray.length; i++)
			{
				var b:Body = starlingSandbox.ballArray[i] as Body;
				var v:Vec2 = b.position;
				target = int(i);
				if(v.y){
					sb.volume( target, Utils.rescaleRange(Math.round(v.y), stage.stageHeight - c, c, 0, _m.maxVolume));
				}
				if (v.x)
				{
					sb.pan(target, Utils.rescaleRange(Math.round(v.x), c, stage.stageWidth - c, -1, 1));
				}
				var graphic:Orb = b.graphic as Orb;
				if (!graphic.isActive)
				{
					sb.volume(target, 0);
				}
			}		
		}
		
		private function initSound(e:Event = null):void
		{
			Starling.current.stage.removeEventListener("starlingready", initSound);
			sb = new SoundBox(_m);	
		}
		
		private function updateViews(e:Event = null):void
		{
			sb.pitchTempo = _m.pitch;
			starlingSandbox.gravity = _m.gravity;
			autoDJ();
		}
		
		private function initAccelerometer():void
		{
			accl = new Accelerometer();
		//	accl.setRequestedUpdateInterval(200);
			accl.addEventListener(AccelerometerEvent.UPDATE, onAccelUpdate);
		}
		
		private function onAccelUpdate(e:AccelerometerEvent):void 
		{
			
			var x:Number = Math.round(e.accelerationX * 100);
			var y:Number = Math.round(e.accelerationY * 100);
			var z:Number = Math.round(e.accelerationZ * 100);
			
			starlingSandbox.tr("x: " + x.toString() + " y: " + y.toString() + " z: " + z.toString());
			
			if (_m.isAccelerometer)
			{
				_m.gravity = y/2;
				starlingSandbox.gravity = _m.gravity;
				mp.setGravityValue(_m.gravity);
			}
		}
		
		private function autoDJ(e:TimerEvent = null):void
		{
			 if (_m.isAutoDJ)
			 {
				 TweenMax.to(starlingSandbox, 5, { gravity: -15, onUpdate: moveController, onComplete: resetGravity } );
				 autoDJTimer.start();
			 } else {
				 autoDJTimer.stop();
			 }
		}
		private function moveController():void
		{
			_m.gravity = starlingSandbox.gravity;
			mp.setGravityValue(_m.gravity);
		}
		private function resetGravity():void
		{
			TweenMax.to(starlingSandbox, 2, {gravity: 0, onUpdate: moveController } );
		}
	}

}