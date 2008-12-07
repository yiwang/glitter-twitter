package glitter
{
	import mx.controls.LinkButton;
	import mx.controls.Text;

	public class HelpLinkButton extends LinkButton
	{
		
		public var targetText:Text;
		
		public function HelpLinkButton()
		{
			super();
			targetText = new Text();
		}
		
	}
}