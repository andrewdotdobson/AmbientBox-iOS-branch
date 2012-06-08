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
package org.josht.starling.foxhole.controls
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;
	import starling.utils.transformCoords;

	/**
	 * Displays a single-line of text. Cannot be clipped.
	 */
	public class Label extends FoxholeControl
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();
		
		public function Label()
		{
			this.isQuickHitAreaEnabled = true;
		}
		
		private var _characters:Vector.<Image> = new <Image>[];
		private var _cache:Vector.<Image> = new <Image>[];
		
		private var _lastFont:BitmapFont;
		
		/**
		 * @private
		 */
		private var _textFormat:BitmapFontTextFormat;
		
		/**
		 * The font and styles used to draw the text.
		 */
		public function get textFormat():BitmapFontTextFormat
		{
			return this._textFormat;
		}
		
		/**
		 * @private
		 */
		public function set textFormat(value:BitmapFontTextFormat):void
		{
			if(this._textFormat == value)
			{
				return;
			}
			this._textFormat = value;
			if(this._textFormat)
			{
				if(this._textFormat.font != this._lastFont)
				{
					this.invalidate(INVALIDATION_FLAG_DATA);
				}
				this._lastFont = this._textFormat.font;
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @private
		 */
		private var _text:String = "";
		
		/**
		 * The text to display.
		 */
		public function get text():String
		{
			return this._text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * A smoothing value passed to each character.
		 */
		public function get smoothing():String
		{
			return this._smoothing;
		}
		
		/**
		 * @private
		 */
		public function set smoothing(value:String):void
		{
			if(this._smoothing == value)
			{
				return;
			}
			this._smoothing = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._lastFont = null;
			super.dispose();
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			
			if(dataInvalid)
			{
				this.rebuildCharacters();
			}
			
			if(dataInvalid || stylesInvalid)
			{
				const color:uint = this._textFormat ? this._textFormat.color : uint.MAX_VALUE;
				for each(var charDisplay:Image in this._characters)
				{
					charDisplay.color = color;
					charDisplay.smoothing = this.smoothing;
				}
				this.layout();
			}
		}
		
		/**
		 * @private
		 */
		private function rebuildCharacters():void
		{
			if(!this._textFormat)
			{
				while(this._characters.length > 0)
				{
					var charDisplay:Image = this._characters.shift();
					this.removeChild(charDisplay);
				}
				return;
			}
			
			const temp:Vector.<Image> = this._cache;
			this._cache = this._characters;
			this._characters = temp;
			this._characters.length = 0;
			
			const font:BitmapFont = this._textFormat.font;
			const charCount:int = this._text.length;
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:Number = this._text.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					trace("Missing character " + String.fromCharCode(charID) + " in font " + font.name + ".");
					continue;
				}
				if(this._cache.length > 0)
				{
					charDisplay = this._cache.shift();
					charDisplay.texture = charData.texture;
					charDisplay.readjustSize();
				}
				else
				{
					charDisplay = charData.createImage();
					charDisplay.touchable = false;
				}
				this.addChild(charDisplay);
				this._characters.push(charDisplay);
			}
			while(this._cache.length > 0)
			{
				charDisplay = this._cache.shift();
				this.removeChild(charDisplay);
			}
		}
		
		/**
		 * @private
		 */
		private function layout():void
		{
			if(!this._textFormat)
			{
				this.setSizeInternal(0, 0, false);
				return;
			}
			const font:BitmapFont = this._textFormat.font;
			const customSize:Number = this._textFormat.size;
			const customLetterSpacing:Number = this._textFormat.letterSpacing;
			const isKerningEnabled:Boolean = this._textFormat.isKerningEnabled;
			const scale:Number = isNaN(customSize) ? 1 : (customSize / font.size);
			
			var currentX:Number = 0;
			var maxY:Number = 0;
			var lastCharID:Number = NaN; 
			var characterIndex:int = 0;
			const charCount:int = this._text.length;
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:Number = this._text.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					continue;
				}
				if(isKerningEnabled && !isNaN(lastCharID))
				{
					currentX += charData.getKerning(lastCharID);
				}
				var charDisplay:Image = this._characters[characterIndex];
				charDisplay.scaleX = charDisplay.scaleY = scale;
				charDisplay.x = currentX + charData.xOffset * scale;
				charDisplay.y = charData.yOffset * scale;
				
				currentX += charData.xAdvance * scale + customLetterSpacing;
				maxY = Math.max(maxY, charDisplay.y + charDisplay.height);
				lastCharID = charID;
				characterIndex++;
			}
			
			this.setSizeInternal(currentX, Math.max(maxY, font.lineHeight * scale), false);
		}
	}
}