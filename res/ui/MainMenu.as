package res.ui
{
//	import com.adobe.nativeExtensions.AdBanner;
//	import com.adobe.nativeExtensions.AdBannerEvent;
//	import com.adobe.nativeExtensions.AdBannerPosition;
	
	import fl.controls.Button;
	
	import flash.events.MouseEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class MainMenu extends BaseUI
	{
		private var _btnStartGame : Button;
		private var _btnHelp : Button;
		
		public function MainMenu()
		{
			super("Menu");
			
			_btnStartGame = _components["btn_startGame"];
			_btnHelp = _components["btn_help"];
			
//			initAD();
			
			_btnStartGame.addEventListener(MouseEvent.CLICK, onClickStartGame);
			_btnHelp.addEventListener(MouseEvent.CLICK, onClickHelp);
		}
		
		public override function destroy():void
		{
			_btnStartGame.removeEventListener(MouseEvent.CLICK, onClickStartGame);
			_btnHelp.removeEventListener(MouseEvent.CLICK, onClickHelp);
			
			super.destroy();
		}
		
		private function onClickStartGame(event : MouseEvent):void
		{
			Gamex.service.game.start();
			Gamex.service.main.stop();
//			var url : URLRequest = new URLRequest("http://www.baidu.com");
//			navigateToURL(url,"_blank");
		}
		
		private function onClickHelp(event : MouseEvent):void
		{
//			var url : URLRequest = new URLRequest("http://www.baidu.com");
//			navigateToURL(url,"_blank");
			Gamex.service.help.start();
			Gamex.service.main.stop();
		}
		
		
//		private function initAD():void
//		{
//			AdBanner.adView.startShowingAds(AdBannerPosition.TOP, false);  
//			AdBanner.adView.addEventListener(AdBannerEvent.AD_LOADED, adLoaded);  
//			AdBanner.adView.addEventListener(AdBannerEvent.AD_LOADING_FAILED, adFailed)
//			AdBanner.adView.addEventListener(AdBannerEvent.USER_INTERACTION_STARTING, adStart);  
//			AdBanner.adView.addEventListener(AdBannerEvent.USER_INTERACTION_FINISHED, adFinished); 
//		}
//		
//		private function adLoaded(event:AdBannerEvent):void
//		{
//			trace("Ad Loaded");         
//			AdBanner.adView.visible = true;         
//			trace("leaving: " + event.leaving); 
//		}
//		
//		private function adFailed(event:AdBannerEvent):void
//		{
//			trace("Loaded Failded: " + event.errorCode);
//			AdBanner.adView.visible = false;
//		}
//		
//		private function adStart(event:AdBannerEvent):void
//		{
//			trace("Starting");
//			trace(Gamex.stage.orientation);
//		}
//		
//		private function adFinished(event:AdBannerEvent):void
//		{
//			trace("Finished");
//			trace(Gamex.stage.orientation);
//		}
	}
}