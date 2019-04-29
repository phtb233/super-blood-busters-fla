package  
{
	import flash.media.Sound;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class EmbeddedAssetsCore 
	{
		
		//[Embed(source = "../lib/assets/fonts/minecraftia/Minecraftia.ttf", embedAsCFF="false", fontFamily="Minecraftia")]
		//public static const Minecraftia:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "intro.wav")]
		public static const IntroSnd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "highScores.wav")]
		public static const HighScoresSnd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "gameOver.wav")]
		public static const GameOverSnd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "backgroundOne_theme.wav")]
		public static const BG1Snd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "backgroundTwo_theme.wav")]
		public static const BG2Snd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "backgroundThree_theme.wav")]
		public static const BG3Snd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "backgroundFour_theme.wav")]
		public static const BG4Snd:Class;
		
		[Embed(source = "../lib/assets/sound/compressedSounds.swf", symbol = "entername.wav")]
		public static const NameEntrySnd:Class;
		
		protected static var _Music:Dictionary = new Dictionary();
		
		public static function getMusic(name:String):Sound
		{
			if (_Music[name] == undefined) 
			{
				_Music[name] = new EmbeddedAssetsCore[name]() as Sound;
			}
			return _Music[name];
		}
		
		
	}

}