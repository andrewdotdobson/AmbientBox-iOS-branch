package uk.co.andrewdobson.flickr 
{
	import flash.display.Sprite;
	import uk.co.andrewdobson.flickr.FlickrLoader;
	import flash.events.Event;
	import uk.co.andrewdobson.images.ImageLoader;
	
	/**
	 * ...
	 * @author Andrew DObson
	 */
	public class Showr extends Sprite
	{
		private var photoSetLoader:FlickrLoader = new FlickrLoader();
		private var totalImages:Number;
		public function Showr() 
		{
			photoSetLoader.load( "72157600010113893" );
			photoSetLoader.addEventListener( Event.COMPLETE, photoSetCompleteHandler, false, 0, true );
		}
		
		private function photoSetCompleteHandler( e:Event ):void
		{
			
			photoSetLoader.removeEventListener( Event.COMPLETE, photoSetCompleteHandler );
			totalImages = photoSetLoader.getImageData().length;
			//var currentImage:uint = Math.floor( Math.random() * totalImages );
			trace( photoSetLoader.getImageData()[0].title );
			
			thumbnailDisplay(4);
			//http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
		}
		
		private function thumbnailDisplay(cols:Number = 5):void
		{
			var xTracker:Number = 0;
			var yTracker:Number = 0;
			var colTracker:Number = 0;
			for (var i:uint = 0; i < totalImages; i++)
			{
				var image:ImageLoader = new ImageLoader(flickrURL(i, "s"));
				image.x = xTracker;
				image.y = yTracker;
				xTracker += 76;
				colTracker ++;
				
				if (colTracker == cols) {
				colTracker = 0;
				xTracker = 0;
				yTracker += 76;
				}
				
				this.addChild(image);
			}
		}
		
		private function flickrURL(id:Number, size:String):String
		{
			var s:Object = photoSetLoader.getImageData()[id];
			trace(s.server);
			/*"http://farm" + 
								photos[i].farm + ".static.flickr.com/" + 
								photos[i].server + "/" + 
								photos[i].id + "_" + 
								photos[i].secret + ".jpg" ) */
			var u:String = "http://farm" +
			s.farm + ".static.flickr.com/" +
			s.server + "/" +
			s.id + "_" +
			s.secret + "_" + size + ".jpg";
			return(u);
		}
	}
}