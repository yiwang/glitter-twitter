package glitter
{
	import flash.events.*;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.controls.Text;
	import mx.events.*;
	import mx.managers.PopUpManager;

	public class HelpWindow extends TitleWindow
	{

		private var helpHBox:HBox;
		private var bodyCanvas:Canvas;
		private var helpMenu:VBox;
		private var linksArray:Array;

		public function HelpWindow(theCanvas:Canvas)
		{
			super();
			helpHBox = new HBox();
			bodyCanvas = new Canvas();
			helpMenu = new VBox();
			linksArray = new Array();
			initializeHelp(theCanvas);
		}

		private function initializeHelp(theCanvas:Canvas):void {
			this.title = "Help";
			this.showCloseButton = true;
			this.width = 700;
			this.height = 500;
			this.addEventListener(CloseEvent.CLOSE, closeTitleWindow);
			PopUpManager.addPopUp( this, theCanvas, true );
			PopUpManager.centerPopUp(this);
			buildLayout();
		}

		private function buildLayout():void {
			this.addChild(helpHBox);
			helpHBox.percentWidth = 100;
			helpHBox.percentHeight = 100;
			helpHBox.addChild(helpMenu);

			linksArray["Basic Twitter Usage"] = "Acres of webpage real estate have been written " +
			"on basic Twitter functionality and we include most of it in Glitter. See http://help.twitter.com/index.php?pg=kb.page&id=26 from the Twitter folks for more info on these basic commands and features. These features can be found in our control panel.";
			linksArray["Basic Glitter Usage"] = "Clicking each button is like invoking the corresponding Twitter command. The results of each command are then displayed in the red Tweets window. If some of the Tweets also have photos attached, (a.k.a. glitter), the change will cascade over to the blue photos display, where all the photos present in the list of tweets can be seen in order.";
			linksArray["Sending"] = "Tweets can also be sent from the interface by typing the text of your tweet in the white box below your list of tweets. Furthermore, you can add images to a tweet by dragging the image from your desktop to the tweet editing window, or by clicking 'Add Image'.";
			linksArray["Labels"] = "<p>An advanced feature of Glitter is that you can select specific tweets that strike your fancy (or those that get your goat) and give them a label. Lists of these tweets will then be displayed under their organizing labels.</p><br /><p>Create a label by clicking the 'create' button. Once the label is created you can save tweets to it by dragging the tweet's photo icon over the label name. To view the tweets under one label, click that label name.</p>";

			//loop through links and add to vbox
			for (var linkName:String in linksArray) {
				var lb:HelpLinkButton = new HelpLinkButton();
				lb.addEventListener(MouseEvent.CLICK,linkButtonHandler);
				lb.label = linkName;
				lb.targetText.htmlText = linksArray[linkName];
				lb.targetText.width = 400;
				helpMenu.addChild(lb);
			}
			var defaultBody:Text = new Text();
			defaultBody.width = 300;
			defaultBody.htmlText = "<p><b>Glitter Help</b></p><p>Hopefully using the links to the left will quickly have you up and running.</p>";
			bodyCanvas.percentWidth = 100;
			bodyCanvas.percentHeight = 100;
			bodyCanvas.setStyle("backgroundColor",0xEEEEEE);
			bodyCanvas.setStyle("paddingTop",20);
			bodyCanvas.setStyle("paddingRight",20);
			bodyCanvas.setStyle("paddingBottom",20);
			bodyCanvas.setStyle("paddingLeft",20);
			bodyCanvas.addChild( defaultBody );
			helpHBox.addChild( bodyCanvas );
		}


		private function linkButtonHandler ( event:Event ):void {
			bodyCanvas.removeAllChildren();
			bodyCanvas.addChild(event.target.targetText);
		}


        private function closeTitleWindow (event:CloseEvent):void {
            PopUpManager.removePopUp(this);
        }
	}
}