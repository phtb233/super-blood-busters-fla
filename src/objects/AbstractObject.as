package objects 
{
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class AbstractObject extends Sprite 
	{
		protected var _group:Group;
		protected var _speed:Number;
		
		public function AbstractObject(x:Number, y:Number) 
		{
			super();
			this.x = x;
			this.y = y;
			if (getQualifiedClassName(this) == "AbstractObject")
			{
				throw new ArgumentError("AbstractObject can't be instantiated directly. Try one of it's sub-children.");
			}
		}
		
		public function reset(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function update(passedTime:Number):void
		{
			// override this.
		}
		
		/**
		 * Reference to the group that contains this sprite.
		 */
		public function get group():Group
		{
			return _group;
		}
		
		public function set group(g:Group):void
		{
			_group = g;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
	}

}