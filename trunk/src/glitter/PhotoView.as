package glitter
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.*;

	public class PhotoView extends Canvas
	{
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;

		public function PhotoView()
		{
			super();
			photoArray = new ArrayCollection;
			loadPhotosFromDirectory();
			displayPhotos();
		}
		
		private function loadPhotosFromDirectory():void {
//			var tempPhotos:ArrayCollection = new ArrayCollection();
			var myFile:File = new File();
			try
			{
			    directory.browseForDirectory("Select Directory");
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
		    var files:Array = directory.getDirectoryListing();
		    for(var i:uint = 0; i < files.length; i++)
		    {
		    	if ( files[i].nativePath.indexOf(".jpg")
		    		|| files[i].nativePath.indexOf(".gif")
		    		|| files[i].nativePath.indexOf(".png") ) {
//		    			Alert.show(files[i].nativePath);
		    			var image:Image = new Image();
		    			image.source = "@Embed( 'file:///' + files[i].nativePath )";
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
		}
		
		public function displayPhotos() {
			this.removeAllChildren();
			for(var i:uint=0; i<photoArray.length; i++) {
				Alert.show(photoArray[i]);
				photoBox.addChild( photoArray[i] );
			}
		}
				
	}
}