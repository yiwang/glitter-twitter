package glitter
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import glitter.data.Session;
	import glitter.twitter.Twitter;
	
	import mx.collections.ArrayCollection;
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;

	public class ApplicationController
	{
		private var appWindow:WindowedApplication;
		static private var INTERVAL:Number = 8; // seconds to refresh
		private var timer:Timer;
		private var session:Session = new Session();
		private var twitter:Twitter;
		private var isVerifiedCredentials:Boolean = false;
		private var tweetDisplay:TweetDisplay;
				
		private var labelsData:Object = new Object();

		[Bindable]
		public var currentTimelineName:String = "";
		[Bindable]
		public var currentTimeLineNum:Number = 0;
				
		// constructor
		public function ApplicationController(appWindow:WindowedApplication)
		{
			this.twitter = new Twitter(Twitter.getStoredUserName(),Twitter.getStoredPassword(),this);
			this.appWindow = appWindow;
			this.tweetDisplay = appWindow["display"];
			//this.load_session();
			// timer for twitterloop
			timer = new Timer(INTERVAL*1000, 0);
            timer.addEventListener("timer", startTwitterLoop);
            timer.start();
		}
		public function confirmVerifiedCredentials():void{
			isVerifiedCredentials = true;
		}
		
		// checking based on appearace of stored user name and pwd may not be reliable
		public function testUserVerified():Boolean{
			var u:String = Twitter.getStoredUserName();
			var p:String = Twitter.getStoredPassword();
			var b:Boolean = u && p && (u!="") && (p!="");
			return b && isVerifiedCredentials;
		}

		// insertion of fetched data
		private function insertStatusesToLabel(statuses:Array,labelname:String):void{
			if(labelsData[labelname]==null){
				labelsData[labelname] = new Label(labelname);
			}
			var label:Label = labelsData[labelname];
			for each (var status:Status in statuses){
				label.addStatus(status);
			}
		}
		
		private function getStatusesFromLabel(labelname:String):ArrayCollection{
			var label:Label = labelsData[labelname];
			return label.getStatuses();
		}
		
		// Home
		public function getFriendsTimeline():void {
			this.currentTimelineName = "Home";
			this.twitter.getFriendsTimeline(getTimelineCallback);
		}
		
		// Update
		public function getUserTimeline(): void {
			this.currentTimelineName = "My Updates";
			this.twitter.getUserTimeline(getTimelineCallback);
		}
		
		// @Replies	
		public function getReplies():void{
			this.currentTimelineName = "@Replies";
			this.twitter.getReplies(getTimelineCallback);
		}
		
		// Update
		public function getUserUpdates(username:String):void {
			this.currentTimelineName = username + "'s Update";
			this.twitter.getUserTimeline(getTimelineCallback, username);	
		}
		
		////////////////////////////////////////// Search
		public function search(key:String):void {
			this.currentTimelineName = key + "'s Update";
			this.twitter.getUserTimeline(getTimelineCallback, key);	
			//this.twitter.search(getTimelineCallback, key);
		}
		////////////////////////////////////////////

		// callback
		private function getTimelineCallback(statuses:Array):void{
			insertStatusesToLabel(statuses,this.currentTimelineName);
			this.tweetDisplay.showTweets(getStatusesFromLabel(this.currentTimelineName));
		}
				
		// All
		public function showall():void{
			//this.tweetDisplay.showTweets(statuses);
			
		}
		
		public function get_lastid():String
		{
			var label:Label = labelsData[this.currentTimelineName];
			if(label==null) return "1000000000";
			var statuses:ArrayCollection = (labelsData[this.currentTimelineName]as Label).getStatuses();
			if(statuses.length==0) return "1000000000";
			return statuses.getItemAt(0).getId();
		}
		

		/**
		 * do nothing if key_func is not in the specific ones
		 */
		private function startTwitterLoop(e:TimerEvent):void
		{
			testUserVerified();
			if(testUserVerified() && twitter == null){
				this.twitter = new Twitter(Twitter.getStoredUserName(),Twitter.getStoredPassword());
			}
			this.twitter.getFriendsTimeline(twitterLoopCallback);
			//this.save_session();
		}
		
		// callback
		private function twitterLoopCallback(statuses:Array):void{
			insertStatusesToLabel(statuses,"Home");
			if (this.currentTimelineName == "Home") {
				this.tweetDisplay.addTweets(statuses);
			}
		}

		public function settingsButtonClick():void {
			var settingsWindow:AccountSettings = new AccountSettings();
			PopUpManager.addPopUp(settingsWindow, appWindow, true);
			PopUpManager.centerPopUp(settingsWindow);			
		}
		
		public function searchButtonClick():void {
			var searchWindow:Search = new Search();
			PopUpManager.addPopUp(searchWindow, appWindow, true);
			PopUpManager.centerPopUp(searchWindow);			
		}
		
		// save and load session data of current user
		private function save_session():void{
			if(testUserVerified()){
				var username:String = Twitter.getStoredUserName();
				this.session.save(username);
			}	
		}
		private function load_session():void{
			if(testUserVerified()){
				var username:String = Twitter.getStoredUserName();
				this.session.load(username);
			}
		}
	}
}
