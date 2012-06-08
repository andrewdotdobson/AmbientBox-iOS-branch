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
package org.josht.starling.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.transformCoords;

	/**
	 * Scales an image with nine regions to maintain the aspect ratio of the
	 * corners regions. The top and bottom regions stretch horizontally, and the
	 * left and right regions scale vertically. The center region stretches in
	 * both directions to fill the remaining space.
	 */
	public class Scale9Image extends Sprite
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();
		
		/**
		 * Constructor.
		 */
		public function Scale9Image(texture:Texture, scale9Grid:Rectangle)
		{
			super();
			this._hitArea = new Rectangle();
			
			this._scale9Grid = scale9Grid;
			this.saveWidthAndHeight(texture);
			this.createImages(texture);
			this.refreshProperties(false);
			this.refreshLayout();
		}
		
		/**
		 * @private
		 */
		private var _width:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = value;
			this.refreshLayout();
		}
		
		/**
		 * @private
		 */
		private var _height:Number = NaN;
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = value;
			this.refreshLayout();
		}
		
		/**
		 * @private
		 */
		private var _textureScale:Number = 1;
		
		/**
		 * The amount to scale the texture. Useful for DPI changes.
		 */
		public function get textureScale():Number
		{
			return this._textureScale;
		}
		
		/**
		 * @private
		 */
		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this.refreshLayout();
		}
		
		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * The smoothing value to pass to the images.
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
			this.refreshProperties(true);
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The color value to pass to the images.
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
			this.refreshProperties(true);
		}

		/**
		 * @private
		 */
		private var _autoFlatten:Boolean = true;

		/**
		 * Automatically flattens after layout or property changes to, generally, improve performance.
		 */
		public function get autoFlatten():Boolean
		{
			return this._autoFlatten;
		}

		/**
		 * @private
		 */
		public function set autoFlatten(value:Boolean):void
		{
			if(this._autoFlatten == value)
			{
				return;
			}
			this._autoFlatten = value;
			this.refreshLayout();
		}
		
		private var _scale9Grid:Rectangle;
		private var _leftWidth:Number;
		private var _centerWidth:Number;
		private var _rightWidth:Number;
		private var _topHeight:Number;
		private var _middleHeight:Number;
		private var _bottomHeight:Number;
		
		private var _hitArea:Rectangle;
		
		private var _topLeftImage:Image;
		private var _topCenterImage:Image;
		private var _topRightImage:Image;
		
		private var _middleLeftImage:Image;
		private var _middleCenterImage:Image;
		private var _middleRightImage:Image;
		
		private var _bottomLeftImage:Image;
		private var _bottomCenterImage:Image;
		private var _bottomRightImage:Image;
		
		/**
		 * @inheritDoc
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(this.scrollRect)
			{
				return super.getBounds(targetSpace, resultRect);
			}
			
			if(!resultRect)
			{
				resultRect = new Rectangle();
			}
			
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			if (targetSpace == this) // optimization
			{
				minX = this._hitArea.x;
				minY = this._hitArea.y;
				maxX = this._hitArea.x + this._hitArea.width;
				maxY = this._hitArea.y + this._hitArea.height;
			}
			else
			{
				this.getTransformationMatrix(targetSpace, helperMatrix);
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
			}
			
			resultRect.x = minX;
			resultRect.y = minY;
			resultRect.width  = maxX - minX;
			resultRect.height = maxY - minY;
			
			return resultRect;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}

		/**
		 * @private
		 */
		private function saveWidthAndHeight(texture:Texture):void
		{
			const textureFrame:Rectangle = texture.frame;
			this._leftWidth = this._scale9Grid.x;
			this._centerWidth = this._scale9Grid.width;
			this._rightWidth = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			this._topHeight = this._scale9Grid.y;
			this._middleHeight = this._scale9Grid.height;
			this._bottomHeight = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;
		}
		
		/**
		 * @private
		 */
		private function createImages(texture:Texture):void
		{
			//start by creating the subtextures
			
			const textureFrame:Rectangle = texture.frame;
			
			const regionLeftWidth:Number = this._leftWidth + textureFrame.x;
			const regionTopHeight:Number = this._topHeight + textureFrame.y;
			const regionRightWidth:Number = this._rightWidth - (textureFrame.width - texture.width) - textureFrame.x;
			const regionBottomHeight:Number = this._bottomHeight - (textureFrame.height - texture.height) - textureFrame.y;
			
			const hasLeftFrame:Boolean = regionLeftWidth != this._leftWidth;
			const hasTopFrame:Boolean = regionTopHeight != this._topHeight;
			const hasRightFrame:Boolean = regionRightWidth != this._rightWidth;
			const hasBottomFrame:Boolean = regionBottomHeight != this._bottomHeight;
			
			const topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			const topLeftFrame:Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._leftWidth, this._topHeight) : null;
			const topLeft:Texture = Texture.fromTexture(texture, topLeftRegion, topLeftFrame);
			
			const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, this._centerWidth, regionTopHeight);
			const topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, this._centerWidth, this._topHeight) : null;
			const topCenter:Texture = Texture.fromTexture(texture, topCenterRegion, topCenterFrame);
			
			const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, 0, regionRightWidth, regionTopHeight);
			const topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, this._rightWidth, this._topHeight) : null;
			const topRight:Texture = Texture.fromTexture(texture, topRightRegion, topRightFrame);
			
			const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, this._middleHeight);
			const middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._middleHeight) : null;
			const middleLeft:Texture = Texture.fromTexture(texture, middleLeftRegion, middleLeftFrame);
			
			const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, this._centerWidth, this._middleHeight);
			const middleCenter:Texture = Texture.fromTexture(texture, middleCenterRegion);
			
			const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight, regionRightWidth, this._middleHeight);
			const middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, this._rightWidth, this._middleHeight) : null;
			const middleRight:Texture = Texture.fromTexture(texture, middleRightRegion, middleRightFrame);
			
			const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + this._middleHeight, regionLeftWidth, regionBottomHeight);
			const bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._bottomHeight) : null;
			const bottomLeft:Texture = Texture.fromTexture(texture, bottomLeftRegion, bottomLeftFrame);
			
			const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + this._middleHeight, this._centerWidth, regionBottomHeight);
			const bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, this._centerWidth, this._bottomHeight) : null;
			const bottomCenter:Texture = Texture.fromTexture(texture, bottomCenterRegion, bottomCenterFrame);
			
			const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight + this._middleHeight, regionRightWidth, regionBottomHeight);
			const bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, this._rightWidth, this._bottomHeight) : null;
			const bottomRight:Texture = Texture.fromTexture(texture, bottomRightRegion, bottomRightFrame);
			
			//then pass them to the images
			this._topLeftImage = new Image(topLeft);
			this._topLeftImage.touchable = false;
			this.addChild(this._topLeftImage);
			this._topCenterImage = new Image(topCenter);
			this._topCenterImage.touchable = false;
			this.addChild(this._topCenterImage);
			this._topRightImage = new Image(topRight);
			this._topRightImage.touchable = false;
			this.addChild(this._topRightImage);
			
			this._middleLeftImage = new Image(middleLeft);
			this._middleLeftImage.touchable = false;
			this.addChild(this._middleLeftImage);
			this._middleCenterImage = new Image(middleCenter);
			this._middleLeftImage.touchable = false;
			this.addChild(this._middleCenterImage);
			this._middleRightImage = new Image(middleRight);
			this._middleRightImage.touchable = false;
			this.addChild(this._middleRightImage);
			
			this._bottomLeftImage = new Image(bottomLeft);
			this._bottomLeftImage.touchable = false;
			this.addChild(this._bottomLeftImage);
			this._bottomCenterImage = new Image(bottomCenter);
			this._bottomCenterImage.touchable = false;
			this.addChild(this._bottomCenterImage);
			this._bottomRightImage = new Image(bottomRight);
			this._bottomRightImage.touchable = false;
			this.addChild(this._bottomRightImage);
		}
		
		/**
		 * @private
		 */
		private function refreshProperties(canAutoFlatten:Boolean):void
		{
			this._topLeftImage.smoothing = this._smoothing;
			this._topCenterImage.smoothing = this._smoothing;
			this._topRightImage.smoothing = this._smoothing;
			
			this._middleLeftImage.smoothing = this._smoothing;
			this._middleCenterImage.smoothing = this._smoothing;
			this._middleRightImage.smoothing = this._smoothing;
			
			this._bottomLeftImage.smoothing = this._smoothing;
			this._bottomCenterImage.smoothing = this._smoothing;
			this._bottomRightImage.smoothing = this._smoothing;

			this._topLeftImage.color = this._color;
			this._topCenterImage.color = this._color;
			this._topRightImage.color = this._color;

			this._middleLeftImage.color = this._color;
			this._middleCenterImage.color = this._color;
			this._middleRightImage.color = this._color;

			this._bottomLeftImage.color = this._color;
			this._bottomCenterImage.color = this._color;
			this._bottomRightImage.color = this._color;
			
			if(canAutoFlatten && this._autoFlatten)
			{
				this.flatten();
			}
		}
		
		/**
		 * @private
		 */
		private function refreshLayout():void
		{
			const scaledLeftWidth:Number = this._leftWidth * this._textureScale;
			const scaledTopHeight:Number = this._topHeight * this._textureScale;
			const scaledRightWidth:Number = this._rightWidth * this._textureScale;
			const scaledBottomHeight:Number = this._bottomHeight * this._textureScale;
			if(isNaN(this._width))
			{
				this._width = this._leftWidth + this._centerWidth + this._rightWidth * this._textureScale;
			}
			
			if(isNaN(this._height))
			{
				this._height = this._topHeight + this._middleHeight + this._bottomHeight * this._textureScale;
			}
			
			this._topLeftImage.scaleX = this._topLeftImage.scaleY = this._textureScale;
			this._topLeftImage.x = scaledLeftWidth - this._topLeftImage.width;
			this._topLeftImage.y = scaledTopHeight - this._topLeftImage.height;
			this._topCenterImage.scaleX = this._topCenterImage.scaleY = this._textureScale;
			this._topCenterImage.x = scaledLeftWidth;
			this._topCenterImage.y = scaledTopHeight - this._topCenterImage.height;
			this._topCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._topRightImage.scaleX = this._topRightImage.scaleY = this._textureScale;
			this._topRightImage.x = this._width - scaledRightWidth;
			this._topRightImage.y = scaledTopHeight - this._topRightImage.height;
			
			this._middleLeftImage.scaleX = this._middleLeftImage.scaleY = this._textureScale;
			this._middleLeftImage.x = scaledLeftWidth - this._middleLeftImage.width;
			this._middleLeftImage.y = scaledTopHeight;
			this._middleLeftImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			this._middleCenterImage.scaleX = this._middleCenterImage.scaleY = this._textureScale;
			this._middleCenterImage.x = scaledLeftWidth;
			this._middleCenterImage.y = scaledTopHeight;
			this._middleCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._middleCenterImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			this._middleRightImage.x = this._width - scaledRightWidth;
			this._middleRightImage.scaleX = this._middleRightImage.scaleY = this._textureScale;
			this._middleRightImage.y = scaledTopHeight;
			this._middleRightImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			
			this._bottomLeftImage.scaleX = this._bottomLeftImage.scaleY = this._textureScale;
			this._bottomLeftImage.x = scaledLeftWidth - this._bottomLeftImage.width;
			this._bottomLeftImage.y = this._height - scaledBottomHeight;
			this._bottomCenterImage.scaleX = this._bottomCenterImage.scaleY = this._textureScale;
			this._bottomCenterImage.x = scaledLeftWidth;
			this._bottomCenterImage.y = this._height - scaledBottomHeight;
			this._bottomCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._bottomRightImage.scaleX = this._bottomRightImage.scaleY = this._textureScale;
			this._bottomRightImage.x = this._width - scaledRightWidth;
			this._bottomRightImage.y = this._height - scaledBottomHeight;
			
			this._hitArea.width = this._width;
			this._hitArea.height = this._height;
			if(this._autoFlatten)
			{
				this.flatten();
			}
		}
	}
}