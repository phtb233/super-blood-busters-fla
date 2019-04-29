package events 
{
	import starling.events.Event;
	
	/**
	 * Contains information about which screen we should switch to.
	 * Fired when we need to change screens.
	 * @author Stephen Oppong Beduh
	 */
	public class NavigationEvent extends Event 
	{
		/**
		 * Indicates that the screen needs to be changed to what's indicated in the event's "params" property.
		 */
		public static const CHANGE_SCREEN:String = "changeScreen";
		/**
		 * Store the screen we should change to here.
		 */
		public var params:Object;
		
		public function NavigationEvent(type:String, params:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.params = params;
		} 
		
		
		public override function toString():String 
		{ 
			var s:String = "Navigation Event -- \n";
			//return formatToString("NavigationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			for (var prop:String in params) {
				s += prop + " : " + params[prop] + "\n";
			}
			return s;
		}
		
	}
	
}