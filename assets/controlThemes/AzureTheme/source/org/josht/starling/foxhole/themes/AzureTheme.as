package org.josht.starling.foxhole.themes
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import org.josht.starling.display.Image;
	import org.josht.starling.display.Scale3Image;
	import org.josht.starling.display.Scale9Image;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.FPSDisplay;
	import org.josht.starling.foxhole.controls.Label;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.PickerList;
	import org.josht.starling.foxhole.controls.SimpleItemRenderer;
	import org.josht.starling.foxhole.controls.Slider;
	import org.josht.starling.foxhole.controls.ToggleSwitch;
	import org.josht.starling.foxhole.core.AddedWatcher;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.josht.starling.text.BitmapFont;

	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AzureTheme extends AddedWatcher
	{
		[Embed(source="/../assets/images/azure.png")]
		private static const ATLAS_IMAGE:Class;

		[Embed(source="/../assets/images/azure.xml",mimeType="application/octet-stream")]
		private static const ATLAS_XML:Class;

		private static const ATLAS:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ATLAS_IMAGE, false), XML(new ATLAS_XML()));

		private static const BUTTON_UP_SKIN_TEXTURE:Texture = ATLAS.getTexture("button-up-skin");

		private static const BUTTON_DOWN_SKIN_TEXTURE:Texture = ATLAS.getTexture("button-down-skin");

		private static const BUTTON_DISABLED_SKIN_TEXTURE:Texture = ATLAS.getTexture("button-disabled-skin");

		private static const SLIDER_TRACK_UP_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-track-up-skin");

		private static const SLIDER_TRACK_DOWN_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-track-down-skin");

		private static const SLIDER_TRACK_DISABLED_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-track-disabled-skin");

		private static const SLIDER_THUMB_UP_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-thumb-up-skin");

		private static const SLIDER_THUMB_DOWN_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-thumb-down-skin");

		private static const SLIDER_THUMB_DISABLED_SKIN_TEXTURE:Texture = ATLAS.getTexture("slider-thumb-disabled-skin");

		private static const INSET_BACKGROUND_LEFT_TEXTURE:Texture = ATLAS.getTexture("inset-left");

		private static const INSET_BACKGROUND_RIGHT_TEXTURE:Texture = ATLAS.getTexture("inset-right");

		private static const PICKER_ICON_TEXTURE:Texture = ATLAS.getTexture("picker-icon");

		private static const LIST_ITEM_UP_TEXTURE:Texture = ATLAS.getTexture("list-item-up-skin");

		private static const LIST_ITEM_DOWN_TEXTURE:Texture = ATLAS.getTexture("list-item-down-skin");

		[Embed(source="/../assets/fonts/lato30.fnt",mimeType="application/octet-stream")]
		private static const ATLAS_FONT_XML:Class;

		private static const BITMAP_FONT:BitmapFont = new BitmapFont(ATLAS.getTexture("lato30_0"), XML(new ATLAS_FONT_XML()));

		private static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(8, 8, 15, 71);
		private static const INSET_LEFT_SCALE_9_GRID:Rectangle = new Rectangle(8, 8, 8, 16);
		private static const INSET_RIGHT_SCALE_9_GRID:Rectangle = new Rectangle(0, 8, 8, 16);
		private static const SLIDER_FIRST:Number = 16;
		private static const SLIDER_SECOND:Number = 15;
		
		private static const PRIMARY_TEXT_COLOR:uint = 0xe5e5e5;
		private static const SELECTED_TEXT_COLOR:uint = 0xffffff;

		public function AzureTheme(root:DisplayObject, scaleToDPI:Boolean = true)
		{
			super(root);
			this.initialize(scaleToDPI);
		}

		private var _scale:Number;
		private var _fontSize:int;

		private function initialize(scaleToDPI:Boolean):void
		{
			this._scale = scaleToDPI ? (Capabilities.screenDPI / 326) : 1;

			this._fontSize = 30 * this._scale;

			this.setInitializerForClass(Label, labelInitializer);
			this.setInitializerForClass(FPSDisplay, labelInitializer);
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(Slider, sliderInitializer)
			this.setInitializerForClass(ToggleSwitch, toggleSwitchInitializer);
			this.setInitializerForClass(SimpleItemRenderer, itemRendererInitializer);
			this.setInitializerForClass(PickerList, pickerListInitializer);
		}

		private function labelInitializer(label:Label):void
		{
			if(label.name)
			{
				return;
			}
			label.textFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
		}

		private function buttonInitializer(button:Button):void
		{
			if(button.name == "foxhole-slider-thumb")
			{
				const sliderThumbDefaultSkin:Image = new Image(SLIDER_THUMB_UP_SKIN_TEXTURE);
				sliderThumbDefaultSkin.width = 88 * this._scale;
				sliderThumbDefaultSkin.height = 88 * this._scale;
				button.defaultSkin = sliderThumbDefaultSkin;
				const sliderThumbDownSkin:Image = new Image(SLIDER_THUMB_DOWN_SKIN_TEXTURE);
				button.downSkin = sliderThumbDownSkin;
				const sliderThumbDisabledSkin:Image = new Image(SLIDER_THUMB_DISABLED_SKIN_TEXTURE);
				button.disabledSkin = sliderThumbDisabledSkin;
			}
			else if(button.name == "foxhole-slider-track")
			{
				const sliderTrackDefaultSkin:Scale3Image = new Scale3Image(SLIDER_TRACK_UP_SKIN_TEXTURE, SLIDER_FIRST, SLIDER_SECOND);
				sliderTrackDefaultSkin.textureScale = this._scale;
				button.defaultSkin = sliderTrackDefaultSkin;
				const sliderTrackDownSkin:Scale3Image = new Scale3Image(SLIDER_TRACK_DOWN_SKIN_TEXTURE, SLIDER_FIRST, SLIDER_SECOND);
				sliderTrackDownSkin.textureScale = this._scale;
				button.downSkin = sliderTrackDownSkin;
				const sliderTrackDisabledSkin:Scale3Image = new Scale3Image(SLIDER_TRACK_DISABLED_SKIN_TEXTURE, SLIDER_FIRST, SLIDER_SECOND);
				sliderTrackDisabledSkin.textureScale = this._scale;
				button.disabledSkin = sliderTrackDisabledSkin;
			}
			else
			{
				const defaultSkin:Scale9Image = new Scale9Image(BUTTON_UP_SKIN_TEXTURE, BUTTON_SCALE_9_GRID);
				defaultSkin.width = 88 * this._scale;
				defaultSkin.height = 88 * this._scale;
				defaultSkin.textureScale = this._scale;
				button.defaultSkin = defaultSkin;

				const downSkin:Scale9Image = new Scale9Image(BUTTON_DOWN_SKIN_TEXTURE, BUTTON_SCALE_9_GRID);
				downSkin.width = 88 * this._scale;
				downSkin.height = 88 * this._scale;
				downSkin.textureScale = this._scale;
				button.downSkin = downSkin;

				const disabledSkin:Scale9Image = new Scale9Image(BUTTON_DISABLED_SKIN_TEXTURE, BUTTON_SCALE_9_GRID);
				disabledSkin.width = 88 * this._scale;
				disabledSkin.height = 88 * this._scale;
				disabledSkin.textureScale = this._scale;
				button.defaultSelectedSkin = disabledSkin;

				button.defaultSelectedSkin = downSkin;

				button.defaultTextFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
				button.defaultSelectedTextFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);

				button.contentPadding = 16 * this._scale;
				button.gap = 12 * this._scale;
			}

			if(button.name == "foxhole-pickerlist-button")
			{
				const pickerListButtonDefaultIcon:Image = new Image(PICKER_ICON_TEXTURE);
				pickerListButtonDefaultIcon.scaleX = pickerListButtonDefaultIcon.scaleY = this._scale;
				button.defaultIcon = pickerListButtonDefaultIcon
				button.gap = Number.POSITIVE_INFINITY; //fill as completely as possible
				button.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
				button.iconPosition = Button.ICON_POSITION_RIGHT;
			}
		}

		private function sliderInitializer(slider:Slider):void
		{
			if(slider.direction == Slider.DIRECTION_HORIZONTAL)
			{
				slider.setTrackProperty("width", 264 * this._scale);
				slider.setTrackProperty("height", 88 * this._scale);
			}
			else
			{
				slider.setTrackProperty("width", 88 * this._scale);
				slider.setTrackProperty("height", 264 * this._scale);
			}
		}

		private function toggleSwitchInitializer(toggleSwitch:ToggleSwitch):void
		{
			const onSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_LEFT_TEXTURE, INSET_LEFT_SCALE_9_GRID);
			onSkin.textureScale = this._scale;
			onSkin.width = 132 * this._scale;
			onSkin.height = 88 * this._scale;
			toggleSwitch.onSkin = onSkin;

			const offSkin:Scale9Image = new Scale9Image(INSET_BACKGROUND_RIGHT_TEXTURE, INSET_RIGHT_SCALE_9_GRID);
			offSkin.textureScale = this._scale;
			offSkin.width = 132 * this._scale;
			offSkin.height = 88 * this._scale;
			toggleSwitch.offSkin = offSkin;

			toggleSwitch.defaultTextFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
			toggleSwitch.onTextFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, SELECTED_TEXT_COLOR);
		}

		private function itemRendererInitializer(renderer:SimpleItemRenderer):void
		{
			const defaultSkin:Image = new Image(LIST_ITEM_UP_TEXTURE);
			defaultSkin.width = 88 * this._scale;
			defaultSkin.height = 88 * this._scale;
			renderer.defaultSkin = defaultSkin;

			const downSkin:Image = new Image(LIST_ITEM_DOWN_TEXTURE);
			downSkin.width = 88 * this._scale;
			downSkin.height = 88 * this._scale;
			renderer.downSkin = downSkin;

			renderer.defaultSelectedSkin = downSkin;

			renderer.contentPadding = 20 * this._scale;
			renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;

			renderer.defaultTextFormat = new BitmapFontTextFormat(BITMAP_FONT, this._fontSize, PRIMARY_TEXT_COLOR);
		}

		private function pickerListInitializer(list:PickerList):void
		{
			list.listProperties =
			{
				verticalAlign: List.VERTICAL_ALIGN_BOTTOM,
				clipContent: true
			}
		}
	}
}