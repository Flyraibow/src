package service.ui
{
	import define.UIDefine;
	
	import res.ui.HelpPanel;
	
	import service.BaseService;
	
	public final class HelpService extends BaseService
	{
		public function HelpService()
		{
			super();
		}
		
		protected override function onStart(param:Object):Boolean
		{
			var helpPanel : HelpPanel = new HelpPanel();
			
			Gamex.ui.setUI(UIDefine.HELP,helpPanel);
			
			return true;
		}
		
		protected override function onStop():Boolean
		{
			Gamex.ui.destroyUI(UIDefine.HELP);
			
			return true;
		}
	}
}