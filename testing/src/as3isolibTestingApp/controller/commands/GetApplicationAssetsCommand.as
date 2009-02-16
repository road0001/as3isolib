package as3isolibTestingApp.controller.commands
{
	import as3isolibTestingApp.model.Model;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;

	public class GetApplicationAssetsCommand implements ICommand, IResponder
	{
		private var callback:Function;
		
		public function execute (event:CairngormEvent):void
		{
			if (event.data.hasOwnProperty("callback"))
				callback = event.data.callback as Function;
			
			var bl:BulkLoader = new BulkLoader(BulkLoader.getUniqueName());
			bl.addEventListener(BulkProgressEvent.COMPLETE, result);
			bl.addEventListener(BulkLoader.ERROR, fault);
			
			bl.add("assets/xml/map.xml", {id:"map"});
			
			bl.start();
		}
		
		public function result (data:Object):void
		{
			var bl:BulkLoader = BulkLoader(data.target);
			bl.removeEventListener(BulkProgressEvent.COMPLETE, result);
			bl.removeEventListener(BulkLoader.ERROR, fault);
			
			Model.getInstance().map = bl.getContent("map") as XML;
			
			if (callback)
				callback.call();
		}
		
		public function fault (info:Object):void
		{
		}
		
	}
}