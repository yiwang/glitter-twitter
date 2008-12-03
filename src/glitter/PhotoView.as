package glitter
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.*;
	import mx.containers.VBox;

	public class PhotoView extends Canvas
	{
		private var disp:VBox;
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;

		public function PhotoView()
		{
			disp = new VBox();
/* 			disp.width = 500;
			disp.height= 500;
			disp.setStyle("backgroundColor", 0xCCCCCC);
 */			addChild(disp);
			photoArray = new ArrayCollection;
//			loadPhotosFromDirectory();
		}
		
		private function loadPhotosFromDirectory():void {
//			var tempPhotos:ArrayCollection = new ArrayCollection();
			var myFile:File = new File();
			try
			{
			    directory.browseForDirectory("Select directory of photos (for testing)");
			    directory.addEventListener(Event.SELECT, hndlFileSelect);
			}
			catch (error:Error)
			{
			    trace("Failed:", error.message)
			}
		}

		private function hndlFileSelect(event:Event):void 
		{
		    directory = event.target as File;
		    var lcpath:String;
		    var files:Array = directory.getDirectoryListing();
 		    var testImage:Image = new Image();
		    testImage.source = "@Embed('/Users/colin/Documents/dl/IMG00052.jpg')";
			photoArray.addItem(testImage);
		    for(var i:uint = 0; i < files.length; i++)
		    {
//		    	Alert.show(files[i].nativePath);
				lcpath = files[i].nativePath.toLowerCase();
		    	if ( lcpath.indexOf("jpg") > 0
		    		|| lcpath.indexOf("gif") > 0 
		    		|| lcpath.indexOf("png") > 0 ) {
//		    			Alert.show(files[i].nativePath);
		    			var image:Image = new Image();
/* 						image.x = 10;
						image.y = 10;
 */						image.width = 300;
						image.height = 300;
						image.setStyle("verticalCenter", 0);
						image.setStyle("horizontalCenter", 0);
		    			image.source = "file://" + files[i].nativePath;
/* 		    		var ldr:Loader = new Loader();
					var url:String = "file:///" + files[i].nativePath;
					var urlReq:URLRequest = new URLRequest(url);
					ldr.load(urlReq);
					addChild(ldr);
			    	var bitmap:Bitmap = new Bitmap();
 */
 //			    	image.source = "file:///" + files[i].nativePath;
//			    	Alert.show(image.source.toString());
						photoArray.addItem(image);
			     }
		    }
			displayPhotos();
		}
		
		public function displayPhotos():void {
			disp.removeAllChildren();
			disp.graphics.clear();
			for(var i:uint=0; i<photoArray.length; i++) {
//				Alert.show(photoArray[i].toString());
				disp.addChild( photoArray[i] );
			}
		}
				
	}
}