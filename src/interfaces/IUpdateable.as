package interfaces
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	
	/**
	 * ...
	 * @author Stephen Oppong Beduh
	 */
	public interface IUpdateable 
	{
		function update(passedTime:Number):void;
		
		function get stage():Stage;
	}
	
}