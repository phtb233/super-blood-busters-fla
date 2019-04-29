package screens 
{
	import adobe.utils.CustomActions;
	import com.greensock.*;
	import com.greensock.easing.Strong;
	import com.greensock.easing.Linear;
	import objects.fireworks.Fireworks;
	import objects.fireworks.Spark;
	import starling.display.QuadBatch;
	import events.*;
	import objects.*;
	import starling.core.*;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.MovieClip;
	import starling.display.Image;
	import starling.events.*;
	import starling.text.*;
	import starling.utils.*;
	
	/**
	 * The high scores screen.
	 * @author Stephen Oppong Beduh
	 */
	public class HighScores extends AbstractScreen 
	{
		private var _bg:				Quad;
		private var _starfield:			Starfield;
		private var _bgLayer:			Sprite;
		private var _textLayer:     	Sprite;
		private var _textVector:    	Vector.<TextField>;
		private var _textXPos:      	Array;
		private var _index:				uint;
		private var _counter: 			uint;
		private var _scores: 			Array;
		private var _germ1:         	MovieClip;
		private var _germ2:         	MovieClip;
		private var _germ3:         	MovieClip;
		private var _germ4:         	MovieClip;
		private var _germArray:     	Array;
		private var _trophy: 			Image;
		private var _timing: 			Boolean;
		private var _fireworkTimer:		Number;
		private var _firstScreen:		Sprite;
		private var _secondScreen:		Sprite;
		
		private var _firstPlaceDetails: Vector.<TextField>;
		private var _scoreLetters:		Vector.<TextField>;
		private var _letterPos: 		Vector.<Array>;
		
		private var _state:				uint;
		private var _angle:				Number;
		
		private const _playerName:		String = "FOO";
		private var _scoresVector:		Vector.<Number>;
		private var _scoreboard: 		Sprite;
		
		private var _fireworks:			Group;
		private var _fwdir:				int;
		
		private var _tweenedObjects:     Array;
		
		private static const _HIGHSCORES_Y: uint = 50;
		private static const _HIGHSCORES_PADDING:uint = 80;
		private static const _NUM_OF_COLUMNS: uint = 3;
		private static const _NUM_OF_ROWS: uint = 3;
		
		public function HighScores() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_scoresVector = new Vector.<Number>();
			_fireworks = new Group();
			_fireworkTimer = 0;
			_fwdir = 1;
			_tweenedObjects = [];
		}
		
		override public function load():void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.LOADED, true));
			Assets.Music.switchSound("highscores");
		}
		
		override public function onTweenComplete():void 
		{
			showScores();
			makeGerms();
			addEventListener(TouchEvent.TOUCH, onTouch);
			//showScoresIntensive();
		}
		
		override public function unload():void 
		{
			super.unload();
			var len:uint = _tweenedObjects.length;
			for (var i:int = 0; i < len; i++) 
			{
				TweenLite.killTweensOf(_tweenedObjects[i]);
			}
			var glen:uint  = _germArray.length;
			var germ:MovieClip;
			for (var j:int = 0; j < glen; j++) 
			{
				germ = _germArray[j] as MovieClip;
				germ.pause();
			}
			//Assets.Music.tweenVolume("highscores", 0, 1);
		}
		
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_state = 0;
			_angle = 0;
			//0x5A2E2E
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x5A2E2E);
			_starfield = new Starfield();
			_bgLayer = new Sprite();
			_textLayer = new Sprite();
			_firstScreen = new Sprite();
			_secondScreen = new Sprite();
			addChild(_bgLayer);
			addChild(_firstScreen);
			
			_bgLayer.addChild(_bg);
			_bgLayer.addChild(_starfield);
			
			_firstScreen.addChild(_textLayer);
			_secondScreen.x = stage.stageWidth;
			
			_firstPlaceDetails = new Vector.<TextField>();
			var rank:TextField = new TextField(70, 30, "1ST", "pressStart80", 20);
			rank.x = 20 + rank.width / 2;
			rank.y = stage.stageHeight - 90;
			
			var name:TextField = new TextField(70, 20, Assets.HighScores[0][0], "pressStart80", 20);
			name.x = stage.stageWidth - 15 -  name.width;
			name.y = rank.y;
			name.hAlign = HAlign.RIGHT;
			
			var score:TextField = new TextField(stage.stageWidth, 30, Assets.HighScores[0][1].toString(), "pressStart80", 25);
			score.y = stage.stageHeight - score.height - 5;
			score.x = stage.stageWidth / 2;
			score.hAlign = HAlign.CENTER;
			rank.color = name.color = score.color = 0xFFFFFF;
			_firstPlaceDetails.push(rank, name, score);
			var len:uint = _firstPlaceDetails.length;
			for (var i:int = 0; i < len ; i++) 
			{
				var text:TextField = _firstPlaceDetails[i] as TextField;
				text.pivotX = text.width / 2;
				text.pivotY = text.height / 2;
			}
			rank.scaleX = rank.scaleY = score.scaleX = score.scaleY = name.scaleX = name.scaleY = 0;
			
			
			_trophy = new Image(Assets.Manager.getTexture("trophy"));
			_trophy.scaleX = _trophy.scaleY = 0.6;
			_trophy.pivotX = _trophy.width / 2 + 70;
			_trophy.pivotY = _trophy.height / 2 + 100;
			_trophy.x = Math.ceil(stage.stageWidth / 2);
			_trophy.y = Math.ceil(stage.stageHeight / 2) + 15;
			
			_index = 0;
			_counter = 0;
			
			createTitle();
			initScores();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (!touch) return;
			if (touch.phase === TouchPhase.BEGAN) 
			{
				dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "title" }, true))
			}
		}
		
		private function initScores():void
		{
			_scoreboard = new Sprite();
			_scoreLetters = new Vector.<TextField>();
			_letterPos = new Vector.<Array>();
			_scoreboard.x = 80;
			_scoreboard.y = _HIGHSCORES_Y + _HIGHSCORES_PADDING;
			_scoreboard.touchable = false;
			addChild(_scoreboard);
			for (var i:int = 0; i < 3; i++) 
			{
				_scoresVector[i] = Math.round(Math.random() * 10000 + 5000);
			}
		}
		
		/**
		 * Make sprites appear at the bottom and tween them across the screen.
		 */
		private function makeGerms():void 
		{
			_germArray = new Array();
			_germ1 = new MovieClip(Assets.Manager.getTextures("germOne_"), 20);
			_germ1.scaleX = _germ1.scaleY = 0.6;
			_germ2 = new MovieClip(Assets.Manager.getTextures("germTwo_"), 20);
			 _germ2.scaleX = _germ2.scaleY = 0.7;
			_germ3 = new MovieClip(Assets.Manager.getTextures("germThree_"), 24);
			_germ4 = new MovieClip(Assets.Manager.getTextures("germFour_"), 60);
			_germ3.scaleX = _germ3.scaleY = 0.5;
			_germArray.push(_germ1, _germ2, _germ3, _germ4);
			var len:uint = _germArray.length;
			var callback:Function = null;
			for (var i:int = 0; i < len; i++) 
			{
				var germ:MovieClip = _germArray[i] as MovieClip;
				if (i === 3) 
				{
					germ.y = stage.stageHeight - 40;
				}else 
				{
					germ.y = stage.stageHeight - 60;
				}
				germ.x = stage.stageWidth + 100;
				germ.scaleY = germ.scaleX *= 0.8;
				germ.pivotX = germ.width / 2;
				germ.pivotY = germ.height / 2;
				if (i === len - 1) 
				{
					callback = switchScreen;
				}
				TweenLite.to(germ, 2.4, { x: -100, delay: i * 0.7, ease:Linear.easeNone, onComplete: callback } );
				_tweenedObjects.push(germ);
				Starling.juggler.add(germ);
				_firstScreen.addChild(germ);
			}
		}
		
		/**
		 * Move the screens to the left so we can see who's in first place.
		 */
		private function switchScreen():void 
		{
			
			addChild(_secondScreen);
			
			TweenLite.to(_firstScreen, 1, { x: -stage.stageWidth, ease:Strong.easeOut } );
			_tweenedObjects.push(_firstScreen);
			TweenLite.to(_secondScreen, 1, { x: 0, ease:Strong.easeOut, onComplete: function():void {
				removeChild(_firstScreen);
				showSecondScreen();
				_state = 1;
			}} );
			_tweenedObjects.push(_secondScreen);
		}
		
		/**
		 * Show the 1st place score and trophy for the second screen.
		 */
		private function showSecondScreen():void 
		{
			var len:uint = _firstPlaceDetails.length;
			for (var i:int = 0; i < len; i++) 
			{
				var text:TextField = _firstPlaceDetails[i] as TextField;
				var callback:Function = null;
				_secondScreen.addChild(text);
				if (i === len - 1) 
				{
					callback = showTrophy;
				}
				TweenLite.to(text, 0.4, { scaleX: 1, scaleY: 1, ease:Strong.easeOut, delay: i * 0.5, onComplete:callback } );
				_tweenedObjects.push(text);
			}
		}
		
		private function showTrophy():void 
		{
			addChild(_trophy);
			TweenLite.from(_trophy, 1.5, { scaleX:0, scaleY:0, ease:Strong.easeOut } );
			_tweenedObjects.push(_trophy);
			_timing = true;
		}
		
		/**
		 * Show the scores (1st, 2nd, 3rd)
		 */
		private function showScores():void 
		{
			_scores = new Array();
			var fontSize:uint = 13;
			var font:String = "pressStart80";
			for (var i:int = 0; i < _NUM_OF_ROWS; i++) 
			{
				var append:String = "";
				switch (i) 
				{
					case 0:
						append = "ND";
					break;
					case 1:
						append = "RD";
					break;
					case 2:
						append = "TH";
					break;
					default:
				}
				var row:Sprite = new Sprite();
				
				for (var j:int = 0; j < _NUM_OF_COLUMNS; j++) 
				{
					var text:TextField;
					switch (j) 
					{
						case 0:
							// Position (2nd, 3rd or 4th)
							text = new TextField(140, 30, (i + 2) + append, font, fontSize);
							text.hAlign = HAlign.RIGHT;
						break;
						case 1:
							// Player name.
							text = new TextField(90, 30, Assets.HighScores[i + 1][0], font, fontSize);
							text.hAlign = HAlign.LEFT;
							text.x = row.getChildAt(0).width + 80;
						break;
						case 2:
							// The score.
							text = new TextField(200, 30, Assets.HighScores[i + 1][1].toString(), font, fontSize);
							text.x = row.getChildAt(1).x + row.getChildAt(1).width + 20;
							text.hAlign = HAlign.LEFT;
						break;
						default:
					}
					text.color = 0xFFFFFF;
					row.addChild(text);
				}
				row.pivotX = row.width / 2;
				row.pivotY = row.height / 2;
				row.y = _HIGHSCORES_Y + _HIGHSCORES_PADDING + (i * 50);
				row.x = stage.stageWidth / 2;
				_firstScreen.addChild(row);
				TweenLite.from(row, 0.5, { y : stage.stageHeight / 2, alpha: 0, scaleX:0, scaleY:0, delay: i * 0.2 } );
				_tweenedObjects.push(row);
				_scores.push(row);
			}
		}
		
		/*
		private function showScoresIntensive():void
		{
			for (var i:int = 0; i < _NUM_OF_ROWS; i++) 
			{
				var row:Sprite = new Sprite();
				var append:String = "";
				switch (i) 
				{
					case 0:
						append = "ND";
					break;
					case 1:
						append = "RD";
					break;
					case 2:
						append = "TH";
					break;
					default:
				}
				
				for (var j:int = 0; j < _NUM_OF_COLUMNS; j++) 
				{
					var col:Sprite = new Sprite();
					var string:String = "";
					var len:uint;
					var text:TextField;
					switch (j) 
					{
						case 0:
							string = (i + 2) + append;
							
						break;
						case 1:
							string = _playerName;
						break;
						case 2:
							string = _scoresVector[i].toString();
						break;
						default:
					}
					len = string.length;
					for (var k:int = 0; k < len; k++) 
					{
						text = new TextField(15, 15 , string.charAt(k), "pressStart80", 14);
						text.x = k * 15;
						text.pivotX = text.width / 2;
						text.pivotY = text.height / 2;
						text.color = 0xFFFFFF;
						col.addChild(text);
						_scoreLetters.push(text);
						_letterPos.push([text.x, text.y]);
					}
					col.x = j * 110;
					row.addChild(col);
				}
				row.y = 55 * i;
				_scoreboard.addChild(row);
			}
		}
		*/
		
		/**
		 * Create the colourful highscores title.
		 */
		private function createTitle():void 
		{
			_textXPos = new Array();
			var text:String = "HIGHSCORES";
			var len:uint = text.length;
			_textVector = new Vector.<TextField>();
			for (var i:int = 0; i < len; i++) 
			{
				var space:uint = i >= 4 ? 30 : 0;
				var letter:TextField = new TextField(40, 40, text.charAt(i), "pressStart80", 40, 0xFFFFFF);
				_textVector.push(letter);
				letter.pivotX = letter.width / 2;
				letter.pivotY = letter.height / 2;
				letter.x = i * 42 + 40 + space;
				_textXPos.push(letter.x);
				letter.y = _HIGHSCORES_Y;
				_firstScreen.addChild(letter);
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			_starfield.update(e.passedTime);
			if (_state === 0) 
			{
				_textVector.forEach(animateText);
				if (_counter++ > 3) 
				{
					_counter = 0;
					_index++;
				}
				//_scoreLetters.forEach(animateLetters);
				
			} else if (_state === 1) 
			{
				_trophy.rotation += Math.cos(deg2rad(_angle)) * 0.02;
				_angle += 2;
				var len:uint = _fireworks.length;
				for (var i:int = 0; i < len; i++) 
				{
					var fw:Fireworks = _fireworks.array[i] as Fireworks;
					if (!fw) continue;
					fw.update(e.passedTime);
					if (fw.age > 1.7) 
					{
						//fw.reset(0, 0);
						removeChild(fw);
					}
				}
				if (_timing) 
				{
					_fireworkTimer += e.passedTime;
					if (_fireworkTimer > 0.7) 
					{
						_fireworkTimer = 0;
						
						addChild(_fireworks.recycle(stage.stageWidth / 2 + (_fwdir * 50) + (_fwdir * Math.random() * stage.stageWidth / 4), Math.random() * 100 + (stage.stageHeight / 2 - 50), Utility.FIREWORKS) as Fireworks);
						_fwdir *= -1;
					}
				}
			}
		}
		
		private function animateLetters(t:TextField, i:uint, v:Vector.<TextField>):void 
		{
			t.x = _letterPos[i][0] + ( -2 + (Math.random() * 4));
			t.y = _letterPos[i][1] + ( -2 + (Math.random() * 4));
		}
		
		private function animateText(t:TextField, i:uint, v:Vector.<TextField>):void 
		{
			t.color = Utility.RAINBOW_VECTOR[int((_index + i) % 7)];
			
			t.x = _textXPos[i] + ( -3 + (Math.random() * 6));
			t.y = _HIGHSCORES_Y + ( -3 + (Math.random() * 6));
		}
	}

}