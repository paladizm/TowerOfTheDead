package totd.gameplay
{
   import loom.gameframework.AnimatedComponent;
   import loom2d.Loom2D;
   import loom2d.display.Image;
   import loom2d.display.Sprite;
   import loom2d.display.MovieClip;
   import loom2d.textures.Texture;

   public class PlayerRenderer extends AnimatedComponent
   {
      [Inject]
      public var playfield:Sprite;

      public var mover:PlayerMover;

      public var player:MovieClip;
      public var playerFalling:MovieClip;

      private var playerTexture1:Texture;
      private var playerTexture2:Texture;
      private var playerFallingTexture1:Texture;
      private var playerFallingTexture2:Texture;
      private var _falling:Boolean = false;

      public function set x(value:Number):void
      {
         if(player)
            player.x = value;
      }

      public function set y(value:Number):void
      {
         if(player)
            player.y = value;
      }

      public function set scale(value:Number):void
      {
         if(player)
            player.scale = value;
      }

      public function set falling(value:Boolean):void
      {
         if (_falling != value){
            _falling = value;
            if (_falling){
                player.visible = false;
                player.stop();
                playerFalling.visible = true;
                playerFalling.play();
            }
            else{
                playerFalling.visible = false;
                playerFalling.stop();
                player.visible = true;
                player.play();
            }
         }
      }

      protected function onAdd():Boolean
      {
         if(!super.onAdd())
            return false;

         playerTexture1 = Texture.fromAsset("assets/images/player.png");
         playerTexture2 = Texture.fromAsset("assets/images/player2.png");

         var playerTextures:Vector.<Texture> = new Vector.<Texture>();
         playerTextures.pushSingle(playerTexture1);
         playerTextures.pushSingle(playerTexture2);

         player = new MovieClip(playerTextures, 4);
         player.loop = true;
         player.pivotX = player.width / 2;
         player.pivotY = player.height / 2;
         playfield.addChild(player);

         Loom2D.juggler.add(player);
         player.play();

         playerFallingTexture1 = Texture.fromAsset("assets/images/playerFalling.png");
         playerFallingTexture2 = Texture.fromAsset("assets/images/playerFalling2.png");

         var playerFallingTextures:Vector.<Texture> = new Vector.<Texture>();
         playerFallingTextures.pushSingle(playerFallingTexture1);
         playerFallingTextures.pushSingle(playerFallingTexture2);

         playerFalling = new MovieClip(playerFallingTextures, 4);
         playerFalling.loop = true;
         playerFalling.visible = false;
         playerFalling.pivotX = playerFalling.width / 2;
         playerFalling.pivotY = playerFalling.height / 2;
         Loom2D.juggler.add(playerFalling);

         playfield.addChild(playerFalling);

         return true;
      }

      protected function onFrame():void
      {
         super.onFrame();

         if (playerFalling.visible){
            playerFalling.x = player.x;
            playerFalling.y = player.y;
         }
      }

      protected function onRemove():void
      {
         playfield.removeChild(player);
         playfield.removeChild(playerFalling);
         Loom2D.juggler.remove(playerFalling);
         Loom2D.juggler.remove(player);
         player = null;
         playfield = null;
         playerFallingTexture1 = null;
         playerFallingTexture2 = null;
         playerTexture1 = null;
         playerTexture2 = null;

         super.onRemove();
      }
   }
}
