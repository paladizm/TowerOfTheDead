package totd.gameplay
{
   import totd.utils.Parallax;
   import totd.gameplay.PlayerRenderer;
   import totd.gameplay.PlayerMover;
   import totd.gameplay.EnemyRenderer;

   import totd.gameplay.EnemyMover;
   import loom2d.display.DisplayObjectContainer;
   import loom2d.display.Sprite;
   import loom2d.display.Image;
   import loom2d.display.Quad;
   import loom2d.textures.Texture;

   import loom2d.events.Event;
   import loom2d.events.Touch;
   import loom2d.events.TouchEvent;
   import loom2d.events.TouchPhase;
    
   import loom2d.ui.SimpleLabel;

   import loom2d.math.Point;

   import loom.gameframework.LoomGroup;
   import loom.gameframework.LoomGameObject;
   import loom.gameframework.IAnimated;
   import loom.gameframework.TimeManager;

   import loom.platform.Timer;

   import loom.animation.LoomTween;
   import loom.animation.LoomEaseType;

   delegate TowerLevelCompletionCallback():void;

   public class TowerLevel extends LoomGroup implements IAnimated
   {
      [Inject]
      public var timeManager:TimeManager;

      [Inject]
      public var playfield:Sprite;

      [Inject]
      public var overlay:Sprite;

      //Player Vars
      public var playerRenderer:PlayerRenderer;
      public var playerMover:PlayerMover;
      public var playerGameObject:LoomGameObject;
      public var playerTargetX:Number;
      public var playerTargetY:Number;

      //Score Vars
      public var score:Number;
      public var scoreLabel:SimpleLabel;

      //Enemy Vars
      public var enemies:Vector.<EnemyMover>;
      public var enemyPool:Vector.<LoomGameObject>;
      public var enemyGameObjects:Vector.<LoomGameObject>;
      static public var enemyBatch:DisplayObjectContainer;

      //Enemy Spawn Timer
      public var spawnTimer:Timer;
      public var spawnRate:Number;

      //Lightning 
      public var lightningTimer:Timer;
      public var lightning:Quad; 

      //Life
      public var lives:Vector.<Image>;

      //Game Over
      public var onFinished:TowerLevelCompletionCallback;
      public var gameOver:Boolean = false;

      //Parallax
      public var parallaxLayer1:Parallax;
      public var parallaxLayer2:Parallax;

      public function initialize(_name:String = null):void
      {
         super.initialize(_name);

         onFinished = new TowerLevelCompletionCallback();
         createPlayer();

         this.owningGroup.registerManager(playerMover, null, "playerMover");

         //Create Parallax
         parallaxLayer1 = new Parallax(); 
         parallaxLayer1.owningGroup = this.owningGroup;
         parallaxLayer1.displayObjectList = towerBackground();
         parallaxLayer1.parallax = 0.5;
         parallaxLayer1.initialize();

         lightning = new Quad(playfield.stage.stageWidth, playfield.stage.stageHeight, 0xFFFFFF);
         lightning.alpha = 0;
         playfield.addChild(lightning);

         parallaxLayer2 = new Parallax(); 
         parallaxLayer2.owningGroup = this.owningGroup;
         parallaxLayer2.displayObjectList = towerBuilder();
         parallaxLayer2.parallax = 1;
         parallaxLayer2.initialize();

         //Add Player
         playerGameObject.initialize();

         enemies = new Vector.<EnemyMover>();
         enemyPool = new Vector.<LoomGameObject>();
         enemyGameObjects = new Vector.<LoomGameObject>();

         enemyBatch = new Sprite();
         enemyBatch.name = "enemyBatch";
         playfield.addChild(enemyBatch);

         spawnTimer = new Timer(500);
         spawnTimer.onComplete = createEnemyTimerComplete;

         lightningTimer = new Timer(5000);
         lightningTimer.onComplete = lightningTimerComplete;

         timeManager.addAnimatedObject(this);
         spawnTimer.start();
         lightningTimer.start();

         //Add Score
         scoreLabel = new SimpleLabel("assets/impact.fnt");
         scoreLabel.text = "0";
         scoreLabel.x = playfield.stage.stageWidth - (scoreLabel.width+20);
         scoreLabel.y = 2;
         score = 0;
         overlay.addChild(scoreLabel);

         //Add Lives
         lives = new Vector.<Image>();
         var life1:Image = new Image(Texture.fromAsset("assets/images/life.png"));
         life1.pivotX = life1.width *0.5;
         life1.pivotY = life1.height *0.5;
         life1.x = life1.width + 10;
         life1.y = life1.height + 10;
         overlay.addChild(life1);

         var life2:Image = new Image(Texture.fromAsset("assets/images/life.png"));
         life2.pivotX = life2.width *0.5;
         life2.pivotY = life2.height *0.5;
         life2.x = life1.x + life2.width + 10;
         life2.y = life1.y;
         overlay.addChild(life2);

         var life3:Image = new Image(Texture.fromAsset("assets/images/life.png"));
         life3.pivotX = life3.width *0.5;
         life3.pivotY = life3.height *0.5;
         life3.x = life2.x + life3.width + 10;
         life3.y = life1.y;
         overlay.addChild(life3);

         lives.pushSingle(life1);
         lives.pushSingle(life2);
         lives.pushSingle(life3);

         playfield.stage.addEventListener(TouchEvent.TOUCH, onTouchBegin);
      }

      private function createEnemyTimerComplete(t:Timer=null):void
      {
         t.reset();
         createEnemy();

         //Eventually Make a new score timer 
         if (!playerMover.falling){
            score += 10;
            scoreLabel.text = score.toString();
            scoreLabel.x = playfield.stage.stageWidth - (scoreLabel.width+20);
         }

         t.start();
      }

      private function lightningTimerComplete(t:Timer=null):void
      {
         t.reset();
         LoomTween.to(lightning, 0.5, {"alpha": 1, 
                        "ease": LoomEaseType.EASE_OUT_BOUNCE}).onComplete += lightningTweenComplete;
      }

      private function lightningTweenComplete(tween:LoomTween)
      {
         lightning.alpha = 0; 
         lightningTimer.start();
      }
      
      private function createEnemy():LoomGameObject
      {
         var enemyGameObject:LoomGameObject;
         var enemyRenderer:EnemyRenderer;
         var enemyMover:EnemyMover;

         if (gameOver)
            return enemyGameObject;

         if (enemyPool.length > 0){
            enemyGameObject = enemyPool[0];
            enemyPool.remove(enemyGameObject);
            enemyMover = enemyGameObject.lookupComponentByName("mover") as enemyMover;
            enemyMover.placeRandomly();
            enemyMover.stopped = false;
         }
         else{
            enemyGameObject = new LoomGameObject();
            enemyGameObject.owningGroup = this;
            
            enemyRenderer = new EnemyRenderer();
            enemyMover = new EnemyMover();

            enemyMover.stageHeight = playfield.stage.stageHeight;
            enemyMover.stageWidth = playfield.stage.stageWidth;
            enemyMover.placeRandomly();
            enemyMover.scale = .75;
            enemyMover.renderer = enemyRenderer; 
            enemies.pushSingle(enemyMover);
            enemyGameObject.addComponent(enemyMover, "mover");

            enemyRenderer.addBinding("x", "@mover.x");
            enemyRenderer.addBinding("y", "@mover.y");
            enemyRenderer.addBinding("scale", "@mover.scale");

            enemyRenderer.mover = enemyMover;
            enemyGameObject.addComponent(enemyRenderer, "renderer");

            enemyGameObject.initialize();
            enemyGameObjects.pushSingle(enemyGameObject);
         }

         return enemyGameObject;
      }

      private function createPlayer(){
         playerGameObject = new LoomGameObject();
         playerGameObject.owningGroup = this;

         playerRenderer = new PlayerRenderer();
         playerMover = new PlayerMover();

         playerMover.x = playfield.stage.stageWidth/2;
         playerMover.y = playfield.stage.stageHeight; 
         playerTargetX = playerMover.x;
         playerTargetY = playerMover.y;
         playerMover.scale = 1;
         playerMover.speed = 5;
         playerMover.stopped = true;
         playerGameObject.addComponent(playerMover, "mover");

         playerRenderer.addBinding("x", "@mover.x");
         playerRenderer.addBinding("y", "@mover.y");
         playerRenderer.addBinding("scale", "@mover.scale");
         playerRenderer.addBinding("falling", "@mover.falling");
         playerRenderer.mover = playerMover;
         playerGameObject.addComponent(playerRenderer, "renderer");
      }

      private function movePlayer(x:Number, y:Number):LoomGameObject{
         if (x > 50 && x < playfield.stage.stageWidth - 50){
            playerTargetX = x;
            playerTargetY = y;
            LoomTween.to(playerMover, 0.3, {"x": playerTargetX, "y": playerTargetY, "ease": LoomEaseType.EASE_OUT_BOUNCE});
        }
        return playerGameObject;
      }

      private function collisionDetection(){
        for (var i=0; i<enemyGameObjects.length; i++){
            var lgo:LoomGameObject = enemyGameObjects[i];
            var enemyMover:EnemyMover = lgo.lookupComponentByName("mover") as EnemyMover;
            var enemyRenderer:EnemyRenderer = lgo.lookupComponentByName("renderer") as EnemyRenderer;
            
            if (!enemyMover.stopped){
                var enemyX = enemyMover.x;
                var enemyY = enemyMover.y;

                var distX = playerMover.x-enemyX;
                var distY = playerMover.y-enemyY;

                var distSqr = distX*distX + distY*distY;
                
                var R1R2 = (enemyRenderer.enemy.width*.5)+(playerRenderer.player.width*.5);
                if (distSqr <=  (R1R2 * R1R2)){
                    enemyCollision(enemyMover, enemyRenderer);
                }
            }
        }
      }

      private function enemyCollision(enemyMover:EnemyMover, enemyRenderer:EnemyRenderer)
      {
        playerMover.hit = true;
      }

      public function onTouchBegin(te:TouchEvent):void
      {
         var touch = te.getTouch(playfield.stage, TouchPhase.BEGAN);
         if(touch == null)
             return;
         if(playerMover.hit)
            return;

         var p:Point = touch.getLocation(playfield);

         if (!p)
         {
             trace("Bad touch");
             return;
         }
         var lgo:LoomGameObject = movePlayer(p.x, p.y);
         var mover:PlayerMover = lgo.lookupComponentByName("mover") as PlayerMover;
      }

      public function destroy():void
      { 
         timeManager.removeAnimatedObject(this);

         playfield.stage.removeEventListener(TouchEvent.TOUCH, onTouchBegin);

         parallaxLayer1.destroy();
         parallaxLayer2.destroy();
         super.destroy();

         playfield.removeChild(enemyBatch);
         playfield.removeChild(lightning);
         overlay.removeChild(scoreLabel);
      }

      public function onFrame():void
      {
         if (gameOver)
            return;
         else{   
            collisionDetection();

            if (playerMover.HP <= 0){
                trace("FINISHED");
                timeManager.stop();
                spawnTimer.stop();
                gameOver=true;
                onFinished();
                return;
            }
            else if (playerMover.HP < lives.length)
            {
                //Lose a life
                overlay.removeChild(lives.pop());
            }

            for (var i=0; i<enemyGameObjects.length; i++){
                var lgo = enemyGameObjects[i];
                var mover:EnemyMover = lgo.lookupComponentByName("mover") as EnemyMover;
                var renderer:EnemyRenderer = lgo.lookupComponentByName("renderer") as EnemyRenderer;

                if(mover.y > (playfield.stage.stageHeight + renderer.enemy.height) && !mover.stopped){
                    mover.stopped = true;
                    enemyPool.pushSingle(lgo);
                }
            }
         }
      }

      public function pause(value:Boolean)
      {
         if(value)
            timeManager.stop();
         else
            timeManager.start();
      }

      private function towerBuilder():Vector.<Image>
      {
         var imageList:Vector.<Image> = new Vector.<Image>();
         var image:Image = new Image(Texture.fromAsset("assets/images/tower.png"));
         var image2:Image = new Image(Texture.fromAsset("assets/images/tower.png"));
         var image3:Image = new Image(Texture.fromAsset("assets/images/tower.png"));

         image.scaleX = image2.scaleX = image3.scaleX = 1;
         image.scaleY = image2.scaleY = image3.scaleY = 1;

         imageList.pushSingle(image);
         imageList.pushSingle(image2);
         imageList.pushSingle(image3);

         for (var i=0; i<imageList.length; i++){
            var q = imageList[i];
            q.x = playfield.stage.stageWidth / 2 - (q.width/2);
            if(i){
                q.y = imageList[i-1].y - q.height ;
            }else{
                q.y = playfield.stage.stageHeight / 2 - (q.height/2);
            }
         }

         return imageList;
      }

      private function towerBackground():Vector.<Image>
      {
         var imageList:Vector.<Image> = new Vector.<Image>();
         var image:Image = new Image(Texture.fromAsset("assets/images/tower-bg.png"));
         var image2:Image = new Image(Texture.fromAsset("assets/images/tower-bg2.png"));
         var image3:Image = new Image(Texture.fromAsset("assets/images/tower-bg.png"));

         image.scaleX = image2.scaleX = image3.scaleX = 1;
         image.scaleY = image2.scaleY = image3.scaleY = 1;

         imageList.pushSingle(image);
         imageList.pushSingle(image2);
         imageList.pushSingle(image3);

         for (var i=0; i<imageList.length; i++){
            var q = imageList[i];
            q.x = 0;
            if(i){
                q.y = imageList[i-1].y - q.height ;
            }else{
                q.y = 0;
            }
         }

         return imageList;
      }
    }
}
