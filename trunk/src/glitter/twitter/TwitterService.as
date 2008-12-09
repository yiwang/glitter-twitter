package glitter.twitter
{
	import com.adobe.serialization.json.JSON;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class TwitterService extends HTTPService
	{
		private static var TWITTER_URL:String = "http://twitter.com/";		
		private var resultCallback:Function;
		
		public function TwitterService(credentials:String, resultCallback:Function, type:String, method:String, id:String = "") {
			super();
			this.resultCallback = resultCallback;
			if (id == "") {
				this.url = TWITTER_URL + type + "/" + method + ".json";
			}
			else {
				this.url = TWITTER_URL + type + "/" + method + "/" + id + ".json";
			}
			this.headers = {Authorization: "Basic " + credentials};
			this.resultFormat = "text";
			this.showBusyCursor = false;
			this.addEventListener(ResultEvent.RESULT, onResult);
			this.addEventListener(FaultEvent.FAULT, onFault);
		}
		
		public function performPost(params:Object):void {
			this.method = "POST";
			this.request = params;
			this.send();
		}
		
		public function performGet(params:Object=null):void {
			this.request = params;
			this.send();
		}
		
		private function onResult(event:ResultEvent):void {
			resultCallback.apply(this, [JSON.decode(String(event.result))]);
		}

		private function onFault(event:FaultEvent):void
		{
			trace("TwitterService fault: " + event.headers);
		}
	}
}