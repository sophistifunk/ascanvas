/*

	Based on work by Colin Lueng

*/

package com.w3canvas.ascanvas {

	// public var CSSColors = { 'white':'#FFFFFF' };

	public class CSSColor {
		private var _color:uint=0;
		private var _alpha:Number=1;

		private var aqua:String = "#00FFFF";
		private var black:String = "#000000";
		private var blue:String = "#0000FF";
		private var fuchsia:String = "#FF00FF";
		private var gray:String = "#808080";
		private var green:String = "#008000";
		private var lime:String = "#00FF00";
		private var maroon:String = "#800000";
		private var navy:String = "#000080";
		private var olive:String = "#808000";
		private var purple:String = "#800080";
		private var red:String = "#FF0000";
		private var silver:String = "#C0C0C0";
		private var teal:String = "#008080";
		private var white:String = "#FFFFFF";
		private var yellow:String = "#FFFF00";

		public function CSSColor(str:String){
			//rgb(255,221,0), rgba(255,255,255,1), #FFFFFF, #FFF, #FF
			if(str.indexOf('#')!=-1){
				if(str.length == 2) _color = parseInt("0x" +
					[str.substr(1,1),str.substr(1,1),str.substr(1,1),str.substr(1,1),str.substr(1,1),str.substr(1,1)].join(''));
				else if(str.length == 3) _color = parseInt("0x" +
					[str.substr(1,2),str.substr(1,2),str.substr(1,2)].join(''));
				else if(str.length == 4) _color = parseInt("0x" +
					[str.substr(1,1),str.substr(1,1),str.substr(2,1),str.substr(2,1),str.substr(3,1),str.substr(3,1)].join(''));
				else _color = parseInt("0x"+str.substr(1,6));
				_alpha = 1;
			}else
			if(str.indexOf('rgb(')!=-1){
				_color = decStrToHexColor(str.substring(4,str.length-1).split(","));
				_alpha = 1;
			}else
			if(str.indexOf('rgba(')!=-1){
				var components:Array = str.substring(5, str.length-1).split(",");
				_color = decStrToHexColor(components);
				_alpha = components[3];
			}else{
				str = str.toLowerCase();
				try{
					_color = parseInt("0x"+this[str].substr(1,6));
					_alpha =1;
				}catch(e:Error){
					if((typeof(CSSColors) != 'undefined') && (str in CSSColors))
						_color = parseInt("0x"+CSSColors[str]);
					else _color = 0x000000;
					_alpha = 1;
				}
			}
		}
		
		private function decStrToHexColor(components:Array):Number{
			//255,255,0
			var cr:Number = Number(components[0])<<16;
			var cg:Number = Number(components[1])<<8;
			var cb:Number = Number(components[2]);
			return cr+cg+cb;
		}
		
		public function get color():uint{
			return _color;
		}

		public function get alpha():Number{
			return _alpha;
		}

		public function get rgba():Number{
			return _color << 8 + Math.round(_alpha*255);
		}
	}
}

