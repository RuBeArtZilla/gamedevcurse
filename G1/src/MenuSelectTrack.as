package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class MenuSelectTrack extends Sprite
	{
		private const song_file:String = "http://files.artzilla.name/game/song_list";
		private const MINI_SIZE:Number = 200;
		private var song_list_loader:URLLoader = new URLLoader();
		private var song_list_file:Array = new Array();
		private var song_list:Array = new Array();
		private var mini:Loader = new Loader();
		
		public function MenuSelectTrack()
		{
			super();
			
			song_list_loader.addEventListener(Event.COMPLETE, onSongListLoaded);
			song_list_loader.load(new URLRequest(song_file));
			
			var btn_new_game:Button = new Button();
			
			this.addChild(btn_new_game);
			btn_new_game.x = Main.screen_width - btn_new_game.width - 50;
			btn_new_game.y = Main.screen_height - btn_new_game.height - 100;
			btn_new_game.label = "Начать игру";
			btn_new_game.addEventListener(MouseEvent.CLICK, NewGame);
		}
		
		private function onSongListLoaded(e:Event):void
		{
			song_list_loader.removeEventListener(Event.COMPLETE, onSongListLoaded);
			song_list_file = e.target.data.split(/\n/);
			
			for each (var song:String in song_list_file)
			{
				song_list.push( new SongButton().Init(song, this) );
				//song_list[song_list.length - 1].addEventListener(MouseEvent.CLICK, onMouseCLICK);
				if (song_list.length > 1)
					song_list[song_list.length - 1].y = song_list[song_list.length - 2].y + song_list[song_list.length - 2].height + 10;
				else
					song_list[song_list.length - 1].y = 10;
				
				this.addChild(song_list[song_list.length - 1]);
			}
		}
		
		private function NewGame(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.CLICK, NewGame);
			dispatchEvent(new CustomEvents("game_begin"));
		}
		
		public function UpdatePicture(url:String):void 
		{
			//removeChild(mini);
			//mini.x = Main.screen_width - MINI_SIZE;
			//mini.y = 20;
			//mini.scaleX = mini.width / MINI_SIZE - 1;
			mini.load(new URLRequest(url));
			addChild(mini);
		}
		
		
	}
}