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
			this.send();
		}
		
		private function onResult(event:ResultEvent):void {
			resultCallback.apply(this, [JSON.decode(String(event.result))]);
		}
		
//		public function TwitterService(credentials:String, tw:Twitter, dest:String, type:String)
//		{
//			//super("http://twitter.com/statuses/", dest+ ".json");
//			super();
//			this.tw = tw;
//			this.dest = "_"+dest;
//			
//			this.url = "http://twitter.com/"+ type + "/"+ dest+ ".json";
//			//this.url = "http://twitter.com/statuses/user_timeline.json";
//			this.headers = {Authorization: "Basic " + credentials};	
//			this.resultFormat = "text";
//			this.showBusyCursor= false;
//			this.addEventListener("fault", onFault);
//			this.addEventListener("result", onResult);	
//			
//		}
//		
		private function onFault(event:FaultEvent):void
		{
			trace("TwitterService fault: " + event.headers);
		}
//					
//		private function onResult(event:ResultEvent):void
//		{
//			var rawData:String = String( event.result );
//			//var a:Array = JSON.decode( rawData ) as Array; 
//			var obj:Object = JSON.decode( rawData ) as Object;
//			tw[dest] = obj;
//			/*
//			if (dest=="_rate_limit_status"||dest=="_update_location") 
//			{
//				tw[dest] = obj;
//			}
//			else
//			{
//				tw[dest] = a;
//			}
//			*/
//		}		
	}
}