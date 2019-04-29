package screens.subscreens 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Strong;
	import events.NavigationEvent;
	import flash.display.Bitmap;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Bounce;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	/**
	 * The main menu graphic and buttons.
	 * @author Stephen Oppong Beduh
	 */
	public class MainMenu 
	{
		/**
		 * All the graphics of the main menu.
		 */
		private var _display:	Sprite;
		/**
		 * The brick wall and logo graphic.
		 */
		private var _bg:					Image;
		private var _x:						Number;
		private var _y:						Number;
		private var _dispatcher:			EventDispatcher;
		private var _width:					Number;
		private var _startBtn:  			Button;
		private var _instructionsBtn:		Button;
		private var _levelBtn:         		Button;
		private var _levelNumber:           int;
		private var _levelText:             TextField;
		private var _nextArrow:             Button;
		private var _prevArrow:             Button
		private var _buttons:				Vector.<Button>;
		private var _buttonsSprite:         Sprite;
		private var _timer:                 Number;
		private var _settingsBtn:        	Button;
		/**
		 * The selector on the menu that follows hover touches.
		 */
		private var _band:					Quad;
		/**
		 * The trailing textures are placed underneath the buttons using this sprite.
		 */
		private var _underneath:				Sprite;
		private var _currTouched:				Button;
		private static const _BUTTON_PADDING:	uint = 32;
		private static const _BUTTON_SPACING:	uint = 40;
		private var _hidden:					Boolean;
		private var _callbackCalled:			Boolean;
		
		private var _onIdle:					Function;
		
		public function MainMenu(onIdle:Function = null ) 
		{
			_display = new Sprite();
			_bg = new Image(Assets.Manager.getTexture("title-screen-resized"));
			_display.addChild(_bg);
			_buttons = new Vector.<Button>();
			_buttonsSprite = new Sprite();
			_underneath = new Sprite()
			_display.addChild(_underneath);
			_display.addChild(_buttonsSprite);
			_dispatcher = new EventDispatcher();
			_startBtn = new Button(Assets.Manager.getTexture("startBtn"), "", Assets.Manager.getTexture("startBtn"));
			_instructionsBtn = new Button(Assets.Manager.getTexture("instructionsBtn"), "", Assets.Manager.getTexture("instructionsBtn"));
			_levelBtn = new Button(Assets.Manager.getTexture("level"), "", Assets.Manager.getTexture("level"));
			_band = new Quad(width, _startBtn.height + 10, 0x240900);
			_band.alpha = 0.5;
			_buttons.push(_startBtn); 
			_buttons.push(_levelBtn);
			_buttons.push(_instructionsBtn);
			_nextArrow = new Button(Assets.Manager.getTexture("arrow"), "");
			_prevArrow = new Button(Assets.Manager.getTexture("arrow"), "");
			_prevArrow.scaleX = -1;
			_currTouched = _startBtn;
			_timer = 0;
			_hidden = _callbackCalled = false;
			_onIdle = onIdle;
			_levelNumber = Assets.LevelIndex;
			_levelText = new TextField(70, 40, (_levelNumber + 1).toString() , "pressStart80", 24, Color.WHITE);
			_settingsBtn = new Button(Assets.Manager.getTexture("optionsButton"), "", Assets.Manager.getTexture("optionsButton"));
		}
		
		/**
		* Make the buttons and text appear
		*/
		public function displayOptions():void
		{
			var stage:Stage = _display.stage;
			_buttonsSprite.x = stage.stageWidth / 2;
			var len:uint = _buttons.length;
			var button:Button;
			for (var i:int = 0; i < len; i++) 
			{
				button = _buttons[i];
				_buttonsSprite.addChild(button);
				button.x =  - button.width / 2;
				button.y =  stage.stageHeight / 2 + _BUTTON_PADDING + (_BUTTON_SPACING * i);
			}
			_levelText.pivotX = _levelText.width / 2;
			_levelText.hAlign = HAlign.CENTER;
			_levelText.y = _levelBtn.y - 8;
			_levelText.x = _levelBtn.x + _levelBtn.width / 2 + 150;
			_buttonsSprite.addChild(_levelText);
			_nextArrow.y = _levelBtn.y;
			_nextArrow.x = _levelText.x + _levelText.width/2 + 5;
			_buttonsSprite.addChild(_nextArrow);
			_prevArrow.y = _levelBtn.y;
			_prevArrow.x = _levelText.x - + _levelText.width/2 - 5;
			_buttonsSprite.addChild(_prevArrow);
			_settingsBtn.x = stage.stageWidth - _settingsBtn.width;
			_display.addChild(_settingsBtn);
			_band.y = _startBtn.y - 5;
			_underneath.addChild(_band);
			_display.addEventListener(TouchEvent.TOUCH, onTouch);
			_display.addEventListener(Event.TRIGGERED, onTriggered);
			//_display.addEventListener(Event.TRIGGERED, onTriggered);
			trace('options have been displayed');
		}
		
		private function onTriggered(e:Event):void 
		{
			var t:Button = e.target as Button;
			if (t === _nextArrow || t === _prevArrow) 
			{
				if (t === _nextArrow) 
				{
					levelNumber ++;
				} else if (t === _prevArrow) 
				{
					levelNumber--;
				}
				Assets.SoundEffects.playSound("blip");
				e.stopImmediatePropagation();
			}
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(_display.stage);
			if (!touch) return;
			if (touch.phase == TouchPhase.HOVER) 
			{
				var len:uint = _buttons.length;
				var btn:Button;
				for (var i:int = 0; i < len; i++) 
				{
					btn = _buttons[i];
					if (touch.isTouching(btn)) 
					{
						if (_currTouched !== btn) 
						{
							TweenLite.to(_band, 0.6, { y: btn.y - 5, ease: Strong.easeOut, overwrite:true } );
							_currTouched = btn;
							break;
						}
					} 
				}
				
				if (touch.isTouching(_nextArrow) || touch.isTouching(_prevArrow) || touch.isTouching(_levelText)) 
					{
						if (_currTouched !== _levelBtn) 
						{
							TweenLite.to(_band, 0.6, { y: _levelBtn.y - 5, ease: Strong.easeOut, overwrite:true } );
							_currTouched = _levelBtn;
						}
					}
				
				_timer = 0;
			}
		}
		
		public function update(passedTime:Number):void 
		{
			if (!_hidden) 
			{
				if (_timer > 12) 
				{
					if (!_callbackCalled && _onIdle !== null) 
					{
						_onIdle();
						_callbackCalled = true;
					}
				}else 
				{
					_timer += passedTime;
				}
			}
		}
		
		/**
		 * Remove listeners.
		 */
		public function hide():void
		{
			_display.removeEventListeners();
			_hidden = true;
		}
		
		public function show():void
		{
			_display.addEventListener(TouchEvent.TOUCH, onTouch);
			_display.addEventListener(Event.TRIGGERED, onTriggered);
			_timer = 0;
			_hidden = false;
		}

		

		// ================ GETTERS AND SETTERS ================ 
		
		private function set levelNumber(value:int):void
		{ 
			var n:int = value;
			if (n > Assets.MaxLevel) 
			{
				n = 0;
			}else if (n < 0) 
			{
				n = Assets.MaxLevel;
			}
			_levelNumber = n;
			_levelText.text = (_levelNumber + 1).toString();
			Assets.LevelIndex = _levelNumber;
		}
		
		private function get levelNumber():int
		{
			return _levelNumber;
		}
		
		public function get display():Sprite 
		{
			return _display;
		}
		
		public function get x():Number 
		{
			return _display.x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			_display.x = value;
		}
		
		public function get y():Number 
		{
			return _display.y;
			
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			_display.y = value;
		}
		
		public function get width():Number 
		{
			return _display.width;
		}
		
		public function get height():Number 
		{
			return _display.height;
		}
		
		public function get startBtn():Button 
		{
			return _startBtn;
		}
		
		public function get instructionsBtn():Button 
		{
			return _instructionsBtn;
		}
		
		public function get highScoresBtn():Button 
		{
			return _levelBtn;
		}
		
		public function get settingsBtn():Button 
		{
			return _settingsBtn;
		}
		
	}

}