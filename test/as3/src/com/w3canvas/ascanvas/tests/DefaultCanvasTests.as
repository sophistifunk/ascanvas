package com.w3canvas.ascanvas.tests
{
    import com.w3canvas.ascanvas.core.Canvas;
    import com.w3canvas.ascanvas.core.CanvasRenderingContext2D;
    import com.w3canvas.ascanvas.core.impl.DefaultCanvas;
    
    import flexunit.framework.TestCase;
    
    public class DefaultCanvasTests extends TestCase
    {
        public function testCanvasSizeShouldDefaultTo300x150():void
        {
            var c:Canvas = new DefaultCanvas();
            assertEquals("Width is wrong", 300, c.width);
            assertEquals("Height is wrong", 150, c.height);
        }

        public function testCanvasShouldReturnValidRenderingContext2d():void
        {
            var c:Canvas = new DefaultCanvas();
            assertTrue("Did not get a valid CanvasRenderingContext2D", c.getContext("2d") is CanvasRenderingContext2D);
        }
    }
}   