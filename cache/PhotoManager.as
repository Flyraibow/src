package cache
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class PhotoManager
	{
		private var _cachePhoto : Object;
		
		private var _loadingObject : Object;
		
		public function PhotoManager()
		{
			_cachePhoto = new Object();
			_loadingObject = new Object();
		}
		
		public function getBitmapData(id : String):BitmapData
		{
			return _cachePhoto[id];
		}
		
		public function loadBitmapData(id : String, photoBox : PhotoBox,dictionaryString : String, suffix : String):void
		{
			var temp : Dictionary = _loadingObject[id];
			if(temp != null)
			{
				if(temp[photoBox] == null)
				{
					temp[photoBox] = photoBox;
				}
			}
			else
			{
				temp = new Dictionary();
				temp[photoBox] = photoBox;
				_loadingObject[id] = temp;
				
				loadBmd(id,dictionaryString,suffix);
			}
		}
		
		private function loadBmd(id : String, dictionaryString : String, suffix : String):void
		{
			var path : String = File.applicationDirectory.nativePath + "/res1/" + id + "." + suffix;

			var file : File = new File(path);
			if(file.exists)
			{
				var fileStream : FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var byteArray : ByteArray = new ByteArray();
				fileStream.readBytes(byteArray);
				
				var context : LoaderContext = new LoaderContext();
				context.allowCodeImport = true;
				var loader : Loader = new Loader();
				loader.name = id.toString();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.loadBytes(byteArray,context);
			}
			else
			{
				delete _loadingObject[id];
			}
		}
		
		private function onLoadComplete(event : Event):void
		{
			var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			var loaderName : String = loaderInfo.loader.name;
			
			var bitmap : Bitmap = loaderInfo.content as Bitmap;
			var bitmapData : BitmapData = bitmap.bitmapData;
			_cachePhoto[loaderName] = bitmapData;
			var temp : Dictionary = _loadingObject[loaderName];
			for each(var photoBox : PhotoBox in temp)
			{
				photoBox.refresh(bitmapData);
			}
			
			delete _loadingObject[loaderName];
		}
		
		private function onLoadError(event : Event):void
		{
			var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			
			var loaderName : String = loaderInfo.loader.name;
			delete _loadingObject[loaderName];
		}
	}
}