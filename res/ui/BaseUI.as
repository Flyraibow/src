package res.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import res.component.UIPanel;

	/**
	 * UI基类 
	 * @author liuyujie
	 * 
	 */	
	public class BaseUI
	{
		protected var _components : Object;						// 空间集
		protected var _container : DisplayObjectContainer;
		protected var _width : Number;
		protected var _height : Number;
		
		private var _function : Object;
		private var _count : Object;
		
		public function BaseUI(uiName : String = null)
		{
			if(uiName != null)
			{
				_components = new Object();
				_container = Gamex.uiManager.getComponentContainer(uiName + Gamex.suffix,_components);
				_width = _container.width;
				_height = _container.height;
			}
			else
			{
				_container = new Sprite;
				_width = 0;
				_height = 0;
			}
			_function = new Object();
			_count = new Object();
		}
		
		public function get container():DisplayObjectContainer
		{
			return _container;
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
		
		public function applyCallback(id : int, param : Object = null):void
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
		
		public function resize(w : int, h : int):void
		{
			_container.x = 0;
			_container.y = 0;
		}
		
		public function destroy():void
		{
			
		}
	}
}