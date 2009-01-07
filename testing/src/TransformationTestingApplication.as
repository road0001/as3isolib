package
{
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.geom.transformations.IsometricTransformation;
	
	import flash.display.Sprite;

	public class TransformationTestingApplication extends Sprite
	{
		public function TransformationTestingApplication()
		{
			super();
			
			IsoMath.transformationObject = new IsometricTransformation();
			
			var pt:Pt = new Pt(10, 0, 5);
			
			IsoMath.isoToScreen(pt);
			IsoMath.screenToIso(pt);
		}
		
	}
}