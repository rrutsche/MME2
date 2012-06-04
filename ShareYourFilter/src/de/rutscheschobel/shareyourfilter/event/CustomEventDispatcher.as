package de.rutscheschobel.shareyourfilter.event
{
	import flash.events.EventDispatcher;

	public class CustomEventDispatcher extends EventDispatcher
	{
		public function CustomEventDispatcher(){}
		
		private static var instance:CustomEventDispatcher = null;
		public static function getInstance():CustomEventDispatcher {
			if (CustomEventDispatcher.instance == null) {
				CustomEventDispatcher.instance = new CustomEventDispatcher();
			}
			return CustomEventDispatcher.instance;
		}
		
		public function dispatchFilterValuesChangedEvent(event:FilterValuesChangedEvent):void {
			dispatchEvent(event);
		}
		
		public function dispatchFilterListEvent(event:FilterListEvent):void {
			dispatchEvent(event);
		}
	}
}