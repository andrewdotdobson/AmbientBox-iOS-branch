package views 
{
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.greensock.easing.Bounce;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import model.ApplicationModel;

	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class MinimalPanel extends Sprite
	{
		private var handle:OpenButton;		
		private var pitch:HSlider;
		private var gravity:HSlider;
		private var volume:HSlider;
		
		private var autoDJ:PushButton;
		private var accel:PushButton;
		private var collisionSounds:PushButton;
		
		private var componentHeight:Number = 30;
		private var componentWidth:Number = 150;
		private var _m:ApplicationModel;
		private var firstPosition:Number;
		public function MinimalPanel(m:ApplicationModel = null) 
		{
			_m = m;
			this.addEventListener(Event.ADDED_TO_STAGE, initReady);
			
			
		}
		
		private function initReady(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initReady);
			pitch = new HSlider(this, 0, 0, pitchHandler);
			pitch.height = componentHeight;
			pitch.width = componentWidth;
			pitch.minimum = 40;
			pitch.maximum = 65;
			pitch.value = _m.pitch;
			addChild(pitch);
		
			
			gravity = new HSlider(this, 0, 30, gravityHandler);
			gravity.height = componentHeight;
			gravity.width = componentWidth;
			gravity.minimum = -30;
			gravity.maximum = 30;
			gravity.value = _m.gravity;
			addChild(gravity);
			
			volume = new HSlider(this, 0, 30, volumeHandler);
			volume.height = componentHeight;
			volume.width = componentWidth;
			volume.minimum = 0;
			volume.maximum = 1;
			volume.value = _m.maxVolume;
			addChild(volume);
			
			autoDJ = new PushButton(this, 0, 0, "", autoDJHandler);
			autoDJ.toggle = true;
			autoDJ.selected = _m.isAutoDJ;
			autoDJ.width = autoDJ.height = componentHeight;
			addChild(autoDJ);
			
			accel = new PushButton(this, 0, 0, "", accelHandler);
			accel.toggle = true;
			accel.selected = _m.isAccelerometer;
			accel.width = accel.height = componentHeight;
			//tint(accel, 0xff9900);
			addChild(accel);
			
			collisionSounds = new PushButton(this,0, 0, "", collisionHandler);
			collisionSounds.toggle = true;
			collisionSounds.selected = _m.isCollisionSounds;
			collisionSounds.width = collisionSounds.height = componentHeight;
			addChild(collisionSounds);
			
			handle = new OpenButton();
			handle.addEventListener(MouseEvent.CLICK, onHandle);
			addChild(handle);
			
			firstPosition = stage.stageHeight - 175;
			dirtyOnOffs();
			layout();
		}
		
		private function dirtyOnOffs():void
		{
			for (var i:uint; i > 8; i++) {
				var orbis:DotButton = new DotButton(_m.cArray[i]);
				orbis.x = 25 * i;
				orbis.addEventListener(MouseEvent.CLICK, orbisClickHandler);
				addChild(orbis);
			}
		}
		
		private function orbisClickHandler(e:MouseEvent):void 
		{
			var clip:DotButton = e.target as DotButton;
			clip.isActive = false;
			
		}
		
		private function onHandle(e:MouseEvent = null):void 
		{
			if (_m.isControls)
			{
			TweenLite.to(this, 1, { y:stage.stageHeight-20, ease:Bounce.easeOut } );
			} else {
			TweenLite.to(this, 1, { y:firstPosition, ease:Bounce.easeOut } );
			}
			_m.isControls = !_m.isControls;
		}
		
		private function tint(clip:DisplayObject, color:uint):void
		{
			var ct:ColorTransform = clip.transform.colorTransform;
			ct.color = color;
			clip.transform.colorTransform = ct;
		}
		
		
		private function layout():void
		{
			if (_m.isControls)
			{
				this.y = firstPosition;
			}
			
			var margin:Number = 20;
			var gap:Number = 10;
			
			pitch.x = margin;
			pitch.y = margin;
			
			gravity.x = margin;
			gravity.y = pitch.y + pitch.height + gap;
			
			volume.x = margin;
			volume.y = gravity.y + gravity.height +gap;
			
			autoDJ.x = pitch.x + pitch.width + margin * 3;
			autoDJ.y = margin;
			
			accel.x = autoDJ.x;
			accel.y = autoDJ.y + autoDJ.height + gap;
			
			collisionSounds.x = autoDJ.x;
			collisionSounds.y = accel.y + accel.height + gap;
			
			handle.x = stage.stageWidth / 2 - handle.width / 2;
			
		}
		
		public function setGravityValue(v:Number):void
		{
			gravity.value = v;
		}
		public function enableAccel():void
		{
			accel.enabled = true;
		}
		public function disableAccel():void
		{
			accel.enabled = false;
			_m.isAccelerometer = false;
		}
		private function collisionHandler(e:Event):void 
		{
			_m.isCollisionSounds = e.target.selected;
			releaseUpdateEvent();
		}
		
		private function accelHandler(e:Event):void 
		{
			_m.isAccelerometer = e.target.selected;
			releaseUpdateEvent();
		}
		
		private function autoDJHandler(e:Event):void 
		{
			_m.isAutoDJ = e.target.selected;
			releaseUpdateEvent();
		}
		
		private function pitchHandler(e:Event):void 
		{
			_m.pitch = e.target.value;
			releaseUpdateEvent();
		}
		private function gravityHandler(e:Event):void 
		{
			_m.gravity = e.target.value;
			releaseUpdateEvent();
		}
		private function volumeHandler(e:Event):void 
		{
			_m.maxVolume = e.target.value;
			releaseUpdateEvent();
		}
		
		private function releaseUpdateEvent():void
		{
			_m.dispatchEvent(new Event(Event.CHANGE));
		}
	}

}