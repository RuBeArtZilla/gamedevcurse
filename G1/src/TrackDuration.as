package  
{
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class TrackDuration extends Sprite 
	{
		private const GLOW_DURATION:uint = 40;
		
		private var current_position:Number = 0;
		private var track_duration:Number = 100000;
		private var pos_y:Number = 720;
		private var screen_offset:Number = 0.95;
		private var left_offset:Number = 200;
		private var track_duration_in_pixel:Number = 0;
		
		private var glow:GlowFilter = new GlowFilter(0xCCCCCC,  0.8, 16, 16, 4, BitmapFilterQuality.HIGH, false, false);
		
		private var cooldown:uint = GLOW_DURATION;
		
		private var track_duration_current:TrackDurationCurrent = new TrackDurationCurrent();
		public function TrackDuration() 
		{
			super();
			
		}
		
		public function Init():void
		{
			
			pos_y = Main.screen_height * screen_offset;
			left_offset = Main.screen_width * (1 - screen_offset) + left_offset;
			track_duration_in_pixel = Main.screen_width * screen_offset - left_offset;
			
			filters = [ glow ];
			
			this.graphics.lineStyle(4, 0x00FFAA, 0.6);
			this.graphics.moveTo(left_offset, pos_y);
			this.graphics.lineTo(Main.screen_width * screen_offset, pos_y);
			this.graphics.endFill();
			
			track_duration_current.y = pos_y;
			track_duration_current.x = left_offset;
			this.addChild(track_duration_current);
		}
		
		public function Update(pos:Number, len:Number):void
		{
			current_position = pos;
			track_duration = len;
			cooldown--;
			
			glow.blurX = 8 + Math.sin(Math.PI * cooldown / 20);
			glow.blurY = 8 + Math.sin(Math.PI * cooldown / 20);
			
			filters = [ glow ];
			
			track_duration_current.x = left_offset + (pos / track_duration) * track_duration_in_pixel;
			
			
			if (!cooldown)
				cooldown = GLOW_DURATION;
		}
	}

}