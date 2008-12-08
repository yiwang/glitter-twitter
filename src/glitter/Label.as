package glitter
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
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
//			var sortField:SortField = new SortField();
//			sortField.name = "getId";
//			sortField.numeric = true;
//			var sort:Sort = new Sort();
//			sort.reverse();
//			sort.fields = [sortField];
//			statuses.sort = sort;
//			statuses.refresh();
			return statuses;
		}
		
		public function getName():String {
			return name;
		}
		
		public function insertStatusesThatMatchFilters(statuses:ArrayCollection):void {
			for each (var status:Status in statuses) {
				for each (var filter:Filter in filters) {
					if (filter.statusMatchesFilter(status)) {
						addStatus(status);
					}
				}
			}
		}
	}
}