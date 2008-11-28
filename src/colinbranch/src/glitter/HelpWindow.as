package glitter
{
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.containers.VBox;
	import mx.controls.LinkButton;
	import mx.controls.Text;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class HelpWindow extends TitleWindow
	{

		private var helpCanvas:Canvas;
		private var helpMenu:VBox;
		private var linksArray:Array;

		public function HelpWindow(theCanvas:Canvas)
		{
			super();
			initializeHelp(theCanvas);
		}

		private function buildLayout():void {
			helpCanvas = new Canvas();
			helpCanvas.width=680;
			helpCanvas.height=480;
			this.addChild(helpCanvas);

			helpMenu = new VBox();
			linksArray = new Array();
			linksArray["Working with Tweets"] = "<div style='font-weight:bold'>Working with Tweets</div>" +
			"<div class='helpText'>Here is some help text.</div>";
			//loop through links and add to vbox
			for (var linkName:String in linksArray) {
				var lb:LinkButton = new LinkButton();
				lb.label = linkName;
				helpMenu.addChild(lb);
			}						
		}


		private function initializeHelp(theCanvas:Canvas):void {
<mx:Canvas id="help" xmlns:mx="http://www.adobe.com/2006/mxml" width="680" height="480" backgroundColor="#ABD7A8">
	<mx:VBox x="10" y="10" width="200" height="460" backgroundColor="#CAEAC7">
		<mx:LinkButton label="LinkButton" textAlign="left"/>
		<mx:LinkButton label="LinkButton" textAlign="left"/>
	</mx:VBox>
	<mx:Label x="577" y="10" text="Help!" textAlign="right" fontSize="30" fontWeight="bold"/>
	<mx:Canvas x="218" y="60" width="452" height="410" backgroundColor="#CAEAC7">
		<mx:Text text="Text" width="432" height="390" x="10" y="10"/>
	</mx:Canvas>
</mx:Canvas>
			buildLayout();
			
			var labelDef:Text = new Text();
			labelDef.htmlText = "<b>Selecting a property or a default property</b><br />";
			var labelDefBody:Text = new Text();
			labelDefBody.width = 670;
			labelDefBody.htmlText = "<b>Radial Menus vs. Horizontal Menu Bar</b><br />" +
				"Secondary-clicking (usually the right mouse button) brings up a radial menu. " +
				"Then secondary-click in the direction of the item you wish to choose. Using primary-click (usually the left mouse button)" +
				"before an item has been selected will remove the radial menu. If you secondary-click while no item is selected you will be given" +
				"general options. However, if you secondary-click while an item is selected you will be given the option to change the item's color.<br />" +
				"<br />" +
				"Alternatively you can choose from the horizontal menu bar at the top of the screen." +
				"<br /><br />" +
			"<b>Selecting a property or a default property</b><br />" +
				"Choosing a color while an object is selected will change the properties of that object. Choosing one while no object is selected will set the default color/line for all new objects." +
				"<br /><br />" +
				"<b>Drawing</b><br />" +
				"";
			//titleWindow = new TitleWindow();
			this.title = "Help";
			this.showCloseButton = true;
			this.width = 700;
			this.height = 500;
			this.addChild(labelDefBody);
			this.addEventListener(CloseEvent.CLOSE, closeTitleWindow);
			PopUpManager.addPopUp( this, theCanvas, true );
			PopUpManager.centerPopUp(this);
		}

            private function closeTitleWindow (event:CloseEvent):void {
                PopUpManager.removePopUp(this);
            }
	}
}