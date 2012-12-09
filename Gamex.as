package
{
	import cache.PhotoManager;
	
	import flash.display.Stage;
	
	import music.SoundManager;
	
	import res.SkinManager;
	import res.UIManager;
	import res.ui.UIGroup;
	
	import service.UIService;

	public class Gamex
	{
		//UI管理器，这个部分你应该用不到
		public static var uiManager : UIManager;
		
		//皮肤管理器，这个部分一般情况用不到，不排除要调用一些调用
		public static var skinManager : SkinManager;
		
		// 存放界面组
		public static var ui : UIGroup;
		
		// 存放界面服务，用于调用界面
		public static var service : UIService;
		
		// 音效管理器
		public static var soundManager : SoundManager;
		
		// 图形管理器
		public static var photoManager : PhotoManager;
		
		// 舞台
		public static var stage : Stage;
		
		public static var suffix : String;
		
		public static var rateX : Number;
		public static var rateY : Number;
	}
}