package de.rutscheschobel.shareyourfilter.event
{
	import flash.events.EventDispatcher;

	public class CustomEventDispatcher extends EventDispatcher
	{
		public function CustomEventDispatcher()
		{
		}
		
		public function dispatchFilterValuesChangedEvent(event:FilterValuesChangedEvent):void {
			dispatchEvent(event);
		}
	}
}