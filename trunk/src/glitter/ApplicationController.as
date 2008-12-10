package glitter
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import glitter.data.JsonFile;
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
		private var photoView:PhotoView;
				
		private var labelsData:Object = new Object();

		[Bindable]
		public var currentTimelineName:String = "";
		[Bindable]
		public var currentTimeLineNum:Number = 0;
						
		public function addLabel(label:Label):void {
			labelsData[label.getName()] = label;		
		}
		
		public function labelNameUnique(name:String):Boolean {
			for (var oldName:String in labelsData){
				if (oldName==name) return false;
			} 
			return true;
		}
		
		public function deleteLabel(label:Label):void {
			var labelName:String = label.getName();
			if( labelsData[labelName] == null) return;
			labelsData[labelName] = null;
		}
		
		public function getLabels():ArrayCollection {
			var labels:ArrayCollection = new ArrayCollection();
			for each (var label:Label in labelsData){
				labels.addItem(label);
			} 
			return labels;
		}		

		// constructor
		public function ApplicationController(appWindow:WindowedApplication)
		{
			this.twitter = new Twitter(Twitter.getStoredUserName(),Twitter.getStoredPassword(),this);
			this.appWindow = appWindow;
			this.tweetDisplay = appWindow["display"];
			this.photoView = appWindow["photoView"];
			//this.load_session();
			// timer for twitterloop
			timer = new Timer(INTERVAL*1000, 0);
            timer.addEventListener("timer", startTwitterLoop);
            timer.start();
            
            // for load_session to work
            var timerLoad:Timer = new Timer(1500,1);
            timerLoad.addEventListener("timer",onTimerLoad);
            timerLoad.start();
		}
		private function onTimerLoad(e:TimerEvent):void{
			this.load_session();
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
		private function clearStatusesOfLabel(labelname:String):void{
			if(labelsData[labelname]==null){
				labelsData[labelname] = new Label(labelname);
			}
			var label:Label = labelsData[labelname];
			label.clearStatuses();
		}
		
		private function getStatusesFromLabel(labelname:String):ArrayCollection{
			var label:Label = labelsData[labelname];
			if(label==null){
				return null;
			}else{
				return label.getStatuses();
			}
		}
		
		// Home
		public function getFriendsTimeline():void {
			this.currentTimelineName = "Home";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getFriendsTimeline(getTimelineCallback);
		}
		
		// Update
		public function getUserTimeline(): void {
			this.currentTimelineName = "My Updates";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getUserTimeline(getTimelineCallback);
		}
		
		// @Replies	
		public function getReplies():void{
			this.currentTimelineName = "@Replies";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getReplies(getTimelineCallback);
		}
		
		// Directs
		public function getDirects():void{
			this.currentTimelineName = "Directs";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getDirects(getTimelineCallback);
		}
		
		// Directs Sent
		public function getDirectsSent():void{
			this.currentTimelineName = "Directs Sent";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getDirectsSent(getTimelineCallback);
		}
		
		// Search
		public function search(terms:String, fromUser:String, toUser:String, referencingUser:String, hashTag:String, hasPhoto:Boolean):void {
			this.currentTimelineName = "Search";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.search(searchCallback, terms, fromUser, toUser, referencingUser, hashTag, hasPhoto);
		}
		
		// Update
		public function getUserUpdates(username:String):void {
			this.currentTimelineName = username + "'s Update";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getUserTimeline(getTimelineCallback, username);	
		}

		// callback
		private function getTimelineCallback(statuses:Array):void{			
			insertStatusesToLabel(statuses,this.currentTimelineName);
			this.tweetDisplay.showTweets(getStatusesFromLabel(this.currentTimelineName));
			this.photoView.loadPhotosFromStatuses(getStatusesFromLabel(this.currentTimelineName));
			appWindow["loadingMessage"].stopMessage();
		}
		
		private function searchCallback(statuses:Array):void{
			clearStatusesOfLabel(this.currentTimelineName);
			insertStatusesToLabel(statuses,this.currentTimelineName);
			this.tweetDisplay.showTweets(getStatusesFromLabel(this.currentTimelineName));
			appWindow["loadingMessage"].stopMessage();
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
		
		private function startTwitterLoop(e:TimerEvent):void
		{
			testUserVerified();
			if(testUserVerified() && twitter == null){
				this.twitter = new Twitter(Twitter.getStoredUserName(),Twitter.getStoredPassword());
			}
			this.twitter.getFriendsTimeline(twitterLoopCallback);
			this.save_session();
		}
		
		// callback
		private function twitterLoopCallback(statuses:Array):void{
			insertStatusesToLabel(statuses,"Home");
			if (this.currentTimelineName == "Home") {
				this.tweetDisplay.addTweets(statuses);
				this.photoView.loadPhotosFromStatuses(getStatusesFromLabel(this.currentTimelineName));
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
		public function save_session():void{
			//if(testUserVerified()){
				var username:String = Twitter.getStoredUserName();
				this.saveToFile(username);
			//}	
		}
		public function load_session():void{
			//if(testUserVerified()){
				var username:String = Twitter.getStoredUserName();
				this.loadFromFile(username);
			//}
		}
		
		private function saveToFile(username:String):void{
			JsonFile.write(username ,this.labelsData);
		}
		
		private function loadFromFile(username:String):void{
			this.labelsData = JsonFile.read(username);
			if(this.labelsData==null){
				this.labelsData = new Object();
			}
			this.currentTimelineName = "Home";
			var homeStatues:ArrayCollection = getStatusesFromLabel("Home");
			if(homeStatues!=null){
				this.tweetDisplay.showTweets(homeStatues);	
			}
		}

	}
}
