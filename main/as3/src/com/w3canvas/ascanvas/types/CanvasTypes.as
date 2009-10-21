package com.w3canvas.ascanvas.types
{
	public class CanvasTypes
	{
		public static const LINE_CAPS:Enum = new StringEnum("butt", "round", "square").withDefault("butt");
		
		public static const COMPOSITE_OPERATIONS:Enum = new StringEnum("source-atop", "source-in", "source-out", "source-over", 
																	   "destination-atop", "destination-in", "destination-out", 
																	   "destination-over", "lighter", "copy", 
																	   "xor").withDefault("source-over");
		
		public static const LINE_JOINS:Enum = new StringEnum("round", "bevel", "miter").withDefault("miter");
	}
}