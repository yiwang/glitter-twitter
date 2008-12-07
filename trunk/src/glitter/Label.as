package glitter
{
	import mx.collections.ArrayCollection;
	
	public class Label
	{
		private var statuses:ArrayCollection;
		private var name:String;
		private var filters:ArrayCollection;
		
		public function Label(name:String)
		{
			this.name = name;
			statuses = new ArrayCollection();
		}
		
		public function addStatus(status:Status):void {
			statuses.addItem(status);
		}
		
		public function getStatuses():ArrayCollection {
			return statuses.sort();
		}
		
		public function getName():String {
			return name;
		}
		
		public function insertStatusesThatMatchFilters(statuses:ArrayCollection):void {
			for each (var status:Status in statuses) {
				for each (var filter:Filter in filters) {
					if (filter.statusMatchesFilter(status) {
						addStatus(status);
					}
				}
			}
		}
	}
}