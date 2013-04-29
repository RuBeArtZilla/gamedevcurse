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
	public class TrackDurationCurrent extends Sprite 
	{
		
		public function TrackDurationCurrent() 
		{
			super();
			this.graphics.lineStyle(2, 0xCC2222, 0.5);
			this.graphics.beginFill(0xCC2222, 0.8);
			this.graphics.drawCircle(0, 0, 4);
			this.graphics.endFill();
			//filters = [ new GlowFilter(0x000000,  0.8, 12, 12, 2, BitmapFilterQuality.HIGH, false, false) ];
		}
		
		public function Update():void
		{
			
		}
	}
}