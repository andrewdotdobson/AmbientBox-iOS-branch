/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package org.josht.starling.text
{
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	
	/**
	 * A subclass of Starling's BitmapFont class to expose the baseline value.
	 * Will be removed if and when Starling adds support.
	 */
	public class BitmapFont extends starling.text.BitmapFont
	{
		private var mBase:Number;
	
		/**
		 * Constructor.
		 */
		public function BitmapFont(texture:Texture, fontXml:XML=null)
		{
			super(texture, fontXml);
			if(fontXml)
			{
				parseFontXml(fontXml);
			}
		}
		
		/**
		 * @private
		 */
		private function parseFontXml(fontXml:XML):void
		{
			mBase = parseFloat(fontXml.common.attribute("base"));
		}
		
		/**
		 * The baseline value for the font.
		 */
		public function get base():Number { return mBase; }
		
		/**
		 * @private
		 */
		public function set base(value:Number):void { mBase = value; }
	}
}