package com.w3canvas.ascanvas.core.impl
{
    import com.w3canvas.ascanvas.core.Canvas;
    import com.w3canvas.ascanvas.core.CanvasGradient;
    import com.w3canvas.ascanvas.core.CanvasPattern;
    import com.w3canvas.ascanvas.core.CanvasRenderingContext2D;
    import com.w3canvas.ascanvas.core.ImageData;
    import com.w3canvas.ascanvas.core.TextMetrics;
    import com.w3canvas.ascanvas.types.CanvasTypes;

    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Matrix;
    import flash.geom.Point;

    public class DefaultRenderingContext implements CanvasRenderingContext2D
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        public function DefaultRenderingContext(canvas:Canvas, owner:*=null)
        {
            _canvas = canvas;
            _self = owner; //TODO: Add RenderingContextProxy support
        }

        //--------------------------------------------------------------------------
        //
        //  Internals
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  owning canvas
        //----------------------------------

        private var _canvas:Canvas;

        //----------------------------------
        //  "this" proxy
        //----------------------------------

        private var _self:CanvasRenderingContext2D;

        protected function get self():CanvasRenderingContext2D
        {
            return _self == null ? this : _self;
        }

        //----------------------------------
        //  sprite
        //----------------------------------

        protected var renderSprite:Sprite = new Sprite();

        //----------------------------------
        //  validation / invalidation
        //----------------------------------

        /**
         * Invalidate transform matrix.
         */
        protected function invalidateTransformMatrix():void
        {
            renderSprite.transform.matrix = transformMatrix.clone();
        }

        private function invalidateActualStrokeStyle():void
        {
            _actualStrokeStyle = null;
        }

        //--------------------------------------------------------------------------
        //
        //  CanvasRenderingContext2D impl
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  owning canvas
        //----------------------------------

        public function get canvas():Canvas
        {
            return _canvas;
        }

        //----------------------------------
        //  state stack
        //----------------------------------

        public function save():void
        {
            throw new IllegalOperationError("not implemented");
        }

        public function restore():void
        {
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  transformations
        //----------------------------------

        private var transformMatrix:Matrix = new Matrix();

        public function scale(x:Number, y:Number):void
        {
            transformMatrix.a *= x;
            transformMatrix.d *= y;

            invalidateTransformMatrix();
        }

        public function rotate(angle:Number):void
        {
            var sin:Number = Math.sin(angle);
            var cos:Number = Math.cos(angle);
            var a:Number = transformMatrix.a;
            var c:Number = transformMatrix.c;

            transformMatrix.a = a * cos - transformMatrix.b * sin;
            transformMatrix.b = a * sin + transformMatrix.b * cos;
            transformMatrix.c = c * cos - transformMatrix.d * sin;
            transformMatrix.d = c * sin + transformMatrix.d * cos;

            invalidateTransformMatrix();
        }

        public function translate(x:Number, y:Number):void
        {
            var p:Point = transformMatrix.deltaTransformPoint(new Point(x, y));
            transformMatrix.tx += p.x;
            transformMatrix.ty += p.y;

            invalidateTransformMatrix();
        }

        public function transform(m11:Number, m12:Number, m21:Number, m22:Number, dx:Number, dy:Number):void
        {
            transformMatrix.concat(new Matrix(m11, m12, m21, m22, dx, dy));
            invalidateTransformMatrix();
        }

        public function setTransform(m11:Number, m12:Number, m21:Number, m22:Number, dx:Number, dy:Number):void
        {
            transformMatrix.identity();
            transformMatrix.concat(new Matrix(m11, m12, m21, m22, dx, dy));
        }

        //----------------------------------
        //  global alpha for operations
        //----------------------------------

        private var _globalAlpha:Number = 1.0;

        public function get globalAlpha():Number
        {
            return _globalAlpha;
        }

        public function set globalAlpha(value:Number):void
        {
            _globalAlpha = value;
        }

        //----------------------------------
        //  composition mode
        //----------------------------------

        private var _globalCompositeOperation:String = CanvasTypes.COMPOSITE_OPERATIONS.defaultValue;

        public function get globalCompositeOperation():String
        {
            return _globalCompositeOperation;
        }

        public function set globalCompositeOperation(value:String):void
        {
            if (CanvasTypes.COMPOSITE_OPERATIONS.contains(value))
                _globalCompositeOperation = value;
        }

        //----------------------------------
        //  stroke style
        //----------------------------------

        private var _strokeStyle:* = "#000000";
        private var _actualStrokeStyle:* = SolidColor.BLACK;

        public function get strokeStyle():*
        {
            return _strokeStyle;
        }

        public function set strokeStyle(value:*):void
        {
            _strokeStyle = value;
            invalidateActualStrokeStyle();
        }

        //----------------------------------
        //  fill style
        //----------------------------------

        public function get fillStyle():*
        {
            return null;
        }

        public function set fillStyle(value:*):void
        {
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  Gradients
        //----------------------------------

        public function createLinearGradient(x0:Number, y0:Number, x1:Number, y1:Number):CanvasGradient
        {
            throw new IllegalOperationError("not implemented");
        }

        public function createRadialGradient(x0:Number, y0:Number, r0:Number, x1:Number, y1:Number, r1:Number):CanvasGradient
        {
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  patterns
        //----------------------------------

        public function createPattern(image:*, repetition:String):CanvasPattern
        {
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  line width
        //----------------------------------

        private var _lineWidth:Number = 1;

        public function get lineWidth():Number
        {
            return _lineWidth;
        }

        public function set lineWidth(value:Number):void
        {
            _lineWidth = value;
        }

        //----------------------------------
        //  line cap
        //----------------------------------

        private var _lineCap:String = CanvasTypes.LINE_CAPS.defaultValue;

        public function get lineCap():String
        {
            return _lineCap;
        }

        public function set lineCap(value:String):void
        {
            if (CanvasTypes.LINE_CAPS.contains(value))
                _lineCap = value;
        }

        //----------------------------------
        //  line join
        //----------------------------------

        public function get lineJoin():String
        {
            return null;
        }

        public function set lineJoin(value:String):void
        {
        }

        public function get miterLimit():Number
        {
            return 0;
        }

        public function set miterLimit(value:Number):void
        {
        }

        public function get shadowOffsetX():Number
        {
            return 0;
        }

        public function set shadowOffsetX(value:Number):void
        {
        }

        public function get shadowOffsetY():Number
        {
            return 0;
        }

        public function set shadowOffsetY(value:Number):void
        {
        }

        public function get shadowBlur():Number
        {
            return 0;
        }

        public function set shadowBlur(value:Number):void
        {
        }

        public function get shadowColor():String
        {
            return null;
        }

        public function set shadowColor(value:String):void
        {
        }

        public function clearRect(x:Number, y:Number, w:Number, h:Number):void
        {
        }

        public function fillRect(x:Number, y:Number, w:Number, h:Number):void
        {
        }

        public function strokeRect(x:Number, y:Number, w:Number, h:Number):void
        {
        }

        public function beginPath():void
        {
        }

        public function closePath():void
        {
        }

        public function moveTo(x:Number, y:Number):void
        {
        }

        public function lineTo(x:Number, y:Number):void
        {
        }

        public function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void
        {
        }

        public function bezierCurveTo(cp1x:Number, cp1y:Number, cp2x:Number, cp2y:Number, x:Number, y:Number):void
        {
        }

        public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, radius:Number):void
        {
        }

        public function rect(x:Number, y:Number, w:Number, h:Number):void
        {
        }

        public function arc(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, anticlockwise:Boolean):void
        {
        }

        public function fill():void
        {
        }

        public function stroke():void
        {
        }

        public function clip():void
        {
        }

        public function isPointInPath(x:Number, y:Number):Boolean
        {
            return false;
        }

        public function get font():String
        {
            return null;
        }

        public function set font(value:String):void
        {
        }

        public function get textAlign():String
        {
            return null;
        }

        public function set textAlign(value:String):void
        {
        }

        public function get textBaseline():String
        {
            return null;
        }

        public function set textBaseline(value:String):void
        {
        }

        public function fillText(text:String, x:Number, y:Number, maxWidth:Number=NaN):void
        {
        }

        public function strokeText(text:String, x:Number, y:Number, maxWidth:Number=NaN):void
        {
        }

        public function measureText(text:String):TextMetrics
        {
            return null;
        }

        public function drawImage(... args):void
        {
        }

        public function createImageData(... args):ImageData
        {
            return null;
        }

        public function getImageData(sx:Number, sy:Number, sw:Number, sh:Number):ImageData
        {
            return null;
        }

        public function putImageData(imagedata:ImageData, dx:Number, dy:Number, ... rest):void
        {
        }
    }
}