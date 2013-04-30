package
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Block extends Sprite
	{

		
		public var keyID:uint;
		
		public var type:uint;
		public var additional_type:uint;
		public var time:Number;
		public var duration:Number;
		
		public var to_x:Number;
		public var to_y:Number;
		public var from_x:Number;
		public var from_y:Number;
		
		public var to_x_orig:Number;
		public var to_y_orig:Number;
		public var from_x_orig:Number;
		public var from_y_orig:Number;
		
		public var motion_type:uint;
		public var motion_function:uint;
		
		public var active:Boolean = true;
		public var state:uint = 1;
		
		public var size:Number = 40;
		public var half:Number = 20;
		
		private var delta_x:Number;
		private var delta_y:Number;
		private var delta_matrix:Matrix = new Matrix();
		
		public var event_duration:Number = 1000;
		
		private const _colors:Array = [0xFAD4DB, 0xEC748B, 0xC13A59, 0xA81230];
		private const _colors2:Array = [0xcfd3e8, 0x9aa2cf, 0x4e5ba4, 0x3d4881];
		private const _alphas:Array = [100, 100, 100, 100];
		private const _ratios:Array = [0, 126, 127, 255];
		private const _matrix:Matrix = new Matrix();
		
		private var debug_text:TextField = new TextField();
		private var circle_main:Circle = new Circle();
		private var circle_drag:Circle = new Circle();
				
		public function Block()
		{
			super();
			addChild(debug_text);
			debug_text.text = "";
			debug_text.y = 50;
		}
		
		public function Set(input:String):Block
		{
			var splited:Array = input.split("|");
			type = splited[0];
			additional_type = splited[1];
			time = splited[2];
			duration = splited[3];
			to_x_orig = splited[4];
			to_y_orig = splited[5];
			from_x_orig = splited[6];
			from_y_orig = splited[7];
			motion_type = splited[8];
			motion_function = splited[9];
			keyID = Game.keyArray[type];
			UpdateCoord();
			
			circle_main.init(type, size);
			circle_main.x = to_x;
			circle_main.y = to_y;
			circle_main.main = true;
			addChild(circle_main);
			
			circle_drag.init(type, size);
			circle_drag.x = from_x;
			circle_drag.y = from_y;
			addChild(circle_drag);
			return this;
		}
		
		public function UpdateCoord():void
		{
			to_x = to_x_orig * Main.screen_width;
			to_y = to_y_orig * Main.screen_height;
			from_x = from_x_orig * Main.screen_width;
			from_y = from_y_orig * Main.screen_height;
			delta_x = Math.abs(from_x - to_x);
			delta_y = Math.abs(from_y - to_y);
		}
		
		public function DrawUpdate(t:Number):void
		{
			if (t <= 0)
			{
				circle_drag.x = CalcQuadraticBezier(1 + t, from_x, to_x, to_x);
				circle_drag.y = CalcQuadraticBezier(1 + t, from_y, from_y, to_y);
				
				filters = [ new GlowFilter(Game.colorArr[type],  (- t), 16 * (1 + t), 16 * (1 + t), 4, BitmapFilterQuality.LOW, false, false) ];
				
				var cqvx:Number = CalcQuadraticBezier(1 + t, from_x + half, to_x + half, to_x + half);
				var cqvy:Number = CalcQuadraticBezier(1 + t, from_y + half, from_y + half, to_y + half);
					
				var cqvy1:Number = (delta_y - size) * (1 + t);
				
				if (from_y < to_y)
					cqvy1 = from_y + cqvy1 + half
				else
					cqvy1 = from_y - cqvy1 + half;
				
				this.graphics.clear();
				this.graphics.lineStyle(8, Game.colorArrBkg[type]);
				this.graphics.moveTo(cqvx, cqvy);
				this.graphics.curveTo(to_x + half, cqvy1, to_x + half, to_y + half);
				
				this.graphics.lineStyle(4, Game.colorArr[type]);
				this.graphics.moveTo(cqvx, cqvy);
				this.graphics.curveTo(to_x + half, cqvy1, to_x + half, to_y + half);
			}
			else
			{
				circle_drag.x = to_x;
				circle_drag.y = to_y;
				circle_drag.visible = false;
				filters = [ new GlowFilter(Game.colorArr[type],  0.5, 16 * t, 16 * t, 4, BitmapFilterQuality.LOW, false, false), new BlurFilter(16 * t, 16 * t, BitmapFilterQuality.LOW) ];
				this.graphics.clear();
			}		
		}
		
		private function CalcQuadraticBezier(t:Number, p0:Number, p1:Number, p2:Number):Number
		{
			return ((1 - t) * (1 - t) * p0 + 2 * t * (1 - t) * p1 + t * t * p2);
		}
	
	}
}