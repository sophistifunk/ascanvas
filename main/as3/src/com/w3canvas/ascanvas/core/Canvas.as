package com.w3canvas.ascanvas.core
{
	public interface Canvas
	{
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function toDataUrl(type:String = null, ...args):String;
		
		function getContext(contextId:String):*;
	}
}