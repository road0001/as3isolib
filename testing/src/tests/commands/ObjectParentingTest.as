package tests.commands
{
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.IIsoView;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class ObjectParentingTest implements ICommand
	{
		
		private var v:IIsoView;
		private var mover:IIsoDisplayObject;
		
		public function execute (event:CairngormEvent):void
		{
			v = IIsoView(event.data);
			
			
			
		}	
		
		private function app_keyboardEventHandler (evt:KeyboardEvent):void
		{
			switch (evt.keyCode)
			{
				case Keyboard.UP:
				{
					if (evt.shiftKey)
						mover.moveBy(0, 0, 5);
					
					else
						mover.moveBy(0, -5, 0);
						
					break;
				}
				
				case Keyboard.DOWN:
				{
					if (evt.shiftKey)
						mover.moveBy(0, 0, -5);
					
					else
						mover.moveBy(0, 5, 0);
					
					break;
				}
				
				case Keyboard.LEFT:
				{
					mover.moveBy(-5, 0, 0);
					break;
				}
				
				case Keyboard.RIGHT:
				{
					mover.moveBy(5, 0, 0);
					break;
				}
			}
			
			if (mover.isInvalidated)
			{
				v.render(true);
				trace(mover.x, mover.y, mover.z);
			}			
		}
	}
}