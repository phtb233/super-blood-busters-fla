package screens 
{
	import events.NavigationEvent;
	import flash.display.Loader;
	//import flash.filesystem.File;
	import flash.media.Sound;
	import objects.data.*;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;
	import starling.utils.deg2rad;
	/**
	 * Load all assets and store them in Assets registry.
	 * @author Stephen Oppong Beduh
	 */
	public class Loading extends AbstractScreen 
	{
		private var _bg:Quad;
		private var _text:TextField;
		private var _progressBar:Quad;
		private var _progressBg:Quad;
		private var _letters:Vector.<Image>;
		private const _LETTERNAMES:String = "LOADING";
		private var _letter_len:uint; 
		private var _angle:int;
		
		public function Loading() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_progressBar = new Quad(285, 2, 0x00FF00);
			_progressBg = new Quad(_progressBar.width, _progressBar.height, 0x000000);
			_progressBar.scaleX = 0;
			Assets.Manager = new AssetManager(Assets.Scale);
			_letters = new Vector.<Image>();
			_letter_len = _LETTERNAMES.length;
			_angle = 0;
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			Assets.Scale === 2 ?
				Assets.Manager.enqueue(EmbeddedAssets2x) :
				Assets.Manager.enqueue(EmbeddedAssets1x);
			Assets.Manager.verbose = false;
			Assets.Manager.loadQueue(function(ratio:Number):void
			{
				if (ratio === 1) 
				{
					init();
				}
			});
		}
		
		private function init():void
		{
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x363636);
			//addChild(_bg);
			//_text = new TextField(stage.stageWidth, 70, "LOADING", "pressStart80", 40, 0xFDFDFD);
			//_text.hAlign = HAlign.CENTER;
			//_text.y = 100;
			//addChild(_text);
			
			var loadedData:Object = GameData.Load();
			Assets.HighScores = loadedData.highScores;
			Assets.MaxLevel = loadedData.maxLevel;
			//trace(Assets.HighScores);
			//trace(Assets.MaxLevel);
			
			_progressBar.x = _progressBg.x = stage.stageWidth / 2 - _progressBg.width / 2;
			_progressBar.y = _progressBg.y = stage.stageHeight / 2 - _progressBg.height / 2;
			
			var l:Image;
			for (var i:int = 0; i < _letter_len; i++) 
			{
				l = new Image(Assets.Manager.getTexture(_LETTERNAMES.charAt(i)));
				l.x = Math.ceil(_progressBar.x + i * 40);
				l.y = 100;
				_letters.push(l);
				addChild(l);
			}
			addChild(_progressBg);
			addChild(_progressBar);
			Assets.Manager.verbose = true;
			loadAssets();
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			var l:Image;
			for (var i:int = 0; i < _letter_len; i++) 
			{
				l = _letters[i];
				
				l.y = 100 + (Math.cos(deg2rad(_angle + l.x)) * 7);
			}
			_angle += e.passedTime * 100;
		}
		
		private function loadAssets():void 
		{
			//var appDir:File = File.applicationDirectory;
			//Assets.Manager.enqueue(appDir.resolvePath("atlas/@" + Assets.Scale + "x"));
			
			//Assets.Manager.enqueue(appDir.resolvePath("font/@" + Assets.Scale + "x"));
			//Assets.Manager.enqueue(appDir.resolvePath("fnt/@" + Assets.Scale + "x"));
			//Assets.Manager.enqueue(appDir.resolvePath("xml"));
			//Assets.Manager.enqueue(appDir.resolvePath("sound/sfx"));
			for (var i:int = 1; i < 6; i++) 
			{
				Assets.Manager.enqueue("atlas/@" + Assets.Scale + "x/textureAtlas_" + i + ".png"); 
				Assets.Manager.enqueue("atlas/@" + Assets.Scale + "x/textureAtlas_" + i + ".xml"); 
			}
			
			if (Assets.Scale > 1) 
			{
				for (var k:int = 1; k < 3; k++) 
				{
					Assets.Manager.enqueue("font/@" + Assets.Scale + "x/pressStart80/pressStart80.fnt"); 
					Assets.Manager.enqueue("font/@" + Assets.Scale + "x/pressStart80/pressStart80.png"); 
				}
			}
			
			
			for (var j:int = 1; j < 3; j++) 
			{
				Assets.Manager.enqueue("fnt/@" + Assets.Scale + "x/Minecraftia54.fnt"); 
				Assets.Manager.enqueue("fnt/@" + Assets.Scale + "x/pressStart80.fnt"); 
			}
			
			Assets.Manager.enqueue("sound/sfx/blip.mp3");
			Assets.Manager.enqueue("sound/sfx/clearScreen.mp3");
			Assets.Manager.enqueue("sound/sfx/crash.mp3");
			Assets.Manager.enqueue("sound/sfx/death.mp3");
			Assets.Manager.enqueue("sound/sfx/fireworks.mp3");
			Assets.Manager.enqueue("sound/sfx/germFourHit.mp3");
			Assets.Manager.enqueue("sound/sfx/germOneHit.mp3");
			Assets.Manager.enqueue("sound/sfx/germThreeHit.mp3");
			Assets.Manager.enqueue("sound/sfx/germTwoHit.mp3");
			Assets.Manager.enqueue("sound/sfx/hide.mp3");
			Assets.Manager.enqueue("sound/sfx/hit.mp3");
			Assets.Manager.enqueue("sound/sfx/hitFour.mp3");
			Assets.Manager.enqueue("sound/sfx/hitOne.mp3");
			Assets.Manager.enqueue("sound/sfx/hitThree.mp3");
			Assets.Manager.enqueue("sound/sfx/hitTwo.mp3");
			Assets.Manager.enqueue("sound/sfx/hyperFinished.mp3");
			Assets.Manager.enqueue("sound/sfx/hyperMode.mp3");
			Assets.Manager.enqueue("sound/sfx/hyperShot.mp3");
			Assets.Manager.enqueue("sound/sfx/levelChange.mp3");
			Assets.Manager.enqueue("sound/sfx/newHit.mp3");
			Assets.Manager.enqueue("sound/sfx/points.mp3");
			Assets.Manager.enqueue("sound/sfx/powerup.mp3");
			Assets.Manager.enqueue("sound/sfx/right.mp3");
			Assets.Manager.enqueue("sound/sfx/shot.mp3");
			Assets.Manager.enqueue("sound/sfx/show.mp3");
			Assets.Manager.enqueue("sound/sfx/wrong.mp3");
			
			Assets.Manager.enqueue("xml/gameData.xml");
			Assets.Manager.loadQueue(function(ratio:Number):void
			{
				_progressBar.scaleX = ratio;
				if (ratio === 1) 
				{
					trace("Loading complete");
					loadLevels();
					loadSounds();
					dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id: "title" }, true));
					//var xml:XML = Assets.Manager.getXml("gameData");
					//trace(xml);
				}
			});
		}
		
		private function loadSounds():void 
		{
			var sn:Vector.<String> = Assets.Manager.getSoundNames();
			var len:int = sn.length;
			
			for (var i:int = 0; i < len; i++) 
			{
				Assets.SoundEffects.addSound(sn[i], Assets.Manager.getSound(sn[i]));
			}
			Assets.Music.addSound("blip", Assets.Manager.getSound("blip"));
			
			Assets.Music.addSound("intro", EmbeddedAssetsCore.getMusic("IntroSnd"));
			Assets.Music.addSound("gameover", EmbeddedAssetsCore.getMusic("GameOverSnd"));
			Assets.Music.addSound("highscores", EmbeddedAssetsCore.getMusic("HighScoresSnd"));
			Assets.Music.addSound("bg1", EmbeddedAssetsCore.getMusic("BG1Snd"));
			Assets.Music.addSound("bg2", EmbeddedAssetsCore.getMusic("BG2Snd"));
			Assets.Music.addSound("bg3", EmbeddedAssetsCore.getMusic("BG3Snd"));
			Assets.Music.addSound("bg4", EmbeddedAssetsCore.getMusic("BG4Snd"));
			Assets.Music.addSound("nameentry", EmbeddedAssetsCore.getMusic("NameEntrySnd"));
		}
		
		private function loadLevels():void 
		{
			var xml:XML = Assets.Manager.getXml("gameData");
			var levelLen:uint = xml.levels.level.length();
			var questionLen:int = xml.questions.question.length();
			
			//For every node in "levels"
			for (var i:int = 0; i < levelLen; i++) 
			{
				var l:XML = xml.levels.level[i];
				var level:Level = new Level(
				l.@toKill, 
				l.germOne.@prob, l.germOne.@speed, l.germOne.@freq,
				l.germTwo.@prob, l.germTwo.@speed, l.germTwo.@freq,
				l.germThree.@prob, l.germThree.@speed, l.germThree.@freq,
				l.germFour.@prob, l.germFour.@speed, l.germFour.@freq,
				l.rbc.@prob, 3, l.rbc.@freq,
				l.powerup.@prob, 2, l.powerup.@freq,
				l.@changeBG == "true", Utility[l.@bg], l.@bgm
				);
				//Add it to the array of levels.
				Assets.LevelArray.push(level);
			}
			
			//For each node in "questions".
			for (var j:int = 0; j < questionLen ; j++) 
			{
				var q:XML = xml.questions.question[j];
				
				var question:Question = new Question(
				q.text, q.answers.@one, 
				q.answers.@two, 
				q.answers.@three, 
				q.answers.@four,
				q.@correctAnswer,
				(q.@time) * 1000
				);
				Assets.QuestionsArray.push(question);
			}
		}
		
	}

}