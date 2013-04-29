package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class MenuSelectTrack extends Sprite
	{
		
		public function MenuSelectTrack()
		{
			super();
			
			var btn_new_game:Button = new Button();
			
			this.addChild(btn_new_game);
			btn_new_game.x = Main.screen_width - btn_new_game.width - 50;
			btn_new_game.y = Main.screen_height - btn_new_game.height - 100;
			btn_new_game.label = "Начать игру";
			btn_new_game.addEventListener(MouseEvent.CLICK, NewGame);
		}
		
		private function NewGame(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.CLICK, NewGame);
			dispatchEvent(new CustomEvents("game_begin"));
		}
	}
}