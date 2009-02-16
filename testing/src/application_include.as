// ActionScript file
	
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	/* import mx.managers.IDragManager;
	import mx.managers.IHistoryManager;
	import mx.managers.IPopUpManager; */
	
	//////////////////////////////////////////////////////////
	//	STATIC
	//////////////////////////////////////////////////////////
	
	private static var _isEventDispatcherHooked:Boolean = hookEventDispatcher();
	
	private static function hookEventDispatcher ():Boolean
	{
		UIComponent.mx_internal::dispatchEventHook = cairngormDispatchEventHook;
		
		return true;
	}
	
	private static function cairngormDispatchEventHook (evt:Event, uic:UIComponent):void
	{
		if (evt is CairngormEvent)
			CairngormEventDispatcher.getInstance().dispatchEvent(CairngormEvent(evt));
	}
	
	//////////////////////////////////////////////////////////
	//	POPUP & DRAG MANAGERS BOOTSTRAPPING FOR MODULES
	//////////////////////////////////////////////////////////
	
	//for more information see http://butterfliesandbugs.wordpress.com/2007/10/25/workaround-for-error-when-loading-popups-from-modules/
	/* private var _iDragMgr:IDragManager;
	private var _iHistoryMgr:IHistoryManager;
	private var _iPopUpMgr:IPopUpManager; */
	