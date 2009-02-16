package as3isolibTestingApp.view
{
	import as3isolib.display.IIsoView;
	import as3isolib.display.IsoView;
	
	import mx.core.UIComponent;

	public class IsoViewContainer extends UIComponent
	{
		private var isoView:IsoView;
		
		public function get view ():IIsoView
		{
			return isoView;
		}
		
		public function IsoViewContainer ()
		{
			super();
		}
		
		override protected function createChildren ():void
		{
			if (!isoView)
			{
				isoView = new IsoView();
				isoView.name = "view";
				addChild(isoView);
			}
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			isoView.setSize(unscaledWidth, unscaledHeight);
			isoView.render();
		}
	}
}