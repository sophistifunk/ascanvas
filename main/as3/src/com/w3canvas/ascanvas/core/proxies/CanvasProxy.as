package com.w3canvas.ascanvas.core.proxies
{
	import com.w3canvas.ascanvas.core.Canvas;

	public class CanvasProxy
	{
		public static function forObject(o:*):Canvas
		{
			return o is Canvas ? o : new CanvasProxyInstance(o);
		}
	}
}