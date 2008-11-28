package kaori.glitter.twitter
{
	import com.hurlant.util.Base64;
	import kaori.glitter.twitter.*;
	
	import flash.events.TimerEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.rpc.http.mxml.HTTPService;
		
	// Yi
	// implement like so:
	// http://blog.log2e.com/2008/05/25/twitter-flex-and-json/
	public class Twitter
	{
		private var username:String;
		private var password:String;
		private var credentials:String;
   				
		private static var logger:ILogger = Log.getLogger("Twitter.as");
		public var _user_timeline:Array = new Array();
		public var _friends_timeline:Array = new Array();
		public var _replies:Array = new Array();
		public var _rate_limit_status:Object = new Object();
		public var _update_location:Object = new Object();
		public var _update:Object = new Object();
		
		// TwitterService
		private var ts_user_timeline:TwitterService;
		private var ts_friends_timeline:TwitterService;
		private var ts_replies:TwitterService;
		private var ts_rate_limit_status:TwitterService;
		private var ts_update_location:TwitterService;
		private var ts_update:TwitterService;
		
		public function Twitter(username:String, password:String)
		{
			this.username = username;
			this.password = password;
			this.credentials = Base64.encode(username + ":" + password);
			this.ts_user_timeline = new TwitterService(credentials,this,"user_timeline","statuses");
			this.ts_friends_timeline = new TwitterService(credentials,this,"friends_timeline","statuses");
			this.ts_replies = new TwitterService(credentials,this,"replies","statuses");
			this.ts_rate_limit_status = new TwitterService(credentials,this,"rate_limit_status","account");
			// for setting
			this.ts_update_location = new TwitterService(credentials,this,"update_location","account");
			this.ts_update = new TwitterService(credentials,this,"update","statuses");
			
			// 1st time pull data
			this.refreshAll();
			/*
			var myTimer:Timer = new Timer(10000, 0);
            myTimer.addEventListener("timer", timerHandler);
            myTimer.start();
            */
			
		}

		// Refresh, PULL all status
		public function refreshAll():void
		{
			this.ts_user_timeline.send();
			this.ts_friends_timeline.send();
			this.ts_replies.send();
			this.ts_rate_limit_status.send();			
		}
		
        private function timerHandler(event:TimerEvent):void
        {
            trace("timerHandler: " + event);
        }
		
		// methods to retrieve timelines. These all return Arrays of Status objects
		public function getUserTimeline():Array 
		{
			this.ts_user_timeline.send();
			return _user_timeline;
		}
		
		public function getFriendsTimeline():Array 
		{
			this.ts_friends_timeline.send();
			return _friends_timeline;
		}
		
		public function getReplies():Array 
		{
			this.ts_replies.send();
			return _replies;
		}
		
		// returns the remaining_hits in the rate limit
		public function getRateLimit():Number 
		{
			this.ts_rate_limit_status.send();
			//trace(_rate_limit_status);
			return _rate_limit_status.remaining_hits;
		}
		
		// sets the user's location on twitter
		public function setLocation(location:String):void 
		{
			this.ts_update_location.method="POST";
			this.ts_update_location.request={location:location};
			//trace(this.ts_update_location.url);
			this.ts_update_location.send();
		}
		
		public function setUpdate(status:String):void
		{
			this.ts_update.method="POST";
			this.ts_update.request={status:status};
			//trace(this.ts_update.url);
			this.ts_update.send();			
			
		}
	}
}



