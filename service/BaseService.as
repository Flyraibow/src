package service
{
	import flash.utils.Dictionary;

	public class BaseService
	{
		private var _function : Object;			// 回调函数
		private var _count : Object;			// 回调数量索引
		private var _status : int;				// 服务状态
		
		public static const STATUS_DESTROYED : int = 0;
		public static const STATUS_STOP : int = 1;
		public static const STATUS_RUNNING : int = 2;
		
		public function BaseService()
		{
			_function = null;
			_count = null;
			_status = STATUS_DESTROYED;
		}
		
		public function get status():int
		{
			return _status;
		}
		
		public function create():Boolean
		{
			if(_status != STATUS_DESTROYED)
			{
				return false;
			}
			_status = STATUS_STOP;
			if(onCreate())
			{
				_function = new Object();
				_count = new Object();
				return true;
			}
			else
			{
				_status = STATUS_DESTROYED;
				return false;
			}
		}
		
		public function destroy():Boolean
		{
			if(_status == STATUS_DESTROYED)
			{
				return false;
			}
			if(_status != STATUS_STOP)
			{
				throw new Error(this + ":you must stopService before destroy it");
				return false;
			}
			
			_status = STATUS_DESTROYED;
			
			if(onDestroy())
			{
				_function = null;
				_count = null;
				return true;
			}
			else
			{
				_status = STATUS_STOP;
				return false;
			}
		}
		
		public function start(param : Object = null):Boolean
		{
			if(_status == STATUS_DESTROYED)
			{
				throw new Error(this + ":you must createService before start it");
				return false;
			}
			else if(_status == STATUS_RUNNING)
			{
				return false;
			}
			
			_status = STATUS_RUNNING;
			if(onStart(param))
			{
				return true;
			}
			else 
			{
				_status = STATUS_STOP;
				return false;
			}
		}
		
		public function stop():Boolean
		{
			if(_status == STATUS_DESTROYED)
			{
				throw new Error(this + ":you must createService before start it");
				return false;
			}
			else if(_status == STATUS_STOP)
			{
				return false;
			}
			_status = STATUS_STOP;
			if(onStop())
			{
				return true;
			}
			else 
			{
				_status = STATUS_RUNNING;
				return false;
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
		
		protected function onCreate():Boolean
		{
			return true;
		}
		
		protected function onDestroy():Boolean
		{
			return true;
		}
		
		protected function onStart(param : Object):Boolean
		{
			return true;
		}
		
		protected function onStop():Boolean
		{
			return true;
		}
	}
}