package  
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import events.*;
	import screens.*;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	//import starling.display.*;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.*;
	
	
	/**
	 * 
	 * @author Stephen Oppong Beduh
	 */
	public class BloodBusters extends Sprite 
	{
		
		private var _title:						Title;
		private var _loading:					Loading;
		private var _currentScreen:				AbstractScreen;
		private var _newScreen:					AbstractScreen;
		
		private static const _TRANSITION: 		Number = 1.5;
		private static const _DELAY: 			Number = 0.5;
		
		public function BloodBusters() 
		{
			super();
			TweenPlugin.activate([HexColorsPlugin]);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var isHardwareMode:Boolean =
				Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
			//if (!isHardwareMode) 
			//{
				//var text:TextField = new TextField(stage.stageWidth, stage.stageHeight, "THIS IS SOFTWARE MODE!!!!", "Verdana", 40, 0xFFFFFF);
				//addChild(text);
			//}
			
			//_title = new Title();
			//addChild(_title);
			//_currentScreen = _title;
			
			//TweenLite.from(_title, 1.6, { y: -stage.stageHeight, ease: Bounce.easeOut, onComplete: _title.onTweenComplete } );
			
			_loading = new Loading();
			addChild(_loading);
			_currentScreen = _loading;
			
			addEventListener(ProgressEvent.LOADED, onNewScreenLoaded);
			addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
		}
		
		private function onChangeScreen(e:NavigationEvent):void 
		{
			switch (e.params.id) 
			{
				case "playstate":
					_newScreen = new PlayState();
					_newScreen.y = stage.stageHeight;
				break;
				case "nameentry":
					_newScreen = new NameEntry(e.params.playerScore);
					_newScreen.x = stage.stageWidth;
				break;
				case "highscores":
					_newScreen = new HighScores();
					_newScreen.x = stage.stageWidth
				break;
				case "title":
					_newScreen = new Title();
					_newScreen.y = -stage.stageHeight;
				break;
				default:
			}
			addChild(_newScreen);
			_newScreen.load();
			 _currentScreen.unload();
		}
		
		/*
		private function switchScreen(screen:String):void
		{
			switch (screen) 
			{
				case "playstate":
					_newScreen = new PlayState();
					_newScreen.y = stage.stageHeight;
					addChild(_newScreen);
					_newScreen.load();
					_currentScreen.unload();
					TweenLite.to(_currentScreen, _TRANSITION, { y: -_currentScreen.height, delay: _DELAY, ease:Strong.easeOut, onComplete: destroyOldScreen } );
					TweenLite.to(_newScreen, _TRANSITION, { y: 0, delay: _DELAY, ease:Strong.easeOut } );
				break;
				default:
			}
		}
		*/
		
		/**
		 * New screen has loaded successfully, so animate it's entrance.
		 * @param	e
		 */
		private function onNewScreenLoaded(e:ProgressEvent):void 
		{
			var screen:AbstractScreen = e.target as AbstractScreen;
			
			if (e.target is PlayState) 
			{
				//FIXME: Had to put a delay on the tween, as it doesnt wait for the assets to load, causing a jerk in it's animation.
				TweenLite.to(_currentScreen, _TRANSITION, { y: -_currentScreen.height, delay: _DELAY, ease:Strong.easeOut, onComplete: destroyOldScreen } );
				TweenLite.to(_newScreen, _TRANSITION, { y: 0, delay: _DELAY, ease:Strong.easeOut } );
			} else if (e.target is HighScores || e.target is NameEntry) 
			{
				TweenLite.to(_currentScreen, _TRANSITION, { x: -stage.stageWidth, delay: _DELAY, ease:Strong.easeOut, onComplete: destroyOldScreen } );
				TweenLite.to(_newScreen, _TRANSITION, { x: 0, delay: _DELAY, ease:Strong.easeOut, onComplete: _newScreen.onTweenComplete } );
			} else if (e.target is Title) 
			{
				TweenLite.to(_newScreen, 1.3, { y: 0, delay: 0.2, ease: Bounce.easeOut, onComplete:function():void
				{
					_newScreen.onTweenComplete();
					destroyOldScreen();
				}});
			}
		}
		
		private function destroyOldScreen():void
		{
			_currentScreen.dispose();
			removeChild(_currentScreen);
			_currentScreen = _newScreen;
			_newScreen = null;
		}
		
	}

}