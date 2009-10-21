package com.w3canvas.ascanvas.core.impl
{
	public class SolidColor
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		private var _color:uint = 0;
		private var _alpha:Number = 1;
		
		public function SolidColor(color:uint = 0x000000, alpha:Number = 1)
		{
			_color = color;
			_alpha = alpha;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters
		//
		//--------------------------------------------------------------------------
		
		public function get color():uint
		{
			return _color;
		}
		
		public function get alpha():Number
		{
			return _alpha;	
		}
		
		//--------------------------------------------------------------------------
		//
		//  Consts
		//
		//--------------------------------------------------------------------------
		
		public static const BLACK:SolidColor = new SolidColor();
	}
}