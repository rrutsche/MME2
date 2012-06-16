package de.rutscheschobel.shareyourfilter.view {
	import com.hurlant.util.der.Integer;
	
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
	import de.rutscheschobel.shareyourfilter.event.FilterListEvent;
	import de.rutscheschobel.shareyourfilter.event.FilterValuesChangedEvent;
	import de.rutscheschobel.shareyourfilter.main.ApplicationManager;
	import de.rutscheschobel.shareyourfilter.service.ServiceManager;
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TextInput;
	
	public class BatchJobWindow extends AbstractWindow {
		
		[Bindable]
		public var filterCollection:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var batchFiles:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var textWidth:TextInput;
		[Bindable]
		public var textHeight:TextInput;
		public var filterList:List;
		public var fileList:List;
		public var buttonStartBatchJob:Button;
		private var dispatcher:CustomEventDispatcher;
		private var _bitmap:Bitmap;
		private var _filter:FilterValueObject;
		private var _loader:Loader;
		
		public function BatchJobWindow() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			dispatcher = CustomEventDispatcher.getInstance();
			filterList.addEventListener(Event.CHANGE, onFilterClick);
			fileList.addEventListener(Event.CHANGE, onFileClick);
			buttonStartBatchJob.addEventListener(MouseEvent.CLICK, onBatchJobStart);
			filterCollection = ServiceManager.getInstance().filterList;
			batchFiles = ApplicationManager.getInstance().batchFiles;
		}
		
		private function onFilterClick(event:Event):void {
			_filter = List(event.currentTarget).selectedItem;
			ApplicationManager.getInstance().basicFilter.setFilterValueObject(_filter);
			dispatcher.dispatchFilterValuesChangedEvent(new FilterValuesChangedEvent(_filter));
		}
		
		private function onBatchJobStart(e:MouseEvent):void {
			_bitmap = ApplicationManager.getInstance().bitmap;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, processBitmap);
			_loader.load(new URLRequest(encodeURI(batchFiles.getItemAt(0).nativePath)));
		}
		
		private function processBitmap(e:Event):void {
			_bitmap = Bitmap(_loader.content); 
			ApplicationManager.getInstance().bitmap = _bitmap;
			PopUpManager.removePopUp(this);
			var scale:Number = _bitmap.width / int(textWidth.text),
			matrix:Matrix = new Matrix();
//			matrix.scale(scale, scale);
			ApplicationManager.getInstance().saveImage(matrix);
		}
		
		private function onFileClick(event:Event):void {
			var file:File = List(event.currentTarget).selectedItem;
			Alert.show(file.nativePath);
		}
	}
}