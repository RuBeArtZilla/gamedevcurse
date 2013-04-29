package  
{
	import flash.display.*;
	import flash.text.*;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Button extends Sprite 
	{
		private const _colors:Array = [0xFAD4DB, 0xEC748B, 0xC13A59, 0xA81230];
		private const _colors2:Array = [0xcfd3e8, 0x9aa2cf, 0x4e5ba4, 0x3d4881];
		private const _alphas:Array = [100, 100, 100, 100];
		private const _ratios:Array = [0, 126, 127, 255];
		private const _matrix:Matrix = new Matrix();
 
		//текстовая метка, формат и эффект свечения текста
		private var _label:TextField;
		private var myFormat:TextFormat = new TextFormat();
		private var labelGlow:GlowFilter = new GlowFilter(0xFFFFFF, .50, 4, 4, 3, 3);
		private var labelFilters:Array = [labelGlow];
 
		//ширина и высота кнопки
		private var _w:Number = 120;
		private	var _h:Number = 30;
		
		public function Button() 
		{
			super();
			
			//свойства объекта, задающего форматирование текста
			myFormat.align = "center";
			myFormat.font = "Tahoma";
			myFormat.size = 13;
			myFormat.color = 0xFFFFFF;	
 
			//стиль линии
			this.graphics.lineStyle(0, 0x820F26, 60, true, "none", "square", "round");
 
			//матрица для градиента
			_matrix.createGradientBox(_w, _h, 90/180*Math.PI);
 
			//включаем градиентную заливку
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix);
 
			//рисуем Фон кнопки
			this.graphics.drawRect(0, 0, _w, _h);
 
			//завершаем заливку
			this.graphics.endFill();
 
			//создаем текстовую метку и задаем ей некоторые параметры
			_label = new TextField();
			_label.width = _w;
			_label.height = _h-5;
			_label.y = 5;
			_label.selectable = false;
			_label.text = "Кнопка";
			_label.setTextFormat(myFormat);
			_label.filters = labelFilters;
 
			//спрайт Button в режиме кнопки
			this.buttonMode = true;
 
			//при наведении - показывать курсор-указатель в виде руки
			this.useHandCursor = true;
 
			//запрещаем для текстового поля с меткой перехват мыши - чтобы курсор-указатель не пропадал
			_label.mouseEnabled = false;
 
			//добавляем метку в экранный контейнер с фоном кнопки
			this.addChild(_label);
 
			//вешаем обработчики событий мыши:
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver); 	//курсор встал на кнопку
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);	//курсор покинул кнопку
		}
		//setter-функция - установка текста кнопки
		public function set label(text:String):void
		{
			//меняем текст метки
			this._label.text = text;
 
			//восстанавливаем форматирование текста, т.к. оно сбрасывается при изменении текста
			_label.setTextFormat(myFormat);
		}
 
		private function onMouseOver(e:MouseEvent):void
		{
			//меняем фон кнопки при наведении мыши
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors2, _alphas, _ratios, _matrix);
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
		}
 
		private function onMouseOut(e:MouseEvent):void
		{
			//возвращаем прежний фон кнопки при уходе мыши
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix);
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
		}
	}

}