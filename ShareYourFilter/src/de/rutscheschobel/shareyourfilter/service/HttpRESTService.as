package de.rutscheschobel.shareyourfilter.service
{
	import de.rutscheschobel.shareyourfilter.util.FilterValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class HttpRESTService
	{
		
		private var _uri:String = "http://localhost:8080/de.rutscheschobel.syf.rest/rest/filters";
		
		public function HttpRESTService(uri:String)
		{
			_uri = uri;
		}
		
		public function get() : void {
			
			var service: HTTPService = new HTTPService();
			service.contentType = "application/json";
			service.method = "GET";
			service.resultFormat = "text";
			service.url = _uri;
			service.useProxy = false;
			
			service.addEventListener( FaultEvent.FAULT , function(event:FaultEvent):void {
				Alert.show( event.message.toString() );
			} )      
			
			service.addEventListener( ResultEvent.RESULT , function(event:ResultEvent):void {
				var message: Object = JSON.parse( event.message.body.toString() );
				
				var filter:FilterValueObject = new FilterValueObject();
				filter.id = message.filters[0].id;
				filter.name = message.filters[0].name;
				filter.brightness = message.filters[0].brightness;
				filter.saturation = message.filters[0].saturation;
				filter.contrast = message.filters[0].contrast;
				filter.red = message.filters[0].red;
				filter.green = message.filters[0].green;
				filter.blue = message.filters[0].blue;
				filter.negative = message.filters[0].negative;
				
				trace(filter.toString());
			} )      
			
			service.send();        
		}
		
		public function create(filter:FilterValueObject) : void {
			var service: HTTPService = new HTTPService();
			service.contentType = "application/json";
			service.method = "POST";
			service.resultFormat = "text";
			service.url = _uri;
			service.useProxy = false;
			
			service.addEventListener( FaultEvent.FAULT , function(event:FaultEvent):void {
				trace( event.message.toString() );
			} );    
			
			service.addEventListener( ResultEvent.RESULT , function(event:ResultEvent):void {
				var response: Object = JSON.parse( event.message.body.toString() );
				for(var s:String in response){
					trace(s+": "+response[s]);
				}
			} );
			
			var json:String = JSON.stringify( filter );
			trace(json);
			var jsonData:ByteArray = new ByteArray();
			jsonData.writeUTFBytes(json);
			jsonData.position = 0;
			var contentType:String = "application/json";
			
			//client.post(uri, jsonData, contentType);
			
			service.send( jsonData );
			
			
			
		}
		
		
	}
}