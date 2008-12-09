package glitter
{
	import mx.controls.Label;

	public class LoadingMessage extends Label
	{
		public function LoadingMessage()
		{
			super();
			
		}
		
		public function startMessage( message:String ):void {
			this.text = message;
		}

		public function stopMessage( ):void {
			this.text = "";
		}
		
	}
}