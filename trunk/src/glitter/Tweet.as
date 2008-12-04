package glitter
{
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	//import flash.display.Bitmap;
	//import flash.display.BitmapData;
	
	import mx.containers.Canvas;
	import mx.controls.*;
	//import mx.core.DragSource;
	//import mx.core.UIComponent;
	import mx.styles.StyleManager;
	//import mx.managers.DragManager;
	
	public class Tweet extends Canvas
	{
		private var cvs:Canvas;
		private var userName:Label;
		private var profileImage:Image;
		private var text:Text;
		private var createdAt:Label;
		private var display:TweetDisplay;
		private var isLinked:Boolean = false;
		private var url:String;
		private var replyTo:Label;
		public var isReply:Boolean = false;
			
		public function Tweet(status:Status, display:TweetDisplay)
		{
			this.display = display;
			
			cvs = new Canvas();
			cvs.setStyle("left", 2);
			cvs.setStyle("right", 2);
			cvs.height = 72;
			setColor(0x91e4f3);
			
			userName = new Label();
			setUserName(status.getUserName());
			userName.height = 18;
			userName.setStyle("left", 65);
			userName.setStyle("top", 10);
			userName.setStyle("color", 0xEE5815);
			userName.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			userName.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			userName.addEventListener(MouseEvent.CLICK, getUserUpdates);
			
			replyTo = new Label();
			replyTo.height = 18;
			replyTo.setStyle("left", 120);
			replyTo.setStyle("top", 10);
			replyTo.setStyle("color", 0xEE5815);
			replyTo.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			replyTo.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			replyTo.addEventListener(MouseEvent.CLICK, getUserUpdates);
			
			profileImage = new Image();
			profileImage.width = 48;
			profileImage.height = 48;
			profileImage.setStyle("left", 10);
			profileImage.setStyle("verticalCenter", 0);
			setSource(status.getSource());
			
			var glow:GlowFilter = new GlowFilter();
            glow.color = StyleManager.getColorName("white");
            glow.alpha = 0.8;
            glow.blurX = 4;
            glow.blurY = 4;
            glow.strength = 6;
            glow.quality = BitmapFilterQuality.HIGH;
            profileImage.filters = [glow];
	
			text = new Text();
			text.setStyle("right", 3);
			text.setStyle("left", 65);
			text.setStyle("top", 10);
			text.setStyle("bottom", 18);
			text.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			text.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			text.addEventListener(MouseEvent.CLICK, link);
			setText(status.getText());

			createdAt = new Label();
			createdAt.height = 18;
			createdAt.setStyle("left", 65);
			createdAt.setStyle("right", 3);
			createdAt.setStyle("bottom", 3);
			createdAt.setStyle("color", 0x3b71d4);
			setTime(status.getFormattedDate());
			
			cvs.addChild(profileImage);
			cvs.addChild(text);
			cvs.addChild(replyTo);
			cvs.addChild(userName);
			cvs.addChild(createdAt);

			addChild(cvs);
			//cvs.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		public function setUserName(name:String):void{
			userName.text = name;
		}
		public function setSource(src:String):void{
			profileImage.source = src;
		}
		public function setText(status:String):void{
			var x:int = userName.text.length;
			var i:int = 0;

			var a:Array = status.split(" ");
			a.reverse();
			
			// change color for url links
			for each(var s:String in a){
				if(s.match("http://")){
					url = s;
					isLinked = true;
					text.setStyle("color", 0xEE5815);
					break;
				}
			}	
			
			// change color for replies
			var fst:String = a.pop().toString();
			if(fst.charAt(0) == '@'){
				setColor(0x82f2d4);
				replyTo.text = fst;
				isReply = true;
				var sp:String = "";
				for(i=0; i<=fst.length; i++){
					sp = sp + "  ";
				}
				status = status.replace(fst, sp);
				replyTo.setStyle("left", 100+(x*3));
			}
			
			var space:String = "       ";
			for(i=0; i<=x; i++){
				space = space + " ";
			}
			status = space + status;
			text.text = status;

			// adjust tweet height
			if (status.length > 80)
			  cvs.height += (status.length - 80)/28*20;
			
		}
		
		public function getHeight():int {
			return cvs.height;
		}
		
		public function link(e:MouseEvent):void{
			if(isLinked){
			text.setStyle("color", 0x1931c4);
			var urlRequest:URLRequest = new URLRequest(url);
			navigateToURL(urlRequest, null);
			}
		}
		
        public function setTime(tm:String):void{
        	createdAt.text = tm;
        }
		public function setColor(color:uint):void{
			cvs.setStyle("backgroundColor", color);
		}
		public function rollOver(e:MouseEvent):void{
			if (e.target == userName)
				userName.setStyle("textDecoration", "underline");
			else if (e.target == replyTo)
				replyTo.setStyle("textDecoration", "underline");
			else if (e.target==text && isLinked)
				text.setStyle("color", 0x1931c4);
		}
		public function rollOut(e:MouseEvent):void{
			if (e.target == userName)
				userName.setStyle("textDecoration", "none");
			else if (e.target == replyTo)
				replyTo.setStyle("textDecoration", "none");
			else if (e.target==text && isLinked)
				text.setStyle("color", 0xEE5815);
		}
	 	public function getUserUpdates(e:MouseEvent):void {
	 		if (e.currentTarget == userName)
	 			display.getUserUpdates(userName.text);
	 		else if (e.currentTarget == replyTo) {
				var name:String = replyTo.text.substr(1, replyTo.text.length-1);
				display.getUserUpdates(name);
	 		}
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
