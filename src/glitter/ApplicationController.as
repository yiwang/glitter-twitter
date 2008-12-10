package glitter
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import glitter.data.JsonFile;
	import glitter.data.Session;
	import glitter.twitter.Twitter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.LinkButton;
	import mx.core.WindowedApplication;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.managers.PopUpManager;
	
	public class ApplicationController
	{
		private var appWindow:WindowedApplication;
		static private var INTERVAL:Number = 10; // seconds to refresh
		private var timer:Timer;
		private var session:Session = new Session();
		private var twitter:Twitter;
		private var isVerifiedCredentials:Boolean = false;
		private var tweetDisplay:TweetDisplay;
		private var newLabel:Boolean;
		private var selectedLabel:Label;
		private var photoView:PhotoView;
				
		private var labelsData:Object = new Object();
		private var reservedTimeLineNameArray:Array = new Array("home","my updates","@replies","directs","directs sent","search");
		//private var 

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
			this.photoView = appWindow["photoView"];
			this.load_session();
			// timer for twitterloop
			timer = new Timer(INTERVAL*1000, 0);
            timer.addEventListener("timer", startTwitterLoop);
            timer.start();
            
            // for load_session to work
            var timerLoad:Timer = new Timer(1500,1);
            timerLoad.addEventListener("timer",onTimerLoad);
            timerLoad.start();
		}
		
		// update display
		private function onTimerLoad(e:TimerEvent):void{
			var homeStatues:ArrayCollection = getStatusesFromLabel("home");
			if(homeStatues!=null){
				refreshCurrentDisplay();
			}
		}
		
		// refresh both timeline and photos
		private function refreshCurrentDisplay():void{
			this.tweetDisplay.showTweets(getStatusesFromLabel(this.currentTimelineName));
			this.photoView.loadPhotosFromStatuses(getStatusesFromLabel(this.currentTimelineName));			
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
			for (var i:int = statuses.length - 1; i >= 0; i--) {
				label.addStatus(statuses[i]);
			}
//			for each (var status:Status in statuses.reverse()){
//				label.addStatus(status);
//			}
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
		
		// label functions
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
				var isReservedLabel:Boolean = false;
				for each(var reservedTimeLineName:String in this.reservedTimeLineNameArray){
					if ( reservedTimeLineName==label.getName() || label.getName().search("'s update")!= -1){
						isReservedLabel = true;
					}
				}
				if (!isReservedLabel){
					labels.addItem(label);
				}
			} 
			return labels;
		}
		
		public function getSelectedLabel():Label {
			if (newLabel) {
				return new Label("");
			}
			else {
				return selectedLabel;
			}
		}
		
		public function showTweetsForLabel(event:MouseEvent):void {
			var l:LinkButton = event.target as LinkButton;
			this.selectedLabel = labelsData[l.label];
			this.currentTimelineName = selectedLabel.getName();
			this.refreshCurrentDisplay();
		}
		
		public function createLabelButtonClicked():void {
			this.newLabel = true;
			var newLabelWindow:EditLabel = new EditLabel();
			PopUpManager.addPopUp(newLabelWindow, appWindow, true);
			PopUpManager.centerPopUp(newLabelWindow);			
		}
		
		public function editLabelButtonClicked(event:Event):void {
			
		}
		
		public function saveLabel(label:Label):void {
			labelsData[label.getName()] = label;
			
			main(appWindow).loadLabels(getLabels());
		}
		
		public function labelDragEnterHander(event:DragEvent):void {
			var dropTarget:LinkButton = event.currentTarget as LinkButton;
			if (event.dragSource.hasFormat("status")) {
				dropTarget.drawFocus(true);
				DragManager.acceptDragDrop(dropTarget);
			}
		}
		
		public function labelDragExitHandler(event:DragEvent):void {
			var dropTarget:LinkButton = event.currentTarget as LinkButton;
			if (event.dragSource.hasFormat("status")) {
				dropTarget.drawFocus(false);
				DragManager.acceptDragDrop(dropTarget);
			}
		}
		
		public function labelDragDropHandler(event:DragEvent):void {
			var dropTarget:LinkButton = event.currentTarget as LinkButton;
			dropTarget.drawFocus(false);
			var dropLabel:Label = labelsData[dropTarget.label];
			dropLabel.addStatus(event.dragSource.dataForFormat("status") as Status); 
		}
		
		// Home
		public function getFriendsTimeline():void {
			this.currentTimelineName = "home";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getFriendsTimeline(getTimelineCallback);
		}
		
		// Update
		public function getUserTimeline(): void {
			this.currentTimelineName = "my updates";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getUserTimeline(getTimelineCallback);
		}
		
		// @Replies	
		public function getReplies():void{
			this.currentTimelineName = "@replies";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getReplies(getTimelineCallback);
		}
		
		// Directs
		public function getDirects():void{
			this.currentTimelineName = "directs";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getDirects(getTimelineCallback);
		}
		
		// Directs Sent
		public function getDirectsSent():void{
			this.currentTimelineName = "directs sent";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getDirectsSent(getTimelineCallback);
		}
		
		// Search
		public function search(terms:String, fromUser:String, toUser:String, referencingUser:String, hashTag:String, hasPhoto:Boolean):void {
			this.currentTimelineName = "search";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.search(searchCallback, terms, fromUser, toUser, referencingUser, hashTag, hasPhoto);
		}
		
		// Update
		public function getUserUpdates(username:String):void {
			this.currentTimelineName = username + "'s update";
			appWindow["loadingMessage"].startMessage("loading...");
			this.twitter.getUserTimeline(getTimelineCallback, username);	
		}

		// callback
		private function getTimelineCallback(statuses:Array):void{			
			insertStatusesToLabel(statuses,this.currentTimelineName);
			this.refreshCurrentDisplay();
			appWindow["loadingMessage"].stopMessage();
		}
		
		private function searchCallback(statuses:Array):void{
			clearStatusesOfLabel(this.currentTimelineName);
			insertStatusesToLabel(statuses,this.currentTimelineName);
			this.refreshCurrentDisplay();
			appWindow["loadingMessage"].stopMessage();
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
			insertStatusesToLabel(statuses,"home");
			if (this.currentTimelineName == "home") {
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
			
			this.currentTimelineName = "home";

		}

	}
}
