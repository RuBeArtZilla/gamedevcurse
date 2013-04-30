package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFormatAlign;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Score extends Sprite
	{
		private const MAX_XP:int = 100;
		private const DEFAULT_HP:int = 50;
		
		private const SCREEN_OFFSET:Number = 0.95;
		private const DEFAULT_SCREEN_POSITION = SCREEN_OFFSET * Main.screen_height;
		
		private const DEFAULT_FONT_SIZE:Number = 40;
		
		public const SCORE_MULTIPLIER:Number = 50;
		public const SCALE:Number = 5;
		
		private var score:int = 0; //Current player scores
		private var hp:int = DEFAULT_HP; //Current hp, if less 0 game_over
		private var series:int = 0; //Correct keys in a row
		
		private var score_text:TextField = new TextField();
		private var score_text_color:uint = 0x00FF00;
		
		private var notice_array:Array = new Array(); //For "fly" text with scores changes
		
		public function Score()
		{
			super();
		}
		
		public function Init(start_score:int = 0):void
		{
			var scoreTextFormat:TextFormat = new TextFormat();
			
			score_text.selectable = false;
			score_text.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			score_text.textColor = score_text_color;
			
			scoreTextFormat.align = TextFormatAlign.LEFT;
			scoreTextFormat.size = DEFAULT_FONT_SIZE;
			score_text.text = String(score);
			score_text.setTextFormat(scoreTextFormat);
			
			score_text.defaultTextFormat = score_text.getTextFormat();
			
			score_text.x = (1 - SCREEN_OFFSET) * Main.screen_width;
			score_text.y = DEFAULT_SCREEN_POSITION - DEFAULT_FONT_SIZE;
			
			addChild(score_text);
			
			filters = [new GlowFilter(0xFFFFFF, 0.8, 12, 12, 2, BitmapFilterQuality.LOW, false, false), new GlowFilter(0xFFFFFF, 1, 2, 2, 2, BitmapFilterQuality.LOW, true, false)];
		}
		
		public function Update():void
		{
			if (notice_array.length)
			{
				for each (var flytext:TextField in notice_array)
				{
					flytext.y = flytext.y - 1;
					flytext.alpha = flytext.alpha - 0.01;
				}
				
				if (notice_array[0].alpha <= 0)
				{
					removeChild(notice_array[0]);
					notice_array.shift();
				}
			}
		}
		
		public function Change(correct:Boolean, percent:Number /*must be [0...1]*/):void
		{
			if ((percent > 1) || (percent < 0)) return;
			
			var change:Number = - Math.floor(SCALE * Math.abs(percent * percent));
			
			if (correct)
			{
				change += SCALE * 2;
				
				if (change > 2)
				{
					series++;
					change += series;
				}
				
				score += change * SCORE_MULTIPLIER;
			}
			else
			{
				series = 0;
				score += change * SCORE_MULTIPLIER;
			}
			
			hp += change;
			if (hp > MAX_XP)
				hp = MAX_XP;
				
			var pos:Number = notice_array.length;
			
			notice_array.push(new TextField());
			notice_array[pos].x = (1 - SCREEN_OFFSET) * Main.screen_width;
			notice_array[pos].y = DEFAULT_SCREEN_POSITION - DEFAULT_FONT_SIZE - DEFAULT_FONT_SIZE;
			
			var scoreTextFormat:TextFormat = new TextFormat();
			scoreTextFormat.align = TextFormatAlign.LEFT;
			scoreTextFormat.size = DEFAULT_FONT_SIZE;
			notice_array[pos].setTextFormat(scoreTextFormat);
			notice_array[pos].defaultTextFormat = notice_array[pos].getTextFormat();
						
			if (correct)
			{
				notice_array[pos].textColor = 0x00FF00;
				notice_array[pos].text = "+".concat( String(change * SCORE_MULTIPLIER));
			}
			else 
			{
				notice_array[pos].textColor = 0xFF0000;
				notice_array[pos].text = String(change * SCORE_MULTIPLIER);
			}
			
			//notice_array[pos].filters = [new GlowFilter(0xFFFFFF, 1, 4, 4, 4, BitmapFilterQuality.LOW, false, false)];
			
			addChild(notice_array[pos]);
			
			score_text.text = String(score);
		}
	}

}