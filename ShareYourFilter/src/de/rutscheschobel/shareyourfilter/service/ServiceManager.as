package de.rutscheschobel.shareyourfilter.service {
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import mx.collections.ArrayCollection;

	public class ServiceManager {
		
		[Bindable]
		private var _filterList:ArrayCollection = new ArrayCollection();
		private var _service:HttpRESTService;
		private static const _uri:String = "http://localhost:8080/de.rutscheschobel.syf.rest/rest/filters/";
		
		public function ServiceManager() {
		}
		
		private static var instance:ServiceManager = null;
		public static function getInstance():ServiceManager {
			if (ServiceManager.instance == null) {
				ServiceManager.instance = new ServiceManager();
			}
			return ServiceManager.instance;
		}
		
		public function updateFilterList():ArrayCollection {
			_service = new HttpRESTService(_uri);
			_service.readAll();
			return filterList;
		}
		
		public function createFilter(filter:FilterValueObject):void {
			_service = new HttpRESTService(_uri);
			_service.createFilter(filter);
		}

		public function get filterList():ArrayCollection {
			return _filterList;
		}

		public function set filterList(value:ArrayCollection):void {
			_filterList = value;
		}
		
		

		
	}
}