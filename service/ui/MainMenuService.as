package service.ui
{
	import define.UIDefine;
	
	import res.ui.MainMenu;
	
	import service.BaseService;
	
	public class MainMenuService extends BaseService
	{
		public function MainMenuService()
		{
			super();
		}
		
		protected override function onStart(param:Object):Boolean
		{
			var mainMeun : MainMenu = new MainMenu();
			
			Gamex.ui.setUI(UIDefine.MAINMENU,mainMeun);
			
			return true;
		}
		
		protected override function onStop():Boolean
		{
			Gamex.ui.destroyUI(UIDefine.MAINMENU);
			
			return true;
		}
	}
}