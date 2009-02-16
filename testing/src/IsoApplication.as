package
{	
	import as3isolib.core.ClassFactory;
	import as3isolib.core.IsoDisplayObject;
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.renderers.DefaultViewRenderer;
	import as3isolib.display.renderers.ViewBoundsRenderer;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoHexGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.IsoOrientation;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.geom.transformations.DefaultIsometricTransformation;
	import as3isolib.graphics.BitmapFill;
	import as3isolib.graphics.IFill;
	import as3isolib.graphics.IStroke;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.gskinner.motion.GTween;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import gs.easing.Cubic;
	
	[SWF(frameRate="24", backgroundColor="#666666")] 
	public class IsoApplication extends Sprite
	{
		private var box:IsoDisplayObject;
		private var scene:IsoScene;
		private var g:IsoGrid;
		private var view:IsoView;
		
		private var s:uint = 25;
		private var numObj:uint = 50;
		
		private var assetLoader:BulkLoader
		
		private var bitmap:Bitmap;
		
		public function IsoApplication ()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//IsoMath.transformationObject = new IsometricTransformation(20);
			//IsoMath.transformationObject = new DimetricTransformation();
			
			//load bitmap assets
			assetLoader = new BulkLoader("assetLoader");
			assetLoader.add("assets/rsl/assetsManifest.xml", {id:"assetsManifest"});
			assetLoader.add("assets/rsl/assets.swf", {id:"assetsLib"});
			assetLoader.add("assets/gfx/textures/stoneFloor.jpg", {id:"stoneFloor"});
			assetLoader.addEventListener(BulkProgressEvent.COMPLETE, assetLoader_completeHandler);
			assetLoader.addEventListener(BulkLoader.ERROR, assetsLoader_errorHandler);
			assetLoader.start();
		}
		
		private function assetsLoader_errorHandler (evt:Event):void
		{
			
		}
		
		private function assetLoader_completeHandler (evt:Event):void
		{
			
			assetLoader.removeEventListener(BulkProgressEvent.COMPLETE, assetLoader_completeHandler);
			
			var lib:DisplayObject = assetLoader.getContent("assetsLib");
			
			IsoMath.transformationObject = new DefaultIsometricTransformation();
			//IsoMath.transformationObject = new IsometricTransformation();
			
			//scene
			scene = new IsoScene();
			//scene.layoutEnabled = false;
			
			g = new IsoHexGrid();
			g.id = "grid";
			g.setGridSize(60, 60);
			g.gridlines = new Stroke(0, 0x0000FF, 1);
			g.cellSize = 50;
			//g.showOrigin = false;
			g.addEventListener(MouseEvent.CLICK, grid_mouseHandler);
			//scene.addChild(g);
			
			var alphaFill:SolidColorFill = new SolidColorFill(0xFF0000, 0.25);
			
			var targetObj:IsoBox = new IsoBox();
			targetObj.id = "mover";
			targetObj.setSize(50, 50, 30);
			
			//assetLoader.x = -50;
			//assetLoader.y = -1 * assetLoader.height + 50;
			
			box = targetObj;
			scene.addChild(box);
			
			var stone:IFill = new BitmapFill(assetLoader.getContent("stoneFloor"), IsoOrientation.XY, new Matrix(1.25, 0, 0, 1.25), null, false);
			var blankStroke:IStroke = new Stroke(0, 0, 0);
			
			var s2:IsoScene = new IsoScene();
			s2.layoutEnabled = false;
			
			var tileSize:Number = 500;
			
			var i:uint;
			var j:uint;
			var m:uint = Math.floor(g.gridSize[0] * g.cellSize / tileSize);
			while (j < m)
			{
				i = 0;
				while (i < m)
				{
					var tile:IsoRectangle = new IsoRectangle();
					tile.setSize(tileSize, tileSize, 0);
					tile.moveTo(i * tileSize, j * tileSize, 0);
					tile.fills = [stone];
					tile.strokes = [blankStroke];
					
					s2.addChild(tile);
					
					i++;
				}
				
				j++;
			}
			
			s2.render();
			
			var skinClass:Class;
			skinClass = lib.loaderInfo.applicationDomain.getDefinition("Alter000") as Class;
				
			var randomBox:IsoSprite;
			i = 0;
			while (i < numObj)
			{
				randomBox = new IsoSprite();
				//randomBox.renderAsOrphan = true;
				randomBox.setSize(g.cellSize, g.cellSize, 0);
				//randomBox.edges = [];
				randomBox.sprites = [skinClass];
				randomBox.container.mouseChildren = false;
				//randomBox.
				
				var rX:Number = Math.random() * s * g.cellSize;
				var rY:Number = Math.random() * s * g.cellSize;
				
				var nX:int = Math.floor(rX / g.cellSize) * g.cellSize;
				var nY:int = Math.floor(rY / g.cellSize) * g.cellSize;
				var nZ:int = 0;//Math.max(25, Math.random() * 100);
				
				randomBox.moveTo(nX, nY, nZ);
				scene.addChild(randomBox);
				
				i++;
			}
			
			var f:ClassFactory = new ClassFactory(DefaultViewRenderer);
			f.properties = {};
			f.properties.scenes = [scene];
			
			view = new IsoView();
			view.clipContent = false;
			view.viewRenderers = [f, new ClassFactory(ViewBoundsRenderer)];
			view.x = 100
			view.y = 50;
			view.setSize(800, 250);
			//view.zoom(0.75);
			//view.addScene(scene);
			
			bitmap = new Bitmap();
			bitmap.x = 100;
			bitmap.y = 50;
			addChild(bitmap);
			
			//scene.layoutRenderer = factory;
			//scene.styleRenderers = [factory2];
			//scene.hostContainer = new Sprite(); //orphan the scene.container from the display list
			
			var gridScene:IsoScene = new IsoScene();
			gridScene.addChild(g);
			
			view.addScene(s2);
			view.addScene(gridScene);
			view.addScene(scene);
			
			view.render(true);
			scene.render();
			
			addChild(view);
			
			tweenChangeHandler(new Event(""));
		}
		
		private function tweenChangeHandler (evt:Event):void
		{
			view.render(true);
		}
		
		private var gt:GTween;
		private var vt:GTween;
		
		private var vtPt:Pt;
		
		private function grid_mouseHandler (evt:ProxyEvent):void
		{
			var mEvt:MouseEvent = MouseEvent(evt.targetEvent);
			var pt:Pt = new Pt(mEvt.localX, mEvt.localY, 0);
			
			IsoMath.screenToIso(pt);
			
			
			pt.x = Math.floor(pt.x / g.cellSize) * g.cellSize;
			pt.y = Math.floor(pt.y / g.cellSize) * g.cellSize;			
			/* var randomBox:IsoBox = new IsoBox();
			randomBox.setSize(25, 25, Math.max(25, Math.random() * 100))
			randomBox.moveTo(pt.x, pt.y, 0);
			scene.addChild(randomBox); */
			
			vtPt = IsoMath.isoToScreen(new Pt(pt.x, pt.y, pt.z));
			
			if (vt)
				vt.pause();
			
			else
			{
				
				vt = new GTween(view, 1.5);
				vt.autoPlay = false;
				vt.transitionFunction = gs.easing.Cubic.easeInOut;
				vt.addEventListener(Event.CHANGE, tweenChangeHandler);
				//vt.addEventListener(Event.CHANGE, function (e:Event):void { view.render(true); });
				vt.addEventListener(Event.COMPLETE, function (e:Event):void { trace(view.currentPt.toString()); }); 
			}
			
			vt.setProperties({currentX:vtPt.x, currentY:vtPt.y});
			vt.play();
			
			//view.centerOnPt(vtPt, false);
			
			if (gt)
				gt.pause();
			
			else
			{
				gt = new GTween();
				//gt.nextTween = vt;
				gt.transitionFunction = gs.easing.Cubic.easeOut;
				//gt.addEventListener(Event.CHANGE, tweenChangeHandler);
				//gt.addEventListener(Event.CHANGE, function (e:Event):void { view.render(true); });
				//gt.addEventListener(Event.CHANGE, function (evt:Event):void { scene.render() });
				//gt.addEventListener(Event.COMPLETE, function (evt:Event):void { trace("gt complete") });
			}
			
			gt.target = box;
			gt.duration = 1.5;
			gt.setProperties({x:pt.x, y:pt.y});
			gt.play();
		}
		
		private function getRandomTheta ():Number
		{
			return 0.5 + Math.random() * 3;
		}
	}
}