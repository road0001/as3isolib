package as3isolibTestingApp.view.mediators
{
	import as3isolibTestingApp.events.*;
	
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	
	import tests.Tests;
	
	public class ApplicationMediator extends EventDispatcher
	{
		private var view:As3isolib_TestingApplication;
		
		public function ApplicationMediator (target:IEventDispatcher)
		{
			view = As3isolib_TestingApplication(target);
			view.addEventListener(FlexEvent.APPLICATION_COMPLETE, view_applicationCompleteHandler);
		}
		
		private function view_applicationCompleteHandler (evt:FlexEvent):void
		{			
			var cEvt:CairngormEvent = new CairngormEvent(AppEvent.GET_APPLICATION_ASSETS);
			cEvt.data = {};//
			cEvt.data.callback = executeTests;
			cEvt.dispatch();
		}
		
		private function executeTests (... args):void
		{
			var cEvt:CairngormEvent = new CairngormEvent(Tests.VARIABLE_TERRAIN_HEIGHT_TEST);
			cEvt.data = {};
			cEvt.data.view = view.isoViewContainer.view;
			cEvt.dispatch();
		}
	}
}