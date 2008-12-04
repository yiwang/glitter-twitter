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
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;

		public function PhotoView()
		{
			photoAreasHBox = new HBox();
			photoIconsVBox = new VBox();
			addChild(photoAreasHBox);
			photoAreasHBox.addChild(photoIconsVBox);
			photoArray = new ArrayCollection;
			//loadPhotosFromDirectory();
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
		    			var image:ImageIcon = new ImageIcon( "file://" + files[i].nativePath );
						photoArray.addItem(image);
			     }
		    }
			displayIcons();
		}
		
		private function displayIcons():void {
			photoIconsVBox.removeAllChildren();
			photoIconsVBox.graphics.clear();
			for(var i:uint=0; i<photoArray.length; i++) {
				photoIconsVBox.addChild( photoArray[i] );
			}
		}
				
	}
}