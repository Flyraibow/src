package res.ui.elements
{
	import cache.PhotoBox;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CardSprite extends Sprite
	{
		public var cardNo : int;
		public var cardNum : int;
		public var cardColor : int;
		public var type : int;				// 0普通，1：运动中（不可操作）
		public var cols : int;				// 索引位置列
		public var rows : int;				// 索引位置排
		public var destroyed : Boolean;		// 是否销毁了
		private var _cardBitmap : PhotoBox;
		
		private var _startX : int;
		private var _startY : int;
		private var _destX : int;
		private var _destY : int;
		private var _state : int;			//状态 0 ： 普通， 1：放大中， 2：放大了, 3: 缩小中
		private var _time : int;			// 放大缩小的时间
		
		private var _callback : Function;
		
		private static const CARD_WIDTH : int = 100;
		private static const CARD_HEIGHT : int = 128;
		
		/**
		 * 构造卡牌 
		 * 
		 */		
		public function CardSprite()
		{
			super();
			_cardBitmap = new PhotoBox();
			addChild(_cardBitmap);
			_state = 0;
			_time = 0;
			type = 0;
			_callback = null;
			destroyed = false;
		}
		
		public function setCardNo(index : int):void
		{
			cardNo = index;
			if(index >= 52)
			{
				cardNum = -1;
				cardColor = -1;
			}
			else
			{
				cardNum = index % 13;
				cardColor = index / 13;
			}
			var string : String;
			if(index < 52)
			{
				string = int(index / 13) + "_" + (index % 13 + 1); 
			}
			else
			{
				string = index.toString();
			}
			_cardBitmap.setPhoto(string,"pokerCard");
		}
		
		public function setState(state : int, completeCallback : Function = null):void
		{
			_state = state;
			_callback = completeCallback;
		}
		
		public function toStr():String
		{
			var str : String = "";
			if(cardNo < 52)
			{
				var color : int = cardNo / 13;
				switch(color)
				{
					case 0:
						str += "♠"
						break;
					case 1:
						str += "❤";
						break;
					case 2:
						str += "♣";
						break;
					case 3:
						str += "♢";
						break;
				}
				var num : int = cardNo % 13;
				switch(num)
				{
					case 0:
						str += "A";
						break;
					case 10:
						str += "J";
						break;
					case 11:
						str += "Q";
						break;
					case 12:
						str += "K";
						break;
					default :
						str += (num + 1);
						break;
				}
			}
			else if(cardNo == 52)
			{
				str = "小鬼";
			}
			else
			{
				str = "大鬼";
			}
			return str;
		}
		
		public function moveTo(destX : int, destY : int, completeCallback : Function = null):void
		{
			_startX = x;
			_startY = y;
			_state = 4;
			_destX = destX;
			_destY = destY;
			_time = 0;
			_callback = completeCallback;
		}
		
		public function clone():CardSprite
		{
			var cardSprite : CardSprite = new CardSprite();
			cardSprite.setCardNo(cardNo);
			cardSprite.x = x;
			cardSprite.y = y;
			return cardSprite;
		}
		
		public function destroy():void
		{
			if(parent != null)
			{
				parent.removeChild(this);
			}
			destroyed = true;
		}
		
		public function enterFrame():void
		{
			if(_state == 1)
			{
				_time += 1;
				_cardBitmap.scaleX = 1 + _time / 100;
				_cardBitmap.scaleY = 1 + _time / 100;
				_cardBitmap.x = - CARD_WIDTH * _time / 200;
				_cardBitmap.y = - CARD_HEIGHT * _time / 200;
				if(_time >= 10)
				{
					_state = 2;
					if(_callback != null)
					{
						_callback(this);
					}
				}
			}
			else if(_state == 3)
			{
				_time -= 1;
				_cardBitmap.scaleX = 1 + _time / 100;
				_cardBitmap.scaleY = 1 + _time / 100;
				_cardBitmap.x = - CARD_WIDTH * _time / 200;
				_cardBitmap.y = - CARD_HEIGHT * _time / 200;
				if(_time <= 0)
				{
					_state = 0;
					if(_callback != null)
					{
						_callback(this);
					}
				}
			}
			else if(_state == 4)
			{
				_time += 1;
				if(_time < 20)
				{
					x = _startX + (_destX - _startX) * _time / 20;
					y = _startY + (_destY - _startY) * _time / 20;
				}
				else
				{
					x = _destX;
					y = _destY;
					_state = 0;
					_time = 0;
					if(_callback != null)
					{
						_callback(this);
					}
				}
			}
		}
	}
}