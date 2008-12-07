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
			helpHBox.addChild(helpMenu);

			linksArray["Working with Tweets"] = "<p><b>Working with Tweets</b></p>" +
			"<p class='helpText'>Here is some help text.</p>";
			linksArray["the next button"] = "<p style='font-weight:bold'><b>the next button</b></p>" +
			"<p class='helpText'>Here is some help text.</p>";
			linksArray["another button"] = "<p style='font-weight:bold'><b>another button</b></p>" +
			"<p class='helpText'>Here is some help text.</p>";
			linksArray["one more"] = "<p style='font-weight:bold'><b>one more</b></p>" +
			"<p class='helpText'>Here is some help text.</p>";

			//loop through links and add to vbox
			for (var linkName:String in linksArray) {
				var lb:HelpLinkButton = new HelpLinkButton();
				lb.addEventListener(MouseEvent.CLICK,linkButtonHandler);
				lb.label = linkName;
				lb.targetText.htmlText = linksArray[linkName];
				helpMenu.addChild(lb);
			}
			var defaultBody:Text = new Text();
			defaultBody.htmlText = "<p><b>Glitter Help</b></p><p>Hopefully using the links to the left will quickly have you up and running.</p>";
			bodyCanvas.addChild( defaultBody );
			helpHBox.addChild( bodyCanvas );
		}


		private function linkButtonHandler ( event:Event ) {
			bodyCanvas.removeAllChildren();
			bodyCanvas.addChild(event.target.targetText);
		}


        private function closeTitleWindow (event:CloseEvent):void {
            PopUpManager.removePopUp(this);
        }
	}
}