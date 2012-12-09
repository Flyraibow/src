package res.ui
{
	import fl.controls.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import res.component.UIPanel;
	import res.ui.elements.GameSprite;

	public class GamePanel extends BaseUI
	{
		private var _gamePanel : UIPanel;
		private var _gameSprite : GameSprite;
		
		private var _panPause : UIPanel;
		
		private var _labScore : Label;
		private var _labMoves : Label;
		
		private var _pauseUI : PausePanel;
		
		public function GamePanel()
		{
			super("Game");
			
			_gamePanel = _components["pan_card"];
			_panPause = _components["pan_pause"];
			_labScore = _components["lab_score"];
			_labMoves = _components["lab_moves"];
			
			_gameSprite = new GameSprite();
			_gamePanel.addChild(_gameSprite);
			
			_labScore.text = "0";
			_labMoves.text = _gameSprite.moves.toString();
			
			_gameSprite.addCallback(GameSprite.EVENT_SCORE_CHANGE, onScoreChange);
			_gameSprite.addCallback(GameSprite.EVENT_MOVES_CHANGE, onMovesChange);
			_gameSprite.addCallback(GameSprite.EVENT_ENDING, onEnding);
			_panPause.addEventListener(MouseEvent.CLICK, onClickPause);
		}
		
		public override function destroy():void
		{
			_gameSprite.removeCallback(GameSprite.EVENT_SCORE_CHANGE, onScoreChange);
			_gameSprite.removeCallback(GameSprite.EVENT_MOVES_CHANGE, onMovesChange);
			_gameSprite.removeCallback(GameSprite.EVENT_ENDING, onEnding);
			_panPause.removeEventListener(MouseEvent.CLICK, onClickPause);
			
			if(_pauseUI != null)
			{
				var pauseContainer : DisplayObjectContainer = _pauseUI.container;
				container.removeChild(pauseContainer);
				_pauseUI.destroy();
				_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESUME, onClickStartPanel);
				_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESTART, onClickRestartPanel);
				_pauseUI.removeCallback(PausePanel.EVENT_CLICK_MENU, onReturnToMenu);
				_pauseUI = null;
			}
			_gameSprite.destroy(true);
			super.destroy();
		}
		
		private function onScoreChange(score : int):void
		{
			_labScore.text = score.toString();
		}
		
		private function onMovesChange(moves : int):void
		{
			_labMoves.text = moves.toString();
		}
		
		private function onEnding(purchaseTime : int):void
		{
			
		}
		
		private function onClickPause(event : MouseEvent):void
		{
			_gameSprite.stop();
			if(_pauseUI == null)
			{
				_pauseUI = new PausePanel();
				var pauseContainer : DisplayObjectContainer = _pauseUI.container;
				pauseContainer.x = 0;
				pauseContainer.y = 0;
				container.addChild(pauseContainer);
				_pauseUI.addCallback(PausePanel.EVENT_CLICK_RESUME, onClickStartPanel);
				_pauseUI.addCallback(PausePanel.EVENT_CLICK_RESTART, onClickRestartPanel);
				_pauseUI.addCallback(PausePanel.EVENT_CLICK_MENU, onReturnToMenu);
			}
		}
		
		private function onClickStartPanel(param : Object):void
		{
			var pauseContainer : DisplayObjectContainer = _pauseUI.container;
			container.removeChild(pauseContainer);
			_pauseUI.destroy();
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESUME, onClickStartPanel);
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESTART, onClickRestartPanel);
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_MENU, onReturnToMenu);
			_pauseUI = null;
			_gameSprite.start();
		}
		
		private function onClickRestartPanel(param : Object):void
		{
			var pauseContainer : DisplayObjectContainer = _pauseUI.container;
			container.removeChild(pauseContainer);
			_pauseUI.destroy();
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESUME, onClickStartPanel);
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_RESTART, onClickRestartPanel);
			_pauseUI.removeCallback(PausePanel.EVENT_CLICK_MENU, onReturnToMenu);
			_pauseUI = null;
			_labScore.text = "0";
			_gameSprite.destroy();
			_gameSprite.init();
			_labMoves.text = _gameSprite.moves.toString();
		}
		
		private function onReturnToMenu(param : Object):void
		{
			Gamex.service.game.stop();
			Gamex.service.main.start();
		}
	}
}