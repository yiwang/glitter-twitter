package glitter
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.events.*;


	public class PhotoView extends Canvas
	{
		private var photoAreasHBox:HBox;
		private var photoIconsVBox:VBox;
		private var photoZoomCanvas:Canvas;
		private var photoArray:ArrayCollection;
		private var directory:File = File.documentsDirectory;
		private var curIndex:int;
		
		private var photoCache:Object = new Object();

		public function PhotoView()
		{
			photoIconsVBox = new VBox();
			photoIconsVBox.percentWidth=100;
			photoIconsVBox.percentHeight=100;
			this.addChild(photoIconsVBox);
			photoArray = new ArrayCollection;
			//loadPhotosFromDirectory();
			//loadTestPhotos();
		}


		public function setCurrentIndex( curIndex:int ):void {
			this.curIndex = curIndex;
		}


		public function getCurrentIndex( ):int {
			return curIndex;
		}


		public function loadPhotosFromStatuses( statusArray:ArrayCollection ):void {
			photoIconsVBox.removeAllChildren();
			this.photoArray = new ArrayCollection(); 
			var hasAtLeastOnePhoto:Boolean = new Boolean();
			hasAtLeastOnePhoto = false;
			for ( var i:uint = 0; i<statusArray.length; i++ ) {
				if ( statusArray[i].hasPhoto() ) {
					hasAtLeastOnePhoto = true;
					var url:String = new String();
					url = statusArray[i].getPhotoUrl();
					var sender:String = new String();
					sender = statusArray[i].getUserName();
					var date:String = new String();
					date = statusArray[i].getFormattedDate();
	//				var text:String = new String();
	//				text = statusArray[i].get
					var imageCached:ImageIcon = photoCache[url];
					if(imageCached==null){
						photoCache[url] = new ImageIcon( url, i, sender, date );
					}
					photoArray.addItem( photoCache[url] );
				}
			}
			if ( hasAtLeastOnePhoto ) {
				displayPhotos( photoArray );
			}
		}


		public function loadTestPhotos():void {
			var image:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 013.JPG",0,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image);
			var image1:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 015.JPG",1,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image1);
			var image2:ImageIcon = new ImageIcon( "file:///Users/colin/Documents/dl/Nikhil birth 020.JPG",2,new String("linusconcepcion"),new String("2008-12-04"));// + files[i].nativePath );
			photoArray.addItem(image2);
			displayPhotos( photoArray );
		}

		
		public function loadPhotosFromDirectory():void {
			var myFile:File = new File();
			try
			{
			    directory.browseForDirectory("Select directory of photos");
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
		    			var image:ImageIcon = new ImageIcon( "file://" + files[i].nativePath, i,"test","2008-12-04" );
						image.setStyle("horizontalAlign","center");
						photoArray.addItem(image);
			     }
		    }
			displayPhotos( photoArray );
		}
				
		public function displayPhotos( thePhotoArray:ArrayCollection ):void {
			for(var i:uint=0; i<thePhotoArray.length; i++) {
				var vBox:VBox = new VBox();
				vBox.percentWidth=100;
				vBox.minHeight = 100;
	            vBox.setStyle("paddingLeft", 20);
	            vBox.setStyle("paddingRight", 20);
	            vBox.setStyle("paddingTop", 20);
	            vBox.setStyle("paddingBottom", 20);
				vBox.setStyle("color",0x000000);
				vBox.setStyle("backgroundColor",0x8EA4BE);
				vBox.setStyle("horizontalAlign","center");
//				vBox.setStyle("verticalAlign","top");
//				vBox.setStyle("margin","10");
				var label:mx.controls.Label = new mx.controls.Label();
				label.text = thePhotoArray[i].date + ' by ' + thePhotoArray[i].sender;
				label.setStyle("verticalAlign","top");
				photoIconsVBox.addChild( vBox );
				vBox.addChild( thePhotoArray[i] );
				vBox.addChild( label );
			} 			
		}
	}
}