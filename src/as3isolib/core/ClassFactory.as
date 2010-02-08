////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package as3isolib.core
{
	import mx.core.ClassFactory;
	import mx.core.IMXMLObject;
	
	/**
	 *  A ClassFactory instance is a "factory object" which Flex uses
	 *  to generate instances of another class, each with identical properties.
	 *
	 *  <p>You specify a <code>generator</code> class when you construct
	 *  the factory object.
	 *  Then you set the <code>properties</code> property on the factory object.
	 *  Flex uses the factory object to generate instances by calling
	 *  the factory object's <code>newInstance()</code> method.</p>
	 *
	 *  <p>The <code>newInstance()</code> method creates a new instance
	 *  of the <code>generator</code> class, and sets the properties specified
	 *  by <code>properties</code> in the new instance.
	 *  If you need to further customize the generated instances,
	 *  you can override the <code>newInstance()</code> method.</p>
	 *
	 *  <p>The ClassFactory class implements the IFactory interface.
	 *  Therefore it lets you create objects that can be assigned to properties 
	 *  of type IFactory.</p>
	 */
	public class ClassFactory extends mx.core.ClassFactory implements IMXMLObject
	{
		/**
		 * Constructor
		 */
		public function ClassFactory (generator:Class = null)
		{
			super(generator);
		}
		
		public var document:Object;
		public var id:String;
		
		/**
		 * @inheritDoc
		 */
		public function initialized (document:Object, id:String):void
		{
			this.document = document;
			this.id = id;
		}
	}
}