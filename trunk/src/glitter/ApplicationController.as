package glitter
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import glitter.twitter.Twitter;
	
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;

	public class ApplicationController
	{
		private var appWindow:WindowedApplication;
		static private var INTERVAL:Number = 8; // seconds to refresh
		private var timer:Timer;
		
		/** 
		 * the inventory of timelines / category.
		 * used directly by Twitter.as
		 * for retrieving newer data, filtering and user customized tweets
		 */  
		private var a_timelines:Object = new Object();
		private var a_lastids:Object = new Object();
		
		private var key_func:String;
		private var key_uid:String;
		private var key_filter:String;
		private var __key__:String; // current key
		/**
		 * key_current_timeline can ONLY be one of the Strings bellow
		 * getUserTimeline
		 * getFriendsTimeline
		 * getReplies
		 * getUserUpdates - used with key_current_timeline_u
		 */		

		public function insert_tweet(key:String,tw:Object):void{
			if(a_timelines[key]==null){
				a_timelines[key] = new Array(tw);	
			}else{
				var a:Array = a_timelines[key] as Array;
				var b_new:Boolean =  false;
				for each (var i_tw:Object in a){
					b_new = (i_tw.id == tw.id);
				} 
				if(b_new){ 
					a.push(tw);
					a.sortOn("id",Array.DESCENDING | Array.NUMERIC);
				}
			}
		}
		
		public function update_view(key:String):void{
			 this.appWindow["display"].call_showTweets(a_timelines[key]);
		}
				 
		public function set_key_timeline(key1:String, key2:String="", key3:String =""):void
		{
			key_func = key1;
			key_uid = key2;
			key_filter = key3;
			__key__ = key1 + "&"+ key2 + "&" + key3;
			if(a_timelines[__key__]==null){
				a_lastids[__key__] = "1000000000";//"1032736924";
				//a_timelines[key] = new Array();
			}else{
				a_lastids[__key__] = String(a_timelines[__key__][0].id);
			}
		}
		
		public function get_lastid():Number
		{
			return a_lastids[__key__];
		}
		
		public function get_new_timeline(new_a:Array):Array
		{
			if(a_timelines[__key__]==null){
				a_timelines[__key__] = new_a;
			}else{
				a_timelines[__key__] = new_a.concat(a_timelines[__key__]);
			}
			return a_timelines[__key__];
		}
		
		public function ApplicationController(appWindow:WindowedApplication)
		{
			this.appWindow = appWindow;
			
			// timer for twitterloop
			timer = new Timer(INTERVAL*1000, 0);
            timer.addEventListener("timer", startTwitterLoop);
            timer.start();
		}

		private function startTwitterLoop(e:TimerEvent):void
		{
			if(key_func == "getUserTimeline" ||
			 key_func == "getFriendsTimeline" || 
			 key_func == "getReplies")
			{
				this.appWindow["display"][key_func](Twitter.getStoredUserName(),Twitter.getStoredPassword());
			}
			if(key_func == "getUserUpdates"){
				this.appWindow["display"][key_func](key_uid);
			}
		}
		
		public function settingsButtonClick():void {
			var settingsWindow:AccountSettings = new AccountSettings();
			PopUpManager.addPopUp(settingsWindow, appWindow, true);
			PopUpManager.centerPopUp(settingsWindow);			
		}
	}
}