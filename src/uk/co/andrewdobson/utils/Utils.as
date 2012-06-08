package uk.co.andrewdobson.utils 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Andrew DObson
	 */

	public class Utils
	{
		
		/**	Returns a random whole number in between a provided range
		 * 
		 * @param from: integer to start from 
		 * @param to: integer to end at
		 * 
		 * @return random integer between provided range
		 */
		public static function randomInRange(from:int, to:int):int {
			
			//return Math.ceil(Math.random() * (to – from + 1)) + from;
			return Math.floor(Math.random() * (to - from + 1)) + from;
		}
		
		/** Caculates the relative position of a number given a range to rescale from and to
		 * B=y1+(y2-y1)*(A-x1)/(x2-x1)
		 * where A is a point between x1 and x2 and
		 * B is a point between y1 and y2
		 * 
		 * @author andy
		 * 
		 * @param a: the number to be converted
		 * @param x1: low end of the original scale
		 * @param x2: high end of the original scale
		 * @param y1: low end of the new scale
		 * @param y2: high end of the new scale
		 * 
		 * @return rescaled number
		 * 
		 */
		public static function rescaleRange(a:Number, x1:Number, x2:Number, y1:Number, y2:Number):Number
		{
			
			var b:Number = y1 + (y2 - y1) * (a - x1) / (x2 - x1);
			return b;
		}
		
		/**
		 * tests the value to see whether or not it's a whole number
		 * @author andy
		 * 
		 * @param	value 
		 * @return  Boolean
		 */
		public static function isWholeNumber(value:Number):Boolean
		{
			var check:Number = value % 1;
			if (check)
			{
				return false;
			} else {
				return true;
			}
		}
		/**
		 * adds a quick cachebuster token to any string
		 * @author andy
		 * 
		 * @param	u: string to have the cachecontrol added
		 * @return string with cache appended
		 */
		public static function cacheControl(u:String):String
		{
			//return u + "?cachbuster=" + new Date().getTime();
			return null;
			//myXML.load("tabs.xml?cachebuster=" + new Date().getTime());
		}
		
		public static function isLocalPlayback():Boolean
		{
			return true;
		}
		
		/**
		 * Converts a string value (i.e. from XML) to a boolean value
		 * @param	value: a string literal to be tested
		 * @return	Boolean
		 */
		public static function string2Boolean(value:String):Boolean
		{
			var isBoolean:Boolean = false;
			switch (value.toLowerCase())
			{
				case "1":
				case "true":
				 case "yes":
				 case "y":
				 case "on":
				 case "enabled":
				 isBoolean = true;
				 break;
			}
			return isBoolean;
		}
		
		/**
		 * returns time in hh:mm:ss format from seconds
		 * 
		 * @param	time in seconds
		 * @return 	string
		 */
		public static function formatTime ( time:Number ):String
		{
			var remainder:Number;
			var hours:Number = time / ( 60 * 60 );
			remainder = hours - (Math.floor ( hours ));
			hours = Math.floor ( hours );
			var minutes:Number = remainder * 60;
			remainder = minutes - (Math.floor ( minutes ));
			minutes = Math.floor ( minutes );
			var seconds:Number = remainder * 60;
			remainder = seconds - (Math.floor ( seconds ));
			seconds = Math.floor ( seconds );
			var hString:String = hours < 10 ? "0" + hours : "" + hours;	
			var mString:String = minutes < 10 ? "0" + minutes : "" + minutes;
			var sString:String = seconds < 10 ? "0" + seconds : "" + seconds;
			if ( time < 0 || isNaN(time)) return "00:00";			
			if ( hours > 0 )
			{			
				return hString + ":" + mString + ":" + sString;
			}else
			{
				return mString + ":" + sString;
			}
		}
		
		//arry stuff
		public static function arrayLookUp(item:*, array:Array):*
		{
			for (var i:Number = 0; i < array.length(); i++)
			{
				if (item == array[i])
				{
					break;
					return item;
				}
			}
		}
	}
	
}