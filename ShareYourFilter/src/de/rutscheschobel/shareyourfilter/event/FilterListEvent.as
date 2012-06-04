package de.rutscheschobel.shareyourfilter.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class FilterListEvent extends Event
	{
		public var filters:ArrayCollection;
		
		public static const FILTERLIST_CHANGED:String = "FILTERLIST_CHANGED";
		
		public function FilterListEvent(filters:ArrayCollection, type:String = FilterListEvent.FILTERLIST_CHANGED, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			this.filters = filters;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			// Return a new instance of this event with the same parameters.
			return new FilterListEvent(filters, type, bubbles, cancelable);
		}
	}
}