package com.w3canvas.ascanvas.core.proxies
{
	import com.w3canvas.ascanvas.core.Canvas;
	
	internal class CanvasProxyInstance implements Canvas
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Don't call this, use CanvasProxy.forObject() instead
		 * @see CanvasProxy.forObject()
		 */
		function CanvasProxyInstance(target:*)
		{
			this.target = target;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internals
		//
		//--------------------------------------------------------------------------
		
		private var target:*;
		
		//--------------------------------------------------------------------------
		//
		//  Canvas API impl
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 */
		public function get width():Number
		{
			return target.width;
		}
		
		public function set width(value:Number):void
		{
			target.width = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get height():Number
		{
			return target.height;
		}
		
		public function set height(value:Number):void
		{
			target.height = value;
		}
		
		/**
		 * @inheritDoc 
		 */
		public function toDataUrl(type:String=null, ...args):String
		{
			(args = args.concat()).unshift(type);
			return target.toDataUrl.apply(target,args);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function getContext(contextId:String):*
		{
			return target.getContext(contextId);
		}
	}
}