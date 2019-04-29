package objects.data 
{
	/**
	 * Contains details for the quiz questions.
	 * @author Stephen Oppong Beduh
	 */
	public class Question 
	{
		private var _question:String;
		private var _aOne:String;
		private var _aTwo:String;
		private var _aThree:String;
		private var _aFour:String;
		private var _correctAnswer:int;
		private var _time:Number;
		
		/**
		 * 
		 * @param	question 
		 * @param	aOne The first selectable answer.
		 * @param	aTwo The second...
		 * @param	aThree
		 * @param 	aFour The last answer.
		 * @param	correctAnswer 
		 * @param	time The amount of time the player has to answer, in milliseconds.
		 */
		public function Question(question:String, aOne:String, aTwo:String, aThree:String, aFour:String, correctAnswer:int, time:Number) 
		{
			_question = question;
			_aOne = aOne;
			_aTwo = aTwo;
			_aThree = aThree;
			_aFour = aFour;
			_correctAnswer = correctAnswer;
			_time = time;
		}
		
		public function get question():String 
		{
			return _question;
		}
		
		public function get aOne():String 
		{
			return _aOne;
		}
		
		public function get aTwo():String 
		{
			return _aTwo;
		}
		
		public function get aThree():String 
		{
			return _aThree;
		}
		
		public function get correctAnswer():int 
		{
			return _correctAnswer;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function get aFour():String 
		{
			return _aFour;
		}
		
	}

}