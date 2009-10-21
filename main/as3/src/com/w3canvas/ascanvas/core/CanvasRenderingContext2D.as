package com.w3canvas.ascanvas.core
{

	public interface CanvasRenderingContext2D
	{
		/**
		 * back-reference to the canvas
		 */
		function get canvas():Canvas;

		/**
		 * push state on state stack
		 */
		function save():void;

		/**
		 * pop state stack and restore state
		 */
		function restore():void;

		//----------------------------------
		//  transformations (default transform is the identity matrix)
		//----------------------------------
		
		function scale(x:Number, y:Number):void;
		function rotate(angle:Number):void;
		function translate(x:Number, y:Number):void;
		function transform(m11:Number, m12:Number, m21:Number, m22:Number, dx:Number, dy:Number):void;
		function setTransform(m11:Number, m12:Number, m21:Number, m22:Number, dx:Number, dy:Number):void;

		//----------------------------------
		//  compositing
		//----------------------------------
		
		function get globalAlpha():Number;
		function set globalAlpha(value:Number):void; // (default 1.0)
		
		function get globalCompositeOperation():String;
		function set globalCompositeOperation(value:String):void; // (default source-over)

		//----------------------------------
		//  colors and styles
		//----------------------------------
		
		function get strokeStyle():*;
		function set strokeStyle(value:*):void; // (default black)
		
		function get fillStyle():*;
		function set fillStyle(value:*):void; // (default black)
		
		function createLinearGradient(x0:Number, y0:Number, x1:Number, y1:Number):CanvasGradient;
		function createRadialGradient(x0:Number, y0:Number, r0:Number, x1:Number, y1:Number, r1:Number):CanvasGradient;
		function createPattern(image:*, repetition:String):CanvasPattern;

		//----------------------------------
		//  line caps/joins
		//----------------------------------
		
		function get lineWidth():Number;
		function set lineWidth(value:Number):void; // (default 1)
		
		function get lineCap():String;
		function set lineCap(value:String):void; // "butt", "round", "square" (default "butt")
		
		function get lineJoin():String;
		function set lineJoin(value:String):void; // "round", "bevel", "miter" (default "miter")
		
		function get miterLimit():Number;
		function set miterLimit(value:Number):void; // (default 10)

		//----------------------------------
		//  shadows
		//----------------------------------
		
		function get shadowOffsetX():Number;
		function set shadowOffsetX(value:Number):void; // (default 0)
		
		function get shadowOffsetY():Number;
		function set shadowOffsetY(value:Number):void; // (default 0)
		
		function get shadowBlur():Number;
		function set shadowBlur(value:Number):void; // (default 0)
		
		function get shadowColor():String;
		function set shadowColor(value:String):void; // (default transparent black)

		//----------------------------------
		//  rects
		//----------------------------------
		
		function clearRect(x:Number, y:Number, w:Number, h:Number):void;
		function fillRect(x:Number, y:Number, w:Number, h:Number):void;
		function strokeRect(x:Number, y:Number, w:Number, h:Number):void;

		//----------------------------------
		//  path API
		//----------------------------------
		
		function beginPath():void;
		function closePath():void;
		function moveTo(x:Number, y:Number):void;
		function lineTo(x:Number, y:Number):void;
		function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void;
		function bezierCurveTo(cp1x:Number, cp1y:Number, cp2x:Number, cp2y:Number, x:Number, y:Number):void;
		function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, radius:Number):void;
		function rect(x:Number, y:Number, w:Number, h:Number):void;
		function arc(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, anticlockwise:Boolean):void;
		function fill():void;
		function stroke():void;
		function clip():void;
		function isPointInPath(x:Number, y:Number):Boolean;

		//----------------------------------
		//  text
		//----------------------------------
		
		function get font():String;
		function set font(value:String):void; // (default 10px sans-serif)
		
		function get textAlign():String;
		function set textAlign(value:String):void; // "start", "end", "left", "right", "center" (default: "start")
		
		function get textBaseline():String;
		function set textBaseline(value:String):void; // "top", "hanging", "middle", "alphabetic", "ideographic", "bottom" (default: "alphabetic")
		
		function fillText(text:String, x:Number, y:Number, maxWidth:Number=NaN):void;
		function strokeText(text:String, x:Number, y:Number, maxWidth:Number=NaN):void;
		function measureText(text:String):TextMetrics;

		//----------------------------------
		//  drawing images - hardcoded multimethod
		//----------------------------------
		
		function drawImage(... args):void;

		//----------------------------------
		//  pixel manipulation
		//----------------------------------
		
		function createImageData(... args):ImageData;
		function getImageData(sx:Number, sy:Number, sw:Number, sh:Number):ImageData;
		function putImageData(imagedata:ImageData, dx:Number, dy:Number, ... rest):void;








	}
}