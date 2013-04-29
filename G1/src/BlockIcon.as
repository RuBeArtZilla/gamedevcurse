package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class BlockIcon extends Sprite 
	{
		public var type:uint = 0; 
		public var size:Number = 0; 
		
		public function BlockIcon() 
		{
			super();
		}
		
		public function init(_type:uint, _size:Number):void 
		{
			type = _type;
			size = _size;
		}
		
	}

}