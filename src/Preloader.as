package 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import AmbientSandbox;
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class Preloader extends MovieClip 
	{
		private var pl:SoundboxPreloader;
		private var origWidth:Number;
		public function Preloader() 
		{
			pl = new SoundboxPreloader();
			origWidth = pl.plbar.width;
			
			
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			pl.x = 512;
			pl.y = 384;
			addChild(pl);
			pl.output.htmlText = "Loading soundscapes";
			pl.plbar.width = 0;
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
			pl.output.text = "There has been an error, please restart";
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var pc:Number = Math.round((e.bytesLoaded / e.bytesTotal) * 100);
			pl.plbar.width = (pc / 100) * origWidth;
			pl.output.htmlText = "Loading soundscapes at " + NumberUtil.converToWords(pc) + "percent";
			trace(pl.output.text);
		}
		
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			TweenLite.to(pl, 3, { alpha: 0, onComplete:startup } );
			
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("AmbientSandbox") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}