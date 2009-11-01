package com.w3canvas.ascanvas.core.impl
{
    import com.w3canvas.ascanvas.core.Canvas;
    import com.w3canvas.ascanvas.core.CanvasRenderingContext2D;
    import com.w3canvas.ascanvas.core.proxies.CanvasProxy;

    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;

    /**
     * Default impl of the drawing-related parts of W3Canvas - extend it, or use it as a delegate.
     * @author josh
     */
    public class DefaultCanvas extends Sprite implements Canvas
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         * Create a default canvas impl
         * @param owner if not null, will be used as a reference to the canvas instead of "this". For dynamics and delegates.
         */
        public function DefaultCanvas(owner:*=null)
        {
            if (owner != null)
                _owner = CanvasProxy.forObject(owner);
            
            width = 300;
            height = 150;
        }

        //--------------------------------------------------------------------------
        //
        //  "self" / "owner"
        //
        //--------------------------------------------------------------------------

        private var _owner:Canvas

        protected function get owner():Canvas
        {
            return _owner == null ? this : _owner;
        }

        //--------------------------------------------------------------------------
        //
        //  Canvas Impl
        //
        //--------------------------------------------------------------------------

//        //----------------------------------
//        //  width
//        //----------------------------------
//        
//        /**
//         * @inheritDoc
//         */
//        override public function get width():Number
//        {
//            return super.width;
//        }
//
//        override public function set width(value:Number):void
//        {
//            super.width = value;
//        }
//
//        //----------------------------------
//        //  height
//        //----------------------------------
//        
//        /**
//         * @inheritDoc
//         */
//        override public function get height():Number
//        {
//            return super.height;
//        }
//
//        override public function set height(value:Number):void
//        {
//            super.height = value;
//        }

        //----------------------------------
        //  toDataUrl
        //----------------------------------

        /**
         * @inheritDoc
         */
        public function toDataUrl(type:String=null, ... args):String
        {
            throw new IllegalOperationError("not implemented");
        }

        //----------------------------------
        //  getContext
        //----------------------------------

        private var _context2d:CanvasRenderingContext2D;

        /**
         * @inheritDoc
         */
        public function getContext(contextId:String):*
        {
            if (contextId && contextId.toLowerCase() == "2d")
            {
                if (!_context2d)
                {
                    var tmp:DefaultRenderingContext = new DefaultRenderingContext(owner);
                    addChild(tmp.displayObject);
                    _context2d = tmp;
                }

                return _context2d;
            }

            throw new IllegalOperationError("\"" + contextId + "\" is not a valid contextId.");
        }
    }
}