package isoLib.primitive
{
	public class IsoCube extends IsoShape
	{
		protected var sq0:IsoSquare = new IsoSquare();
		protected var sq1:IsoSquare = new IsoSquare();
		protected var sq2:IsoSquare = new IsoSquare();
		protected var sq3:IsoSquare = new IsoSquare();
		protected var sq4:IsoSquare = new IsoSquare();
		protected var sq5:IsoSquare = new IsoSquare();
		
		public function IsoCube ()
		{			
			addChild(sq0);
			addChild(sq1);
			addChild(sq2);
			addChild(sq3);
			addChild(sq4);
			addChild(sq5);
		}
		
		override protected function pointLogic ():Boolean
		{
			return (isoWidth <= 0 && isoLength <= 0 && isoHeight <= 0)? false: true;
		}
		
		override protected function renderGeometry ():void
		{
			//bottom face
			sq0.isoWidth = isoWidth;
			sq0.isoLength = isoLength;
			
			//back-left face
			sq1.isoLength = isoLength;
			sq1.isoHeight = isoHeight;
			
			//back-right face
			sq2.isoWidth = isoWidth;
			sq2.isoHeight = isoHeight;
			
			//front-left face
			sq3.isoWidth = isoWidth;
			sq3.isoHeight = isoHeight;
			sq3.isoY = isoLength;
			
			//front-right face
			sq4.isoLength = isoLength;
			sq4.isoHeight = isoHeight;
			sq4.isoX = isoWidth;
			
			//top face
			sq5.isoWidth = isoWidth;
			sq5.isoLength = isoLength;
			sq5.isoZ = isoHeight;
			
			//now apply all common properties
			var sq:IsoSquare;
			var i:int;
			var l:int = numChildren;
			for (i; i < l; i++)
			{
				sq = IsoSquare(getChildAt(i));
				
				//styling
				sq.lineAlphas = [lineAlphas[i]];
				sq.lineColors = [lineColors[i]];
				sq.lineThicknesses = [lineThicknesses[i]];
				sq.faceAlphas = [faceAlphas[i]];
				sq.faceColors = [faceColors[i]];
				sq.type = type;
				
				sq.render();
			}			
		}
	}
}