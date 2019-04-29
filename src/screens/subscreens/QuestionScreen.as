package screens.subscreens 
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import objects.data.Question;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	/**
	 * Question screen after hitting quiz powerup.
	 * @author Stephen Oppong Beduh
	 */
	public class QuestionScreen extends Sprite 
	{
		private var _bg:					Quad;
		private var _container: 			Sprite;
		
		private var _state:					uint;
		private var _title:					TextField;
		private var _lettersVector:			Vector.<TextField>;
		private var _titleSprite:			Sprite;
		private var _timer:					Number;
		private var _counterTimer:          Number;
		private var _counter: 				uint;
		private var _questionBg:			Image;
		private var _answerSprite:        	Sprite;
		private var _answerVector:			Vector.<Sprite>;
		private var _answerStates:          Array;
		private var _correctAnswerGiven:    Boolean;
		
		private var _questionObject: 		Question;
		private var _questionText:			TextField;
		private var _questionTextVector:    Vector.<String>;
		
		private var _timeLeft:              Number;
		private var _timeDisplay:           TextField;
		private var _timeState:             int;
		
		private var _removeMe:                  Boolean;
		
		//private var _resultSymbol:              Image;
		private var _angle:                     Number;
		
		static private const _EASE:				Number = 0.08;
		private static const _TITLE_LETTERS:	String = "QUESTION!";
		private static const _PADDING_Y:		uint   = 5;
		private static const _NO_OF_QUESTIONS:  uint   = 3;
		private static const _QUESTIONS_Y:      uint   = 160;
		private static const _QUESTION_PADDING: uint   = 7;
		private static const _TRANSITION_SPEED: Number = 0.2;
		private static const _QUESTION_BG_COLOR: uint  = 0xD2ACCF;
		
		
		public function QuestionScreen(question:Question) 
		{
			super();
			_lettersVector = new Vector.<TextField>(9, true);
			_titleSprite = new Sprite();
			_timer = 0;
			_counter = 0;
			_counterTimer = 0;
			_removeMe = false;
			_angle = 0;
			_answerVector = new Vector.<Sprite>(3, true);
			_answerSprite = new Sprite();
			_container = new Sprite();
			_questionObject = question;
			_questionTextVector = new <String>[_questionObject.aOne, _questionObject.aTwo, _questionObject.aThree];
			_questionTextVector.fixed = true;
			_timeLeft = _questionObject.time / 1000;
			_timeState = _timeLeft - 1;
			_answerStates = [false, false, false];
			_correctAnswerGiven;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			e.stopPropagation();
			var touch:Touch = e.getTouch(stage);
			var s:Sprite;
			var q:Quad;
			if (!touch) return;
			
			if (touch.phase === TouchPhase.HOVER) 
			{
				for (var i:int = 0; i < _NO_OF_QUESTIONS; i++) 
				{
					s = _answerVector[i];
					if (touch.isTouching(s)) 
					{
						if (!_answerStates[i]) 
						{
							_answerStates[i] = true;
							q = s.getChildAt(0) as Quad;
							TweenLite.killTweensOf(q);
							q.color = 0xFE8B36;
							break;
						}
					} else 
					{
						if (_answerStates[i]) 
						{
							_answerStates[i] = false;
							q = s.getChildAt(0) as Quad;
							TweenLite.to(q, 0.4, { hexColors : {color : _QUESTION_BG_COLOR }, ease: Strong.easeOut, overwrite : true} );
							break;
						}
					}
				}
			}else if (touch.phase === TouchPhase.ENDED) 
			{
				for (var j:int = 0; j < _NO_OF_QUESTIONS; j++) 
				{
					s = _answerVector[j];
					if (touch.isTouching(s)) 
					{
						trace("Answer " + j + " was selected.");
						checkAnswer(j + 1);
						removeEventListener(TouchEvent.TOUCH, onTouch); 
					}
				}
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_state = 0;
			_bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			_bg.touchable = false;
			addChild(_bg);
			addChild(_container);
			_container.pivotX = stage.stageWidth / 2;
			_container.pivotY = stage.stageHeight / 2;
			_container.x = stage.stageWidth / 2;
			_container.y = stage.stageHeight / 2;
			_questionBg = new Image(Assets.Manager.getTexture("questionPlaque"));
			_questionBg.pivotX = _questionBg.width / 2;
			_questionBg.pivotY = _questionBg.height / 2;
			_questionBg.x = stage.stageWidth / 2;
			_questionBg.y = stage.stageHeight / 2;
			_questionBg.scaleX = _questionBg.scaleY = 0;
			_timeDisplay = new TextField(stage.stageWidth, 60, "00:" + Math.round(_timeLeft), "pressStart80", 16, Color.WHITE);
			_timeDisplay.y = stage.stageHeight - 50;
			_container.addChild(_questionBg);
			_container.addChild(_answerSprite);
			var len:uint = _TITLE_LETTERS.length;
			var l:TextField;
			for (var i:int = 0; i < len; i++) 
			{
				l = new TextField(44, 44, _TITLE_LETTERS.charAt(i), "pressStart80", 40, Color.WHITE);
				l.x = i * l.width;
				_lettersVector[i] = l;
				_titleSprite.addChild(l);
			}
			_titleSprite.pivotX = _titleSprite.width / 2;
			_titleSprite.pivotY = _titleSprite.height / 2;
			_titleSprite.x = stage.stageWidth / 2;
			_titleSprite.y = stage.stageHeight / 2;
			_bg.alpha = 0;
		}
		
		public function update(passedTime:Number):void
		{
			if (_state === 0) 
			{
				if (_bg.alpha < 0.7) 
				{
					_bg.alpha += Math.max(1 - _bg.alpha, 0.04) * _EASE;
				}else 
				{
					_state = 1;
					showQuestionTitle();
				}
			} else if (_state === 1) 
			{
				if (_timer < 1) 
				{
					animateTitle();
					if (_counterTimer > 1) 
					{
						_counter++;
						_counterTimer = 0;
					}
					_timer += passedTime;
					_counterTimer ++;
					
				} else 
				{
					_timer = 0;
					_state = 2;
					prepareQuestion();
				}
			}else if (_state === 2) 
			{
				if (_timeLeft > 0) 
				{
					_timeLeft -= passedTime;
					showTime();
				}else 
				{
					outOfTime();
					_timer = 0;
				}
			}else if (_state === 4) 
			{
				//_resultSymbol.rotation = 
				//l.rotation = 0 + (Math.cos(deg2rad(_angle + (i * 6))) * 0.7);
				//_resultSymbol.rotation = 0 + (Math.cos(deg2rad(_angle))) * 0.7;
				//_angle += passedTime * 78;
				_timer += passedTime;
				if (_timer > 2.4) 
				{
					_state = 5;
					TweenLite.to(_container, 0.55, { onInit: function ():void 
					{
						Assets.SoundEffects.playSound("hide");
					}, ease:Strong.easeOut, scaleX: 0, scaleY: 0, alpha : 0, onComplete : function ():void 
					{
						removeChild(_container);
					} } );
					trace("Start removing this subscreen.");
				}
			}else if (_state === 5) 
			{
				if (_bg.alpha > 0) 
				{
					_bg.alpha += Math.min(0 - _bg.alpha, - 0.02) * _EASE;
				}else 
				{
					_removeMe = true;
					_state = 6;
				}
			}
		}
		
		/**
		 * Player ran out of time. Prevent them from choosing any answers, make sure they lose health.
		 */
		private function outOfTime():void 
		{
			_correctAnswerGiven = false;
			removeEventListener(TouchEvent.TOUCH, onTouch);
			_state = 4;
			var s:Sprite;
			var q:Quad;
			// If any questions are highlighted, unhighlight them.
			for (var i:int = 0; i < _NO_OF_QUESTIONS; i++) 
			{
				if (_answerStates[i]) 
				{
					s = _answerVector[i];
					_answerStates[i] = false;
					q = s.getChildAt(0) as Quad;
					TweenLite.to(q, 0.4, { hexColors : {color : _QUESTION_BG_COLOR }, ease: Strong.easeOut, overwrite : true} );
				}
			}
		}
		
		private function prepareQuestion():void 
		{
			_lettersVector.forEach(function (l:TextField, i:uint, v:Vector.<TextField>):void 
				{
					l.color = Color.WHITE;
				}
			);
			TweenLite.to(_titleSprite, 0.4, { scaleX: 0.4, scaleY: 0.4, y: _titleSprite.height + _PADDING_Y, ease: Strong.easeOut } );
			
			
			//_container.addChildAt(_questionBg, 1);
			TweenLite.to(_questionBg, 0.3, { onInit: function ():void 
			{
				Assets.SoundEffects.playSound("show");
			}, scaleX: 1, scaleY: 1, ease:Strong.easeOut, onComplete: function ():void 
			{
				showQuestions();
				_container.addChild(_timeDisplay);
			} } );
		}
		
		private function showQuestionTitle():void
		{
			_container.addChild(_titleSprite);
			TweenLite.from(_titleSprite, 0.5, {scaleX: 0, scaleY: 0, ease:Strong.easeOut } );
		}
		
		/**
		 * Make the 'QUESTION' text flash rainbow colours.
		 */
		private function animateTitle():void
		{
			var len:uint = _lettersVector.length;
			var offset:uint;
			var letter:TextField;
			for (var i:int = 0; i < len; i++) 
			{
				offset = i + _counter;
				letter = _lettersVector[i];
				letter.color = Utility.RAINBOW_VECTOR[offset % 7];
			}
		}
		
		private function showQuestions():void
		{
			var size:int;
			if (_questionObject.question.length > 150) size = 10;
			else size = 12;
			_questionText = new TextField(_questionBg.width * 0.9, _questionBg.height, _questionObject.question, "Minecraftia", size, 0xFFFFFF);
			_questionText.autoSize = TextFieldAutoSize.VERTICAL;
			_questionText.pivotX = _questionText.width / 2;
			_questionText.x = stage.stageWidth / 2 - 7;
			_questionText.y = Math.ceil((_titleSprite.y + _titleSprite.height / 2) + 9);
			_questionText.alpha = 0;
			_container.addChild(_questionText);
			TweenLite.to(_questionText, _TRANSITION_SPEED, { alpha : 1, ease:Strong.easeOut } );
			
			var bg:Quad;
			var text:TextField
			var s:Sprite;
			for (var i:int = 0; i < _NO_OF_QUESTIONS; i++) 
			{
				bg = new Quad(_questionBg.width * 0.9, 30, _QUESTION_BG_COLOR);
				bg.pivotX = bg.width / 2;
				bg.pivotY = bg.height / 2;
				
				if (_questionTextVector[i].length > 40) size = 10;
				else size = 12;
				text = new TextField(bg.width * 0.9, bg.height, _questionTextVector[i], "Minecraftia", size, 0xFFFFFF);
				text.autoSize = TextFieldAutoSize.VERTICAL;
				text.pivotX = Math.ceil(text.width / 2);
				text.pivotY = Math.ceil(text.height / 2);
				
				s = new Sprite();
				s.x = Math.ceil(stage.stageWidth / 2 - 7);
				s.addChild(bg);
				s.addChild(text);
				s.alpha = 0;
				_answerVector[i] = s;
				_answerSprite.addChildAt(s, 0);
				//addChild(s);
			}
			_answerVector[0].y = _QUESTIONS_Y;
			TweenLite.to(_answerVector[0], _TRANSITION_SPEED, { alpha : 1, ease:Strong.easeOut, onComplete : function ():void 
			{
				_answerVector[1].y = _QUESTIONS_Y;
				TweenLite.to(_answerVector[1], _TRANSITION_SPEED, { alpha : 1, ease:Strong.easeOut, y : _QUESTIONS_Y + bg.height + _QUESTION_PADDING, onComplete : function ():void 
				{
					_answerVector[2].y = _answerVector[1].y;
					TweenLite.to(_answerVector[2], _TRANSITION_SPEED, { alpha : 1, ease:Strong.easeOut, y : _QUESTIONS_Y + (2 * bg.height) + (2 * _QUESTION_PADDING), onComplete : function():void 
					{ 
						addEventListener(TouchEvent.TOUCH, onTouch );
					} } );
				}});
			}} );
		}
		
		/**
		 * Update the timer display.
		 */
		private function showTime():void
		{
			if (_timeLeft < 0) _timeLeft = 0;
			if (_timeLeft < _timeState) 
			{
				_timeState -= 1;
				if (_timeState === 3) 
				{
					_timeDisplay.color = 0xF5CD2E;
					_timeDisplay.fontSize = 18;
				} else if (_timeState === 1) 
				{
					_timeDisplay.color = 0xFE3012;
					_timeDisplay.fontSize = 20;
				}
			}
			var n:String = _timeLeft.toFixed(2);
			var s:String = "00:";
			if (_timeLeft < 10) 
			{
				s += "0";
				s += n.charAt(0);
			}else 
			{
				s += n.substring(0, 2);
			}
			s += ":" + n.substr(n.length - 2);
			_timeDisplay.text = s;
			
		}
		
		/**
		 * Check if the user's answer is correct.
		 * @param	answer
		 */
		private function checkAnswer(answer:int):void
		{
			var q:Quad;
			var s:Sprite;
			var color : uint;
			var duration : Number = 0.3;
			s = _answerVector[answer - 1];
			q = s.getChildAt(0) as Quad;
			if (answer === _questionObject.correctAnswer) 
			{
				//_resultSymbol = new Image(Assets.Manager.getTexture("tick"));
				color = 0x37FF37;
				_correctAnswerGiven = true;
				Assets.SoundEffects.playSound("right");
			} else 
			{
				//_resultSymbol = new Image(Assets.Manager.getTexture("cross"));
				TweenLite.to(q, duration, { hexColors : { color : 0xFF2020 }, ease : Strong.easeOut } );
				_correctAnswerGiven = false;
				Assets.SoundEffects.playSound("wrong");
			}
			//_resultSymbol.pivotX = _resultSymbol.width / 2;
			//_resultSymbol.pivotY = _resultSymbol.height / 2;
			//_resultSymbol.x = Math.ceil(stage.stageWidth / 2);
			//_resultSymbol.y = Math.ceil(stage.stageHeight / 2);
			//_resultSymbol.scaleX = _resultSymbol.scaleY = 0;
			s = _answerVector[_questionObject.correctAnswer - 1];
			q = s.getChildAt(0) as Quad;
			TweenLite.to(q, duration, { hexColors : { color : 0x37FF37 }, ease : Strong.easeOut } );
			//TweenLite.to(_resultSymbol, 0.4, { ease:Strong.easeOut, delay : 0.5, scaleX : 1.5, scaleY : 1.5 } );
			_state = 4
			//addChild(_resultSymbol);
		}
		
		public function get removeMe():Boolean 
		{
			return _removeMe;
		}
		
		public function get correctAnswerGiven():Boolean 
		{
			return _correctAnswerGiven;
		}
		
	}

}