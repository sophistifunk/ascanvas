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
        //  Consts
        //
        //--------------------------------------------------------------------------

        //TODO: Refactor out to another class

        public static const NO_OP:Number = 0;
        public static const MOVE_TO:Number = 1;
        public static const LINE_TO:Number = 2;
        public static const CURVE_TO:Number = 3;
        public static const WIDE_MOVE_TO:Number = 4;
        public static const WIDE_LINE_TO:Number = 5;

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

//        //----------------------------------
//        //  sprite
//        //----------------------------------
//
//        protected var renderSprite:Sprite = new Sprite();

        //----------------------------------
        //  Path data
        //----------------------------------

        private var data:Vector.<Number> = new Vector.<Number>();
        private var commands:Vector.<int> = new Vector.<int>();
        private var points:Vector.<Point> = new Vector.<Point>();

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
            commands = new Vector.<int>();
            data = new Vector.<Number>();
            points = new Vector.<Point>();
        }

        public function closePath():void
        {
            if (points.length == 0)
                return;

            moveTo(cpx, cpy);
        }

        public function moveTo(x:Number, y:Number):void
        {
            var p:Point = new Point(x, y);
            points = new Vector.<Point>();
            points.push(p);

            if (useTransform)
                p = transformMatrix.transformPoint(p);

            data.push(p.x);
            data.push(p.y);
            commands.push(MOVE_TO);
        }

        public function lineTo(x:Number, y:Number):void
        {
            if (!points.length)
                return;

            var p:Point = new Point(x, y);
            points.push(p);

            if (useTransform)
                p = transformMatrix.transformPoint(p);

            data.push(p.x);
            data.push(p.y);
            commands.push(LINE_TO);
        }

        public function quadraticCurveTo(cp1x:Number, cp1y:Number, x:Number, y:Number):void
        {

            if (!points.length)
                return;

            if (useTransformSkew)
            {
                // Convert quadratic to cubic bezier -- is this unnecessary?
                var cp0:Point = new Point(cpx, cpy);
                var cp1:Point = new Point(cpx + (2 / 3 * (cp1x - cpx)), cpy + (2 / 3 * (cp1y - cpy)));
                var cp2:Point = new Point(cp1.x + (1 / 3 * (x - cpx)), cp1.y + (1 / 3 * (y - cpy)));
                var cp3:Point = new Point(x, y);
                bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, x, y);
                return;
            }
            if (useTransform)
            {
                var p:Point = transformMatrix.transformPoint(new Point(cp1x, cp1y));
                cp1x = p.x;
                cp1y = p.y;
                p = transformMatrix.transformPoint(new Point(x, y));
                x = p.x;
                y = p.y;
            };
            data.push(cp1x);
            data.push(cp1y);
            data.push(x);
            data.push(y);
            commands.push(CURVE_TO);
        }

        public function bezierCurveTo(cp1x:Number, cp1y:Number, cp2x:Number, cp2y:Number, x:Number, y:Number):void
        {
            var P0:Point = new Point(cpx, cpy);
            var P1:Point = new Point(cp1x, cp1y);
            var P2:Point = new Point(cp2x, cp2y);
            var P3:Point = new Point(x, y);

            if (useTransform)
            {
                P0 = transformMatrix.transformPoint(P0);
                P1 = transformMatrix.transformPoint(P1);
                P2 = transformMatrix.transformPoint(P2);
                P3 = transformMatrix.transformPoint(P3);
            }

            drawCubicBezier_midpoint(P0, P1, P2, P3);
        }

        // Pulled from the C# codebase

        public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, radius:Number):void
        {
            if (points.length == 0)
                return;

            if (radius < 0)
                throw new IllegalOperationError("Radius < 0");

            var x0:Number = cpx;
            var y0:Number = cpy;

            var p:Point;

            if (useTransform)
            {
                p = transformMatrix.transformPoint(new Point(x1, y1));
                x1 = p.x;
                y1 = p.y;

                p = transformMatrix.transformPoint(new Point(x2, y2));
                x2 = p.x;
                y2 = p.y;
            }

            if (radius == 0 || (x0 == x1 && y0 == y1) || (x1 == x2 && y1 == y2))
            {
                moveTo(x1, y1);
                lineTo(x0, y0);
                return;
            }

            //find angle between two lines (p0, p1) and (p1, p2)
            var v01:Point = new Point(x0 - x1, y0 - y1);
            var v12:Point = new Point(x2 - x1, y2 - y1);

            var cosA:Number = ((v01.x * v12.x + v01.y * v12.y) / (Math.sqrt(Math.pow(v01.x, 2) + Math.pow(v01.y, 2)) * Math.sqrt(Math.pow(v12.x, 2) + Math.pow(v12.y, 2))));
            var a:Number = Math.acos(cosA);

            if (Math.abs(a - Math.PI) < 0.00001 || a == 0)
            {
                //all three points are on the straight line
                moveTo(x1, y1);
                lineTo(x0, y0);
                return;
            }

            //find distance from point p1(x1, y1) to intersection with circle (arc)
            var d:Number = radius / Math.tan(a / 2);

            //tangent point of the line (p0, p1)
            var t01:Point = findTangentPoint(x1, y1, x0, y0, d);
            var t12:Point = findTangentPoint(x1, y1, x2, y2, d);
            lineTo(t01.x, t01.y);

            drawArcBetweenTwoPoints(t01.x, t01.y, t12.x, t12.y, radius, Math.PI - a);
            //from point (x0, y0) to t01            
            moveTo(t12.x, t12.y);
        }

        // Pulled from the C# codebase

        private function findTangentPoint(x1:Number, y1:Number, x0:Number, y0:Number, d:Number):Point
        {
            //find point on line (p0, p1) on distance d from point p
            var dx:Number = d * Math.abs(x0 - x1) / distanceBetween(new Point(x0, y0), new Point(x1, y1));
            var x:Number;
            if (x0 < x1)
            {
                //means x0 left from x1
                x = x1 - dx;
            }
            else //means x0 right from x1
            {
                x = x1 + dx;
            }
            var y:Number;
            var dy:Number = d * Math.abs(y0 - y1) / distanceBetween(new Point(x0, y0), new Point(x1, y1));
            if (y0 < y1)
            {
                //means y0 uppper y1
                y = y1 - dy;
            }
            else
            {
                //means y0 down y1
                y = y1 + dy;
            }
            return new Point(x, y);
        }

        // Pulled from the C# codebase

        private function drawArcBetweenTwoPoints(x1:Number, y1:Number, x2:Number, y2:Number, radius:Number, sweepAngle:Number):void
        {
            //define coordinates of center of circle
            //length of chord
            var l:Number = Math.sqrt(Math.pow((x1 - x2), 2) + Math.pow((y1 - y2), 2));
            //distance between chord and center of circle
            var d:Number = Math.sqrt(Math.abs(radius * radius - l * l / 4));
            var x:Number = (x1 + x2) / 2;
            var y:Number = (y1 + y2) / 2;
            //find coordinates of circle's center
            var rX:Number = x + d * (y1 - y2) / l;
            var rY:Number = y + d * (x2 - x1) / l;
            //find angles
            var a1:Number = Math.asin((Math.abs(y1 - rY) / radius));
            var a2:Number = Math.asin((Math.abs(y2 - rY) / radius));
            //adjust angles
            a1 = adjustAngle(a1, x1, y1, rX, rY);
            a2 = adjustAngle(a2, x2, y2, rX, rY);
            var sector1:Number = getSectorNumber(x1, y1, rX, rY);
            var sector2:Number = getSectorNumber(x2, y2, rX, rY);
            var sectorDifference:Number = Math.abs(sector1 - sector2);
            var a:Number;
            if (sectorDifference <= 1) //if angles in the same or in neighborhood sectors
            {
                //draw from min angle to max angle. a1 should be min angle
                if (a1 > a2)
                {
                    a = a1;
                    a1 = a2;
                    a2 = a;
                }
            }
            else
            {
                //draw from max angle to min angle. a1 should be max angle
                if (a1 < a2)
                {
                    a = a1;
                    a1 = a2;
                    a2 = a;
                }
            }

            throw new IllegalOperationError("Not implemented yet");

            //TODO: Implement using code from Degrafa.

            // .net code below
            // Params: http://msdn.microsoft.com/en-us/library/ms142028.aspx

//            surface.DrawArc(_stroke, (float)(rX - radius), (float)(rY - radius), (float)radius * 2,
//                (float)radius * 2,
//                (float)ConvertRadiansToDegrees(a1),
//                (float)ConvertRadiansToDegrees(sweepAngle));
        }

        // Pulled from the C# codebase

        private function adjustAngle(a:Number, x:Number, y:Number, rX:Number, rY:Number):Number
        {
            switch (getSectorNumber(x, y, rX, rY))
            {
                case 0:
                    return Math.PI * 2 - a;
                case 1:
                    return Math.PI + a;
                case 2:
                    return Math.PI - a;
                case 3:
                    return a;
            }
            return a;
        }

        // Pulled from the C# codebase

        private function getSectorNumber(x:Number, y:Number, rX:Number, rY:Number):Number
        {
            if (x >= rX && y < rY)
                return 0;
            if (x < rX && y <= rY)
                return 1;
            if (x <= rX && y > rY)
                return 2;
            if (x > rX && y >= rY)
                return 3;
            throw new IllegalOperationError("Invalid coordinates");
        }

        public function rect(x:Number, y:Number, w:Number, h:Number):void
        {
            moveTo(x, y);
            lineTo(x + w, y);
            lineTo(x + w, y + h);
            lineTo(x, y + h);
            lineTo(x, y);
            closePath();
            beginPath();
            moveTo(x, y);
        }

        public function arc(cx:Number, cy:Number, radius:Number, startAngle:Number, endAngle:Number, anticlockwise:Boolean):void
        {

            //	FIXME: Why are these being converted to degrees?
            startAngle = radianToDegree(startAngle);
            endAngle = radianToDegree(endAngle);
            //		FIXME: Throw error, per spec
            //		if(startAngle<0)startAngle = 360+startAngle;
            if (endAngle < 0)
                endAngle = 360 + endAngle;

            var arc:Number;
            if (anticlockwise)
            {
                arc = endAngle - startAngle;
            }
            else
            {
                arc = 360 - (endAngle - startAngle);
                if (arc == 0 && endAngle != startAngle)
                    arc = 360;
            }

            if (Math.abs(arc) > 360)
                arc = 360;

            var segs:Number = Math.ceil(Math.abs(arc) / 45);
            var segAngle:Number = arc / segs;

            var theta:Number, angle:Number;
            if (anticlockwise)
            {
                theta = (segAngle / 180) * Math.PI;
                angle = (startAngle / 180) * Math.PI;
            }
            else
            {
                theta = -(segAngle / 180) * Math.PI;
                angle = (startAngle / 180) * Math.PI;
            }

            var sx:Number = cx + Math.cos(angle) * radius;
            var sy:Number = cy + Math.sin(angle) * radius;

            if (isNaN(cpx))
            {
                moveTo(sx, sy);
            }
            else
            {
                lineTo(sx, sy);
            }

            var angleMid:Number, bx:Number, by:Number, ctlx:Number, ctly:Number;
            for (var i:int = 0; i < segs; i++)
            {
                angle += theta;
                angleMid = angle - (theta / 2);
                bx = cx + Math.cos(angle) * radius;
                by = cy + Math.sin(angle) * radius;
                ctlx = cx + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
                ctly = cy + Math.sin(angleMid) * (radius / Math.cos(theta / 2));
                quadraticCurveTo(ctlx, ctly, bx, by);
            }
        }

        public function fill():void
        {
            setFillStyleOf(bufferContext);
            //			if(this.readyState == 2) return;
            //			throw new Error("Going"+path.commands+"\n"+path.data.join('|'));
            drawVector(bufferContext, commands, data);
            bufferContext.endFill();
            flush();
        }

        public function stroke():void
        {
            setLineStyleOf(bufferContext);
            //			if(this.readyState == 2) return;
            drawVector(bufferContext, commands, data);
            flush();
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
        //  Helpers.
        //
        //--------------------------------------------------------------------------

        //TODO: Factor out

        private function distanceBetween(p1:Point, p2:Point):Number
        {
            return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2));
        }

        private static function degreeToRadian(degree:Number):Number
        {
            return degree * Math.PI / 180;
        }

        private static function radianToDegree(radian:Number):Number
        {
            return radian * 180 / Math.PI;
        }

        private function get bufferContext():Graphics
        {
            return bufferSprite.graphics;
        }

        //--------------------------------------------------------------------------
        //
        //  Moved from original codebase
        //
        //--------------------------------------------------------------------------

        private function drawVector(g:Graphics, cmds:Vector.<int>, data:Vector.<Number>):void
        {
            g.drawPath(cmds, data);
        }

        private function drawCubicBezier_midpoint(P0:Point, P1:Point, P2:Point, P3:Point):void
        {

            // calculates the useful base points
            var PA:Point = getPointOnSegment(P0, P1, 3 / 4);
            var PB:Point = getPointOnSegment(P3, P2, 3 / 4);

            // get 1/16 of the [P3, P0] segment
            var dx:Number = (P3.x - P0.x) / 16;
            var dy:Number = (P3.y - P0.y) / 16;

            // calculates control point 1
            var Pc_1:Point = getPointOnSegment(P0, P1, 3 / 8);

            // calculates control point 2
            var Pc_2:Point = getPointOnSegment(PA, PB, 3 / 8);
            Pc_2.x -= dx;
            Pc_2.y -= dy;

            // calculates control point 3
            var Pc_3:Point = getPointOnSegment(PB, PA, 3 / 8);
            Pc_3.x += dx;
            Pc_3.y += dy;

            // calculates control point 4
            var Pc_4:Point = getPointOnSegment(P3, P2, 3 / 8);

            // calculates the 3 anchor points
            var Pa_1:Point = getMiddle(Pc_1, Pc_2);
            var Pa_2:Point = getMiddle(PA, PB);
            var Pa_3:Point = getMiddle(Pc_3, Pc_4);

            // draw the four quadratic subsegments
            bufferSprite.graphics.curveTo(Pc_1.x, Pc_1.y, Pa_1.x, Pa_1.y);
            bufferSprite.graphics.curveTo(Pc_2.x, Pc_2.y, Pa_2.x, Pa_2.y);
            bufferSprite.graphics.curveTo(Pc_3.x, Pc_3.y, Pa_3.x, Pa_3.y);
            bufferSprite.graphics.curveTo(Pc_4.x, Pc_4.y, P3.x, P3.y);
        }

        private function getPointOnSegment(P0:Point, P1:Point, ratio:Number):Point
        {
            return new Point((P0.x + ((P1.x - P0.x) * ratio)), (P0.y + ((P1.y - P0.y) * ratio)));
        }

        private function getMiddle(P0:Point, P1:Point):Point
        {
            return getPointOnSegment(P0, P1, .5); // Multiplication and addition are faster than division	
            // return new Point(((P0.x + P1.x) / 2),((P0.y + P1.y) / 2));
        }

        private function get useTransformSkew():Boolean
        {
            return transformMatrix && (transformMatrix.b != transformMatrix.c);
        }

        private function get useTransform():Boolean
        {
            return (transformMatrix.a != 1 || transformMatrix.d != 1 || (transformMatrix.b + transformMatrix.c + transformMatrix.tx + transformMatrix.ty) != 0);
        }

        private function get cpx():Number
        {
            return data.length > 1 ? data[data.length - 2] : 0;
        }

        private function get cpy():Number
        {
            return data.length > 1 ? data[data.length - 1] : 0;
        }

        private function setFillStyleOf(bufferContext:Graphics):void
        {
            bufferContext.lineStyle(undefined);

            if (_fillStyle is CSSColor)
            {
                bufferContext.beginFill(_fillStyle.color, _fillStyle.alpha);
                return;
            }

            // TODO!
            throw new IllegalOperationError("not implemented");

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

            // TODO!
            throw new IllegalOperationError("not implemented");

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