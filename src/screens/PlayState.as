package screens 
{
	import flash.geom.*;
	import objects.*;
	import objects.data.Level;
	import events.ProgressEvent;
	import interfaces.IUpdateable;
	import objects.bullet.*;
	import objects.germs.*;
	import objects.HUD;
	import objects.userinterface.HyperButton;
	import screens.levels.*;
	import screens.subscreens.Flash;
	import screens.subscreens.GameOver;
	import screens.subscreens.Hypermode;
	import screens.subscreens.QuestionScreen;
	import screens.subscreens.Ready;
	import screens.subscreens.StageClear;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.utils.deg2rad;
	import starling.display.DisplayObject;
	
	/**
	 * The main game state where the germs will scroll across the screen.
	 * @author Stephen Oppong Beduh
	 */
	public class PlayState extends AbstractScreen
	{
		private var _angle:             	Number;
		private var _background:			IUpdateable;
		private var _backgroundLayer:		Sprite;
		private var _bgGroup: 				Group;
		private var _bulletGroup:			Group;
		private var _currentLevel:          Level;
		private var _germGroup:				Group;
		private var _flashGroup: 			Group;
		private var _flashLayer: 			Sprite;
		private var _gameOver:				GameOver;
		private var _gameScreen:			Sprite;
		private var _gameState: 			String;
		private var _germOne:		 		GermOne;
		private var _hyperButton: 			MovieClip;
		private var _hyperBg: 				Hypermode;
		private var _hyperGroup:       	 	Group;
		private var _HUD:					HUD;
		private var _interval:         	    Number;
		private var _isShaking:				Boolean;
		private var _layer1:				Layer;
		private var _layer2:				Layer;
		private var _layer3:				Layer;
		private var _layer4:				Layer;
		private var _passedTime:			Number;
		private var _powerupGroup:          Group;
		private var _questionScreen:  		QuestionScreen;
		private var _ready: 				Ready;
		private var _shake: 				Number;
		private var _stageClear:            StageClear;
		private var _staticBackgroundColor: Quad;
		
		private static const GAME_OVER: 	String = "game-over";
		private static const IN_PLAY:		String = "inplay";
		private static const READY:			String = "ready";
		private static const END_OF_LEVEL:  String = "end-of-level";
		static private const QUESTION:		String = "question";
		
		/**
		 * Total time passed since the game started.
		 */
		private var _elapsedTime:       Number;
		
		private var _germOneInterval:	Number;
		private var _germTwoInterval:	Number;
		private var _germThreeInterval:	Number;
		private var _germFourInterval:	Number;
		private var _powerupInterval:	Number;
		
		/**
		 * The string names of the assets to load before the game starts.
		 */
		
		public function PlayState() 
		{
			super();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		override public function load():void 
		{
			_passedTime = _powerupInterval = _germOneInterval = _germTwoInterval = _germThreeInterval = _germFourInterval = _elapsedTime = _angle = 0;
			_isShaking = false;
			this.alpha = 0.999;
			
			dispatchEvent(new ProgressEvent(ProgressEvent.LOADED, true));
		}
		
		/**
		 * The game is loaded after it's added to the stage.
		 * @param	e
		 */
		private function onAddedToStage(e:starling.events.Event):void 
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			init();
		}
		
		/**
		 * Set up everything.
		 */
		private function init():void
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			_staticBackgroundColor = new Quad(stage.stageWidth, stage.stageHeight, 0x61A3FF);
			addChild(_staticBackgroundColor);
			
			_gameScreen = new Sprite();
			addChild(_gameScreen);
			
			
			_flashLayer = new Sprite();
			addChild(_flashLayer);
			
			_backgroundLayer = new Sprite();
			_gameScreen.addChild(_backgroundLayer);
			
			_hyperBg = new Hypermode();
			_hyperGroup = new Group();
			
			_layer1 = new Layer(); _layer2 = new Layer(); _layer3 = new Layer(); _layer4 = new Layer();
			_HUD = new HUD(deactiveHypermode, endOfLevel );
			_hyperButton = _HUD.hypermodeButton;
			
			_gameScreen.addChild(_HUD);
			_gameScreen.addChild(_layer4);
			_gameScreen.addChild(_layer3);
			_gameScreen.addChild(_layer2);
			_gameScreen.addChild(_layer1);
			
			_bulletGroup = new Group();
			_germGroup = new Group();
			_flashGroup = new Group();
			_powerupGroup = new Group();
			
			_ready = new Ready();
			_gameScreen.addChild(_ready);
			_gameState = READY;
			
			_currentLevel = Assets.LevelArray[Assets.LevelIndex /*16*/];
			switchLevel();
			changeMusic();
			_backgroundLayer.touchable = false;
			
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (!touch) return;
			if (touch.phase === TouchPhase.BEGAN) 
			{
				var point:Point = touch.getLocation(stage);
				switch (_gameState) 
				{	
					case IN_PLAY:
						var t:DisplayObject = e.target as DisplayObject;
						
						if (t === _hyperButton) 
						{
							activateHypermode();
						} else {
							var bullet:AbstractBullet;
							if (_HUD.hypermode) 
							{
								bullet = _bulletGroup.recycle(point.x, point.y, Utility.HYPER_BULLET) as HyperBullet;
								_layer1.bullets.addChild(bullet);
								Assets.SoundEffects.playSound('hyperShot');
							} else if (!_HUD.hypermode && _HUD.ammo > 0) 
							{
								bullet = _bulletGroup.recycle(point.x, point.y, Utility.BULLET) as Bullet;
								_layer1.bullets.addChild(bullet);
								_HUD.bulletFired();
								Assets.SoundEffects.playSound('shot');
							}
						}	
					break;
					default:
				}
			}
		}
		
		/**
		 * Activate hypermode. Background changes, and the player can fire rapid, fast bullets.
		 */
		private function activateHypermode():void 
		{
			_HUD.hypermode = true;
			var whiteFlash:Flash = _flashGroup.recycle(0, 0, Utility.FLASH) as Flash;
			whiteFlash.riseRate = 0.3;
			whiteFlash.fallRate = 0.02;
			whiteFlash.color = 0xFFFFFF;
			whiteFlash.callback = function():void {
				if (_HUD.hypermode) 
				{
					_backgroundLayer.removeChild(_background as DisplayObject);
					_hyperBg = _hyperGroup.recycle(0, 0, Utility.HYPER_MODE) as Hypermode;
					_backgroundLayer.addChild(_hyperBg);
					_background = _hyperBg;
					Assets.SoundEffects.playSound('hyperMode');
				}
			};
			_flashLayer.addChild(whiteFlash);
		}
		
		/**
		 * Remove the hypermode background and update the game state.
		 */
		private function deactiveHypermode():void
		{
			_HUD.hypermode = false;
			_HUD.emptyMeter();
			Assets.SoundEffects.playSound('hyperFinished');
			switchLevel();
			levelTransition();
		}
		
		private function levelTransition():void
		{
			var whiteFlash:Flash = _flashGroup.recycle(0, 0, Utility.FLASH) as Flash;
			whiteFlash.riseRate = 0.6;
			whiteFlash.fallRate = 0.01;
			whiteFlash.color = 0xFFFFFF;
			whiteFlash.callback = switchLevel;
			_flashLayer.addChild(whiteFlash);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			if (_background) _background.update(e.passedTime);
			
			switch (_gameState) 
			{
				case READY:
					// The 'ready?' sub screen is shown.
					_HUD.update(e.passedTime);
					if (_ready.stage) 
					{
						_ready.update(e.passedTime);
						if (_ready.alpha <= 0) 
						{
							_gameScreen.removeChild(_ready);
							_gameState = IN_PLAY;
						}
					}
				break;
				case IN_PLAY:
					_HUD.update(e.passedTime);
					_passedTime = e.passedTime;
					_germGroup.array.forEach(moveGerms);
					_bulletGroup.array.forEach(moveBullets);
					_powerupGroup.array.forEach(movePowerups);
					_bulletGroup.array.forEach(checkCollision);
					spawnGerms();
				break;
				case GAME_OVER:
					_HUD.update(e.passedTime);
					_passedTime = e.passedTime;
					_germGroup.array.forEach(moveGerms);
					_germGroup.array.forEach(germVanish);
					_powerupGroup.array.forEach(movePowerups);
					if (_gameOver) 
					{
						_gameOver.update(e.passedTime);
					}
				break;
				case END_OF_LEVEL:
					_HUD.update(e.passedTime);
					_germGroup.array.forEach(moveGerms);
					_powerupGroup.array.forEach(movePowerups);
					_germGroup.array.forEach(germVanish);
					if (_stageClear && _stageClear.stage) 
					{
						_stageClear.update(e.passedTime);
						if (_stageClear.removeMe) 
						{
							removeChild(_stageClear);
							nextLevel();
						}
					}
				break;
				case QUESTION:
					if (_questionScreen && _questionScreen.stage) 
					{
						_questionScreen.update(e.passedTime);
						if (_questionScreen.removeMe) 
						{
							questionEffect(_questionScreen.correctAnswerGiven);
							removeChild(_questionScreen);
						}
					}
				break;
				default:
				
			}
			animateScreen();
			_flashGroup.array.forEach(animateFlash);
		}
		
		/**
		 * Reduce the player's health if they got the question wrong,
		 *  or clear the screen if they answered correctly.
		 */
		private function questionEffect(correct:Boolean):void 
		{
			_gameState = IN_PLAY;
			if (correct) 
			{
				_germGroup.array.forEach(clearScreen);
				clearScreenEffect();
			} else 
			{
				takenDamage();
			}
		}
		
		private function movePowerups(p:Powerup, i:int, a:Array):void 
		{
			if (!p.stage) return;
			p.update(_passedTime);
			if (p.scaleX <= 0 || p.x + p.width / 2 < 0) 
			{
				p.parent.removeChild(p);
			} else if (p.y - p.height / 2 < 0) 
			{
				p.y = p.height / 2;
				p.yDir = 1;
			}else if (p.y + p.height / 2 > stage.stageHeight)
			{
				p.y = stage.stageHeight - p.height / 2;
				p.yDir = -1;
			}
			
		}
		
		private function animateFlash(flash:AbstractObject, i:uint, a:Array):void 
		{
			if (!flash.stage) return;
			
			var f:Flash = flash as Flash;
			f.update(_passedTime);
			if (!f.brighten && f.alpha <= 0.2) 
			{
				_flashLayer.removeChild(f);
			}
		}
		
		
		/**
		 * Create new germs depending on their frequency.
		 */
		private function spawnGerms():void 
		{
			_germOneInterval += _passedTime;
			_germTwoInterval += _passedTime;
			_germThreeInterval += _passedTime;
			_germFourInterval += _passedTime;
			_powerupInterval += _passedTime;
			var rand:Number = Math.random();
			var sprite:AbstractObject;
			
			if (_germFourInterval > _currentLevel.germFourFreq) 
			{
				if (rand < _currentLevel.germFourProb) 
				{
					sprite = _germGroup.recycle(stage.stageWidth, 40 + Math.random() * (stage.stageHeight - 80), Utility.GERM_FOUR) as GermFour;
					_layer4.germs.addChild(sprite);
					sprite.x = stage.stageWidth + sprite.width / 2;
					sprite.speed = _currentLevel.germFourSpeed;
				}
				_germFourInterval = 0;
			}
			
			if (_germThreeInterval > _currentLevel.germThreeFreq) 
			{
				if (rand < _currentLevel.germThreeProb) 
				{
					sprite = _germGroup.recycle(stage.stageWidth, stage.stageHeight / 4 + Math.random() * stage.stageHeight / 2, Utility.GERM_THREE) as GermThree;
					_layer3.germs.addChild(sprite);
					sprite.x = stage.stageWidth + sprite.width / 2;
					sprite.speed = _currentLevel.germThreeSpeed;
				}
				_germThreeInterval = 0;
			}
			
			if (_germTwoInterval > _currentLevel.germTwoFreq) 
			{
				if (rand < _currentLevel.germTwoProb) 
				{
					sprite = _germGroup.recycle(stage.stageWidth, 70 +  Math.random() * (stage.stageHeight - 140), Utility.GERM_TWO) as GermTwo;
					_layer2.germs.addChild(sprite);
					sprite.x = stage.stageWidth + sprite.width / 2;
					sprite.speed = _currentLevel.germTwoSpeed;
				}
				_germTwoInterval = 0;
			}
			
			if (_germOneInterval > _currentLevel.germOneFreq) 
			{
				if (rand < _currentLevel.germOneProb) 
				{
					sprite = _germGroup.recycle(stage.stageWidth, 50 + Math.random() * (stage.stageHeight - 100), Utility.GERM_ONE) as GermOne;
					_layer1.germs.addChild(sprite);
					sprite.x = stage.stageWidth + sprite.width / 2;
					sprite.speed = _currentLevel.germOneSpeed;
				}
				_germOneInterval = 0;
			}
			
			if (_powerupInterval > _currentLevel.powerupFreq /*2*/) 
			{
				if (rand < _currentLevel.powerupProb /*1*/ && !_HUD.hypermode) 
				{
					sprite = _powerupGroup.recycle(stage.stageWidth, stage.stageHeight / 2, Utility.POWERUP) as Powerup;
					_layer4.powerups.addChild(sprite);
					sprite.x = stage.stageWidth + sprite.width / 2;
				}
				_powerupInterval = 0;
			}
			
		}
		
		/**
		 * Animate the germ's movement toward the left side of the screen.
		 * Also animate their deaths.
		 * @param	germ
		 * @param	index
		 * @param	array
		 */
		private function moveGerms(germ:AbstractGerm, index:uint, array:Array):void 
		{
			if (!germ.stage) return;
			germ.update(_passedTime);
			if (germ.x + germ.width / 2 < 0 && !germ.falling) 
			{
				germ.parent.removeChild(germ);
				takenDamage();
			}
			
			 if (germ.y - germ.height / 2 > stage.stageHeight || germ.scaleX <= 0) {
				 if (germ.parent) 
				 {
					germ.parent.removeChild(germ); 
				 } else 
				 {
					 trace("The parent can't be found");
				 }
			 }
		}
		
		/**
		 * The player has taken damage.
		 */
		private function takenDamage():void 
		{
			if (_gameState === IN_PLAY) 
			{
				var redFlash:Flash = _flashGroup.recycle(0, 0, Utility.FLASH) as Flash;
				redFlash.riseRate = 0.5;
				redFlash.fallRate = 0.08;
				redFlash.color = 0xEC0006;
				_flashLayer.addChild(redFlash);
				_HUD.endCombo();
				startShake(10);
				_HUD.loseHealth();
				Assets.SoundEffects.playSound("hit");
				switch (_HUD.health) 
				{
					case 4:
						Assets.SoundEffects.playSound("hitOne");
					break;
					case 3:
						Assets.SoundEffects.playSound("hitTwo");
					break;
					case 2:
						Assets.SoundEffects.playSound("hitThree");
					break;
					case 1:
						Assets.SoundEffects.playSound("hitFour");
					break;
					default:
				}
				if (_HUD.health < 1) 
				{
					initGameOver();
					Assets.SoundEffects.playSound("death");
				}
			}
		}
		
		/**
		 * The player has lost the game.
		 */
		private function initGameOver():void 
		{
			_gameState = GAME_OVER;
			_germGroup.array.forEach(germVanish);
			_powerupGroup.array.forEach(powerupVanish);
			_bulletGroup.array.forEach(bulletVanish);
			if(_HUD.hypermode) deactiveHypermode();
			_gameOver = new GameOver(_HUD.score);
			_gameScreen.addChild(_gameOver);
			Assets.Music.stopAllSounds();
		}
		
		private function bulletVanish(bullet:AbstractBullet, i:uint, a:Array):void
		{
			if (bullet.stage && bullet.parent) 
			{
				bullet.parent.removeChild(bullet);
			}
		}
		
		private function germVanish(germ:AbstractGerm, i:uint, a:Array):void 
		{
			if (!germ.spinning) 
			{
				germ.vanish();
			}
		}
		
		private function checkCollision(item:AbstractBullet, index:uint, array:Array):void 
		{	
			if (!item.stage) return;
			var layer:Layer;
			var bullet:AbstractBullet = item;
			switch (bullet.depth) 
			{
				case AbstractBullet.LAYER_ONE:
					layer = _layer1;
				break;
				case AbstractBullet.LAYER_TWO:
					layer = _layer2;
				break;
				case AbstractBullet.LAYER_THREE:
					layer = _layer3;
				break;
				case AbstractBullet.LAYER_FOUR:
					layer = _layer4;
				break;
				default:
			}
			var len:uint = layer.germs.numChildren;
			var germ:AbstractGerm;
			for (var i:int = 0; i < len; i++) 
			{
				germ = layer.germs.getChildAt(i) as AbstractGerm;
				
				if (germ && bullet.bounds.intersects(germ.bounds) && bullet.scaleX < 0.7 && !germ.spinning) 
				{
					germ.hit();
					germ.playSound();
					bullet.parent.removeChild(bullet);
					startShake(5);
					_HUD.addToScore(germ.score);
					_HUD.remaining -= 1;
					if (!_HUD.hypermode) 
					{
						_HUD.replenishShot();
						_HUD.buildMeter(germ.meter);
					}
					return;					// Exit the loop, as we've already hit an enemy.
				}
			}
			var plen:uint = layer.powerups.numChildren;
			var p:Powerup;
			for (var j:int = 0; j < plen; j++) 
			{
				p = layer.powerups.getChildAt(j) as Powerup;
				if (p && bullet.bounds.intersects(p.bounds) && bullet.scaleX < 0.7 && !p.spinning) 
				{
					bullet.parent.removeChild(bullet);
					switch (p.value) 
					{
						case Powerup.CLEAR_SCREEN:
							_germGroup.array.forEach(clearScreen);
							clearScreenEffect();
						break;
						case Powerup.QUESTION:
							Assets.SoundEffects.playSound("powerup");
							questionTime();
						break;
						case Powerup.DAMAGE:
							takenDamage();
						break;
						case Powerup.METER:
							Assets.SoundEffects.playSound("powerup");
							var flash:Flash;
							flash = _flashGroup.recycle(0, 0, Utility.FLASH) as Flash;
							flash.color = 0x12DE50;
							flash.riseRate = 0.6;
							flash.fallRate = 0.04;
							_flashLayer.addChild(flash);
							_HUD.buildMeter(1);
							startShake(15);
						break;
					default:
						trace("Something's wrong");
					}
					_HUD.replenishShot();
					p.vanish();
					return;
				}
			}
		}
		
		/**
		 * Make the screen shake and flash white.
		 */
		private function clearScreenEffect():void 
		{
			var flash:Flash;
			flash = _flashGroup.recycle(0, 0, Utility.FLASH) as Flash;
			flash.color = 0xFFFFFF;
			flash.riseRate = 0.6;
			flash.fallRate = 0.02;
			_flashLayer.addChild(flash);
			startShake(15);
			Assets.SoundEffects.playSound('clearScreen');
		}
		
		/**
		 * The question powerup was hit, so show the question.
		 */
		private function questionTime():void 
		{
			_gameState = QUESTION;
			
			_questionScreen = new QuestionScreen(Assets.GetQuestion());
			addChild(_questionScreen);
		}
		
		private function moveBullets(item:AbstractBullet, index:uint, array:Array):void 
		{
			var b:AbstractBullet = item;
			var s:Number = b.scaleX;
			if (!b.stage) return;
			if (s > 0) 
			{
				item.update(_passedTime);
				if (s <= 0.55 && s > 0.35 && b.depth !== AbstractBullet.LAYER_TWO) 
				{
					b.depth = AbstractBullet.LAYER_TWO;
					_layer2.bullets.addChild(b);
				} else if (s <= 0.35 && s > 0.15 && b.depth !== AbstractBullet.LAYER_THREE) 
				{
					b.depth = AbstractBullet.LAYER_THREE;
					_layer3.bullets.addChild(b);
				} else if (s <= 0.15 && b.depth !== AbstractBullet.LAYER_FOUR) 
				{
					b.depth = AbstractBullet.LAYER_FOUR;
					_layer4.bullets.addChild(b);
				}
			} else 
			{
				b.parent.removeChild(b);
				_HUD.bulletMissed();
			}
		}
		
		/**
		 * Shake the screen.
		 * @param shake		The amount to shake by/ duration.
		 */
		private function startShake(shake:uint):void
		{
			_shake = shake;
			_isShaking = true;
		}
		
		/**
		 * Move the screen up and down.
		 */
		private function shakeScreen():void
		{
			_gameScreen.y = Math.cos(deg2rad(_angle)) * _shake;
			_angle += 45;
			if (_shake > 0 ) 
			{
				_shake -= 0.2;
			} else 
			{
				_gameScreen.y = 0;
				_isShaking = false;
			}
		}
		
		/**
		 * Deal with flashes and screen shakes.
		 */
		private function animateScreen():void
		{
			if (_isShaking) 
			{
				shakeScreen();
			}
		}
		
		/**
		 * Change the level background.
		 */
		private function switchLevel():void
		{
			var bg:IUpdateable;
			switch (_currentLevel.levelBackground) 
			{
				case Utility.BACKGROUND_ONE:
					bg = new BackgroundOne();
				break;
				case Utility.BACKGROUND_TWO:
					bg = new BackgroundTwo();
				break;
				case Utility.BACKGROUND_THREE:
					bg = new BackgroundThree();
				break;
				case Utility.BACKGROUND_FOUR:
					bg = new BackgroundFour();
				break;
				default:
			}
			_backgroundLayer.removeChild(_background as DisplayObject);
			_background = bg;
			_backgroundLayer.addChild(_background as DisplayObject);
		}
		
		/**
		 * Go to the next level, and update the HUD.
		 */
		private function nextLevel():void
		{
			if (Assets.LevelIndex < Assets.LevelArray.length - 1) 
			{
				Assets.LevelIndex ++;
				if (Assets.LevelIndex > Assets.MaxLevel) 
					Assets.MaxLevel = Assets.LevelIndex;
				_currentLevel = Assets.LevelArray[Assets.LevelIndex];
				_HUD.updateLevel();
				_powerupInterval = _germOneInterval = _germTwoInterval = _germThreeInterval = _germFourInterval = 0;
				_HUD.recoverHealth();
				if (_currentLevel.changeBackground) 
				{
					levelTransition();
					Assets.SoundEffects.playSound("levelChange");
					changeMusic();
				}
				_gameState = IN_PLAY;
			}else {
				initGameOver();
			}
		}
		
		/**
		 * Change background music.
		 */
		private function changeMusic():void 
		{
			switch (_currentLevel.levelBackground) 
			{
				case Utility.BACKGROUND_ONE:
					Assets.Music.switchSound("bg1");
				break;
				case Utility.BACKGROUND_TWO:
					Assets.Music.switchSound("bg2");
				break;
				case Utility.BACKGROUND_THREE:
					Assets.Music.switchSound("bg3");
				break;
				case Utility.BACKGROUND_FOUR:
					Assets.Music.switchSound("bg4");
				break;
				default:
			}
		}
		
		/**
		 * Called when all the germs have been hit.
		 */
		private function endOfLevel():void
		{
			_HUD.endCombo();
			_bulletGroup.array.forEach(bulletVanish);
			_germGroup.array.forEach(germVanish);
			_powerupGroup.array.forEach(powerupVanish);
			if(_HUD.hypermode) deactiveHypermode();
			_gameState = END_OF_LEVEL;
			_stageClear = new StageClear(_HUD.maxCombo);
			addChild(_stageClear);
		}
		
		private function powerupVanish(p:Powerup, i:uint, a:Array):void 
		{
			p.spinning = true;
		}
		
		/**
		 * Getting the "clear-screen" powerup causes this function to hit all germs at once.
		 */
		private function clearScreen(g:AbstractGerm, i:uint, a:Array):void
		{
			if (!g.stage) return;
			g.hit();
			_HUD.addToScore(g.score);
			_HUD.remaining -= 1;
		}

	}

}