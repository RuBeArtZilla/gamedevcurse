package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class MenuMain extends Sprite 
	{
		[Embed(source = "../bkg_menu.png")]
		private var Image:Class;
		
		public function MenuMain() 
		{
			super();
			
						var bkg_img:Bitmap = new Image();
            addChild(bkg_img);
			
			var btn_new_game:Button = new Button();
			this.addChild(btn_new_game);
			
			btn_new_game.x = 100;
			btn_new_game.y = 50;
			btn_new_game.label = "Выбрать трэк";
			btn_new_game.addEventListener(MouseEvent.CLICK, SelectTrackScreen)
		}
		
		private	function SelectTrackScreen(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.CLICK, SelectTrackScreen);
			dispatchEvent(new CustomEvents("menu_select_track"));
		}
	}

}