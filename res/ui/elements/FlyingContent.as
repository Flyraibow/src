package res.ui.elements
{
	import cache.PhotoBox;
	
	import flash.display.Sprite;

	public class FlyingContent
	{
		private var _effectLayer : Sprite;
		private var _bonus : Number;
		private var _solutionData : SolutionData;
		private var _index : int;
		private var _count : int;
		
		private var _cardList : Vector.<CardSprite>;
		private var _startPosX : Vector.<int>;
		private var _startPosY : Vector.<int>;
		private var _currentTime : int;
		private var _totalTime : int;
		private var _cardNum : int;
		private var _destPosX : Vector.<int>;
		private var _destPosY : Vector.<int>;
		private var _scoreBitmap : PhotoBox;
		private var _x : int;
		private var _scoreBitmapX : int;
		private var _scoreBitmapY : int;
		private var _scoreBitmapTime : int;
		private var _scoreBitmapTotalTime : int;
		
		private var _callback : Function;
		private var _state : int;			// 0: 移动，1 ： 消失
		
		private const FLYING_TIME : int = 300;
		private const STATE1_TIME : int = 500;
		private const STATE2_TIME : int = 1500;
		
		/**
		 * 飞行路径 
		 * @param solution
		 * @param bonus
		 * @param index
		 * @param count
		 * 
		 */		
		public function FlyingContent(solution : SolutionData, bonus : Number, index : int, count : int, effectLayer : Sprite)
		{
			_effectLayer = effectLayer;
			_solutionData = solution;
			_bonus = bonus;
			_index = index;
			_count = count;
			_scoreBitmap = null;
			_cardNum = solution.cardList.length;
			_scoreBitmapTime = 0;
			_scoreBitmapTotalTime = 0;
			var cardList : Vector.<CardSprite> = new Vector.<CardSprite>(_cardNum);
			var minNum : int = 14;
			var maxNum : int = -1;
			var minNoNum : int = 1;
			var maxNoNum : int = 1;
			for(var i : int = 0; i < _cardNum; ++i)
			{
				var cardSprite : CardSprite = solution.cardList[i];
				cardList[i] = cardSprite.clone();
				if(cardSprite.cardNum != -1)
				{
					if(cardSprite.cardNum >maxNum)
					{
						maxNum = cardSprite.cardNum;
						maxNoNum = 1;
					}
					else if(cardSprite.cardNum == maxNum)
					{
						maxNoNum++;
					}
					if(cardSprite.cardNum < minNum)
					{
						minNum = cardSprite.cardNum;
						minNoNum = 1;
					}
					else if(cardSprite.cardNum == minNum)
					{
						minNoNum++;
					}
				}
			}
			switch(solution.type)
			{
				case SolutionData.TYPE_FLUSH:
				case SolutionData.TYPE_ROYAL_KING:
				case SolutionData.TYPE_KING_3:
				case SolutionData.TYPE_KING_4:
					// 与顺序无关
					_cardList = cardList.sort(rankCardListByNo);
					break;
				case SolutionData.TYPE_STRAIGHT:
				case SolutionData.TYPE_STRAIGHT_FLUSH:
				case SolutionData.TYPE_ROYAL_FLUSH:
					// 按数字排序，但是鬼要插对地方
					if(minNum == 0 && maxNum > 5)
					{
						maxNum = 13;
						minNum = 9;
					}
					if(minNum > 9)
					{
						minNum = 9;
						maxNum = 13;
					}
					else if(maxNum - minNum < 4)
					{
						maxNum = minNum + 4 ;
					}
					_cardList = new Vector.<CardSprite>(_cardNum);
					var specialCardIndex : int = -1;
					for(i = minNum; i <= maxNum; ++i)
					{
						cardSprite = null;
						for(var j : int = 0; j < _cardNum; ++j)
						{
							var card : CardSprite = cardList[j];
							if(card.cardNum == i ||( i == 13 && (card.cardNum == 0)))
							{
								cardSprite = card;
							}
						}
						if(cardSprite == null)
						{
							for(j = 0; j < _cardNum; ++j)
							{
								card = cardList[j];
								if(j != specialCardIndex && card.cardNum == -1)
								{
									specialCardIndex = j;
									cardSprite = card;
								}
							}
						}
						_cardList[i - minNum] = cardSprite;
					}
					break;
				case SolutionData.TYPE_FULL_HOUSE:
				case SolutionData.TYPE_TWO_PAIRS:
					_cardList = new Vector.<CardSprite>(_cardNum);
					var cardNum : int = maxNoNum >= minNoNum ? maxNum : minNum;
					j = 0;
					var k : int = _cardNum - 1;
					for(i = 0; i < _cardNum; ++i)
					{
						card = cardList[i];
						if(card.cardNum == cardNum)
						{
							_cardList[j++] = card;
						}
						else
						{
							_cardList[k--] = card;
						}
					}
					break;
			}
			
			
			_startPosX = new Vector.<int>(_cardNum);
			_startPosY = new Vector.<int>(_cardNum);
			_destPosX = new Vector.<int>(_cardNum);
			_destPosY = new Vector.<int>(_cardNum);
			for(i = 0; i < _cardNum; ++i)
			{
				card = _cardList[i];
				_startPosX[i] = card.x;
				_startPosY[i] = card.y;
				var width : int = ( 600 / _count) - 60 ;
				if(width > 110 * _cardNum)
				{
					width = 110* _cardNum;
				}
				_destPosX[i] = 600 / _count * _index + 10 + (width / _cardNum * i);
				_destPosY[i] = 10;
			}
			_x = (_destPosX[0] + _destPosX[i - 1] + 100) / 2;
			_totalTime = FLYING_TIME;
			_currentTime = 0;
		}
		
		private function rankCardListByNo(cardSprite1 : CardSprite,cardSprite2 : CardSprite):int
		{
			return cardSprite1.cardNo - cardSprite2.cardNo;
		}
		
		public function setCallback(callback : Function = null):void
		{
			_callback = callback;
		}
		
		public function getCardList():Vector.<CardSprite>
		{
			return _cardList;
		}
		
		public function destroy():void
		{
			for(var i : int = 0; i < _cardNum; ++i)
			{
				var card : CardSprite = _cardList[i];
				card.destroy();
			}
			if(_scoreBitmap != null)
			{
				_effectLayer.removeChild(_scoreBitmap);
				_scoreBitmap = null;
			}
			_callback = null;
			_cardList = null;
			_effectLayer = null;
		}
		
		public function process(interval : int):void
		{
			if(_currentTime < _totalTime)
			{
				_currentTime += interval;
				if(_currentTime < _totalTime)
				{
					if(_state == 0 )
					{
						for(var i : int = 0; i < _cardNum; ++i)
						{
							var card : CardSprite = _cardList[i];
							
							card.x = _startPosX[i] + (_destPosX[i] - _startPosX[i]) * _currentTime / _totalTime;
							card.y = _startPosY[i] + (_destPosY[i] - _startPosY[i]) * _currentTime / _totalTime;
						}
					}
					else if(_state == 2)
					{
						if(_currentTime >= _totalTime / 2)
						{
							var alpha : Number =  (_totalTime - _currentTime) / _totalTime * 2;
							for(i = 0; i < _cardNum; ++i)
							{
								card = _cardList[i];
								card.alpha = alpha;
							}
							_scoreBitmap.alpha = alpha;
						}
					}
				}
				else
				{
					for(i = 0; i < _cardNum; ++i)
					{
						card = _cardList[i];
						card.x = _destPosX[i];
						card.y = _destPosY[i];
					}
					if(_state == 0)
					{
						_totalTime = STATE1_TIME;
						_currentTime = 0;
						_state = 1;
						_scoreBitmap = new PhotoBox();
						_scoreBitmap.setAlian(PhotoBox.ALIAN_CENTER);
						_scoreBitmap.setPhoto(_solutionData.type.toString(),"effect","png");
						_scoreBitmapX = _x;
						_scoreBitmapY = - 60;
						_scoreBitmap.x = _scoreBitmapX;
						_scoreBitmap.y = _scoreBitmapY;
						_scoreBitmapTime = 0;
						_scoreBitmapTotalTime = 200;
						_effectLayer.addChild(_scoreBitmap);
					}
					else if(_state == 1)
					{
						_state = 2;
						_totalTime = STATE2_TIME;
						_currentTime = 0;
						if(_callback != null)
						{
							var callback : Function = _callback;
							_callback = null;
							callback(this);
						}
					}
					else if(_state == 2)
					{
						if(_callback != null)
						{
							callback = _callback;
							_callback = null;
							callback(this);
						}
					}
				}
			}
			if(_scoreBitmapTime < _scoreBitmapTotalTime)
			{
				_scoreBitmapTime += interval;
				if(_scoreBitmapTime < _scoreBitmapTotalTime)
				{
					_scoreBitmap.y = _scoreBitmapY + (78 - _scoreBitmapY) / _scoreBitmapTotalTime * _scoreBitmapTime;
				}
				else
				{
					_scoreBitmap.y = 78;
					_scoreBitmapTotalTime = 0;
					_scoreBitmapTime = 0;
				}
			}
		}
	}
}