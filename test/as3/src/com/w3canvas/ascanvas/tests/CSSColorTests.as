package com.w3canvas.ascanvas.tests
{
    import com.w3canvas.ascanvas.core.CSSColor;
    
    import flexunit.framework.TestCase;
    
    public class CSSColorTests extends TestCase
    {
        public function testConstructorShouldFunctionForSolidBlack():void
        {
            var c:CSSColor = new CSSColor(0,1);
            assertEquals("RGB is wrong", 0, c.rgb);
            assertEquals("Alpha is wrong", 1.0, c.alpha);
        }
        
        public function testConstructorShouldFunctionFor50PercentGreen():void
        {
            var c:CSSColor = new CSSColor(0x00ff00,0.5);
            assertEquals("RGB is wrong", 0x00ff00, c.rgb);
            assertEquals("Alpha is wrong", 0.5, c.alpha);
        }
        
        public function testFactoryShouldFunctionForHTMLColors():void
        {
            var solidBlack:CSSColor = CSSColor.from("#000000");
            assertEquals("#000000 RGB is wrong", 0, solidBlack.rgb);
            assertEquals("#000000 alpha is wrong", 1.0, solidBlack.alpha);
            
            var solidWhite:CSSColor = CSSColor.from("#FFFFFF");
            assertEquals("#FFFFFF RGB is wrong", 0xffffff, solidWhite.rgb);
            assertEquals("#FFFFFF alpha is wrong", 1.0, solidWhite.alpha);
            
            var chocolate:CSSColor = CSSColor.from("#D2691E");
            assertEquals("#D2691E RGB is wrong", 0xD2691E, chocolate.rgb);
            assertEquals("#D2691E alpha is wrong", 1.0, chocolate.alpha);
        }
        
        public function testFactoryShouldFunctionForCSSRGBAColors():void
        {
            var solidBlack:CSSColor = CSSColor.from("rgba(0,0,0,1)");
            assertEquals("rgba(0,0,0,1) RGB is wrong", 0, solidBlack.rgb);
            assertEquals("rgba(0,0,0,1) alpha is wrong", 1.0, solidBlack.alpha);
            
            var solidWhite:CSSColor = CSSColor.from("rgba(255,255,255,1)");
            assertEquals("rgba(255,255,255,1) RGB is wrong", 0xffffff, solidWhite.rgb);
            assertEquals("rgba(255,255,255,1) alpha is wrong", 1.0, solidWhite.alpha);
            
            var chocolate50Percent:CSSColor = CSSColor.from("rgba(210,105,30,0.5)");
            assertEquals("rgba(210,105,30,0.5) RGB is wrong", 0xD2691E, chocolate50Percent.rgb);
            assertEquals("rgba(210,105,30,0.5) alpha is wrong", 0.5, chocolate50Percent.alpha);
            
            var chocolate10Percent:CSSColor = CSSColor.from("rgba(210, 105, 30, 0.1)");
            assertEquals("rgba(210, 105, 30, 0.1) RGB is wrong", 0xD2691E, chocolate10Percent.rgb);
            assertEquals("rgba(210, 105, 30, 0.1) alpha is wrong", 0.1, chocolate10Percent.alpha);
        }
        
        public function testToStringShouldFunction():void
        {
            var solidBlack:CSSColor = CSSColor.from("rgba(0,0,0,1)");
            assertEquals("rgba(0,0,0,1) toString() is wrong", "#000000", solidBlack.toString());
            
            var solidWhite:CSSColor = CSSColor.from("rgba(255,255,255,1)");
            assertEquals("rgba(255,255,255,1) toString() is wrong", "#FFFFFF", solidWhite.toString());
            
            var chocolate50Percent:CSSColor = CSSColor.from("rgba(210,105,30,0.5)");
            assertEquals("rgba(210,105,30,0.5) toString() is wrong", "rgba(210, 105, 30, 0.5)", chocolate50Percent.toString());
            
            var chocolate10Percent:CSSColor = CSSColor.from("rgba(210, 105, 30, 0.1)");
            assertEquals("rgba(210, 105, 30, 0.1) toString() is wrong", "rgba(210, 105, 30, 0.1)", chocolate10Percent.toString());
        }
       
    }
}