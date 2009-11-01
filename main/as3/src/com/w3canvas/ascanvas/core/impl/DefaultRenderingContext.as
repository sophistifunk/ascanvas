package com.w3canvas.ascanvas.core.impl
{
    import com.w3canvas.ascanvas.core.CSSColor;
    import com.w3canvas.ascanvas.core.Canvas;
    import com.w3canvas.ascanvas.core.CanvasGradient;
    import com.w3canvas.ascanvas.core.CanvasPattern;
    import com.w3canvas.ascanvas.core.CanvasRenderingContext2D;
    import com.w3canvas.ascanvas.core.ImageData;
    import com.w3canvas.ascanvas.core.TextMetrics;
    import com.w3canvas.ascanvas.types.CanvasTypes;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.CapsStyle;
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.JointStyle;
    import flash.display.Shape;
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

            canvasBitmap = new Bitmap();
            bufferSprite = new Sprite();
        }

        //--------------------------------------------------------------------------
        //
        //  Internals
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  Main child sprite
        //----------------------------------

        private var canvasBitmap:Bitmap;

        public function get displayObject():DisplayObject
        {
            return canvasBitmap;
        }

        //----------------------------------
        //  Buffer sprite
        //----------------------------------

        private var bufferSprite:Sprite;

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
        {; // Nothing for now
        }

        private function invalidateStrokeStyle():void
        {; // Nothing for now
        }

        private function invalidateFillStyle():void
        {; // Nothing for now
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

        private var _strokeStyle:* = CSSColor.BLACK;

        public function get strokeStyle():*
        {
            return _strokeStyle;
        }

        public function set strokeStyle(value:*):void
        {
            if (value is CanvasPattern || value is CanvasGradient)
            {
                _strokeStyle = value;
                invalidateStrokeStyle();
            }
            else if (value is String)
            {
                var parsed:CSSColor = CSSColor.from(value);
                if (parsed)
                {
                    _strokeStyle = parsed;
                    invalidateStrokeStyle();
                }
            }
        }

        //----------------------------------
        //  fill style
        //----------------------------------

        private var _fillStyle:* = CSSColor.BLACK;

        public function get fillStyle():*
        {
            return _fillStyle.toString();
        }

        public function set fillStyle(value:*):void
        {
            if (value is CanvasPattern || value is CanvasGradient)
            {
                _fillStyle = value;
                invalidateFillStyle();
            }
            else if (value is String)
            {
                var parsed:CSSColor = CSSColor.from(value);
                if (parsed)
                {
                    _fillStyle = parsed;
                    invalidateFillStyle();
                }
            }
        }

        //----------------------------------
        //  Gradients
        //----------------------------------

        public function createLinearGradient(x0:Number, y0:Number, x1:Number, y1:Number):CanvasGradient
        {
            //TODO!
            throw new IllegalOperationError("not implemented");
        }

        public function createRadialGradient(x0:Number, y0:Number, r0:Number, x1:Number, y1:Number, r1:Number):CanvasGradient
        {
            //TODO!
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  patterns
        //----------------------------------

        public function createPattern(image:*, repetition:String):CanvasPattern
        {
            //TODO!
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
            if (!isNaN(value))
            {
                _lineWidth = value;
            }
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
            {
                _lineCap = value;
            }
        }

        //----------------------------------
        //  line join
        //----------------------------------

        private var _lineJoin:String = CanvasTypes.LINE_JOINS.defaultValue;

        public function get lineJoin():String
        {
            return _lineJoin;
        }

        public function set lineJoin(value:String):void
        {
            if (CanvasTypes.LINE_JOINS.contains(value))
            {
                _lineJoin = value;
            }
        }

        //----------------------------------
        //  miters
        //----------------------------------

        private var _miterLimit:Number = 10;

        public function get miterLimit():Number
        {
            return _miterLimit;
        }

        public function set miterLimit(value:Number):void
        {
            if (!isNaN(value))
            {
                _miterLimit = value;
            }
        }

        //----------------------------------
        //  Shadows
        //----------------------------------

        private var _shadowOffsetX:Number = 0;

        public function get shadowOffsetX():Number
        {
            return _shadowOffsetX;
        }

        public function set shadowOffsetX(value:Number):void
        {
            if (!isNaN(value))
            {
                _shadowOffsetX = value;
            }
        }

        private var _shadowOffsetY:Number = 0;

        public function get shadowOffsetY():Number
        {
            return _shadowOffsetY;
        }

        public function set shadowOffsetY(value:Number):void
        {
            if (!isNaN(value))
            {
                _shadowOffsetY = value;
            }
        }

        private var _shadowBlur:Number = 0;

        public function get shadowBlur():Number
        {
            return _shadowBlur;
        }

        public function set shadowBlur(value:Number):void
        {
            if (!isNaN(value))
            {
                _shadowBlur = value;
            }
        }

        private var _shadowColor:CSSColor = CSSColor.TRANSPARENT_BLACK;

        public function get shadowColor():String
        {
            return _shadowColor.toString();
        }

        public function set shadowColor(value:String):void
        {
            var c:CSSColor = CSSColor.from(value);

            if (c)
                _shadowColor = c;
        }

        //----------------------------------
        //  Drawing
        //----------------------------------

        public function clearRect(x:Number, y:Number, w:Number, h:Number):void
        {
            //TODO! -- This will require some voodoo :)
            throw new IllegalOperationError("not implemented");
        }

        public function fillRect(x:Number, y:Number, w:Number, h:Number):void
        {
            var rect:Shape = new Shape();
            setFillStyleOf(rect.graphics);
            rect.graphics.drawRect(x, y, w, h);
            rect.graphics.endFill();
            canvasBitmap.bitmapData.draw(rect, transformMatrix, null, null);
        }

        public function strokeRect(x:Number, y:Number, w:Number, h:Number):void
        {
            var rect:Shape = new Shape();
            setLineStyleOf(rect.graphics);
            rect.graphics.drawRect(x, y, w, h);
            rect.graphics.endFill();
            canvasBitmap.bitmapData.draw(rect, transformMatrix, null, null); // ,state.clipping);
            flush();
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

        //--------------------------------------------------------------------------
        //
        //  Moved from original codebase
        //
        //--------------------------------------------------------------------------

        private function setFillStyleOf(bufferContext:Graphics):void
        {
            bufferContext.lineStyle(undefined);

            var fillResource;

            if (_fillStyle is CSSColor)
            {
                bufferContext.beginFill(_fillStyle.color, _fillStyle.alpha);
                return;
            }
//            else if (_fillStyle is LinearGradient)
//            {
//                var s2 = LinearGradient(fillResource);
//                bufferContext.beginGradientFill(GradientType.LINEAR, s2.colors, s2.alphas, s2.ratios, s2.matrix, s2.spreadMethod, s2.interpolationMethod, s2.focalPointRatio);
//            }
//            else if (_fillStyle is RadialGradient)
//            {
//                var s3 = RadialGradient(fillResource);
//                bufferContext.beginGradientFill(GradientType.RADIAL, s3.colors, s3.alphas, s3.ratios, s3.matrix, s3.spreadMethod, s3.interpolationMethod, s3.focalPointRatio);
//            }
//            else if (_fillStyle is CanvasPattern)
//            {
//                var s4 = CanvasPattern(fillResource);
//                bufferContext.beginBitmapFill(s4.patternFill);
//            }

            // TODO!
            throw new IllegalOperationError("not implemented");
        }

        private function setLineStyleOf(bufferContext:Graphics, pixelHinting:Boolean=true):void
        {
            var _lineJoin:String, _lineCap:String;

            if (lineJoin == 'round')
                _lineJoin = JointStyle.ROUND;
            else if (lineJoin == 'bevel')
                _lineJoin = JointStyle.BEVEL;
            else
                _lineJoin = JointStyle.MITER;

            if (lineCap == 'square')
                _lineCap = CapsStyle.SQUARE;
            else if (lineCap == 'round')
                _lineCap = CapsStyle.ROUND;
            else
                _lineCap = CapsStyle.NONE;

            if (_strokeStyle is CSSColor)
            {
                bufferContext.lineStyle(lineWidth, _strokeStyle.color, _strokeStyle.alpha, pixelHinting, "normal", _lineCap, _lineJoin, miterLimit);
                return;
            }
//            else if (_strokeStyle is LinearGradient)
//            {
//                var s2:* = LinearGradient(strokeResource);
//                bufferContext.lineGradientStyle(GradientType.LINEAR, s2.colors, s2.alphas, s2.ratios, s2.matrix, s2.spreadMethod, s2.interpolationMethod, s2.focalPointRatio);
//            }
//            else if (_strokeStyle is RadialGradient)
//            {
//                var s3:* = RadialGradient(strokeResource);
//                bufferContext.lineGradientStyle(GradientType.RADIAL, s3.colors, s3.alphas, s3.ratios, s3.matrix, s3.spreadMethod, s3.interpolationMethod, s3.focalPointRatio);
//            }
//            else if (_strokeStyle is CanvasPattern)
//            {
//                //				bufferContext.lineBitmapStyle( CanvasPattern(strokeResource), null, true, false); // Flash 10
//                //				bufferContext.beginBitmapFill(s4.patternFill);
//            }

            // TODO!
            throw new IllegalOperationError("not implemented");
        }

        private function flush():void
        {
            if (globalCompositeOperation == 'source-over')
                canvasBitmap.bitmapData.draw(bufferSprite);
            else
                compositeFlush();

            while (bufferSprite.numChildren)
                bufferSprite.removeChildAt(0);

            bufferSprite.graphics.clear();
        }

        private function compositeFlush():void
        {
            // TODO!
            throw new IllegalOperationError("not implemented");
            
//            var b:BitmapData = new BitmapData(canvasBitmap.bitmapData.width, canvasBitmap.bitmapData.height, true, 0x00000000);
//            b.draw(bufferSprite);
//            var compositerFactory = new CanvasCompositing();
//            var compositer:ICompositer = compositerFactory.GetCompositer('flashLogic');
//            var output:BitmapData = compositer.CompositeBitmap(state.globalCompositeOperation, canvasData, b);
//            canvasBitmap.bitmapData.copyPixels(output, new Rectangle(0, 0, canvasBitmap.bitmapData.width, canvasBitmap.bitmapData.height), new Point(0, 0));
        }
    }
}