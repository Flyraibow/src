package service
{
	import service.ui.*;

	public class UIService extends ServiceGroup
	{
		public const main : MainMenuService = createInstance(MainMenuService) as MainMenuService;
		public const game : GameService = createInstance(GameService) as GameService;
		public const help : HelpService = createInstance(HelpService) as HelpService;

		public function UIService()
		{
			super();
		}
	}
}