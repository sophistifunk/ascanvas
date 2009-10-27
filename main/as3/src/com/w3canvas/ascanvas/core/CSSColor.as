package com.w3canvas.ascanvas.core
{


    public class CSSColor
    {
        private var _rgb:uint;
        private var _alpha:Number;

        public function CSSColor(rgb:uint, alpha:Number)
        {
            _rgb = rgb;
            _alpha = alpha;
        }

        public function get rgb():uint
        {
            return _rgb;
        }

        public function get alpha():Number
        {
            return _alpha;
        }

        private static const hexDigits:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 'A', 'B', 'C', 'D', 'E', 'F'];

        public function toString():String
        {
            var result:String = "";
            var i:uint;
            var tmp:uint;

            if (alpha == 1)
            {
                tmp = rgb;
                for (i = 0; i < 6; i++)
                {
                    result = hexDigits[tmp & 0xf] + result;
                    tmp >>= 4;
                }
                return "#" + result;
            }
            
            return "rgba(" + (rgb >> 16) + ", " + ((rgb >> 8) & 0xff) + ", " + (rgb & 0xff) + ", " + alpha + ")";
        }

        private static const _24bit:RegExp = /#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})/i;
        private static const _rgba:RegExp = /rgba\((\d+),\s?(\d+),\s?(\d+),\s?(\d\.\d+|\d)\)/;

        public static function from(colorString:String):CSSColor
        {
            var match:Object;

            match = _24bit.exec(colorString);
            if (match)
            {
                return new CSSColor(parseInt(match[1], 16) * 65536 | parseInt(match[2], 16) * 256 | parseInt(match[3], 16), 1);
            }

            match = _rgba.exec(colorString);
            if (match)
            {
                return new CSSColor(parseInt(match[1]) * 65536 | parseInt(match[2]) * 256 | parseInt(match[3]), parseFloat(match[4]));
            }

            return null;
        }

        public static const BLACK:CSSColor = new CSSColor(0, 1);
        public static const TRANSPARENT_BLACK:CSSColor = new CSSColor(0, 0);
    }
}