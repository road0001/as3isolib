package as3isolib.display.renderers
{
	import as3isolib.bounds.IBounds;
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.scene.IIsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class AnimatedSceneLayoutRenderer implements ISceneLayoutRenderer
	{		
		////////////////////////////////////////////////////
		//	MAP PROPS
		////////////////////////////////////////////////////
		
		public var cellSize:Number = 50;
		
		////////////////////////////////////////////////////
		//	PRE SORT
		////////////////////////////////////////////////////
		
		static private var presortedScenes:Dictionary = new Dictionary(true);
		
		////////////////////////////////////////////////////
		//	RENDER SCENE
		////////////////////////////////////////////////////
		
		private var isoScene:IIsoScene;
		
		/**
		 * @inheritDoc
		 */
		public function renderScene (scene:IIsoScene):void
		{
			isoScene = scene;
			
			var animatedChildren:Array = [];
			var children:Array = isoScene.displayListChildren.slice();
			
			//separate animated children
			var i:uint;
			var child:IIsoDisplayObject;
			for each (child in children)
			{
				child.distance = Pt.distance(child.isoBounds.centerPt, IsoMath.isoCamera) * -1;
				
				if (child.isAnimated)
				{
					i = children.indexOf(child);
					children.splice(i, 1);
					
					animatedChildren.push(child);
				}
			}
			
			//parent animated children to static children
			var animated:IIsoDisplayObject;
			for each (animated in animatedChildren)
			{
				var pt:Pt = new Pt(animated.x + animated.width - 1, animated.y + animated.length - 1, animated.z);
				var r:Rectangle
				var targetParent:IIsoDisplayObject = null;
				
				for each (child in children)
				{
					r = new Rectangle(child.x, child.y, child.width, child.length);
					if (r.containsPoint(pt))
						targetParent = child;
				}
				
				//BAD OOP!!!!
				if (targetParent)
				{
					if (animated.container.parent)
						animated.container.parent.removeChild(animated.container);
					
					targetParent.container.addChild(animated.container);
					
					var tx:Number = animated.x - targetParent.x;
					var ty:Number = animated.y - targetParent.y;
					var tz:Number = animated.z;
					
					pt = IsoMath.isoToScreen(new Pt(tx, ty, tz));
					
					animatedChildren.splice(animatedChildren.indexOf(animated), 1);
				}
				
				else
				{
					if (animated.container.parent != scene.container)
						scene.container.addChild(animated.container);
					
					if (children.indexOf(animated) == -1)
						children.push(animated);
					
					pt = IsoMath.isoToScreen(new Pt(animated.x, animated.y, animated.z));
				}
				
				animated.container.x = pt.x;
				animated.container.y = pt.y;
			}
			
			//sort stationary objects
			children = children.concat(animatedChildren);
			children.sortOn(["distance"], Array.NUMERIC);
			
			i = 0;
			var m:uint = children.length;
			while (i < m)
			{
				child = IIsoDisplayObject(children[i]);
				if (child.depth != i)
					isoScene.setChildIndex(child, i);
				
				i++;
			}		
		}
		
		////////////////////////////////////////////////////
		//	SORT
		////////////////////////////////////////////////////
		
		private function isoDepthSort (childA:Object, childB:Object):int
		{
			var boundsA:IBounds = childA.isoBounds;
			var boundsB:IBounds = childB.isoBounds;
			
			if (boundsA.right <= boundsB.left)
				return -1;
				
			else if (boundsA.left >= boundsB.right)
				return 1;
			
			else if (boundsA.front <= boundsB.back)
				return -1;
				
			else if (boundsA.back >= boundsB.front)
				return 1;
				
			else if (boundsA.top <= boundsB.bottom)
				return -1;
				
			else if (boundsA.bottom >= boundsB.top)
				return 1;
			
			else
				return 0;
		}
	}
}