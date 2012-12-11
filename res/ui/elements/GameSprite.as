package res.ui.elements
{
	import cache.PhotoBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 *  
	 * @author acer
	 * 
	 */	
	public class GameSprite extends Sprite
	{
		private var _cardList : Vector.<Vector.<CardSprite>>;
		private var _cardData : Vector.<int>;
		private var _cardNum : int;
		
		private var _selectCard : CardSprite;
		private var _selectCard1 : CardSprite;
		private var _downSprite : Sprite;		// 下层的容器
		private var _upSprite : Sprite;			// 上层卡牌的容器
		private var _effectSprite : Sprite;		// 特效层
		private var _moving : Boolean;			// 移动
		private var _waitTime : int;			// 等待时间
		
		private var _cacheList : Vector.<CardSprite>;
		private var _cardNumList : Vector.<int>;
		private var _cardColorList : Vector.<int>;
		
		private var _solutionList : Vector.<SolutionData>;
		private var _seriousBonus : Number;
		private var _score : int;
		private var _moves : int;
		private var _purchaseTimes : int;
		
		private var _flyingList : Vector.<FlyingContent>;
		private var _lastTime : int;
		private var _checkCount : int;
		
		private var _paused : Boolean;
		private var _function : Object;
		private var _count : Object;
		
		private const MOVES : int = 30;
		private const PURCHASECOUNT : int = 1;
		
		public static const EVENT_SCORE_CHANGE : int = 1;
		public static const EVENT_MOVES_CHANGE : int = 2;
		public static const EVENT_ENDING : int = 3;
		
		public function GameSprite()
		{
			super();
			
			_function = new Object();
			_count = new Object();
			init();
		}
		
		public function init():void
		{
			// 初始化卡牌数据
			_cardNum = 54;
			_cardData = new Vector.<int>(54);
			for(var i : int = 0; i < 54; ++i)
			{
				_cardData[i] = i;
			}
			
			_downSprite = new Sprite();
			addChild(_downSprite);
			_cardList = new Vector.<Vector.<CardSprite>>(5);
			for(i = 0; i < 5; ++i)
			{
				var list : Vector.<CardSprite> = new Vector.<CardSprite>(5);
				for(var j : int = 0; j < 5; ++j)
				{
					var card : CardSprite = new CardSprite();
					card.cols = j;
					card.rows = i;
					card.setCardNo(getRandCard());
					card.x = j * 125;
					card.y = i * 140 + 150;
					_downSprite.addChild(card);
					list[j] = card;
					card.addEventListener(MouseEvent.CLICK, onClickCard);
				}
				_cardList[i] = list;
			}
			_cacheList = new Vector.<CardSprite>(5);
			_cardNumList = new Vector.<int>(5);
			_cardColorList = new Vector.<int>(5);
			_flyingList = new Vector.<FlyingContent>();
			_selectCard = null;
			_moving = false;
			_waitTime = 0;
			_paused = false;
			
			_solutionList = new Vector.<SolutionData>();
			_upSprite = new Sprite();
			addChild(_upSprite);
			_effectSprite = new Sprite();
			_effectSprite.mouseEnabled = false;
			_effectSprite.mouseChildren = false;
			addChild(_effectSprite);
			
			_seriousBonus = 0;
			_score = 0;
			_moves = MOVES;
			_purchaseTimes = PURCHASECOUNT;
			mouseEnabled = true;
			mouseChildren = true;
			
			_lastTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			check(true);
		}
		
		public function get moves():int
		{
			return _moves;
		}
		
		public function stop():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_paused = true;
		}
		
		public function start():void
		{
			if(_paused)
			{
				_lastTime = getTimer();
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_paused = false;
				mouseEnabled = true;
				mouseChildren = true;
			}
		}
		
		public function destroy(complete : Boolean = false):void
		{
			for(var i : int = 0; i < 5; ++i)
			{
				for(var j : int = 0; j < 5; ++j)
				{
					var card : CardSprite = _cardList[i][j];
					card.removeEventListener(MouseEvent.CLICK, onClickCard);
					card.destroy();
				}
			}
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for(i = _upSprite.numChildren - 1; i >= 0; --i)
			{
				_upSprite.removeChildAt(i);
			}
			for(i = _downSprite.numChildren - 1; i >= 0; --i)
			{
				_downSprite.removeChildAt(i);
			}
			for(i = _effectSprite.numChildren - 1; i >= 0; --i)
			{
				_effectSprite.removeChildAt(i);
			}
			_cardList = null;
			_cardData = null;
			_selectCard = null;
			_selectCard1 = null;
			_cacheList = null;
			_cardNumList = null;
			_cardColorList = null;
			_solutionList = null;
			_flyingList = null;
			_paused = false;
			_checkCount = 0;
			_seriousBonus = 0;
			_moving = false;
			if(complete)
			{
				_function = null;
				_count = null;
			}
		}
		
		private function onClickCard(event : MouseEvent):void
		{
			if(!_moving && _waitTime <= 0)
			{
				if(_moves > 0)
				{
					var card : CardSprite = event.currentTarget as CardSprite;
					if(card.type == 0)
					{
						if(_selectCard1 == null)
						{
							_downSprite.removeChild(card);
							_upSprite.addChild(card);
							card.setState(1, onChooseCardComplete);
							card.type = 1;
							if(_selectCard == null)
							{
								_selectCard = card;
							}
							else
							{
								_selectCard1 = card;
							}
						}
					}
					else if(card.type == 2)
					{
						card.setState(3, onCancelComplete);
						card.type = 1;
						_selectCard = null;
					}
				}
				else
				{
					applyCallback(EVENT_ENDING,_purchaseTimes);
				}
			}
		}
		
		private function onChooseCardComplete(card :CardSprite):void
		{
			card.type = 2;
			if(_selectCard != null && _selectCard1 != null)
			{
				_moving = true;
				_selectCard.moveTo(_selectCard1.x, _selectCard1.y);
				_selectCard1.moveTo(_selectCard.x, _selectCard.y,onMoveComplete);
				_moves--;
				applyCallback(EVENT_MOVES_CHANGE,_moves);
			}
		}
		
		private function onCancelComplete(card : CardSprite):void
		{
			_upSprite.removeChild(card);
			_downSprite.addChild(card);
			card.type = 0;
			if(_checkCount > 0)
			{
				_checkCount--;
				
				if(_checkCount == 0)
				{
					_selectCard1 = null;
					_selectCard = null;
					_moving = false;
					check();
				}
			}
		}
		
		private function onMoveComplete(card : CardSprite):void
		{
			_checkCount = 2;
			_selectCard1.setState(3,onCancelComplete);
			_selectCard.setState(3,onCancelComplete);
			var rows : int = _selectCard.rows;
			var cols : int = _selectCard.cols;
			_selectCard.rows =  _selectCard1.rows;
			_selectCard.cols =  _selectCard1.cols;
			_selectCard1.rows = rows;
			_selectCard1.cols = cols;
			_cardList[_selectCard1.rows][_selectCard1.cols] = _selectCard1;
			_cardList[_selectCard.rows][_selectCard.cols] = _selectCard;
		}
		
		private function getRandCard():int
		{
			var randIndex : int = Math.random() * _cardNum;
			var cardNo : int = _cardData[randIndex];
			_cardData.splice(randIndex,1);
			--_cardNum;
			return cardNo;
		}
		
		private function pushCard(cardNo : int):void
		{
			_cardData.push(cardNo);
			++_cardNum;
		}
		
		/**
		 * 全局檢查是否有可以消除的 
		 * 
		 */		
		private function check(immediately : Boolean = false):void
		{
			_solutionList.length = 0;
			for(var i : int = 0; i < 5; ++i)
			{
				for(var j : int = 0; j < 5; ++j)
				{
					_cacheList[j] = _cardList[i][j];
				}
				var solution : SolutionData = getSolution(_cacheList);
				if(solution != null)
				{
					solution.textString();
					_solutionList.push(solution);
				}
			}
			
			for(i = 0; i < 5; ++i)
			{
				for(j = 0; j < 5; ++j)
				{
					_cacheList[j] = _cardList[j][i];
				}
				solution = getSolution(_cacheList);
				if(solution != null)
				{
					solution.textString();
					_solutionList.push(solution);
				}
			}
			if(immediately)
			{
				count = _solutionList.length;
				for(i = 0; i < count; ++i)
				{
					solution = _solutionList[i];
					cardCount = solution.cardList.length;
					for(j = 0;j < cardCount; ++j)
					{
						cardSprite = solution.cardList[j];
						cardSprite.destroy();
					}
				}
				
				for(i = 0; i < 5; ++i)
				{
					var index : int = 0;
					for(j = 4; j >= 0; --j)
					{
						cardSprite = _cardList[j][i];
						if(cardSprite.destroyed)
						{
							pushCard(cardSprite.cardNo);
						}
						else
						{
							_cardList[4 - index][i] = cardSprite;
							if(cardSprite.rows != 4 - index)
							{
								cardSprite.rows = 4 - index;
								cardSprite.y = (4 - index) * 140 + 150;
							}
							index++;
						}
					}
					for(j = index; j < 5; ++j)
					{
						cardSprite = new CardSprite();
						cardSprite.setCardNo(getRandCard());
						cardSprite.cols = i;
						cardSprite.rows = 4-j;
						cardSprite.x = i * 125;
						cardSprite.y =  (4-j) * 140 + 150;
						cardSprite.addEventListener(MouseEvent.CLICK, onClickCard);
						_downSprite.addChildAt(cardSprite,0);
						_cardList[4-j][i] = cardSprite;
					}
				}
				if(count > 0)
				{
					check(true);
				}
			}
			else
			{
				var count : int = _solutionList.length;
				if(count > 0)
				{
					var bonus : Number = 1 + (count - 1) / 10 + _seriousBonus;
					var score : int = 0;
					for(i = 0; i < count; ++i)
					{
						solution = _solutionList[i];
						score = solution.score * bonus;
						var flyingContent : FlyingContent = new FlyingContent(solution, bonus,i, count,_effectSprite);
						
						var cardCount : int = solution.cardList.length;
						var cardList : Vector.<CardSprite> = flyingContent.getCardList();
						for(j = 0;j < cardCount; ++j)
						{
							cardSprite = solution.cardList[j];
							cardSprite.destroy();
							cardSprite.removeEventListener(MouseEvent.CLICK, onClickCard);
							var cardSprite : CardSprite = cardList[j];
							_upSprite.addChild(cardSprite);
						}
						flyingContent.setCallback(stepComplete1);
						_flyingList.push(flyingContent);
						_score += score;
					}
					applyCallback(EVENT_SCORE_CHANGE, _score);
					_moving = true;
				}
				else
				{
					_seriousBonus = 0;
				}
			}
		}
		
		private function stepComplete1(flyContent : FlyingContent):void
		{
			flyContent.setCallback(stepComplete2);
			if(_moving)
			{
				_moving = false;
				_waitTime = 700;
				for(var i : int = 0; i < 5; ++i)
				{
					var index : int = 0;
					for(var j : int = 4; j >= 0; --j)
					{
						var cardSprite : CardSprite = _cardList[j][i];
						if(cardSprite.destroyed)
						{
							pushCard(cardSprite.cardNo);
						}
						else
						{
							_cardList[4 - index][i] = cardSprite;
							if(cardSprite.rows != 4 - index)
							{
								cardSprite.rows = 4 - index;
								cardSprite.moveTo(cardSprite.x,(4 - index) * 140 + 150);
							}
							index++;
						}
					}
					for(j = index; j < 5; ++j)
					{
						cardSprite = new CardSprite();
						cardSprite.setCardNo(getRandCard());
						cardSprite.cols = i;
						cardSprite.rows = 4-j;
						cardSprite.x = i * 125;
						cardSprite.y =  150;
						cardSprite.addEventListener(MouseEvent.CLICK, onClickCard);
						_downSprite.addChildAt(cardSprite,0);
						if(4 - j != 0)
						{
							cardSprite.moveTo(i * 125,(4-j) * 140 + 150);
						}
						_cardList[4-j][i] = cardSprite;
					}
				}
			}
		}
		
		private function stepComplete2(flyContent : FlyingContent):void
		{
			var index : int = _flyingList.indexOf(flyContent);
			_flyingList.splice(index,1);
			flyContent.destroy();
		}
		
		/**
		 * 排序Vector.<int> 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sortArray(a : int, b : int):int
		{
			return a - b;
		}
		
		/**
		 * 判断是否可以消除 
		 * @param cardList
		 * @return 
		 * 
		 */		
		private function getSolution(cardList : Vector.<CardSprite>):SolutionData
		{
			var solution : SolutionData = null;
			
			var flush : Boolean = true;
			var straight : Boolean = true;
			var min : int = 14;
			var max : int = -1;		//A算1的分值
			var min1 : int = 14;
			var max1 : int = -1;	//A算13的分值
			
			for(var i : int = 0; i < 5; ++i)
			{
				var cardSprite : CardSprite = cardList[i];
				if(cardSprite.cardNo < 52)
				{
					var cardNum : int = cardSprite.cardNo % 13;
					var cardColor : int = cardSprite.cardNo / 13;
				}
				else
				{
					cardNum = -1;
					cardColor = -1;
				}
				_cardNumList[i] = cardNum;
				_cardColorList[i] = cardColor;
				if(flush && cardColor != -1)
				{
					for(var j : int = i - 1; j >= 0; --j)
					{
						if(cardColor != _cardColorList[j] && _cardColorList[j] != -1)
						{
							flush = false;
							break;
						}
					}
				}
				if(straight)
				{
					if(cardNum != -1)
					{
						if(min > cardNum)
						{
							min = cardNum;
						}
						if(max < cardNum)
						{
							max = cardNum;
						}
						var cardNum1 : int = (cardNum ==0?13:cardNum);
						if(min1 > cardNum1)
						{
							min1 = cardNum1;
						}
						if(max1 < cardNum1)
						{
							max1 = cardNum1;
						}
						if(max - min > 4 && max1 - min1 > 4)
						{
							straight = false;
						}
						else
						{
							for(j = i - 1; j >= 0; --j)
							{
								if(_cardNumList[j] == cardNum && _cardNumList[j] != -1)
								{
									straight = false;
									break;
								}
							}
						}
					}
				}
			}
			// 按五个的计算
			// 5k
			var king5 : Boolean = true;
			var king4 : Boolean = false;
			var king3 : Boolean = false;
			var soluteList : Vector.<CardSprite>;
			cardNum = -1;
			for(i = 0; i < 5; ++i)
			{
				num = _cardNumList[i];
				if(num != -1)
				{
					if( cardNum == -1)
					{
						cardNum = num;
					}
					else if(num != cardNum)
					{
						king5 = false;
						if(i == 4)
						{
							king4 = true;
							soluteList = Vector.<CardSprite>([cardList[0],cardList[1],cardList[2],cardList[3]]);
						}
						else if(i == 3)
						{
							king3 = true;
							soluteList = Vector.<CardSprite>([cardList[0],cardList[1],cardList[2]]);
						}
						break;
					}
				}
			}
			
			if(king5)
			{
				solution = new SolutionData(SolutionData.TYPE_ROYAL_KING);
				solution.cardList = cardList.concat();
				return solution;
			}
			
			if(flush && straight)
			{
				if(min1 == 9)
				{
					solution = new SolutionData(SolutionData.TYPE_ROYAL_FLUSH);
				}
				else
				{
					solution = new SolutionData(SolutionData.TYPE_STRAIGHT_FLUSH);
				}
				solution.cardList = cardList.concat();
				return solution;
			}
			
			// 顺子与同花判断完毕，最后判断散牌
			// 4k
			if(!king4)
			{
				cardNum = -1;
				king4 = true;
				for(i = 1; i < 5; ++i)
				{
					var num : int = _cardNumList[i];
					if(num != -1)
					{
						if( cardNum == -1)
						{
							cardNum = num;
						}
						else if(num != cardNum)
						{
							if(i == 4)
							{
								king3 = true;
								soluteList = Vector.<CardSprite>([cardList[1],cardList[2],cardList[3]]);
							}
							king4 = false;
							break;
						}
					}
				}
				if(king4)
				{
					soluteList = Vector.<CardSprite>([cardList[1],cardList[2],cardList[3],cardList[4]]);
				}
			}
			if(king4)
			{
				solution = new SolutionData(SolutionData.TYPE_KING_4);
				solution.cardList = soluteList
				return solution;
			}
			cardNum = -1;
			var cardNum2 : int = -1;
			var fullhouse : Boolean = true;
			var twoPairs : Boolean = false;
			var sameNum1 : int = 1;
			var sameNum2 : int = 1;
			for(i = 0; i < 5; ++i)
			{
				num = _cardNumList[i];
				if(num != -1)
				{
					if(cardNum == -1)
					{
						cardNum = num;
					}
					else if(cardNum != num)
					{
						if( cardNum2 == -1)
						{
							cardNum2 = num;
						}
						else if(cardNum2 != num)
						{
							fullhouse = false;
							if(!king3 && i == 4 && sameNum1 <=2 && sameNum2 <= 2)
							{
								twoPairs = true;
								soluteList = Vector.<CardSprite>([cardList[0],cardList[1],cardList[2],cardList[3]]);
							}
							break;
						}
						else
						{
							++sameNum2;
						}
					}
					else 
					{
						++sameNum1;
					}
				}
			}
			if(fullhouse && sameNum1 < 4 && sameNum2 < 4)
			{
				solution = new SolutionData(SolutionData.TYPE_FULL_HOUSE);
				solution.cardList = cardList.concat();
				return solution;
			}
			if(flush)
			{
				solution = new SolutionData(SolutionData.TYPE_FLUSH);
				solution.cardList = cardList.concat();
				return solution;
			}
			if(straight)
			{
				solution = new SolutionData(SolutionData.TYPE_STRAIGHT);
				solution.cardList = cardList.concat();
				return solution;
			}
			if(!king3)
			{
				cardNum = -1;
				king3 = true;
				for(i = 2; i < 5; ++i)
				{
					num = _cardNumList[i];
					if(num != -1)
					{
						if( cardNum == -1)
						{
							cardNum = num;
						}
						else if(num != cardNum)
						{
							king3 = false;
							break;
						}
					}
				}
				if(king3)
				{
					soluteList = Vector.<CardSprite>([cardList[2],cardList[3],cardList[4]]);
				}
			}
			if(king3)
			{
				solution = new SolutionData(SolutionData.TYPE_KING_3);
				solution.cardList = soluteList;
				return solution;
			}
			if(!twoPairs)
			{
				twoPairs = true;
				cardNum = -1;
				cardNum2 = -1;
				sameNum1 = 1;
				sameNum2 = 1;
				for(i = 1; i < 5; ++i)
				{
					num = _cardNumList[i];
					if(num != -1)
					{
						if(cardNum == -1)
						{
							cardNum = num;
						}
						else if(cardNum != num)
						{
							if( cardNum2 == -1)
							{
								cardNum2 = num;
							}
							else if(cardNum2 != num)
							{
								twoPairs = false;
								break;
							}
							else
							{
								++sameNum2;
							}
						}
						else 
						{
							++sameNum1;
						}
					}
				}
				if(twoPairs)
				{
					if((sameNum1 <= 2 && sameNum2 <= 2))
					{
						soluteList = Vector.<CardSprite>([cardList[1],cardList[2],cardList[3],cardList[4]]);
					}
					else
					{
						twoPairs = false;
					}
				}
			}
			if(twoPairs)
			{
				solution = new SolutionData(SolutionData.TYPE_TWO_PAIRS);
				solution.cardList = soluteList;
				return solution;
			}
			return solution;
		}
		
		private function onEnterFrame(event : Event):void
		{
			var time : int = getTimer();
			var interval : int = time - _lastTime;
			_lastTime = time;
			for(var i : int = 0; i < 5; ++i)
			{
				for(var j : int = 0; j < 5; ++j)
				{
					var cardSprite : CardSprite = _cardList[i][j];
					cardSprite.enterFrame();
				}
			}
			var count : int = _flyingList.length;
			for(i = count - 1; i >= 0; --i)
			{
				var flyingContent : FlyingContent = _flyingList[i];
				flyingContent.process(interval);
			}
			if(_waitTime > 0)
			{
				_waitTime -= interval;
				if(_waitTime <= 0)
				{
					_seriousBonus += 0.1;
					check();
				}
			}
		}
		
		public function addCallback(id : int, callback : Function):void
		{
			if(callback == null)
			{
				return ;
			}
			var temp : Dictionary = _function[id];
			if(temp != null)
			{
				if(temp[callback] != null)
				{
					return ;
				}
				temp[callback] = callback;
				var count : int = _count[id];
				_count[id] = ++count;
			}
			else
			{
				temp = new Dictionary();
				temp[callback] = callback;
				_function[id] = temp;
				_count[id] = 1;
			}
		}
		
		public function removeCallback(id : int, callback : Function):void
		{
			if(callback == null)
			{
				return ;
			}
			var temp : Dictionary = _function[id];
			if(temp != null)
			{
				if(temp[callback] != null)
				{
					
					delete temp[callback]
					var count : int = _count[id] - 1;
					if(count == 0)
					{
						delete _function[id];
						delete _count[id];
					}
					else
					{
						_count[id] = count;
					}
				}
			}
		}
		
		protected function applyCallback(id : int, param : Object = null):void
		{
			var temp : Dictionary = _function[id];
			if(temp != null)
			{
				for each(var callback : Function in temp)
				{
					callback(param);
				}
			}
		}
	}
}