package res.ui
{
	import cache.PhotoBox;
	
	import flash.events.MouseEvent;
	
	import res.component.UIPanel;

	public final class HelpPanel extends BaseUI
	{
		private var _helpPanel : UIPanel;
		private var _photoBox : PhotoBox;
		
		private var _state1:int;
		
		public function HelpPanel()
		{
			super("Help");
			
			_helpPanel = _components["pan_help"];
			
			_photoBox = new PhotoBox();
			_photoBox.setPhoto("Help1","photo","png");
			_helpPanel.addChild(_photoBox);
			
			_state1 = 0;
			
			_helpPanel.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public override function destroy():void
		{
			_helpPanel.removeEventListener(MouseEvent.CLICK, onMouseClick);
			super.destroy();
		}
		
		private function onMouseClick(event : MouseEvent):void
		{
			if(_state1 == 0)
			{
				_photoBox.setPhoto("Help2","photo","png");
				_state1 = 1;
			}
			else
			{
				Gamex.service.main.start();
				Gamex.service.help.stop();
			}
		}
	}
}