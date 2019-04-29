package events 
{
	import starling.events.Event;
	
	/**
	 * Specifies whether a scene has loaded or not.
	 * @author Stephen Oppong Beduh
	 */
	public class ProgressEvent extends Event 
	{
		public static const LOADED:String = "loaded";
		
		public function ProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function toString():String 
		{ 
			//return formatToString("ProgressEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			return "ProgressEvent";
		}
		
	}
	
}