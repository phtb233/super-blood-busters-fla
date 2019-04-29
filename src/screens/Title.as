package screens 
{
	import events.NavigationEvent;
	import events.ProgressEvent;
	import flash.media.Sound;
	import screens.subscreens.Instructions;
	import screens.subscreens.MainMenu;
	import screens.subscreens.Settings;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.display.Button;
	import com.greensock.TweenLite;
	import com.greensock.easing.*
	import starling.extensions.SoundManager;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Title extends AbstractScreen
	{
		private var _mainMenu:			MainMenu;
		private var _instructions:		Instructions;
		private var _settings:          Settings;
		private const _SLIDE_SPEED: 	Number = 0.5;
		
		public function Title() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/* INTERFACE interfaces.IScreen */
		
		override public function load():void 
		{
			super.load();
			if (Assets.PlayTimes < 1) 
			{
				Assets.Music.playSound("intro");
				Assets.PlayTimes++;
			}else 
			{
				Assets.Music.tweenVolume(Assets.Music.recentSoundId, 0, 0.5, function ():void 
					{
						Assets.Music.stopSound(Assets.Music.recentSoundId);
					}
				);
			}
		}
		
		override public function unload():void 
		{
			super.unload();
			_mainMenu.display.removeEventListeners();
		}
		
		override public function onTweenComplete():void 
		{
			_mainMenu.displayOptions();
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_mainMenu = new MainMenu(function ():void 
			{
				var m:SoundManager = Assets.Music;
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "highscores" }, true));
				
				//Assets.Music.crossFade(Assets.Music.currPlayingSounds
			});
			_instructions = new Instructions();
			_settings = new Settings();
			addChild(_mainMenu.display);
			//TweenLite.from(_mainMenu, 1.6, { y: -_mainMenu.height, ease: Bounce.easeOut, onComplete: _mainMenu.displayOptions });
			addEventListener(Event.TRIGGERED, onTriggered);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
			trace("Title has been added. The y is = " + this.y);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			_mainMenu.update(e.passedTime);
			_settings.update(e.passedTime);
		}
		
		private function onTriggered(e:Event):void 
		{
			var button:Button = e.target as Button;
			if (button === _mainMenu.startBtn) 
			{
				removeChild(_instructions.display);			// Remove instructions, otherwise the stage gets bigger to accomodate it.
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "playstate" }, true));
			} else if (button === _mainMenu.instructionsBtn) 
			{
				showInstructions();
			} else if (button === _instructions.backBtn) 
			{
				showMainMenu("instructions");
			} else if (button === _mainMenu.settingsBtn) 
			{
				showSettings();
			} else if (button === _settings.backBtn) 
			{
				showMainMenu("settings");
			}
		}
		
		/**
		 * 
		 */
		private function showSettings():void 
		{
			_mainMenu.hide();
			_settings.show();
			_settings.x = 0;
			addChild(_settings);
			TweenLite.from(_settings, _SLIDE_SPEED, {x:stage.stageWidth, onComplete: _settings.showOptions } );
			TweenLite.to(_mainMenu.display, _SLIDE_SPEED, {x: -stage.stageWidth, onComplete: function ():void 
			{
				_mainMenu.display.visible = false;
			} } );
		}
		
		/**
		 * Animate the main menu scrolling back onto the screen.
		 */
		private function showMainMenu(switchFrom:String):void
		{
			switch (switchFrom) 
			{
				case "instructions":
					_mainMenu.display.visible = true;
					TweenLite.to(_instructions, _SLIDE_SPEED, { x: -_instructions.width, onComplete:_instructions.hide	}  );
					TweenLite.to(_mainMenu, _SLIDE_SPEED, { x: 0 , onComplete:_mainMenu.show}  );
				break;
			case "settings":
					_mainMenu.display.visible = true;
					TweenLite.to(_settings, _SLIDE_SPEED, { x: stage.stageWidth, onComplete: _settings.hide } );
					TweenLite.to(_mainMenu, _SLIDE_SPEED, { x: 0 , onComplete:_mainMenu.show}  );
				break;
				default:
			}
			
		}
		
		/**
		 * Animate the instructions menu sliding in from the left.
		 */
		private function showInstructions():void
		{
			_mainMenu.hide();
			_instructions.show();
			_instructions.x = -_instructions.width;
			addChild(_instructions.display);
			TweenLite.to(_instructions, _SLIDE_SPEED, { x: 0 , onComplete: _instructions.showText }  );
			TweenLite.to(_mainMenu, _SLIDE_SPEED, { x: _instructions.width, onComplete: function():void {
				_mainMenu.display.visible = false;
				}} );
		}
		
		public function get mainMenu():MainMenu 
		{
			return _mainMenu;
		}

	}

}