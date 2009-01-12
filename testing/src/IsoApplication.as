package
{	
	import as3isolib.core.ClassFactory;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.renderers.DefaultViewRenderer;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.IsoOrientation;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.geom.transformations.DefaultIsometricTransformation;
	import as3isolib.geom.transformations.IsometricTransformation;
	import as3isolib.graphics.BitmapFill;
	import as3isolib.graphics.SolidColorFill;
	
	import com.gskinner.motion.GTween;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import gs.easing.Cubic;
	
	[SWF(frameRate="24", backgroundColor="#666666")] 
	public class IsoApplication extends Sprite
	{
		private var box:IsoBox;
		private var scene:IsoScene;
		private var g:IsoGrid;
		private var view:IsoView;
		
		private var s:uint = 50;
		private var numObj:uint = 100;
		
		private var l:Loader
		
		private var bitmap:Bitmap;
		
		public function IsoApplication ()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//IsoMath.transformationObject = new IsometricTransformation(20);
			//IsoMath.transformationObject = new DimetricTransformation();
			
			//load bitmap assets
			l = new Loader();
			l.load(new URLRequest("assets/gfx/textures/wood.jpg"));
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler); 	
		}
		
		private function loader_completeHandler (evt:Event):void
		{
			
			IEventDispatcher(evt.target).removeEventListener(Event.COMPLETE, loader_completeHandler);
			
			IsoMath.transformationObject = new DefaultIsometricTransformation();
			IsoMath.transformationObject = new IsometricTransformation();
			
			//scene
			scene = new IsoScene();
			//scene.layoutEnabled = false;
			
			g = new IsoGrid();
			g.id = "grid";
			g.setGridSize(s, s);
			//g.gridlines = new Stroke(0, 0xFFFFFF);
			g.cellSize = 25;
			//g.showOrigin = false;
			g.addEventListener(MouseEvent.CLICK, grid_mouseHandler);
			//scene.addChild(g);
			
			var f0:BitmapFill = new BitmapFill(l, IsoOrientation.XY);
			var f1:BitmapFill = new BitmapFill(l, IsoOrientation.YZ);
			var f2:BitmapFill = new BitmapFill(l, IsoOrientation.XZ);  
			
			var alphaFill:SolidColorFill = new SolidColorFill(0xFFFFFF, 0.25);
			
			box = new IsoBox();
			//box.renderAsOrphan = true
			box.id = "mover";
			//box.z = 100;
			//box.strokes = [new Stroke(5, 0xFFFFFF)];
			//box.fills = [f0, f1, f2];
			//box.setSize(50, 100, 75);
			//box.addEventListener(MouseEvent.ROLL_OVER, function (e:Event):void { box.container.filters = [new GlowFilter(0xFFFFFF, 0.5, 15, 15,10)]; });
			//box.addEventListener(MouseEvent.ROLL_OUT, function (e:Event):void { box.container.filters = []; });
			
			scene.addChild(box);
			
			var randomBox:IsoBox;
			var i:uint;
			while (i < numObj)
			{
				randomBox = new IsoBox();
				//randomBox.renderAsOrphan = true;
				randomBox.setSize(25, 25, 10 + Math.random() * 40);
				//randomBox.edges = [];
				//randomBox.fills = [alphaFill];
				
				var rX:Number = Math.random() * s * g.cellSize;
				var rY:Number = Math.random() * s * g.cellSize;
				
				var nX:int = Math.floor(rX / g.cellSize) * g.cellSize;
				var nY:int = Math.floor(rY / g.cellSize) * g.cellSize;
				var nZ:int = 0;//Math.max(25, Math.random() * 100);
				
				randomBox.moveTo(nX, nY, nZ);
				scene.addChild(randomBox);
				
				i++;
			}
			
			view = new IsoView();
			view.clipContent = false;
			view.viewRenderers = [new ClassFactory(DefaultViewRenderer)];//, new ClassFactory(ViewBoundsRenderer)];
			view.x = 100
			view.y = 50;
			view.setSize(800, 250);
			//view.addScene(scene);
			
			bitmap = new Bitmap();
			bitmap.x = 100;
			bitmap.y = 50;
			addChild(bitmap);
			
			//scene.layoutRenderer = factory;
			//scene.styleRenderers = [factory2];
			//scene.hostContainer = new Sprite(); //orphan the scene.container from the display list
			
			var s2:IsoScene = new IsoScene();
			s2.addChild(g);
			s2.render();
			view.addScene(s2);
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