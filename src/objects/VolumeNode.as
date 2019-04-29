package objects 
{
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public class VolumeNode 
	{
		/**
		 * Whether the colour is bright (meaning that it's filled in),
		 * or dark (the volume level is less than this node).
		 */
		private var _filled:Boolean;
		/**
		 * This is the last filled in node, and represents the actual
		 * volume level.
		 */
		private var _selected:Boolean;
		public var x:Number;
		public var y:Number;
		
		public function VolumeNode(filled:Boolean = false, selected:Boolean = false) 
		{
			filled = filled;
			selected = selected;
		}
		
		/**
		 * Whether the colour is bright (meaning that it's filled in),
		 * or dark (the volume level is less than this node).
		 */
		public function get filled():Boolean 
		{
			return _filled;
		}
		
		/**
		 * Whether the colour is bright (meaning that it's filled in),
		 * or dark (the volume level is less than this node).
		 */
		public function set filled(value:Boolean):void 
		{
			_filled = value;
		}
		
		/**
		 * This is the last filled in node, and represents the actual
		 * volume level.
		 */
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		/**
		 * This is the last filled in node, and represents the actual
		 * volume level.
		 */
		public function set selected(value:Boolean):void 
		{
			_selected = value;
		}
		
	}

}