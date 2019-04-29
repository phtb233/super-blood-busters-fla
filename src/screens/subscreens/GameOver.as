package screens.subscreens 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import events.NavigationEvent;
	import events.ProgressEvent;
	import interfaces.*;
	import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.deg2rad;
	
	/**
	 * Shows when the player loses all their health.
	 * @author Stephen Oppong Beduh
	 */
	public class GameOver extends Sprite implements IUpdateable 
	{
		private var _bg:Quad;
		
		private var _state:uint;
		private var _angle:Number;
		private var _lettersVector:Vector.<Image>;
		private var _lettersSprite:Sprite;
		private var _timer:Number;
		private var _timing:Boolean;
		
		//private static const _EASE:Number = 0.03;
		private static const _LETTERS:String = "GAMEOVER";
		private var eventDispatched:Boolean;
		private var _playerScore:uint;
		
		public function GameOver(playerScore:uint) 
		{
			super();
			_playerScore = playerScore;
			_state = _angle = _timer = 0;
			eventDispatched = _timing = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x4A0000);
			_bg.alpha = 0;
			addChild(_bg);
			_lettersSprite = new Sprite();
			_lettersVector = new Vector.<Image>();
			TweenLite.to(_bg, 1.5, { alpha: 0.7, ease:Strong.easeOut, onComplete:createLetters } );
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			
			var touch:Touch = e.getTouch(stage);
			if (!touch) return;
			if (touch.phase === TouchPhase.BEGAN) 
			{
				removeEventListener(TouchEvent.TOUCH, onTouch);
				var len:int = _lettersVector.length;
				var t:Image;
				TweenLite.killTweensOf(_bg);
				//_bg.alpha = 0.7;
				for (var i:int = 0; i < len; i++) 
				{
					t = _lettersVector[i];
					TweenLite.killTweensOf(t);
				}
				nextScreen();
			}
		}
		
		private function createLetters():void 
		{
			Assets.Music.playSound("gameover");
			var len:uint = _LETTERS.length;
			var space:Number = 70;
			for (var i:int = 0; i < len; i++) 
			{
				var img:Image = new Image(Assets.Manager.getTexture(_LETTERS.charAt(i)));
				_lettersVector.push(img);
				img.pivotX = img.width / 2; img.pivotY = img.height / 2;
				img.x = Math.ceil(i * img.width + 50);
				img.y = Math.ceil(stage.stageHeight / 2);
				img.scaleX = img.scaleY = 0;
				if (i > 3) 
				{
					img.x += space;
				}
				_lettersSprite.addChild(img);
				var callback:Function = i === len - 1 ? opaqueBackground : null;
				TweenLite.to(img, 0.6, { scaleX: 1, scaleY:1, ease:Bounce.easeOut, delay:i * 0.1, onComplete:callback } );
			}
			addChild(_lettersSprite);
		}
		
		/**
		 * Fully darken the background to the game over screen.
		 */
		private function opaqueBackground():void 
		{
			TweenLite.to(_bg, 1.2, { alpha:1, ease:Strong.easeOut, onComplete:function():void {
				
				_timing = true;
			}} );
		}
		
		public function update(passedTime:Number):void
		{
			/*
			if (_state === 0) 
			{
				if (_bg.alpha < 0.7) 
				{
					_bg.alpha += Math.max(1 - _bg.alpha, 0.01) * _EASE;
				}else 
				{
					_state = 1;
				}
			} else if (_state === 1) 
			{
				_lettersVector.forEach(animateLetters);
				_angle += 2;
			}
			*/
			if (_timing) 
			{
				_timer += passedTime;
				if (_timer > 1.5 && !eventDispatched) 
				{
					nextScreen();
					_timing = false;
				}
			}
		}
		
		private function animateLetters(img:Image, i:uint, v:Vector.<Image>):void 
		{
			/*
			if (img.scaleX < 1) 
			{
				img.scaleX = img.scaleY += Math.max(1 - img.scaleX, 0.01) * _EASE;
			}
			img.rotation += (Math.cos(deg2rad(_angle)) * 0.06);
			*/
		}
		
		private function nextScreen():void
		{
			if (_playerScore > Assets.HighScores[3][1]) 
			{
				trace("Show name entry");
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "nameentry", playerScore: _playerScore }, true));
			}else 
			{
				trace("Show the high scores!");
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "highscores" }, true));
			}
				eventDispatched = true;
		}
	}

}