package glitter
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.containers.Canvas;
	import mx.controls.*;
	import mx.core.Application;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	import mx.styles.StyleManager;
	
	public class Tweet extends Canvas
	{
		private var userName:mx.controls.Label;
		private var profileImage:Image;
		private var htmlLabel:HTML;
		private var createdAt:mx.controls.Label;
		private var display:TweetDisplay;
		private var isLinked:Boolean = false;
		private var url:String;
		private var replyTo:mx.controls.Label;
		public var isReply:Boolean = false;
		private var text:String;
		private var status:Status;
		private var bgColor:String = "'background-color: #d99c96'";
		private var replyColor:String = "'background-color: #E0A997'";
		private var picColor:String = "'background-color: #E9AAA8'"
		private var linkColor:String = "<font color='#FFFFFF'>";
		private var timeColor:String = "<font color='#a64855'>";
		public var uName:String;
		public var rName:String;
		private var directButton:Button;
		private var replyButton:Button;
		private var controller:ApplicationController;
		private var glow:GlowFilter;
		private static var TWITPIC_URL:String = "http://twitpic.com/";
		
		public function domInitialized(event:Event):void {
			htmlLabel.htmlLoader.window.showUserStatuses = getUserUpdates;
			htmlLabel.htmlLoader.window.showLink = link;
		}
		
		public function getStatus():Status {
			return status;
		}
			
		public function Tweet(status:Status, display:TweetDisplay)
		{
			this.status = status;
			this.display = display;
			controller = Application.application.getController();	

			htmlLabel = new HTML();
			htmlLabel.setStyle("right", 2);
			htmlLabel.setStyle("left", 48);
			htmlLabel.width = 245;
			htmlLabel.verticalScrollPolicy = "off";
			htmlLabel.horizontalScrollPolicy = "off";
			htmlLabel.addEventListener(Event.HTML_DOM_INITIALIZE, domInitialized);
			
			text = "<body style=" + bgColor + "><p style='padding: 2px'>";	
			
			setSource(status.getSource());
			setUserName(status.getUserName());
			setText(status.getText());
			setTime(status.getFormattedDate());

			text += "</p></body>";
			htmlLabel.htmlText = text;
									
//			var length:int = status.getUserName().length + status.getText().length
//			if (length > 135) {
//				htmlLabel.height = 83;
//			}
//			else if (length > 100) {
//				htmlLabel.height = 68;
//			}
//			else {
//				htmlLabel.height = 58;
//			}
			htmlLabel.percentHeight = 100;
			
			glow = new GlowFilter();
            glow.color = StyleManager.getColorName("white");
            glow.alpha = 0.6;
            glow.blurX = 4;
            glow.blurY = 4;
            glow.strength = 5;
            glow.quality = BitmapFilterQuality.HIGH;
			
			addChild(htmlLabel);
		}
		
		private function buttonClicked(e:MouseEvent):void {
			var n:Navi = Application.application.getNavi();
			if(e.currentTarget == directButton){
				n.setText("d " + uName + " ");	
			}
			else if(e.currentTarget == replyButton){
				n.setText("@" + uName + " ");	
			}
					
		}
		private function mouseOver(e:MouseEvent):void {
            e.currentTarget.filters = [glow];
		}
		private function mouseOut(e:MouseEvent):void {
			e.currentTarget.filters = null;
		}
		public function setUserName(name:String):void{
			this.uName = name;
			text += "<a href=\"#\" onClick=\"showUserStatuses('" + name + "');\">" + linkColor + name + "</font></a>&nbsp;&nbsp;&nbsp;";			
		}
		public function setSource(src:String):void{
			profileImage = new mx.controls.Image();
			profileImage.source = src;
			profileImage.width = 48;
			profileImage.setStyle("left", 0);
			profileImage.setStyle("top", 0);
			profileImage.percentHeight = 100;
			profileImage.addEventListener(MouseEvent.MOUSE_MOVE, dragIt);

			
			directButton = new Button();
			directButton.setStyle("top", 52);
			directButton.setStyle("left", 30);
			directButton.width = 15;
			directButton.height = 16;
			directButton.toolTip = "send direct msg";
			directButton.addEventListener(MouseEvent.CLICK, buttonClicked);
			directButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			directButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			replyButton = new Button();
			replyButton.setStyle("top", 52);
			replyButton.setStyle("left", 11);
			replyButton.width = 15;
			replyButton.height = 16;
			replyButton.toolTip = "send reply";
			replyButton.addEventListener(MouseEvent.CLICK, buttonClicked);
			replyButton.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			replyButton.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);			

			[Embed("../../images/direct.gif")] 
			var dIcon:Class; 
			directButton.setStyle("icon", dIcon);
			
			[Embed("../../images/reply.gif")] 
			var rIcon:Class; 
			replyButton.setStyle("icon", rIcon);
			
			this.addChild(profileImage);
			this.addChild(replyButton);
			this.addChild(directButton);
//			text += "<img src='" + src + "' style='float:left; margin-right:5px;' />";
		}
		public function setText(status:String):void{ 
			var a:Array = status.split(" ");
			a.reverse();
			var fst:String = a.pop().toString();
			if(fst.charAt(0) == '@'){
				isReply = true;
				this.rName = fst.substr(1, fst.length-1);
			}
			a.push(fst);
			a.reverse();
			for each(var s:String in a){
				if(s == "@"+rName){
					text += "<a href=\"#\" onClick=\"showUserStatuses('" + rName + "');\">" + linkColor + s + "</font></a>&nbsp;&nbsp;";
					text = text.replace(bgColor, replyColor);
				}
				else if(s.match(TWITPIC_URL) && s.length>TWITPIC_URL.length){	// twitpic
					text += "<a href=\"#\" onClick=\"showLink('" + s + "');\">"+ linkColor + s + "</font></a> ";
					//text += "<a href=\"#\" onClick=\"showLink('" + s + "');\"><img src=\"camera.png\"/></a> ";
					text = text.replace(bgColor, picColor);
				}
				else if(s.match("http://")){				// other links
					text += "<a href=\"#\" onClick=\"showLink('" + s + "');\">"+ linkColor + s + "</font></a> ";
				}
				else{
					text += s + " ";
				}
			}	
		}
		
		public function setTime(tm:String):void{
        	text += "<br/>" + timeColor + tm + "</font>";
        }
		
