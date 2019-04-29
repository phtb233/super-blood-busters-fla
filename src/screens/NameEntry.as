package screens 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import events.NavigationEvent;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.text.StageTextField;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	//import flash.text.StageText;
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.utils.*;
	/**
	 * Player enters their name if it's higher than the lowest high score.
	 * @author Stephen Oppong Beduh
	 */
	public class NameEntry extends AbstractScreen 
	{
		private var _bg:Quad;
		private var _playerScore:uint;
		private var _textVector:Vector.<TextField>;
		private var _nameLetters:Vector.<TextField>;
		private var _underscores:Vector.<Quad>;
		private var _nameInput:StageTextTextEditor;
		private var _textCounter:int;
		private var _angle:Number;
		private var _allowedChars:String;
		private var _input:StageTextField;
		private var _flickerCounter:int;
		private var _colourIndex:int;
		
		private static const _NAME_LENGTH:int = 3;
		private static const _HORZ_PADDING:int = 40;
		private static const _VERT_PADDING:int = 20;
		private static const _LETTERS_Y:int = 130;
		private static const _UNDERSCORE_Y:int = 180;
		private static const _OPTIONS_Y:int = 220;
		private static const _NEW_RECORD_Y:int = 250;
		
		public function NameEntry(playerScore:uint) 
		{
			super();
			_playerScore = playerScore;
			_textVector = new Vector.<TextField>();
			_nameLetters = new Vector.<TextField>();
			_underscores = new Vector.<Quad>();
			_textCounter = _angle = 0;
			_allowedChars = "abcdefghijklmnopqrstuvwxyz" +
							"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
			_flickerCounter = 0;
			_colourIndex = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		override public function load():void 
		{
			super.load();
			Assets.Music.switchSound("nameentry");
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x5A2E2E);
			addChild(_bg);
			
			var message:TextField = new TextField(stage.stageWidth, 130, "A NEW RECORD!", "pressStart80", 20, 0xFFFFFF);
			message.hAlign = HAlign.LEFT;
			message.vAlign = VAlign.TOP;
			message.x = _HORZ_PADDING;
			message.y = _VERT_PADDING;
			addChild(message);
			
			var ok:TextField = new TextField(50, 80, "OK", "pressStart80", 20, Color.WHITE);
			ok.x = _HORZ_PADDING;
			ok.y = _OPTIONS_Y;
			
			var clear:TextField = new TextField(110, 80, "CLEAR", "pressStart80", 20, Color.WHITE);
			clear.x = stage.stageWidth - _HORZ_PADDING;
			clear.y = _OPTIONS_Y;
			clear.pivotX = clear.width;
			
			var pos:TextField = new TextField(70, 80, "POS", "pressStart80", 20, Color.WHITE);
			pos.x = _HORZ_PADDING;
			pos.y = _NEW_RECORD_Y;
			//addChild(pos);
			
			var score:TextField = new TextField(200, 80, _playerScore.toString(), "pressStart80", 20, Color.WHITE);
			score.x = stage.stageWidth - _HORZ_PADDING;
			score.y = _NEW_RECORD_Y;
			score.pivotX = score.width;
			//addChild(score);
			
			_textVector.push(message, clear, ok, pos, score);
			
			var t:TextField;
			var q:Quad;
			for (var i:int = 0; i < _NAME_LENGTH; i++) 
			{
				t = new TextField(80, 80, "", "pressStart80", 80, Color.WHITE);
				t.pivotX = t.width / 2;
				t.pivotY = t.height / 2;
				t.scaleX = t.scaleY = 0;
				_nameLetters.push(t);
				t.y = _LETTERS_Y;
				t.x = 110 + (i * 135);
				q = new Quad(100, 10, Color.WHITE);
				q.pivotX = q.width / 2 + 5;
				q.pivotY = q.height / 2;
				q.x = t.x;
				q.y = _UNDERSCORE_Y;;
				_underscores.push(q);
				addChild(q);
				addChild(t);
			}
			_input = new StageTextField();
			_input.viewPort = new Rectangle(100, 100, 0, 0);
			_input.color = Color.WHITE;
			_input.fontSize = 40;
			_input.fontFamily = "pressStart80";
			_input.stage = Starling.current.nativeStage;
			_input.restrict = _allowedChars;
			_input.maxChars = 3;
			_input.autoCapitalize = "all";
			_input.stage.addEventListener(TextEvent.TEXT_INPUT, onInput);
			_input.assignFocus();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var t:Touch = e.getTouch(stage);
			if (!t) return;
			if (t.phase === TouchPhase.BEGAN) 
			{
				_input.assignFocus();
				if (t.isTouching(_textVector[1])) 
				{
					_textCounter = 0;
					// Clear was clicked.
					var text:TextField;
					for (var i:int = 0; i < _NAME_LENGTH; i++) 
					{
						text = _nameLetters[i];
						TweenLite.to(text, 0.6, { scaleX: 0, scaleY: 0, ease:Strong.easeOut, overwrite:true, onComplete:function ():void 
						{
							text.text = "";
						} } );
					}
					removeChild(_textVector[1]);
					removeChild(_textVector[2]);
				}
				
				if (t.isTouching(_textVector[2])) 
				{
					this.removeEventListener(TouchEvent.TOUCH, onTouch);
					updateHighScores();
				}
			}
		}
		
		/**
		 * Save new highscore using the player's input.
		 */
		private function updateHighScores():void 
		{
			var highScores:Array = Assets.HighScores;
			var playerName:String = _nameLetters[0].text
								+	_nameLetters[1].text
								+   _nameLetters[2].text;
								
			for (var i:int = 0; i < 4; i++) 
			{
				var score:int = highScores[i][1];
				if (_playerScore > score) 
				{
					highScores.splice(i, 0, [playerName, _playerScore]);
					break;
				}
			}
			highScores.pop();
			
			//var :Array = highScores;
			var maxLevel:int = Assets.MaxLevel;
			var o:Object = { highScores : highScores, maxLevel : maxLevel };  
			GameData.Save(o);
			dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id : "highscores" }, true));
		}
		
		private function onInput(e:TextEvent):void 
		{
			var text:String = e.text;
			var t:TextField;
			if (text && _allowedChars.indexOf(text)!== -1) 
			{
				if (_textCounter < _NAME_LENGTH) 
				{
					t = _nameLetters[_textCounter];
					t.text = text.toUpperCase();
					TweenLite.to(t, 0.6, { scaleX: 1, scaleY: 1, ease:Strong, overwrite:true } );
					_textCounter++;
					if (_textCounter === _NAME_LENGTH) 
					{
						addChild(_textVector[1]);
						addChild(_textVector[2]);
					}
				}
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			var t:TextField;
			var q:Quad;
			for (var i:int = 0; i < _NAME_LENGTH; i++) 
			{
				t = _nameLetters[i];
				q = _underscores[i];
				q.rotation = t.rotation = Math.cos(_angle) * 0.15;
			}
			
			
			if (_flickerCounter >= 2) 
			{
				_flickerCounter = 0;
				_colourIndex++;
				var len:int = _textVector.length;
				var text:TextField;
				for (var j:int = 0; j < len ; j++) 
				{
					text = _textVector[j];
					text.color = Utility.RAINBOW_VECTOR[_colourIndex % 7];
				}
			}
			_flickerCounter++;
			_angle += e.passedTime * 1.5;
			
		}
	}
}