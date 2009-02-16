package tests.commands
{
	import as3isolib.core.ClassFactory;
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.data.Map;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.renderers.AnimatedSceneLayoutRenderer;
	import as3isolib.display.scene.IsoScene;
	
	import as3isolibTestingApp.model.Model;
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class VariableTerrainHeightTest implements ICommand
	{
		private var mover:IsoBox;
		
		private var v:IsoView;
		
		public function execute (event:CairngormEvent):void
		{
			v = IsoView(event.data.view);
			if (v.stage)
				v.stage.addEventListener(KeyboardEvent.KEY_DOWN, app_keyboardEventHandler);
				
			var objScene:IsoScene = new IsoScene();
			
			var box:IsoBox;
			
			var mapXML:XML = Model.getInstance().map;
			var object:Object;
			var objects:XMLList = mapXML..objects.children();
			for each (object in objects)
			{
				box = new IsoBox();
				box.id = object.x + ", " + object.y;
				box.x = object.x;
				box.y = object.y;
				box.z = object.z;
				box.width = object.width;
				box.length = object.length;
				box.height = object.height;
				
				objScene.addChild(box);
			}
			
			var map:Map = new Map();
			map.cellSize = mapXML.cellSize;
			map.rows = mapXML.rows;
			map.cols = mapXML.cols;
			
			var mapData:Array = [];
			
			//now generate a 2D map array
			var child:IIsoDisplayObject;
			var tempArray:Array = objScene.children.slice();
			tempArray.sortOn(["x", "y", "z"], Array.NUMERIC);
			
			for each (child in tempArray)
			{
				var col:uint = Math.floor(child.x / map.cellSize);
				var row:uint = Math.floor(child.y / map.cellSize);
				
				if (mapData.length <= col)
					mapData.push([]);
				
				mapData[col].push(child);
			}
			
			map.data = mapData;
			
			mover = new IsoBox();
			mover.setSize(50, 50, 50);
			mover.isAnimated = true;
			mover.id = "mover";
			mover.moveTo(100, 0, 50);
			objScene.addChild(mover);
			
			//terrain
			var f:ClassFactory = new ClassFactory(AnimatedSceneLayoutRenderer);
			f.properties = {};
			
			objScene.layoutRenderer = f;
			
			v.addScene(objScene);
			v.render(true);	
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
		
		private function box_clickHandler (evt:ProxyEvent):void
		{
			/* var target:IsoBox = IsoBox(evt.target);
			
			//GTween.timingMode = GTween.FRAME;
			var tTime:Number = 0.125;
			
			var tween:GTween = new GTween(mover, tTime, {x:target.x, y:target.y});
			tween.addEventListener(Event.CHANGE, function (e:Object):void { v.render(true) }); */
		}
	}
}