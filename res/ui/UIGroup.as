package res.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	public class UIGroup
	{
		private var _stage : Stage;
		private var _container : DisplayObjectContainer;
		private var _group : Vector.<BaseUI>;
		private var _uiCount : int;
		
		public function UIGroup(uiStage : Stage, uiContainer : DisplayObjectContainer, uiCount : int)
		{
			_stage = uiStage;
			_container = uiContainer;
			
			_group = new Vector.<BaseUI>(uiCount);
			_uiCount = uiCount;
		}
		
		public function getUI(id : int):BaseUI
		{
			if(id < 0 || id >= _uiCount)
			{
				return null
			}
			return _group[id];
		}
		
		public function setUI(id : int, baseUI : BaseUI):void
		{
			if(id < 0 || id >= _uiCount)
			{
				return ;
			}
			var ui : BaseUI = _group[id];
			if(ui != null)
			{
				_container.removeChild(ui.container);
				ui.destroy();
				_group[id] = null;
			}
			_group[id] = baseUI;
			
			baseUI.resize(_stage.stageWidth, _stage.stageHeight);
			
			_container.addChild(baseUI.container);
		}
		
		public function destroyUI(id : int):void
		{
			if(id < 0 || id >= _uiCount)
			{
				return ;
			}
			var ui : BaseUI = _group[id];
			if(ui != null)
			{
				ui.destroy();
				_container.removeChild(ui.container);
				_group[id] = null;
			}
		}
	}
}