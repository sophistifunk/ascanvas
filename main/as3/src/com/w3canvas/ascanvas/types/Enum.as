package com.w3canvas.ascanvas.types
{
	public interface Enum
	{
		function get defaultValue():String;
		function get values():Array;
		function contains(value:String):Boolean;
	}
}