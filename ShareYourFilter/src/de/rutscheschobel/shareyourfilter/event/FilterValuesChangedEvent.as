package de.rutscheschobel.shareyourfilter.event {
	import flash.events.Event;
	
	public class FilterValuesChangedEvent extends Event
	{
		// Event types.
		public static const ON_COMPLETE:String = "FILTER_VALUES_CHANGED";
		
		public function FilterValuesChangedEvent(type:String = FilterValuesChangedEvent.ON_COMPLETE, bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			// Return a new instance of this event with the same parameters.
			return new FilterValuesChangedEvent(type, bubbles, cancelable);
		}
	}
}