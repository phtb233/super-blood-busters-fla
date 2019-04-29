package screens.subscreens 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	//import flash.events.StorageVolumeChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.display.Button;
	import objects.VolumeNode;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Settings extends Sprite 
	{
		private var _bg:				Image;
		private var _plaque:			Image;
		private var _backBtn:			Button;
		private var _picker:			Image;
		private var _musicIcon:         Image;
		private var _sfxIcon:           Image;
		private var _crossIcon:			Image;
		private var _hidden:            Boolean;
		private var _optionsSprite:     Sprite;
		private var _musicSelectedIndex:     int;
		private var _sfxSelectedIndex:		int;
		private var _musicMuted: 		Boolean;
		private var _sfxMuted:           Boolean;
		private var _angle:				Number;
		
		
		private var _musicVolumeNodes:Vector.<VolumeNode>;
		private var _sfxVolumeNodes:Vector.<VolumeNode>;
		private var _qb:QuadBatch;
		private var _pickerQb:QuadBatch;
		private var _crossQb:QuadBatch;
		
		private var _musicArea:Rectangle;
		private var _sfxArea:Rectangle;
		private var _musicAngle:Number;
		private var _sfxAngle:Number;
		
		private static const _MUSIC_Y:int = 100;
		private static const _SFX_Y:int = 200;
		
		private static const _NUMBER_OF_NODES:int = 10;
		private static const _ICON_X:int = 70;
		private static const _ICON_PADDING:int = 80;
		private static const _FACTOR:Number = 0.6;
		
		public function Settings() 
		{
			super();
			_bg = new Image(Assets.Manager.getTexture("audioSettingsBg"));
			addChild(_bg);
			_plaque = new Image(Assets.Manager.getTexture("settingsPlaque"));
			_backBtn = new Button(Assets.Manager.getTexture("backBtn"), "", Assets.Manager.getTexture("backBtn"));
			_backBtn.pivotX = _backBtn.width / 2;
			_backBtn.pivotY = _backBtn.height / 2;
			_plaque.pivotX = _plaque.width / 2;
			_plaque.pivotY = _plaque.height / 2;
			
			_qb = new QuadBatch();
			_pickerQb = new QuadBatch();
			_crossQb = new QuadBatch();
			_crossQb.touchable = false;
			
			_optionsSprite = new Sprite();
			
			_musicVolumeNodes = new Vector.<VolumeNode>();
			_sfxVolumeNodes = new Vector.<VolumeNode>();
			
			_musicAngle = 0;
			_sfxAngle = 0;
			
			_musicMuted = Assets.Music.isMuted
			_sfxMuted = Assets.SoundEffects.isMuted;
			
			_hidden = true;
			for (var i:int = 0; i < _NUMBER_OF_NODES; i++) 
			{
				_musicVolumeNodes.push(new VolumeNode());
				_sfxVolumeNodes.push(new VolumeNode());
				if (i < (Assets.MusicFactor * _NUMBER_OF_NODES)) 
				{
					_musicVolumeNodes[i].filled = true;
					if (i === (Assets.MusicFactor * _NUMBER_OF_NODES) - 1) 
					{
						_musicVolumeNodes[i].selected = true;
						_musicSelectedIndex = i;
					}
				}
				
				if (i < Assets.SfxFactor * _NUMBER_OF_NODES) 
				{
					_sfxVolumeNodes[i].filled = true;
					if (i === (Assets.SfxFactor * _NUMBER_OF_NODES) - 1) 
					{
						_sfxVolumeNodes[i].selected = true;
						_sfxSelectedIndex = i;
					}
				}
			}
			
			_musicIcon = new Image(Assets.Manager.getTexture("music_icon"));
			_sfxIcon = new Image(Assets.Manager.getTexture("sfx_icon"));
			_picker = new Image(Assets.Manager.getTexture("picker_icon"));
			_crossIcon = new Image(Assets.Manager.getTexture("icon_cross"));
			
			_musicIcon.pivotX = _musicIcon.width / 2;
			_musicIcon.pivotY = _musicIcon.height / 2;
			_musicIcon.y = _MUSIC_Y;
			_musicIcon.x = _ICON_X;
			
			_sfxIcon.pivotX = _sfxIcon.width / 2;
			_sfxIcon.pivotY = _sfxIcon.height / 2;
			_sfxIcon.y = Math.ceil(_SFX_Y);
			_sfxIcon.x = Math.ceil(_ICON_X);
			
			_picker.pivotX = _picker.width / 2;
			_picker.pivotY = _picker.height;
			
			_crossIcon.pivotX = _crossIcon.width / 2;
			_crossIcon.pivotY = _crossIcon.height / 2;
		}
		
		public function update(passedTime:Number):void
		{
			if (!_hidden) 
			{
				if (!_musicMuted) 
				{
					_musicIcon.rotation = Math.cos(_musicAngle) * 0.5;
					_musicAngle += passedTime;
				}
				
				if (!_sfxMuted) 
				{
					_sfxIcon.rotation = Math.cos(_sfxAngle) * 0.5;
					_sfxAngle += passedTime;
				}
				
				drawNodes();
			}
		}
		
		public function showOptions():void
		{
			_plaque.x = stage.stageWidth / 2;
			_plaque.y = stage.stageHeight / 2;
			_backBtn.x = stage.stageWidth / 2;
			_backBtn.y = stage.stageHeight * .75;
			addChild(_plaque);
			_musicArea = new Rectangle(_ICON_PADDING, 0, _plaque.width * _FACTOR, 60);
			_sfxArea = _musicArea.clone();
			_musicArea.x = _ICON_X + _ICON_PADDING;
			_musicArea.y = _MUSIC_Y - _musicArea.height;
			_sfxArea.x = _musicArea.x;
			_sfxArea.y = _SFX_Y - _sfxArea.height;
			
			TweenLite.from(_plaque, 0.5, { scaleX: 0, scaleY:0, ease:Strong.easeOut, onComplete: onShowOptionsComplete } );
			
			trace("x : " + _musicArea.x + "\ny : " + _musicArea.y + "\nWidth : " + _musicArea.width);
		}
		
		public function hide():void
		{
			visible = false;
			hidden = true;
			removeChildren(1);
			removeEventListeners();
		}
		
		public function show():void
		{
			visible = true;
		}
		
		private function onShowOptionsComplete():void
		{
			_optionsSprite.addChild(_qb);
			_optionsSprite.addChild(_pickerQb);
			_optionsSprite.addChild(_backBtn);
			_hidden = false;
			_optionsSprite.addChild(_musicIcon);
			_optionsSprite.addChild(_sfxIcon);
			_optionsSprite.addChild(_crossQb);
			addChild(_optionsSprite);
			initDraw();
			TweenLite.from(_optionsSprite, 0.4, { alpha: 0, ease:Strong.easeOut, onComplete: function ():void 
			{
				addEventListener(TouchEvent.TOUCH, onTouch);
				
			} } );
			TweenLite.from(_backBtn, 0.4, { alpha: 0, ease:Strong.easeOut, delay: 0.5 } );
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (!touch) return;
			if (!touch.isTouching(_backBtn)) 
			{
				if (touch.phase === TouchPhase.BEGAN || touch.phase === TouchPhase.MOVED) 
				{
					var p:Point = touch.getLocation(stage);
					var f:Number = (_plaque.width * _FACTOR) * 1 / (_NUMBER_OF_NODES * 2);
					var v:VolumeNode;
					var i:int;
					if (_musicArea.containsPoint(p)) 
					{
						for (i = 0; i < _NUMBER_OF_NODES; i++) 
						{
							v = _musicVolumeNodes[i];
							if (p.x > v.x - f && p.x < v.x + f) 
							{
								if (!v.selected) 
								{
									_musicVolumeNodes[_musicSelectedIndex].selected = false;
									_musicSelectedIndex = i;
									v.selected = true;
									updatePicker();
									
									Assets.MusicFactor = (_musicSelectedIndex + 1) / _NUMBER_OF_NODES;
									var s:String = Assets.Music.recentSoundId;
									Assets.Music.playSound("blip");
									Assets.Music.recentSoundId = s;
								}
							}
						}
					} else if (_sfxArea.containsPoint(p)) 
					{
						for (i = 0; i < _NUMBER_OF_NODES; i++) 
						{
							v = _sfxVolumeNodes[i];
							if (p.x > v.x - f && p.x < v.x + f) 
							{
								if (!v.selected) 
								{
									_sfxVolumeNodes[_sfxSelectedIndex].selected = false;
									_sfxSelectedIndex = i;
									v.selected = true;
									updatePicker();
									
									Assets.SfxFactor = (_sfxSelectedIndex + 1) / _NUMBER_OF_NODES;
									Assets.SoundEffects.playSound("blip");
								}
							}
						}
					} 
					if (touch.phase === TouchPhase.BEGAN) 
					{
						if (touch.isTouching(_musicIcon)) 
						{
							trace("Music touched");
							musicMuted = !_musicMuted;
							drawCross();
							
						} else if (touch.isTouching(_sfxIcon)) 
						{
							sfxMuted = !_sfxMuted;
							drawCross();
						}
					}
				}
				
				e.stopImmediatePropagation();
			}
		}
		
		private function initDraw():void
		{
			var w:int = _plaque.width * _FACTOR;
			var v:VolumeNode;
			_qb.reset();
			_pickerQb.reset();
			for (var i:int = 0; i < _NUMBER_OF_NODES; i++) 
			{
				v = _musicVolumeNodes[i];
				v.x = _ICON_X + _ICON_PADDING +  (w * (i / _NUMBER_OF_NODES));
				v.y = _MUSIC_Y;
				
				v = _sfxVolumeNodes[i];
				v.x = _ICON_X + _ICON_PADDING +  (w * (i / _NUMBER_OF_NODES));
				v.y = _SFX_Y ;
			}
			updatePicker();
			drawCross();
		}
		
		private function updatePicker():void
		{
			var v:VolumeNode;
			_pickerQb.reset();
			
			v = _musicVolumeNodes[_musicSelectedIndex];
			_picker.x = v.x;
			_picker.y = _MUSIC_Y - 10;
			_pickerQb.addImage(_picker);
			
			v = _sfxVolumeNodes[_sfxSelectedIndex];
			_picker.x = v.x;
			_picker.y = _SFX_Y - 10;
			_pickerQb.addImage(_picker);
			
			for (var i:int = 0; i < _NUMBER_OF_NODES; i++) 
			{
				if (i < _musicSelectedIndex + 1) 
				{
					_musicVolumeNodes[i].filled = true;
				}else 
				{
					_musicVolumeNodes[i].filled = false;
				}
				
				if (i < _sfxSelectedIndex + 1) 
				{
					_sfxVolumeNodes[i].filled = true;
				}else 
				{
					_sfxVolumeNodes[i].filled = false;
				}
			}
			
		}
		
		private function drawNodes():void
		{
			var q:Quad;
			var v:VolumeNode;
			var c:uint;
			_qb.reset();
			for (var i:int = 0; i < _NUMBER_OF_NODES; i++) 
			{
				v = _musicVolumeNodes[i];
				if (v.filled) c = 0xFFFBF9;
				else c = 0x646464;
				q = new Quad(4, 4, c);
				q.pivotX = q.width / 2;
				q.pivotY = q.height / 2;
				q.x = v.x + (1 + (Math.random() * -2));
				q.y = v.y + (1 + (Math.random() * -2));
				_qb.addQuad(q);
				
				v = _sfxVolumeNodes[i];
				if (v.filled) c = 0xFFFBF9;
				else c = 0x646464;
				q = new Quad(4, 4, c);
				q.pivotX = q.width / 2;
				q.pivotY = q.height / 2;
				q.x = v.x + (1 + (Math.random() * -2));
				q.y = v.y + (1 + (Math.random() * -2));
				_qb.addQuad(q);
			}
		}
		
		private function drawCross():void
		{
			_crossQb.reset();
			if (_musicMuted) 
			{
				_crossIcon.x = _musicIcon.x;
				_crossIcon.y = _musicIcon.y;
				_crossQb.addImage(_crossIcon);
			}
			
			if (_sfxMuted)
			{
				_crossIcon.x = _sfxIcon.x;
				_crossIcon.y = _sfxIcon.y;
				_crossQb.addImage(_crossIcon);
			}
		}
		
		private function get musicMuted():Boolean
		{
			return _musicMuted;
		}
		
		private function set musicMuted(value:Boolean):void
		{
			_musicMuted = value;
			if (_musicMuted) 
			{
				Assets.Music.muteAll(true);
			}else 
			{
				Assets.Music.muteAll(false);
			}
		}
		
		private function get sfxMuted():Boolean
		{
			return _sfxMuted;
		}
		
		private function set sfxMuted(value:Boolean):void
		{
			_sfxMuted = value;
			if (_sfxMuted) 
			{
				Assets.SoundEffects.muteAll();
			}else 
			{
				Assets.SoundEffects.muteAll(false)
			}
		}
		
		public function get backBtn():Button 
		{
			return _backBtn;
		}
		
		public function get hidden():Boolean 
		{
			return _hidden;
		}
		
		public function set hidden(value:Boolean):void 
		{
			_hidden = value;
		}
		
	}

}