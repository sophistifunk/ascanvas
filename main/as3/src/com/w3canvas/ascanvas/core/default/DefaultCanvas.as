package com.w3canvas.ascanvas.core.default
{
	import flash.errors.IllegalOperationError;
	import com.w3canvas.ascanvas.core.Canvas;

	/**
	 * Default impl of the drawing-related parts of W3Canvas - extend it, or use it as a delegate.
	 * @author josh
	 */
	public class DefaultCanvas implements Canvas
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function DefaultCanvas()
		{
		}

		//--------------------------------------------------------------------------
		//
		//  W3Canvas Impl
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  width
		//----------------------------------

		private var _width:Number;

		/**
		 * @inheritDoc
		 */
		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width=value;
		}

		//----------------------------------
		//  height
		//----------------------------------

		private var _height:Number;

		/**
		 * @inheritDoc
		 */
		public function get height():Number
		{
			return height;
		}

		public function set height(value:Number):void
		{
			_height=value;
		}

		//----------------------------------
		//  toDataUrl
		//----------------------------------

		/**
		 * @inheritDoc
		 */
		public function toDataUrl(type:String=null, ... args):String
		{
			throw new IllegalOperationError("not implemented");
		}

		//----------------------------------
		//  getContext
		//----------------------------------

		/**
		 * @inheritDoc
		 */
		public function getContext(contextId:String):*
		{
			throw new IllegalOperationError("not implemented");
		}
	}
}