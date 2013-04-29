package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import mx.core.FlexSimpleButton;
	
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Main extends Sprite
	{
		private var menu_main:MenuMain;
		private var menu_select_track:MenuSelectTrack;
		private var menu_end_game:MenuEndGame;
		private var game:Game;
		public static var screen_height:int = 720;
		public static var screen_width:int = 1280;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			screen_height = 720;
			screen_width = 1280;
			menu_main = new MenuMain();
			addChild(menu_main);
			menu_main.addEventListener(CustomEvents.MENU_SELECT_TRACK, selectTrack, false, 0, true);
		}
		
		private function selectTrack(e:CustomEvents):void
		{
			menu_main.removeEventListener(CustomEvents.MENU_SELECT_TRACK, selectTrack);
			removeChild(menu_main);
			
			menu_select_track = new MenuSelectTrack();
			addChild(menu_select_track);
			menu_select_track.addEventListener(CustomEvents.GAME_BEGIN, startGame, false, 0, true);
		}
		
		private function startGame(e:CustomEvents):void
		{
			menu_select_track.removeEventListener(CustomEvents.GAME_BEGIN, startGame);
			removeChild(menu_select_track);
			
			game = new Game();
			addChild(game);
			game.addEventListener(CustomEvents.GAME_END, endGame, false, 0, true);
		}
		
		private function endGame(e:CustomEvents):void
		{
			game.removeEventListener(CustomEvents.GAME_END, endGame);
			removeChild(game);
			
			menu_end_game = new MenuEndGame();
			addChild(menu_end_game);
			menu_end_game.addEventListener(CustomEvents.MENU_SELECT_TRACK, startGame, false, 0, true);
		}
	}

}