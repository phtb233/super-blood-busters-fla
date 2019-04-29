package objects 
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import objects.bullet.Bullet;
	/**
	 * Holds multiple sprites, and recycles them.
	 * @author Stephen Oppong Beduh
	 */
	public class Group 
	{
		private var _array:			Array;
		/**
		 * A method that's called within the update function.
		 */
		private var _loopFunction:	Function = null;
		
		public function Group() 
		{
			_array = new Array();
		}
		
		/**
		 * Add an AbstractObject to the group.
		 * @param	item		The AbstractObject to be added.
		 * @param	display		[Optional] Which container it should be added to.
		 */
		public function add(item:AbstractObject, display:DisplayObjectContainer=null):void
		{
			_array.push(item);
			item.group = this;
			if (display) 
			{
				display.addChild(item);
			}
		}
		
		/**
		 * Re-use a sprite that has been removed from the stage.
		 * @param	x
		 * @param	y
		 * @param	type	Use the Utility static constants to specify the sprite's type.
		 * @return	The requested sprite as an AbstractObject.
		 */
		public function recycle(x:Number, y:Number, type:String):AbstractObject
		{
			var len:uint = _array.length;
			var MyClass:Class = getDefinitionByName(type) as Class;
			for (var i:int = 0; i < len; i++) 
			{
				var item:AbstractObject = _array[i];
				if (item is MyClass) 
				{
					if (!item.stage) 
					{
						item.reset(x, y);
						return item;
					}
				} else {
					continue;
				}
			}
			var newItem:Object = new MyClass(x, y);
			add(newItem as AbstractObject);
			return newItem as AbstractObject;
		}
		
		/**
		 * Call update on everything in this group.
		 * @param	passedTime
		 */
		public function update(passedTime:Number):void
		{
			_array.forEach(
				function(item:AbstractObject, index:int, array:Array):void
				{
					if (!item) return; 
					item.update(passedTime);
					if (_loopFunction != null) 
						_loopFunction(item, index, array);
				}
			);
		}
		
		/**
		 * Get the length of the group's array.
		 */
		public function get length():uint
		{
			return _array.length;
		}
		
		public function get array():Array
		{
			return _array;
		}
		
		/**
		 * A method that's called within the group's update function. 
		 * Is passed the same parameters as forEach.
		 */
		public function set loopFunction(value:Function):void 
		{
			_loopFunction = value;
		}
	}

}