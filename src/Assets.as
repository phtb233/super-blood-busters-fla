package  
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import objects.data.*;
	import starling.extensions.SoundManager;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	/**
	 * Asset Library
	 * @author Stephen Oppong Beduh
	 */
	public class Assets 
	{
		
		public function Assets() 
		{
			
		}
		
		private static const _MUSIC_CONSTANT:Number = 0.48;
		private static const _SFX_CONSTANT:Number = 0.35;
		
		private static var _musicFactor:Number = 0.5;
		private static var _sfxFactor:Number = 0.5;
		
		public static var Manager:AssetManager;
		
		public static var Scale:Number;
		
		public static var LevelArray:Vector.<Level> = new Vector.<Level>();
		
		public static var QuestionsArray:Vector.<Question> = new Vector.<Question>();
		
		public static var LevelIndex:uint;
		
		public static var MaxLevel:uint;
		
		private static var _UsedQuestions:Array = [];
		
		public static var HighScores:Array;
		
		public static var SoundEffects : SoundManager = new SoundManager(_SFX_CONSTANT * _sfxFactor);
		
		public static var Music : SoundManager = new SoundManager(_MUSIC_CONSTANT * _musicFactor);
		
		public static var PlayTimes : int = 0;
		
		/**
		 * Get a unique question object. 
		 * Makes sure the same question isn't picked twice.
		 * @return	The question object.
		 */
		public static function GetQuestion():Question
		{
			var index:int; 
			do
			{
				// Get a random question.
				index = Math.random() * QuestionsArray.length;
				// Make sure it hasn't been picked before.
			}
			while (_UsedQuestions.indexOf(index) !== -1) 
			// Push this new question number into used question array.
			_UsedQuestions.push(index);
			// If used question array is full, reset it.
			if (_UsedQuestions.length === QuestionsArray.length) 
			{
				_UsedQuestions = [];
			}
			
			return QuestionsArray[index];
		}
		
		static public function set MusicFactor(value:Number):void 
		{
			_musicFactor = value;
			Music.setBaseVolume(_MUSIC_CONSTANT * _musicFactor);
		}
		
		static public function set SfxFactor(value:Number):void 
		{
			_sfxFactor = value;
			SoundEffects.setBaseVolume(_SFX_CONSTANT * _sfxFactor);
		}
		
		static public function get MusicFactor():Number 
		{
			return _musicFactor;
		}
		
		static public function get SfxFactor():Number 
		{
			return _sfxFactor;
		}
		
	}

}