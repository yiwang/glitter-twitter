package glitter
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.events.*;

	public class PhotoView extends Canvas
	{
		private var photoAreasHBox:HBox;
		private var photoIconsVBox:VBox;
		private var photoZoomCanvas:Canvas;
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;
		private var curIndex:int;

		public function PhotoView()
		{
			photoAreasHBox = new HBox();
			photoIconsVBox = new VBox();
			photoZoomCanvas = new Canvas();
			photoZoomCanvas.setStyle("backgroundColor",0xFFFFCC);
//			photoZoomCanvas.width = 500;
//			photoZoomCanvas.height = 500;
			var image:ImageZoom = new ImageZoom( "file:///Users/colin/Documents/dl/Nikhil birth 013.JPG" );// + files[i].nativePath );
			image.height = 300;
			image.width = 300;
			photoZoomCanvas.addChild(image);


			addChild(photoAreasHBox);
			photoAreasHBox.addChild(photoIconsVBox);
			photoAreasHBox.addChild(photoZoomCanvas);
			photoArray = new ArrayCollection;
			//loadPhotosFromDirectory();
			loadTestPhotos();
		}

		public function setCurrentImage( curIndex:int ) {
			this.curIndex = curIndex;
		}

		public function loadTestPhotos():void {
			var image:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 013.JPG",0 );// + files[i].nativePath );
			photoArray.addItem(image);
			var image:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 015.JPG",1 );// + files[i].nativePath );
			photoArray.addItem(image);
			var image:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 020.JPG",2 );// + files[i].nativePath );
			photoArray.addItem(image);
			displayPhotos( photoArray );
		}

		
		public function loadPhotosFromDirectory():void {
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
 		    for(var i:uint = 0; i < files.length; i++)
		    {
				lcpath = files[i].nativePath.toLowerCase();
		    	if ( lcpath.indexOf("jpg") > 0
		    		|| lcpath.indexOf("gif") > 0 
		    		|| lcpath.indexOf("png") > 0 ) {
		    			var image:ImageIcon = new ImageIcon( "file://" + files[i].nativePath, i );
						photoArray.addItem(image);
			     }
		    }
			displayPhotos( photoArray );
		}
		
		
		public function displayPhotos( thePhotoArray:ArrayCollection ):void {
			photoIconsVBox.removeAllChildren();
			photoIconsVBox.graphics.clear();
			for(var i:uint=0; i<thePhotoArray.length; i++) {
				photoIconsVBox.addChild( thePhotoArray[i] );
			}
		}
	}
}