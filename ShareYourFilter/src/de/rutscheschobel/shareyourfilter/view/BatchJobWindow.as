package de.rutscheschobel.shareyourfilter.view {
	import de.rutscheschobel.shareyourfilter.event.CustomEventDispatcher;
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
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
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
		private var _bitmapData:BitmapData
		private var _scaleFactor:Number;
		private var _filter:FilterValueObject;
		private var _loader:Loader;
		private var _name:String;
		private var _counter:int;
		
		public function BatchJobWindow() {
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		private function init(event:FlexEvent):void {
			_counter = 0;
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
				var file:File = batchFiles.getItemAt(_counter) as File;
				_bitmap = ApplicationManager.getInstance().bitmap;
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, processBitmap);
				_loader.load(new URLRequest(encodeURI(file.nativePath)));
			
			
		}
		
		private function processBitmap(e:Event):void {
			_bitmap = Bitmap(_loader.content);
			_name = "batchfile"+_counter;
			trace(_name);
			var width:int = int(textWidth.text);
			var height:int = int(textHeight.text);
			var isLandscape:Boolean = _bitmap.width >= _bitmap.height;
			if (width < _bitmap.width && isLandscape) {
				_scaleFactor = _bitmap.width / width;
				_bitmapData = new BitmapData(width, _bitmap.height / _scaleFactor);
			} else {
				_scaleFactor = _bitmap.bitmapData.height / height;
				_bitmapData = new BitmapData(_bitmap.width / _scaleFactor, height);	
			}
			ApplicationManager.getInstance().bitmap = _bitmap;
			PopUpManager.removePopUp(this);
			
			ApplicationManager.getInstance().batchSave(_name, _bitmapData);
			_counter++;
			if (_counter < batchFiles.length) {
				processBitmap(new Event(Event.COMPLETE));
			}
		}
		
		private function onFileClick(event:Event):void {
			var file:File = List(event.currentTarget).selectedItem;
			Alert.show(batchFiles.length.toString());
		}
	}
}