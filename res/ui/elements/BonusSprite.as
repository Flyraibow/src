package res.ui.elements
{
	import cache.PhotoBox;
	
	import flash.display.Sprite;
	
	public class BonusSprite extends Sprite
	{
		private var _photoBoxList : Vector.<PhotoBox>;
		private var _width : int;
		
		public function BonusSprite()
		{
			super();
			_photoBoxList = new Vector.<PhotoBox>();
		}
		
		public function clear():void
		{
			for(var i : int = _photoBoxList.length - 1; i >= 0; --i)
			{
				var photobox : PhotoBox = _photoBoxList[i];
				removeChild(photobox);
			}
			_photoBoxList.length = 0;
		}
		
		/**
		 * 初始化数字 
		 * @param num
		 * 
		 */		
		public function initNum(num : int):void
		{
			var a : int = num;
			var b : int;
			var n : int = 1;
			do
			{
				b = a % 10;
				var photoBox : PhotoBox = new PhotoBox();
				photoBox.setPhoto(b.toString(),"bonus","png");
				_photoBoxList.push(photoBox);
				addChild(photoBox);
				photoBox.x = - n * 60;
				a /= 10;
				++n;
			}while(a > 0);
			_width = (n - 1) * 60;
		}
		
		/**
		 * 初始化浮点数 
		 * @param num
		 * 
		 */		
		public function initFloat(num : Number):void
		{
			var a : int = int(num);
			var f : Number = num - a;
			var b : int;
			var n : int = 1;
			do
			{
				b = a % 10;
				var photoBox : PhotoBox = new PhotoBox();
				photoBox.setAlian(PhotoBox.ALIAN_CENTER);
				photoBox.setPhoto(b.toString(),"bonus","png");
				_photoBoxList.push(photoBox);
				addChild(photoBox);
				photoBox.x = -( n - 0.5) * 50;
				a /= 10;
				++n;
			}while(a > 9);
			photoBox = new PhotoBox();
			photoBox.setAlian(PhotoBox.ALIAN_RIGHT);
			photoBox.setPhoto("bonus","bonus","png");
			_photoBoxList.push(photoBox);
			addChild(photoBox);
			photoBox.x = - (n - 1) * 50;
			photoBox.y = - 8;
			photoBox = new PhotoBox();
			photoBox.setPhoto("dot","bonus","png");
			photoBox.y = 50;
			photoBox.x =  -5;
			_photoBoxList.push(photoBox);
			addChild(photoBox);
			a = int(f * 10 + 0.5);
			photoBox = new PhotoBox();
			photoBox.setAlian(PhotoBox.ALIAN_CENTER);
			photoBox.setPhoto(a.toString(),"bonus","png");
			addChild(photoBox);
			photoBox.x = 55;
			_photoBoxList.push(photoBox);
			_width = (n - 1) * 50;
		}
		
		public function getWidth():int
		{
			return _width;
		}
	}
}