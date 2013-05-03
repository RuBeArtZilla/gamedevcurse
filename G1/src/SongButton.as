package
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class SongButton extends Sprite
	{
		private const _colors:Array = [0xFAD4DB, 0xEC748B, 0xC13A59, 0xA81230];
		private const _colors2:Array = [0xcfd3e8, 0x9aa2cf, 0x4e5ba4, 0x3d4881];
		private const _alphas:Array = [100, 100, 100, 100];
		private const _ratios:Array = [0, 126, 127, 255];
		private const _matrix:Matrix = new Matrix();
		public const _w:Number = 220;
		public const _h:Number = 30;
		
		public var id:uint = 0;
		public var active:Boolean = false;
		public var song_url:String;
		public var song_name:String;
		public var song_artist:String;
		public var song_mini_url:String;
		
		private var label:TextField = new TextField();
		private var labelFormat:TextFormat = new TextFormat();
		private var labelGlow:GlowFilter = new GlowFilter(0x00FF00, .60, 14, 14, 5, 3);
		private var labelGlow2:GlowFilter = new GlowFilter(0x00FFFF, .80, 14, 14, 5, 3);
		private var labelFocus:GlowFilter = new GlowFilter(0x000000, .50, 16, 16, 5, 3);
		private var labelBlur:BlurFilter = new BlurFilter(1, 1, 3);
		
		private var parent:MenuSelectTrack;
		
		public function SongButton()
		{
			super();
		}
		
		public function Init(input:String, par:MenuSelectTrack, _id:uint):SongButton
		{
			id = _id;
			var splited:Array = input.replace("\r", "").split("|");
			song_url = splited[0];
			song_name = splited[1];
			song_artist = splited[2];
			song_mini_url = splited[3];
			
			labelFormat.align = "center";
			labelFormat.size = 20;
			labelFormat.bold = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = song_name;
			label.selectable = false;
			label.setTextFormat(labelFormat);
			this.buttonMode = true;
			this.useHandCursor = true;
			parent = par;
			
			if (active)
				label.filters = [labelGlow, labelBlur, labelFocus];
			else
				label.filters = [labelGlow, labelBlur];
			
			this.addEventListener(MouseEvent.CLICK, onMouseCLICK);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(label);
			
			return this;
		}
		
		private function onMouseCLICK(e:MouseEvent):void
		{
			parent.UpdatePicture(song_mini_url);
			parent.ChangeActive(id);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			label.filters = [labelGlow2];
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			label.filters = [labelGlow, labelBlur];
		}
		
		public function activate():void
		{
			active = !active;
			labelFormat.bold = active;
			label.setTextFormat(labelFormat);
		}
	}
}