package totd.views
{
    import totd.ui.View;
    import totd.ui.ViewCallback;
    import loom2d.ui.SimpleButton;
    import loom2d.ui.SimpleLabel;
    import loom2d.textures.Texture;
    import loom2d.display.Image;  
    import loom2d.display.DisplayObjectContainer;

    import loom.lml.LML;
    import loom.lml.LMLDocument;

    /**
     * View shown overlaying gameplay; hidden when in pause menu.
     */
    class GameOverlayView extends View
    {
        public var onPause:ViewCallback;

        public var scoreLabel:SimpleLabel;

        public function GameOverlayView()
        {
            super();

            var doc = LML.bind("assets/gameOverlay.lml", this);
            doc.onLMLCreated = onLMLCreated;
            doc.apply();
        }

        protected function onClick()
        {
            trace("Pausing");
            onPause();
        }

        protected function onLMLCreated()
        {

        }
    }
}
