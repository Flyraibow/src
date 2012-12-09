package service
{
	public class ServiceGroup
	{
		private var _group : Vector.<BaseService>;
		
		public function ServiceGroup()
		{
		}
		
		public function createAllService():void
		{
			if(_group != null)
			{
				var count : int = _group.length;
				for(var i : int = 0; i < count; ++i)
				{
					_group[i].create();
				}
			}
		}
		
		protected function createInstance(serviceClass : Class):BaseService
		{
			if(_group == null)
			{
				_group = new Vector.<BaseService>();
			}
			var baseService : BaseService = new serviceClass();
			_group.push(baseService);
			
			return baseService;
		}
	}
}