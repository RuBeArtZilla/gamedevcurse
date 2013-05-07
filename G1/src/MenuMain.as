package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class MenuMain extends Sprite
	{
		[Embed(source="../bkg_menu.png")]
		private var Image:Class;
		private var score_text:TextField = new TextField();

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
			btn_new_game.addEventListener(MouseEvent.CLICK, SelectTrackScreen);
			
			
			var scoreTextFormat:TextFormat = new TextFormat();
			scoreTextFormat.size = 40;
			scoreTextFormat.bold = true;
			scoreTextFormat.color = 0x000000;
			score_text.autoSize = TextFieldAutoSize.LEFT;
			score_text.x = 800;
			score_text.y = 40;
			score_text.selectable = false;
			score_text.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			score_text.text = "Your score: 0";
			
			score_text.visible = false;
			
			score_text.setTextFormat(scoreTextFormat);
			score_text.defaultTextFormat = score_text.getTextFormat();
			addChild(score_text);
		}
		
		private function SelectTrackScreen(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.CLICK, SelectTrackScreen);
			dispatchEvent(new CustomEvents("menu_select_track"));
		}
		
		public function ShowScore(score:int):void
		{
			score_text.visible = true;
			score_text.text = "Your score: " + score.toString();
		}
	}

}