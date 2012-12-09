package res.ui
{
	import flash.events.MouseEvent;
	
	import res.component.UIPanel;

	public class PausePanel extends BaseUI
	{
		private var _uiMenu : UIPanel;
		private var _uiRestart : UIPanel;
		private var _uiResume : UIPanel;
		
		public static const EVENT_CLICK_MENU : int = 0;
		public static const EVENT_CLICK_RESTART : int = 1;
		public static const EVENT_CLICK_RESUME : int = 2;
		
		public function PausePanel()
		{
			super("Pause");
			
			_uiMenu = _components["btn_menu"];
			_uiRestart = _components["btn_restart"];
			_uiResume = _components["btn_resume"];
			
			_uiMenu.addEventListener(MouseEvent.CLICK, onClickMenu);
			_uiRestart.addEventListener(MouseEvent.CLICK, onClickRestart);
			_uiResume.addEventListener(MouseEvent.CLICK, onClickResume);
		}
		
		public override function destroy():void
		{
			_uiMenu.removeEventListener(MouseEvent.CLICK, onClickMenu);
			_uiRestart.removeEventListener(MouseEvent.CLICK, onClickRestart);
			_uiResume.removeEventListener(MouseEvent.CLICK, onClickResume);
			
			super.destroy();
		}
		
		private function onClickMenu(event : MouseEvent):void
		{
			applyCallback(EVENT_CLICK_MENU);
		}
		
		private function onClickRestart(event : MouseEvent):void
		{
			applyCallback(EVENT_CLICK_RESTART);
		}
		
		private function onClickResume(event : MouseEvent):void
		{
			applyCallback(EVENT_CLICK_RESUME);
			
		}
	}
}