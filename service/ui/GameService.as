package service.ui
{
	import define.UIDefine;
	
	import res.ui.GamePanel;
	
	import service.BaseService;
	
	public class GameService extends BaseService
	{
		public function GameService()
		{
			super();
		}
		
		protected override function onStart(param:Object):Boolean
		{
			var gamePanel : GamePanel = new GamePanel();
			Gamex.ui.setUI(UIDefine.GAME,gamePanel);
			
			return true;
		}
		
		protected override function onStop():Boolean
		{
			Gamex.ui.destroyUI(UIDefine.GAME);
			
			return true;
		}
	}
}