package as3isolibTestingApp.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	
	import flash.events.EventDispatcher;

	public class Model extends EventDispatcher implements IModelLocator
	{
		public var map:XML;
		
		//////////////////////////////////////////
		//	SINGLETON
		//////////////////////////////////////////
		
		static private var instance:Model;
		
		static public function getInstance ():Model
		{
			if (!instance)
				instance = new Model();
				
			return instance;
		}
		
		function Model ()
		{
			super();
		}

	}
}