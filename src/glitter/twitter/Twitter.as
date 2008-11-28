package glitter.twitter
{
	import com.hurlant.util.Base64;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;

//	import flash.events.TimerEvent;
//	
//	import mx.logging.ILogger;
//	import mx.logging.Log;
		
	// Yi
	// implement like so:
	// http://blog.log2e.com/2008/05/25/twitter-flex-and-json/
	public class Twitter
	{
		private var username:String;
		private var password:String;
		private var credentials:String;
   				
//		private static var logger:ILogger = Log.getLogger("Twitter.as");
//		public var _user_timeline:Array = new Array();
//		public var _friends_timeline:Array = new Array();
//		public var _replies:Array = new Array();
//		public var _rate_limit_status:Object = new Object();
//		public var _update_location:Object = new Object();
//		public var _update:Object = new Object();
		
		// TwitterService
//		private var ts_user_timeline:TwitterService;
//		private var ts_friends_timeline:TwitterService;
//		private var ts_replies:TwitterService;
//		private var ts_rate_limit_status:TwitterService;
//		private var ts_update_location:TwitterService;
//		private var ts_update:TwitterService;
		
		// callback functions
		private var userCallback:Function;
		private var rateLimitCallback:Function;
		
		public function Twitter(username:String, password:String)
		{
			this.username = username;
			this.password = password;
			this.credentials = Base64.encode(username + ":" + password);
//			this.ts_user_timeline = new TwitterService(credentials,this,"user_timeline","statuses");
//			this.ts_friends_timeline = new TwitterService(credentials,this,"friends_timeline","statuses");
//			this.ts_replies = new TwitterService(credentials,this,"replies","statuses");
//			this.ts_rate_limit_status = new TwitterService(credentials,this,"rate_limit_status","account");
//			// for setting
//			this.ts_update_location = new TwitterService(credentials,this,"update_location","account");
//			this.ts_update = new TwitterService(credentials,this,"update","statuses");
			
			// 1st time pull data
//			this.refreshAll();
			/*
			var myTimer:Timer = new Timer(10000, 0);
            myTimer.addEventListener("timer", timerHandler);
            myTimer.start();
            */
			
		}
		
		public function getRateLimit(callback:Function):void {
			this.rateLimitCallback = callback;
			new TwitterService(credentials, parseRateLimit, "account", "rate_limit_status");
		}
		
		private function parseRateLimit(rateLimit:Object):void {
			rateLimitCallback.apply(this, [String(rateLimit.remaining_hits)]);
		}
		
		public function getTwitterUser(userCallback:Function, u:String = ""):void {
			this.userCallback = userCallback;
			u = u == "" ? this.username : u;
			new TwitterService(credentials, parseTwitterUser, "users", "show", u);
		}
		
		private function parseTwitterUser(user:Object):void {
			userCallback.apply(this, [user]);
		}

		// Refresh, PULL all status
//		public function refreshAll():void
//		{
//			this.ts_user_timeline.send();
//			this.ts_friends_timeline.send();
//			this.ts_replies.send();
//			this.ts_rate_limit_status.send();			
//		}
//		
//        private function timerHandler(event:TimerEvent):void
//        {
//            trace("timerHandler: " + event);
//        }
//		
//		// methods to retrieve timelines. These all return Arrays of Status objects
//		public function getUserTimeline():Array 
//		{
//			this.ts_user_timeline.send();
//			return _user_timeline;
//		}
//		
//		public function getFriendsTimeline():Array 
//		{
//			this.ts_friends_timeline.send();
//			return _friends_timeline;
//		}
//		
//		public function getReplies():Array 
//		{
//			this.ts_replies.send();
//			return _replies;
//		}
//		
//		// returns the remaining_hits in the rate limit
//		public function getRateLimit():Number 
//		{
//			this.ts_rate_limit_status.send();
//			//trace(_rate_limit_status);
//			return _rate_limit_status.remaining_hits;
//		}
//		
//		// sets the user's location on twitter
//		public function setLocation(location:String):void 
//		{
//			this.ts_update_location.method="POST";
//			this.ts_update_location.request={location:location};
//			//trace(this.ts_update_location.url);
//			this.ts_update_location.send();
//		}
//		
//		public function setUpdate(status:String):void
//		{
//			this.ts_update.method="POST";
//			this.ts_update.request={status:status};
//			//trace(this.ts_update.url);
//			this.ts_update.send();			
//			
//		}
		
		public static function getStoredUserName():String {
			var storedValue:ByteArray = EncryptedLocalStore.getItem("twitterUserName");
			return storedValue == null ? "" : storedValue.readUTFBytes(storedValue.length);
		}
		
		public static function getStoredPassword():String {
			var storedValue:ByteArray = EncryptedLocalStore.getItem("twitterPassword");
			return storedValue == null ? "" : storedValue.readUTFBytes(storedValue.length);			
		}
		
		public static function setStoredUserName(userName:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(userName);
			EncryptedLocalStore.removeItem("twitterUserName");
			EncryptedLocalStore.setItem("twitterUserName", bytes);			
		}
		
		public static function setStoredPassword(password:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(password);
			EncryptedLocalStore.removeItem("twitterPassword");
			EncryptedLocalStore.setItem("twitterPassword", bytes);			
		}
	}
}