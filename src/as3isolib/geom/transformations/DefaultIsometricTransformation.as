/*

as3isolib - An open-source ActionScript 3.0 Isometric Library developed to assist 
in creating isometrically projected content (such as games and graphics) 
targeted for the Flash player platform

http://code.google.com/p/as3isolib/

Copyright (c) 2006 - 2008 J.W.Opitz, All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
package as3isolib.geom.transformations
{
	import as3isolib.geom.Pt;

	public class DefaultIsometricTransformation implements IAxonometricTransformation
	{
		/**
		 * Constructor
		 */
		public function DefaultIsometricTransformation (projectValuesToAxonometricAxes:Boolean = false):void
		{
			bAxonometricAxesProjection = projectValuesToAxonometricAxes;
		}
		
		private var bAxonometricAxesProjection:Boolean;
		private var theta:Number = Math.atan(0.5);
		
		/**
		 * @inheritDoc
		 */
		public function screenToSpace (screenPt:Pt):Pt
		{
			var z:Number = screenPt.z;
			var y:Number = screenPt.y - screenPt.x / 2 + screenPt.z;
			var x:Number = screenPt.x / 2 + screenPt.y + screenPt.z;
			
			if (bAxonometricAxesProjection)
			{
				x = x / Math.cos(theta);
				y = y / Math.cos(theta);
			}
			
			return new Pt(x, y, z);
		}
		
		/**
		 * @inheritDoc
		 */
		public function spaceToScreen (spacePt:Pt):Pt
		{
			if (bAxonometricAxesProjection)
			{
				spacePt.x = spacePt.x * Math.cos(theta);
				spacePt.y = spacePt.y * Math.cos(theta);
			}
			
			var z:Number = spacePt.z;
			var y:Number = (spacePt.x + spacePt.y) / 2 - spacePt.z;
			var x:Number = spacePt.x - spacePt.y;
			
			return new Pt(x, y, z);
		}
	}
}