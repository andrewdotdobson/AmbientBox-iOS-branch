package views 
{
	import model.ApplicationModel;
	import org.josht.starling.foxhole.controls.Slider;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import org.josht.starling.foxhole.core.AddedWatcher;
	import org.josht.starling.foxhole.themes.AzureTheme;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class StarlingControls extends Sprite
	{
		[Embed(source = "../../assets/controls/pulldown2.png")]
		private var _pulldown:Class;
		
		
		
		
		private var _m:ApplicationModel;
		private var pitch:Slider;
		private var gravity:Slider;
		private var volume:Slider;
		private var autoDJ:ToggleSwitch;
		private var accel:ToggleSwitch;
		private var collision:ToggleSwitch;
		
		private var _addedWatcher:AddedWatcher;
		public function StarlingControls(m:ApplicationModel = null) 
		{
			_m = m;
			setupControls();
		//	this._addedWatcher = new AzureTheme(this.stage);
		}
		
		private function setupControls():void
		{
			pitch = new Slider();
			pitch.minimum = 30;
			pitch.maximum = 80;
			pitch.step = 1;
			pitch.value = 80;//extract from model
			pitch.onChange.add(pitch_change);
			addChild(pitch);
			
			
			layout();
		}
		
		//handlers
		
		private function pitch_change(slider:Slider):void
		{
			//change text
			
			//update model
			
			//bubble starling event to starling stage to say changed.
			dispatchEvent(new Event("controlchange", true));
		}
		
		public function layout():void
		{
			
		}
		
	}

}