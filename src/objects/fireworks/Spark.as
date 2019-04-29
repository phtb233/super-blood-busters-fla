package objects.fireworks 
{
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class Spark
	{
		private var _theta:Number;
		private var _speed:Number;
		private var _x:Number;
		private var _y:Number;
		
		public function Spark() 
		{
			init();
		}
		
		public function init():void
	    {
			_x = 0;
			_y = 0;
		   _theta = Math.random() * (Math.PI * 2);
		   _speed = Math.random() * 3;
	    }
		
		public function update():void
		{
			this._x += Math.sin(_theta) * _speed;
			this._y += -Math.cos(_theta) * _speed;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function get theta():Number 
		{
			return _theta;
		}
		
	}

}













/**
* Generate the speed and angle of the Spark's movement.
   
   private function init():void
   {
   _theta = Math.random() * (Math.PI * 2);
   _speed = Math.random() * 3;
   }
*/
