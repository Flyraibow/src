package cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class PhotoBox extends Bitmap
	{
		private var _alian : int;
		public static const ALIAN_LEFT : int = 0;
		public static const ALIAN_CENTER : int = 1;
		public static const ALIAN_RIGHT : int = 2;
		
		private var _x : Number;
		private var _y : Number;
		private var _width : int;
		private var _height : int;
		
		public function PhotoBox(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_width = 0;
			_height = 0;
			_x = 0;
			_y = 0;
		}
		
		public function setPhoto(id : String, dictionaryString : String = "photo", suffix : String = "jpg"):void
		{
			var bmd : BitmapData = Gamex.photoManager.getBitmapData(id);
			if(bmd != null)
			{
				bitmapData = bmd;
				_width = width;
				_height = height;
			}
			else
			{
				Gamex.photoManager.loadBitmapData(id,this,dictionaryString,suffix);
			}
		}
		
		public function setAlian(alian : int):void
		{
			_alian = alian;
		}
		
		public function refresh(bmd : BitmapData):void
		{
			bitmapData = bmd;
			_width = width;
			_height = height;
			if(_alian == 1)
			{
				super.x = _x - _width / 2;
			}
			else if(_alian == 2)
			{
				super.x = _x - _width;
			}
		}
		
		public override function set x(value:Number):void
		{
			_x = value;
			if(_alian == 0)
			{
				super.x = _x;
			}
			else if(_alian == 1)
			{
				super.x = _x - _width / 2;
			}
			else
			{
				super.x = _x - _width;
			}
		}
	}
}