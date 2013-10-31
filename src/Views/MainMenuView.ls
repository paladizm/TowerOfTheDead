package totd.views
{
    import totd.ui.View;
    import totd.ui.ViewCallback;

    import loom.lml.LML;
    import loom.lml.LMLDocument;

    import loom2d.display.DisplayObjectContainer;
    import loom2d.display.Image;

    import loom2d.ui.SimpleButton;
    import loom2d.ui.TextureAtlasSprite;
   /**
     * Startup view; provides main menu.
     */
    class MainMenuView extends View
    {
        [Bind]
        public var background:Image;

        [Bind]
        public var playButton:SimpleButton;

        public var onPlayClick:ViewCallback;

        public function MainMenuView()
        {
            super();

            var doc = LML.bind("assets/main.lml", this);
            doc.onLMLCreated += onLMLCreated;
            doc.apply();
        }

        public function enter(owner:DisplayObjectContainer):void
        {
            // add to the screen
            super.enter(owner);

            if(stage.stageHeight < background.height){
                trace(stage.stageHeight);
                trace(background.height);
                trace(background.y);
                background.y = -(background.height - stage.stageHeight);
            }

            //Center the button
            playButton.x = (stage.stageWidth / 2) - 125;
            playButton.y = (stage.stageHeight / 2) - 40;
        }

        public function exit():void
        {
            onExitComplete();
        }

        protected function onExitComplete():void
        {
            // really exit
            super.exit();
        }

        protected function playClick()
        {
            trace("Play Clicked");
            onPlayClick();
        }

        protected function onLMLCreated()
        {
            if(playButton){
                trace("Adding onclick");
                playButton.onClick += playClick;
            }
        }
    }
}
