package com.w3canvas.ascanvas.types
{
	import flash.errors.IllegalOperationError;

	internal class StringEnum implements Enum
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StringEnum(...values)
		{
			_values = values; 
		}
		
		//--------------------------------------------------------------------------
		//
		//  Enum Impl
		//
		//--------------------------------------------------------------------------
		
		private var _defaultValue:String;
		
		public function get defaultValue():String
		{
			return _defaultValue;
		}
		
		private var _values:Array = [];
		
		public function get values():Array
		{
			return _values.concat();
		}
		
		public function contains(value:String):Boolean
		{
			return _values.indexOf(value) >= 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Helper methods
		//
		//--------------------------------------------------------------------------
		
		public function withDefault(value:String):Enum
		{
			if (!contains(value))
				throw new IllegalOperationError("Default specified (" + value + ") isn't in list.");
			
			_defaultValue = value;
			return this;
		}
	}
}