package  
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class CustomEvents extends Event 
	{
		public static const GAME_BEGIN:String = "game_begin";
		public static const GAME_END:String = "game_end";
		public static const MENU_SELECT_TRACK:String = "menu_select_track";
		public static const MENU_EXIT:String = "menu_exit";
		
		public function CustomEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}