package glitter
{
	import flash.events.MouseEvent;
	import flash.filters.*;
	
	import mx.containers.Canvas;
	import mx.controls.*;
	import mx.styles.StyleManager;
	
	public class Tweet extends Canvas
	{
		private var cvs:Canvas;
		public var userName:Label;
		private var profileImage:Image;
		private var text:Text;
		private var createdAt:Text;
		private var display:TweetDisplay;
			
		public function Tweet(status:Status, display:TweetDisplay)
		{
			this.display = display;
			
			cvs = new Canvas();
			cvs.width = 260;
			cvs.height = 72;
			setColor(0x91e4f3);
			
			userName = new Label();
			setUserName(status.getUserName());
			userName.x = 68;
			userName.y = 10;
			userName.width=153;
			userName.height=20;
			userName.setStyle("color", 0xEE5815);
			userName.addEventListener(MouseEvent.ROLL_OVER, rollOver);
			userName.addEventListener(MouseEvent.ROLL_OUT, rollOut);
			userName.addEventListener(MouseEvent.CLICK, getUserUpdates);
			
			profileImage = new Image();
			profileImage.x = 10;
			profileImage.y = 10;
			profileImage.width = 48;
			profileImage.height = 48;
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
			text.x = 68;
			text.y = 10;
			text.width = 153;
			text.height = 40;
			setText(status.getText());
			
			createdAt = new Text();
			createdAt.x = 68;
			createdAt.y = 44;
			createdAt.width = 191;
			createdAt.height = 18;
			setTime(status.getFormattedDate());
			
			cvs.addChild(profileImage);
			cvs.addChild(text);
			cvs.addChild(userName);
			cvs.addChild(createdAt);
			addChild(cvs);
		}
		
		public function setUserName(name:String):void{
			userName.text = name;
		}
		public function setSource(src:String):void{
			profileImage.source = src;
		}
		public function setText(st:String):void{
			var x:int = userName.text.length;
			var i:int = 0;
			var space:String = "       ";
			for(i=0; i<=x; i++){
				space = space + " ";
			}
			text.text = space + st;
			
			if(st.charAt(0)=='@')
				setColor(0x82f2d4);
		}
        public function setTime(tm:String):void{
        	createdAt.text = tm;
        }
		public function setColor(color:uint):void{
			cvs.setStyle("backgroundColor", color);
		}
		public function rollOver(e:MouseEvent):void{
			userName.setStyle("textDecoration", "underline");
		}
		public function rollOut(e:MouseEvent):void{
			userName.setStyle("textDecoration", "none");
		}
	 	public function getUserUpdates(e:MouseEvent):void {
			display.getUserUpdates(userName.text);
		} 
	}
}