package glitter.twitter
{
	import com.adobe.serialization.json.JSON;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class TwitterSearch extends HTTPService
	{
		private static var TWITTER_SEARCH_URL:String = "http://search.twitter.com/";		
		private var resultCallback:Function;
		
		public function TwitterSearch(credentials:String, resultCallback:Function, key:String = "") {
			super();
			//http://search.twitter.com/search.json?q=<keyword>
			this.resultCallback = resultCallback;
			this.url = TWITTER_SEARCH_URL + "search.json?q="+key;
			//this.url = "http://search.twitter.com/trends.json";
			//this.url = "http://search.twitter.com/search.json?callback="+resultCallback+"&q=twitter";

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