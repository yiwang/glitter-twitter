package glitter
{
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;

	public class ApplicationController
	{
		private var appWindow:WindowedApplication;
		
		public function ApplicationController(appWindow:WindowedApplication)
		{
			this.appWindow = appWindow;
		}

		static public function startTwitterLoop()
		{
			
		}
		
		public function settingsButtonClick():void {
			var settingsWindow:AccountSettings = new AccountSettings();
			PopUpManager.addPopUp(settingsWindow, appWindow, true);
			PopUpManager.centerPopUp(settingsWindow);			
		}
	}
}