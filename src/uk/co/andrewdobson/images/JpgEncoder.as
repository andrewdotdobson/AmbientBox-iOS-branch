package uk.co.andrewdobson.images 
{
	import com.adobe.images.JPGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.net.URLRequest
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	/**
	 * ...
	 * @author Andrew DObson
	 */
	public class JpgEncoder 
	{
		
		public function JpgEncoder() 
		{
			
		}
		
		public static function encodeJpg(mc:DisplayObject, w:Number=NaN, h:Number=NaN, q:Number=80):void
		{
			var jpgSource:BitmapData = new BitmapData(w, h);
			jpgSource.draw(mc);
			
			var jpgEncoder:JPGEncoder = new JPGEncoder(q);
			var jpgStream:ByteArray = jpgEncoder.encode(jpgSource);
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			
			var jpgURLRequest:URLRequest = new URLRequest("jpg_encoder_download.php?name=snowflake.jpg");
			
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = jpgStream;
			
			navigateToURL(jpgURLRequest, "_self");
		}
			
	}
	
}