/* 		public function getHeight():int {
			return htmlLabel.height;
		} */
		
		public function link(url:String):void{
			var urlRequest:URLRequest = new URLRequest(url);
			navigateToURL(urlRequest, null);
		}
		
	 	public function getUserUpdates(name:String):void {
	 		display.getUserUpdates(name);
		}
		
		public function dragIt(event:MouseEvent):void {
			var dragInitiator:Tweet = event.currentTarget.parent as Tweet;
			var dragSource:DragSource = new DragSource();
			var i:Image = new Image()
			i.source = Image(event.currentTarget).source;
			i.width = 48;
			i.height = 48;
			
			
			dragSource.addData(this.status, 'status');
			var dragProxy:Canvas = new Canvas();
			dragProxy.addChild(i);
			var message:Text = new Text();
			message.setStyle("left", 50);
			message.height = dragInitiator.height;
			message.width = dragInitiator.width - 48;
			message.text = dragInitiator.getStatus().getText();
			dragProxy.addChild(message);
			DragManager.doDrag(dragInitiator, dragSource, event, dragProxy);
		} 
		
		/* private function mouseDownHandler(event:MouseEvent):void{

            var dragSource:DragSource = new DragSource();
			dragSource.addData(cvs, "Canvas");
			
			var imageProxy:UIComponent = new UIComponent();
			var bitmap:Bitmap = new Bitmap();
			var bitmapData:BitmapData = new BitmapData(cvs.width, cvs.height);
			bitmapData.draw(cvs);
			bitmap.bitmapData = bitmapData;
            imageProxy.addChild(bitmap);
			
			DragManager.doDrag(cvs, dragSource, event, imageProxy);
        }  */
	}
}
