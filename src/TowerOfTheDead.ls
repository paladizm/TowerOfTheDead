package
{
    import loom.Application;

    import loom2d.display.StageScaleMode;
    import loom2d.display.DisplayObjectContainer;
    import loom2d.display.Sprite;

    import totd.views.MainMenuView;
    import totd.views.GamePlayView;
    import totd.views.GameOverlayView;

    public class TowerOfTheDead extends Application
    {
        public var uiLayer:DisplayObjectContainer;

        public var mainMenu:MainMenuView;
        public var gameView:GamePlayView;
        public var overlay:GameOverlayView;

        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            stage.scaleMode = StageScaleMode.NONE;

            var playfield = new Sprite();
            stage.addChild(playfield);
            stage.touchable = true;
            stage.reportFps = true;
            group.registerManager(playfield, null, "playfield");

            uiLayer = new Sprite();
            stage.addChild(uiLayer);
            group.registerManager(uiLayer, null, "overlay");    

            mainMenu = new MainMenuView();
            mainMenu.onPlayClick += onPlayGame;

            gameView = new GamePlayView();
            gameView.group = group;

            overlay = new GameOverlayView();
            overlay.onPause += onPauseGame;

            //Show Main Menu
            mainMenu.enter(uiLayer);
        }

        protected function onPlayGame()
        {
            trace("Main Menu Exit");
            mainMenu.onExit += onMenuExit;
            mainMenu.exit();
        }

        protected function onPauseGame()
        {
            trace("Pause Game");
        }

        protected function onMenuExit()
        {
            trace("Menu Exit");
            gameView.enter(stage);
            gameView.level.onFinished += onGameFinished;
            overlay.enter(uiLayer);
            mainMenu.onExit -= onMenuExit;
        }

        protected function onGameFinished()
        {
            gameView.exit();
            overlay.exit();
            mainMenu.enter(uiLayer);
        }
    }
}
