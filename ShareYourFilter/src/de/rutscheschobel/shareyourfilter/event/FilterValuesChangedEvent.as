package de.rutscheschobel.shareyourfilter.event {
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.events.Event;
	
	public class FilterValuesChangedEvent extends Event
	{
		// Event types.
		public static const ON_COMPLETE:String = "FILTER_VALUES_CHANGED";
		public static const NEW_IMAGE:String = "NEW_IMAGE";
		public var filter:FilterValueObject;
		
		public function FilterValuesChangedEvent(filter:FilterValueObject = null, type:String = FilterValuesChangedEvent.ON_COMPLETE, bubbles:Boolean = true, cancelable:Boolean = false) 
		{
			if (filter == null) {
				filter = new FilterValueObject();
			}
			this.filter = filter;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			// Return a new instance of this event with the same parameters.
			return new FilterValuesChangedEvent(filter,type, bubbles, cancelable);
		}
	}
}