package res.ui.elements
{
	public class SolutionData
	{
		public var cardList : Vector.<CardSprite>;
		
		public var type : int;
		
		public var score : int;
		
		public static const TYPE_ROYAL_KING : int = 0;
		public static const TYPE_ROYAL_FLUSH : int = 1;
		public static const TYPE_STRAIGHT_FLUSH : int = 2;
		public static const TYPE_KING_4 : int = 3;
		public static const TYPE_FULL_HOUSE : int = 4;
		public static const TYPE_FLUSH : int = 5;
		public static const TYPE_STRAIGHT : int = 6;
		public static const TYPE_KING_3 : int = 7;
		public static const TYPE_TWO_PAIRS : int = 8;
		
		public static const SCORE_LIST : Vector.<int> = Vector.<int>([360,300,200,120,80,40,30,20,10]);
		
		public function SolutionData(t : int)
		{
			type = t;
			score = SCORE_LIST[t];
		}
		
		public function copyCardList():Vector.<CardSprite>
		{
			var count : int = cardList.length;
			var list : Vector.<CardSprite> = new Vector.<CardSprite>(count);
			for(var i : int = 0; i < count; ++i)
			{
				list[i] = cardList[i].clone();
			}
			return list;
		}
		
		public function textString():void
		{
			var count : int = cardList.length;
			var str : String = "";
			for(var i : int = 0; i < count; ++i)
			{
				var cardSprite : CardSprite = cardList[i];
				str += cardSprite.toStr() + ",";
			}
			trace(type, score, str);
		}
	}
}