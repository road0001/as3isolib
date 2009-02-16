package as3isolibTestingApp.controller
{
	import as3isolibTestingApp.controller.commands.GetApplicationAssetsCommand;
	import as3isolibTestingApp.events.AppEvent;
	
	import com.adobe.cairngorm.control.FrontController;
	
	import tests.Tests;
	import tests.commands.*;

	public class Controller extends FrontController
	{
		public function Controller ()
		{
			super();
			
			//COMMANDS
			addCommand(AppEvent.GET_APPLICATION_ASSETS, GetApplicationAssetsCommand);
			
			//TESTS
			addCommand(Tests.VARIABLE_TERRAIN_HEIGHT_TEST, VariableTerrainHeightTest);
		}
	}
}