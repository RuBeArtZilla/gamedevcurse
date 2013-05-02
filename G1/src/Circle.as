package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Circle extends Sprite 
	{
		public var type:uint = 0; 
		public var size:Number = 0; 
		public var main:Boolean = false;
		
		private var bgColor:uint = 0xFFCC00;
        private var offset:uint  = 50;

		
		public function Circle() 
		{
			super();
		}
		
		public function init(_type:uint, _size:Number):void
		{
			type = _type;
			size = _size;
			
			this.graphics.lineStyle(4, Game.colorArr[type], 60, true, "none", "square", "round");
		
			this.graphics.beginFill(Game.colorArrBkg[type], 1);
			this.graphics.drawEllipse(0, 0, size, size);
			this.graphics.endFill();
			
			var Sym:TextField = new TextField();
			var SymTextFormat:TextFormat = new TextFormat();
			var glowFilter:BitmapFilter = getBitmapFilter();
			
			filters = [ glowFilter/*, new GlowFilter(Game.colorArr[type],  0.4, 8, 8, 4, BitmapFilterQuality.LOW, true, false)*/]
			
			Sym.text = Game.typeArr[type];
			Sym.width = size;
			Sym.height = size;
			Sym.y = size * 0.20;
			SymTextFormat.align = TextFormatAlign.CENTER;
			SymTextFormat.size = size * 0.5;
			SymTextFormat.color = Game.colorArr[type];
			SymTextFormat.bold = true;
			Sym.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			Sym.setTextFormat(SymTextFormat);
			Sym.defaultTextFormat = Sym.getTextFormat();
			Sym.filters = [ new GlowFilter(0xffffff,  1, 8, 8, 4, BitmapFilterQuality.LOW, false, false) ]
			addChild(Sym);
		}
		
		 private function getBitmapFilter():BitmapFilter{
            var color:Number = Game.colorArr[type];
            var alpha:Number = 1;
            var blurX:Number = 16;
            var blurY:Number = 16;
            var strength:Number = 1;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.LOW;
            return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
        }
		
	}

}