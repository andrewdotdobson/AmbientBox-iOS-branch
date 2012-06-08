package  
{

	import assets.AmbientLoopsLite;
	import flash.media.Sound;
	import flash.net.FileReference;
	import model.ApplicationModel;
	import net.hires.debug.Stats;
	import tonfall.core.Engine;
	import tonfall.core.IParameterObserver;
	import tonfall.core.Parameter;
	import tonfall.display.AbstractApplication;
	import tonfall.display.ParameterSlider;
	import tonfall.format.wav.WAVDecoder;
	import tonfall.prefab.audio.ContinuousSyncedLoop;
	import tonfall.prefab.routing.MixingUnit;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class SoundBox extends AbstractApplication
	implements IParameterObserver
		
	{
			
		[Embed(source="../assets/audio/bleeps/hit.mp3")]
		private static const HIT: Class;
		
		private var hitSound:Sound;
		private var mixer:MixingUnit;
		private var par:Parameter;
		private var _pitchTempo:Number;
		
		private var loops:Array = new Array();
		private var loopLength:Array = new Array();
		public var loopsTitles:Array = new Array();
		private var _m:ApplicationModel;
	
		public function SoundBox(m:ApplicationModel = null)
		{
			_m = m;
			//go loops
			loops = [AmbientLoopsLite.LOOP1, AmbientLoopsLite.LOOP2, AmbientLoopsLite.LOOP3, AmbientLoopsLite.LOOP4, AmbientLoopsLite.LOOP5, AmbientLoopsLite.LOOP6, AmbientLoopsLite.LOOP7, AmbientLoopsLite.LOOP8];
			loopLength = [8, 6, 2, 2, 8, 2, 14, 2];
			loopsTitles = ["The Underpinning","Ground Base","Chime"," For Whom the Bell Tolls","An Ascent","The Climber","The Forest Floor","Rhythm of the Pipes"];
			// use this for highquality loops - be warned though, this does add a MASSIVE overhead to the filesize
			
			/*loops = [AmbientLoops.LOOP1, AmbientLoops.LOOP2, AmbientLoops.LOOP3, AmbientLoops.LOOP4, AmbientLoops.LOOP5, AmbientLoops.LOOP6, AmbientLoops.LOOP7, AmbientLoops.LOOP8];
			loopLength = [8, 8, 8, 6, 16, 4, 19, 16];*/
			
			mixer = new MixingUnit(8);
			
			var par:Parameter = new Parameter("volume", 0);
			for (var i:Number = 0; i < loops.length; i++)
			{
				var theLoops:WAVDecoder = loops[i] as WAVDecoder;
				var loopPlayer:ContinuousSyncedLoop = new ContinuousSyncedLoop(theLoops, theLoops.numSamples, loopLength[i]);
				mixer.connectAt(loopPlayer.signalOutput, i);
				engine.processors.push(loopPlayer);
	
			}
				
			engine.bpm = _m.pitch;
			engine.processors.push(mixer);
			
			engine.input = mixer.signalOutput;
			
			hitSound = (new HIT) as Sound;
		}
		
		public function triggerHitSound():void
		{
			if (_m.isCollisionSounds)
			{
				hitSound.play();
			}
		}
		
		public function onParameterChanged(p:Parameter):void
		{
			
		}
		
	
		public function volume(target:int, level:Number):void
		{
			mixer.setGainAt(level, target);
			
		}
		
		public function pan(target:int, level:Number):void
		{
			mixer.setPanAt(level, target);
		}
		
		public function get pitchTempo():Number 
		{
			return _pitchTempo;
		}
		
		public function set pitchTempo(value:Number):void 
		{
			_pitchTempo = value;
			engine.bpm = value;
		}

		
	}

}