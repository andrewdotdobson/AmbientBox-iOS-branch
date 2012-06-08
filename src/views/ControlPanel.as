package views 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.greensock.easing.Bounce;
	import com.greensock.TweenMax;
	import de.popforge.surface.valuation.Potentiometer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.ApplicationModel;
	import model.ApplicationModel;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import uk.co.soulwire.gui.SimpleGUI;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class ControlPanel extends Sprite
	{
		private var _m:ApplicationModel;
		private var controls:Sprite;
		private var pitchControl:HUISlider;
		private var gravityControl:HUISlider;
		private var volControl:HUISlider;
		private var hitSoundToggle:CheckBox;
		private var autoDJToggle:CheckBox;
		private var output:Label;
		private var instructions:Label;
		private var closeButton:PushButton;
		private var openbutton:OpenButton;
		private var isPanel:Boolean = true;
		public function ControlPanel() 
		{
		//	_m = m;
			// original code
			controlInit();
			this.y += 300;
		}
		
		
		private function controlInit():void
		{	
	
			pitchControl = new HUISlider(this,60,15,"Pitch", changePitch);
			pitchControl.width = 200;	
			pitchControl.labelPrecision = 0;
			pitchControl.minimum = -30;
			pitchControl.maximum = 80;
		//	pitchControl.setLabelText("Pitch");
			//pitchControl.addEventListener("onValueChanged", changePitch)
			pitchControl.scaleX = pitchControl.scaleY = 1.2;
			addChild(pitchControl);
			
			gravityControl = new HUISlider(this,60,30,"Gravity", changeGravity);
			gravityControl.width = 250;
		//	gravityControl.scaleX = gravityControl.scaleY = 1.5;
	
			/*gravityControl.x = pitchControl.x + 50;
			gravityControl.setLabelText("Gravity");
			gravityControl.addEventListener("onValueChanged", changeGravity);*/
			addChild(gravityControl);

			volControl = new HUISlider(this, 60,45, "Volume", changeVolume);
			volControl.width = 200;
			addChild(volControl);
			
	
			
			hitSoundToggle = new CheckBox(this, volControl.x +60, volControl.y+5, "Collision Sound", toggleHitSound);
			hitSoundToggle.selected = false;
			addChild(hitSoundToggle);
			
			autoDJToggle = new CheckBox(this, hitSoundToggle.x, hitSoundToggle.y + 20, "Auto DJ", toggleAutoDJ);
			addChild(autoDJToggle);
			
			output = new Label(this, hitSoundToggle.x-2, -20);
			addChild(output);
			output.text = "Track: Starling";
			
			instructions = new Label(this, 690, output.y);
			instructions.text = "Each orb is a seperate track. The y-axis is volume, the x-axis pan\nYou can set the pitch and gravity using the controls on the left\nUse AutoDJ to let the orbs float around on their own\nYou can double click or mousewheel to turn individual orbs on and off\nSit back, relax, tune out";
			addChild(instructions);
			
			closeButton = new PushButton(this, 0, 36, "Close Panel", panelToggle);
			closeButton.x = stage.stageWidth / 2 - closeButton.width / 2;
			closeButton.alpha = 1;
			addChild(closeButton);
			
			openbutton = new OpenButton();
			openbutton.alpha = 0;
			openbutton.buttonMode = true;
			addChild(openbutton);
			openbutton.y = 0;
			openbutton.x = stage.stageWidth / 2 - openbutton.width / 2;
		}
		
		private function panelToggle(e:Event):void
		{
			isPanel = !isPanel;
			if (!isPanel)
			{	
				TweenMax.to(this, 1, { y:"90", ease:Bounce.easeOut } );
				TweenMax.to(openbutton, 1, { alpha:1 } );
				openbutton.addEventListener(MouseEvent.CLICK,  panelToggle);
			} else {
				TweenMax.to(this, 1, { y:"-90", ease:Bounce.easeOut } );
				TweenMax.to(openbutton, 1, { alpha: 0 } );
				openbutton.removeEventListener(MouseEvent.CLICK, panelToggle);
			}
		}
		
		private function toggleHitSound(e:Event):void
		{
			var box:CheckBox = e.target as CheckBox;
			if (box.selected)
			{
				//soundBox.isHitSound = true;
			} else {
			
				//soundBox.isHitSound = false;
			}
		}
		
		private function toggleAutoDJ(e:Event):void
		{
		//	var box:CheckBox = e.target as CheckBox;
		//	isAutoDJ = box.selected;
		//	autoDJ();
			
		}
		private function changeVolume(e:Event):void 
		{
		//	maxVolume = e.target.getValue();
		}
		
		private function changeGravity(e:Event):void 
		{
		//	starlingSandbox.gravity = e.target.getValue();
		}
		
		private function changePitch(e:Event):void 
		{
		//	soundBox.pitchTempo = e.target.getValue();
		}
		
		private function autoDJ(e:TimerEvent = null):void
		{
		/*	 if (isAutoDJ)
			 {
				 TweenMax.to(starlingSandbox, 5, { gravity: -15, onUpdate: moveController, onComplete: resetGravity } );
				 autoDJTimer.start();
			 } else {
				 autoDJTimer.stop();
			 }*/
		}
		private function moveController():void
		{
		//	gravityControl.setValue(starlingSandbox.gravity);
		}
		private function resetGravity():void
		{
		//	TweenMax.to(starlingSandbox, 2, {gravity: 0, onUpdate: moveController } );
		}
		
		
	}

}