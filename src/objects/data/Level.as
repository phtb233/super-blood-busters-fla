package objects.data 
{
	/**
	 * Objects containing data for the levels.
	 * 
	 * @author Stephen Oppong Beduh
	 */
	public class Level 
	{
		private var _toKill:uint;
		private var _germOneProb:Number;
		private var _germOneSpeed:Number;
		private var _germOneFreq:Number;
		
		private var _germTwoProb:Number;
		private var _germTwoSpeed:Number;
		private var _germTwoFreq:Number;
		
		private var	_germThreeProb:Number;
		private var _germThreeSpeed:Number;
		private var _germThreeFreq:Number;
		
		private var _germFourProb:Number;
		private var _germFourSpeed:Number;
		private var _germFourFreq:Number;
		
		private var _powerupProb:Number;
		private var _powerupSpeed:Number;
		private var _powerupFreq:Number;
		
		private var _rbcProb:Number;
		private var _rbcSpeed:Number;
		private var _rbcFreq:Number;
		
		private var _changeBackground:Boolean;
		private var _levelBackground:String;
		private var _music:String;
		
		/**
		 * The level content is described using these objects.
		 * 
		 * @param	toKill 				How many enemies to kill before moving to the next round.
		 * @param	germOneProb			The probability of germ one appearing.
		 * @param	germOneSpeed		The speed of germ one.
		 * @param	germOneFreq			The frequency of its appearances.
		 * @param	germTwoProb
		 * @param	germTwoSpeed
		 * @param	germTwoFreq
		 * @param	germThreeProb
		 * @param	germThreeSpeed
		 * @param	germThreeFreq
		 * @param	germFourProb
		 * @param	germFourSpeed
		 * @param	germFourFreq
		 * @param   rbcProb
		 * @param	rbcFreq
		 * @param	powerupProb			Chances of a power up appearing.
		 * @param	powerupFreq
		 * @param	changeBackground	Whether the background should be changed for this level.
		 * @param	levelBackground		The class name of the background to change to.
		 * @param	music				The music to play for this level.
		 */
		public function Level(
		toKill:uint, 
		germOneProb:Number, germOneSpeed:Number, germOneFreq:Number,
		germTwoProb:Number, germTwoSpeed:Number, germTwoFreq:Number,
		germThreeProb:Number, germThreeSpeed:Number, germThreeFreq:Number,
		germFourProb:Number, germFourSpeed:Number, germFourFreq:Number,
		rbcProb:Number = 0, rbcSpeed:Number = 3, rbcFreq:Number = 0,
		powerupProb:Number = 0, powerupSpeed:Number = 2, powerupFreq:Number = 0,
		changeBackground:Boolean = false, levelBackground:String = null, music:String = null 
		) 
		{
			_toKill = toKill;
			
			_germOneProb = germOneProb;
			_germOneSpeed = germOneSpeed;
			_germOneFreq = germOneFreq;
			
			_germTwoProb = germTwoProb;
			_germTwoSpeed = germTwoSpeed;
			_germTwoFreq = germTwoFreq;
			
			_germThreeProb = germThreeProb;
			_germThreeSpeed = germThreeSpeed;
			_germThreeFreq = germThreeFreq;
			
			_germFourProb = germFourProb;
			_germFourSpeed = germFourSpeed;
			_germFourFreq = germFourFreq;
			
			_rbcProb = rbcProb;
			_rbcSpeed = rbcSpeed;
			_rbcFreq = rbcFreq;
			
			_powerupProb = powerupProb;
			_powerupSpeed = powerupSpeed;
			_powerupFreq = powerupFreq;
			
			_changeBackground = changeBackground;
			_levelBackground = levelBackground;
			_music = music;
			
			
			
		}
		
		public function get toKill():uint 
		{
			return _toKill;
		}
		
		public function get germOneProb():Number 
		{
			return _germOneProb;
		}
		
		public function get germOneSpeed():Number 
		{
			return _germOneSpeed;
		}
		
		public function get germOneFreq():Number 
		{
			return _germOneFreq;
		}
		
		public function get germTwoProb():Number 
		{
			return _germTwoProb;
		}
		
		public function get germTwoSpeed():Number 
		{
			return _germTwoSpeed;
		}
		
		public function get germTwoFreq():Number 
		{
			return _germTwoFreq;
		}
		
		public function get germThreeProb():Number 
		{
			return _germThreeProb;
		}
		
		public function get germThreeSpeed():Number 
		{
			return _germThreeSpeed;
		}
		
		public function get germThreeFreq():Number 
		{
			return _germThreeFreq;
		}
		
		public function get germFourProb():Number 
		{
			return _germFourProb;
		}
		
		public function get germFourSpeed():Number 
		{
			return _germFourSpeed;
		}
		
		public function get germFourFreq():Number 
		{
			return _germFourFreq;
		}
		
		public function get rbcProb():Number 
		{
			return _rbcProb;
		}
		
		public function get rbcSpeed():Number 
		{
			return _rbcSpeed;
		}
		
		public function get rbcFreq():Number 
		{
			return _rbcFreq;
		}
		
		public function get powerupFreq():Number 
		{
			return _powerupFreq;
		}
		
		
		public function get powerupSpeed():Number 
		{
			return _powerupSpeed;
		}
		
		
		public function get powerupProb():Number 
		{
			return _powerupProb;
		}
		
		public function get changeBackground():Boolean 
		{
			return _changeBackground;
		}
		
		public function get levelBackground():String 
		{
			return _levelBackground;
		}
		
		public function get music():String 
		{
			return _music;
		}
		
		
		
	}

}