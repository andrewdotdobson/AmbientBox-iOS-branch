package  
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.greensock.easing.Bounce;
	import com.greensock.TweenMax;
	import de.popforge.surface.valuation.Potentiometer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import starling.core.Starling;
	import starling.display.Stage;
	import flash.display.StageScaleMode;
	import uk.co.andrewdobson.utils.Utils;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	
	public class AmbientSandbox extends Sprite
	{
		private var star:Starling;
		private var s:Stage;
		private var starlingSandbox:StarlingSandbox;
		private var soundBox:SoundBox;
		private var maxVolume:Number = 1;
		private var autoDJTimer:Timer;
		private var isAutoDJ:Boolean = false;
		private var gravityControl:Potentiometer;
		private var output:Label;
		private var controls:Sprite;
		private var isPanel:Boolean = true;
		private var openbutton:OpenButton;
		
		public function AmbientSandbox() 
		{
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.doubleClickEnabled = true;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			star = new Starling(StarlingSandbox, stage);
			star.start();
			
			this.stage.addEventListener("collide", collisionHandler);
			this.stage.addEventListener("ready", starlingReady);
			this.stage.addEventListener("selected", orbSelected);
			
			soundBox = new SoundBox();
			autoDJTimer = new Timer(60000);
			autoDJTimer.addEventListener(TimerEvent.TIMER, autoDJ);
			
			controlInit();
		}
			
		private function oef(e:Event):void 
		{
			//enterframe loop. This function tracks the positions of each body and alters the sounds respectively.
			var c:Number = 37.25;
			s = Starling.current.stage;
			starlingSandbox = s.getChildAt(0) as StarlingSandbox;
			var target:int;
			for (var i:uint; i < starlingSandbox.ballArray.length; i++)
			{
				var b:Body = starlingSandbox.ballArray[i] as Body;
				var v:Vec2 = b.position;
				target = int(i);
				if(v.y){
					soundBox.volume( target, Utils.rescaleRange(Math.round(v.y), stage.stageHeight - c, c, 0, maxVolume));
				}
				if (v.x)
				{
					soundBox.pan(target, Utils.rescaleRange(Math.round(v.x), c, stage.stageWidth - c, -1, 1));
				}
				var graphic:Orb = b.graphic as Orb;
				if (!graphic.isActive)
				{
					soundBox.volume(target, 0);
				}
			}		
		}
		
		private function starlingReady(e:Event):void 
		{
			stage.addEventListener(Event.ENTER_FRAME, oef);
		
		}
		
		private function collisionHandler(e:Event):void
		{
			soundBox.triggerHitSound();
		}
					
		private function orbSelected(e:Event):void 
		{
			output.text = soundBox.loopsTitles[starlingSandbox.activeID];
			output.textField.textColor = starlingSandbox.cArray[starlingSandbox.activeID];
		}
		
		private function controlInit():void
		{	
			controls = new Sprite();
			controls.x = 30;
			controls.y = stage.stageHeight - 60;
			addChild(controls);
			
			var pitchControl:Potentiometer = new Potentiometer(40, 65, 60);
			pitchControl.setLabelText("Pitch");
			pitchControl.addEventListener("onValueChanged", changePitch);
			controls.addChild(pitchControl);
			
			gravityControl = new Potentiometer(-30, 30, 0);
			gravityControl.x = pitchControl.x + 50;
			gravityControl.setLabelText("Gravity");
			gravityControl.addEventListener("onValueChanged", changeGravity);
			controls.addChild(gravityControl);
			
			var volControl:Potentiometer = new Potentiometer(0, 1, maxVolume);
			volControl.x = gravityControl.x + 50;
			volControl.setLabelText("Volume");
			volControl.addEventListener("onValueChanged", changeVolume);
			controls.addChild(volControl);
			
			var hitSoundToggle:CheckBox = new CheckBox(this, volControl.x +60, volControl.y+5, "Collision Sound", toggleHitSound);
			hitSoundToggle.selected = false;
			controls.addChild(hitSoundToggle);
			
			var autoDJToggle:CheckBox = new CheckBox(this, hitSoundToggle.x, hitSoundToggle.y + 20, "Auto DJ", toggleAutoDJ);
			controls.addChild(autoDJToggle);
			
			output = new Label(this, hitSoundToggle.x-2, -20);
			controls.addChild(output);
			output.text = "Track: Starling";
			
			var instructions:Label = new Label(this, 690, output.y);
			instructions.text = "Each orb is a seperate track. The y-axis is volume, the x-axis pan\nYou can set the pitch and gravity using the controls on the left\nUse AutoDJ to let the orbs float around on their own\nYou can double click or mousewheel to turn individual orbs on and off\nSit back, relax, tune out";
			controls.addChild(instructions);
			
			var closeButton:PushButton = new PushButton(this, 0, 36, "Close Panel", panelToggle);
			closeButton.x = stage.stageWidth / 2 - closeButton.width / 2;
			closeButton.alpha = 1;
			controls.addChild(closeButton);
			
			openbutton = new OpenButton();
			openbutton.alpha = 0;
			openbutton.buttonMode = true;
			controls.addChild(openbutton);
			openbutton.y = -50;
			openbutton.x = stage.stageWidth / 2 - openbutton.width / 2;
		}
		
		private function panelToggle(e:Event):void
		{
			isPanel = !isPanel;
			if (!isPanel)
			{	
				TweenMax.to(controls, 1, { y:"90", ease:Bounce.easeOut } );
				TweenMax.to(openbutton, 1, { alpha:1 } );
				openbutton.addEventListener(MouseEvent.CLICK,  panelToggle);
			} else {
				TweenMax.to(controls, 1, { y:"-90", ease:Bounce.easeOut } );
				TweenMax.to(openbutton, 1, { alpha: 0 } );
				openbutton.removeEventListener(MouseEvent.CLICK, panelToggle);
			}
		}
		
		private function toggleHitSound(e:Event):void
		{
			trace(e);
			var box:CheckBox = e.target as CheckBox;
			if (box.selected)
			{

				soundBox.isHitSound = true;
			} else {
			
				soundBox.isHitSound = false;
			}
		}
		private function toggleAutoDJ(e:Event):void
		{
			var box:CheckBox = e.target as CheckBox;
			isAutoDJ = box.selected;
			autoDJ();
			
		}
		private function changeVolume(e:Event):void 
		{
			maxVolume = e.target.getValue();
		}
		
		private function changeGravity(e:Event):void 
		{
			starlingSandbox.gravity = e.target.getValue();
		}
		
		private function changePitch(e:Event):void 
		{
			soundBox.pitchTempo = e.target.getValue();
		}
		
		private function autoDJ(e:TimerEvent = null):void
		{
			 if (isAutoDJ)
			 {
				 TweenMax.to(starlingSandbox, 5, { gravity: -15, onUpdate: moveController, onComplete: resetGravity } );
				 autoDJTimer.start();
			 } else {
				 autoDJTimer.stop();
			 }
		}
		private function moveController():void
		{
			gravityControl.setValue(starlingSandbox.gravity);
		}
		private function resetGravity():void
		{
			TweenMax.to(starlingSandbox, 2, {gravity: 0, onUpdate: moveController } );
		}
		
	}

} 