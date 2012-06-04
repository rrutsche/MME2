package de.rutscheschobel.shareyourfilter.view
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	
	public class UploadFilterControl extends AbstractWindow
	{
		public var uploadFilterButton:Button;
		public var uploadFilterName:TextInput;
		
		public function UploadFilterControl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		public function init(event:FlexEvent):void{
//			uploadFilterButton.addEventListener(MouseEvent.CLICK, onShareButtonClicked);
			trace("hallo");
		}
		
		public function onShareButtonClicked(event:Event):void{
			trace("THE FUCK........");
		}
	}
}