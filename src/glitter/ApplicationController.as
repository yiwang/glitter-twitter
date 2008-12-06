package glitter
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import glitter.data.Session;
	import glitter.twitter.Twitter;
	
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;

	public class ApplicationController
	{
		private var appWindow:WindowedApplication;
		static private var INTERVAL:Number = 8; // seconds to refresh
		private var timer:Timer;
		private var se:Session = new Session();
		
		/**
		 * key_func can ONLY be one of below
		 * getUserTimeline
		 * getFriendsTimeline
		 * getReplies
		 * getUserUpdates - used with key_uid required
		 */	
		private var key_func:String;
		private var key_uid:String;
		private var __key__:String; // current key

		// constructor
		public function ApplicationController(appWindow:WindowedApplication)
		{
			this.appWindow = appWindow;
			this.load_session();
			// timer for twitterloop
			timer = new Timer(INTERVAL*1000, 0);
            timer.addEventListener("timer", startTwitterLoop);
            timer.start();
		}
				 		
		public function testUserVerified():Boolean{
			return (Twitter.getStoredUserName()!=""&&Twitter.getStoredPassword());
		}

		public function getTwitById(__id__:String):Object{
			return se.get_twit_by_id(__id__);
		}
		public function showall():void{
			var a:Array = se.getAllTwits();
			key_func = "";
			this.appWindow["display"].call_showTweets(a);
		}
		
		// called from Twitter.as	 
		public function set_key_timeline(key1:String, key2:String=""):void
		{
			key_func = key1;
			key_uid = key2;
			/**
			 *  __key__ is set here first
			 */
			__key__ = key1 + "&"+ key2;
		}
		
		public function get_lastid():String
		{
			return String(se.get_lastid(__key__));
		}
		
		public function get_new_timeline(new_a:Array):Array
		{
			se.update_timeline_by_key(__key__,new_a);
			return se.get_timeline_by_key(__key__);
		}

		/**
		 * do nothing if key_func is not in the specific ones
		 */
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
			this.save_session();
		}
		
		public function settingsButtonClick():void {
			var settingsWindow:AccountSettings = new AccountSettings();
			PopUpManager.addPopUp(settingsWindow, appWindow, true);
			PopUpManager.centerPopUp(settingsWindow);			
		}
		
		// save and load a_twit, a_key_id of current user
		private function save_session():void{
			if(!testUserVerified()) return;
			var u:String = Twitter.getStoredUserName();
			se.save(u);	
		}
		private function load_session():void{
			if(!testUserVerified()) return;
			var u:String = Twitter.getStoredUserName();
			se.load(u);
		}
	}
}