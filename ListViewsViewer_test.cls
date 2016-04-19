/**==========================================
 *    ListViewsViewer_test - Version 1.0.0
 * ==========================================
 * Unit Test:	ListViewsViewer_test
 *
 * Version 1.0.0:
 *		2016-03-28 by Scott Pelak.
 *		Created.  Tests ListViewsViewer with testViewer().
 */
@isTest
public class ListViewsViewer_test {

	@isTest
	public static void testViewer(){
		/**
		 * Version 1.0.0:
		 *  	Created.  Calls getDescriptionsForColumns() which executs all lines of code.
		 */
		
		// -------------------------------------------  Start Test  -------------------------------------------
		Test.startTest();
	
		ListViewsViewer viewer = new ListViewsViewer();

		ListViewsViewer.Description[] descriptions = viewer.getDescriptions();
		System.assertNotEquals(null, descriptions);

		ListViewsViewer.Description[] descriptionsForColumns = viewer.getDescriptionsForColumns();
		System.assertNotEquals(null, descriptionsForColumns);
	
		Test.stopTest();
		// -------------------------------------------  Stop Test  -------------------------------------------	
	}
}
