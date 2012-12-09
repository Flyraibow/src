package
{
	import cache.PhotoManager;
	
	import define.UIDefine;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import music.SoundManager;
	
	import res.SkinManager;
	import res.UIManager;
	import res.ui.UIGroup;
	
	import service.UIService;
	
	[SWF(frameRate="60")]
	public class PokerMatrix extends Sprite
	{
		public function PokerMatrix()
		{
			super();
			// 侦听加载舞台完成事件
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		/**
		 * 加载舞台完成 
		 * @param event
		 * 
		 */		
		private function onAddToStage(event : Event):void
		{
			//移除侦听事件
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var screenHeight : int = stage.fullScreenHeight;
			var screenWidth : int = stage.fullScreenWidth;
			Gamex.rateX = 1;
			Gamex.rateY = 1;
			if(screenWidth == 640 && screenHeight == 1136)
			{
				Gamex.suffix = "_iphone5";
			}
			else if(screenHeight == 960 && screenWidth == 640)
			{
				Gamex.suffix = "_iphone4";
			}
			else if(screenHeight == 1024 && screenWidth == 768)
			{
				Gamex.suffix = "_ipad";
			}
			else
			{
				var rate : Number = screenHeight / screenWidth;
				if(rate >= 16 / 9)
				{
					Gamex.suffix = "_iphone5";
				}
				else if(rate >= 3 / 2)
				{
					Gamex.suffix = "_iphone4";
				}
				else
				{
					Gamex.suffix = "_ipad";
				}
			}
			
			addEventListener(Event.ENTER_FRAME , onEnterFrame);
		}
		
		private function onEnterFrame(event : Event):void
		{
			removeEventListener(Event.ENTER_FRAME , onEnterFrame);
			
			Gamex.stage = stage;
			
			//读取资源res.res(这个资源是swf和config的打包内容)
			var path : String = File.applicationDirectory.nativePath + "/res1/res.res";
			var file : File = new File(path);
			var byteArray : ByteArray = new ByteArray();
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(byteArray);
			fileStream.close();
			
			//解压
			byteArray.uncompress();
			
			//初始化皮肤管理器
			Gamex.skinManager = new SkinManager();
			Gamex.skinManager.loadRes(byteArray,onLoadResComplete);
			
			return;
		}
		
		// 皮肤初始化回调函数
		private function onLoadResComplete():void
		{
			// 初始化界面
			Gamex.uiManager = new UIManager();
			Gamex.uiManager.skinManager = Gamex.skinManager;
			
			// 读取ui打包资源
			var path : String = File.applicationDirectory.nativePath + "/res1/ui.pkg";
			var file : File = new File(path);
			var byteArray : ByteArray = new ByteArray();
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(byteArray);
			fileStream.close();
			
			//解析UI资源
			byteArray.uncompress();
			Gamex.uiManager.readUI(byteArray);
			
			// 初始化UI类
			Gamex.ui = new UIGroup(stage,this,UIDefine.UI_COUNT);
			
			Gamex.service = new UIService();
			
			Gamex.soundManager = new SoundManager();
			
			Gamex.photoManager = new PhotoManager();
			
			// 初始化所有界面服务
			Gamex.service.createAllService();
			
			//开始主界面
			Gamex.service.main.start();
		}
	}
}