package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class SongButton extends Sprite 
	{

		public var song_url:String;
		public var song_name:String;
		public var song_artist:String;
		public var song_mini_url:String;
		
		private var label:TextField = new TextField();
		private var labelFormat:TextFormat = new TextFormat();	
		
		private var parent:MenuSelectTrack;
		
		public function SongButton() 
		{
			super();
		}
		
		public function Init(input:String, par:MenuSelectTrack):SongButton 
		{
			var splited:Array = input.split("|");
			song_url = splited[0];
			song_name = splited[1];
			song_artist = splited[2];
			song_mini_url = splited[3];		
			label.text = song_name;
			label.setTextFormat(labelFormat);
			parent = par;
			
			this.addEventListener(MouseEvent.CLICK, onMouseCLICK);
			this.addChild(label);
			
			return this;
		}
		
		private function onMouseCLICK(e:MouseEvent):void
		{
			parent.UpdatePicture(song_mini_url);
		}
	}
}