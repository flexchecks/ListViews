/**=====================================
 *    ListViewsViewer - Version 1.0.0
 * =====================================
 * Unit Test:	ListViewsViewer_test
 *
 * Version 1.0.0:
 *		2016-03-28 by Scott Pelak.
 *		Created.   Used to display all List Views.
 */
public with sharing class ListViewsViewer {
	public static final Integer DEFAULT_COLUMNS = 3;	// Version 1.0.0: Created.

	public String columns {get;set;}	// Version 1.0.0: Created.

	public ListViewsViewer(){
		/**
		 * Version 1.0.0:
		 *  	Created.  Sets columns as DEFAULT_COLUMNS's String Value.
		 */
		this.columns = String.valueOf(DEFAULT_COLUMNS);
	}

	public class Description implements Comparable {
		/**
		 * Version 1.0.0:
		 *  	Created.  Holds Schema.DescribeSObjectResult as description.
		 *		Compareable to sort by description's Label.
		 */
		public Schema.DescribeSObjectResult description {get;set;}	// Version 1.0.0: Created.

		public Description(Schema.DescribeSObjectResult description){
			/**
			 * Version 1.0.0:
			 *  	Created.  Sets description.
			 */
			this.description = description;
		}

		public Integer compareTo(Object thatObject){
			/**
			 * Version 1.0.0:
			 *  	Created.  Sorts by description's Label.
			 */
			Description that = (Description) thatObject;
			return this.description.getLabel().compareTo(that.description.getLabel());
		}
	}

	public Description[] getDescriptions(){
		/**
		 * Version 1.0.0:
		 *  	Created.  Sets descriptionMap as new Map: String --> Schema.DescribeSObjectResult.
		 *		For each Schema.DescribeSObjectResult in Schema's Global Describe's Values,
		 *			puts (description's Name, description) into descriptionMap if description's Key Prefix is not blank.
		 *		Sets descriptions as descriptionMap's Values.
		 *		Sorts descrtiptions.
		 *		Returns descriptions.
		 */
		Map<String, Description> descriptionMap = new Map<String, Description>();
		for(SObjectType sObjectType : Schema.getGlobalDescribe().values()){
			Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
			Object putResult = describeResult.isAccessible() && describeResult.isSearchable() && String.isNotBlank(describeResult.getKeyPrefix()) ? descriptionMap.put(describeResult.getName(), new Description(describeResult)) : null;
		}
		Description[] descriptions = descriptionMap.values();
		descriptions.sort();
		return descriptions;
	}

	public Description[] getDescriptionsForColumns(){
		/**
		 * Version 1.0.0:
		 *  	Created.  Sets sortedDescriptions as Descriptions.
		 *		If columns is not null, sets columns as columns replacing all non-digits with ''.
		 *		If columns is blank, sets columns as DEFAULT_COLUMNS's String Value.
		 *		Sets Integer columns as the columns' Integer Value.
		 *		Sets size as sortedDescription's Size.
		 *		Sets minRowCount as the floor of size / columns' Int Value.
		 *		Sets remainder as the mod of size and columns.
		 *		Sets columnStatingIndicies as a new list of Integers.
		 *		Sets row and column as 0,
		 *		While row is less than size:
		 *			- Adds row to columnStartingIndicies
		 *			- Adds minRowCount to row
		 *			- Adds 1 to row if column is less than remainder
		 *			- Adds 1 to column
		 *		Sets descriptionForColumns and notDescriptions as new lists of Descriptions.
		 *		For each i from 0 to minRowCount:
		 *			- For each startingIndex in columnStartingIndicies:
		 *				~ Sets index as startingIndex + i
		 *				~ Adds sortedDescription at index to descriptionsForColumns if index is less than size
		 *		Returns descriptionsForColumns.
		 */
		Description[] sortedDescriptions = this.getDescriptions();

		this.columns = this.columns == null ? null : this.columns.replaceAll('\\D', '');
		this.columns = String.isBlank(this.columns) ? String.valueOf(DEFAULT_COLUMNS) : this.columns;

		Integer columns = Integer.valueOf(this.columns);
		Integer size = sortedDescriptions.size();
		Integer minRowCount = Math.floor(size / columns).intValue();
		Integer remainder = Math.mod(size, columns);

		Integer[] columnStartingIndicies = new Integer[]{};
		Integer row = 0;
		Integer column = 0;
		while(row < size){
			columnStartingIndicies.add(row);

			row += minRowCount;
			row += column < remainder ? 1 : 0;

			column ++;
		}

		Description[] descriptionsForColumns = new Description[]{};
		Description[] notDescriptions = new Description[]{};

		for(Integer i = 0; i < minRowCount + 1; i ++){
			for(Integer startingIndex : columnStartingIndicies){
				Integer index = startingIndex + i;
				Description[] descriptions = index < size ? descriptionsForColumns : notDescriptions;
				descriptions.add(index < size ? sortedDescriptions[index] : null);
			}
		}
		return descriptionsForColumns;
	}
}
