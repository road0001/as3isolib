package eDpLib.events
{
	internal class ListenerHash
	{
		public var listeners:Array = [];
		
		public function addListener (listener:Function):void
		{
			if (!contains(listener))
				listeners.push(listener);
		}
		
		public function removeListener (listener:Function):void
		{
			if (contains(listener))
			{
				var i:int;
				var m:int = listeners.length;
				while (i < m)
				{
					if (listener == Function(listeners[i]))
						break;
					
					i++;
				}
				
				listeners.splice(i, 1);
			}
		}
		
		public function contains (listener:Function):Boolean
		{
			var func:Function;
			for each (func in listeners)
			{
				if (func == listener)
					return true;
			}
			
			return false;
		}
	}
}