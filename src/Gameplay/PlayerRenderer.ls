package totd.gameplay
{
   import loom.gameframework.AnimatedComponent;
   import loom2d.Loom2D;
   import loom2d.display.Image;
   import loom2d.display.Quad;
   import loom2d.display.Sprite;
   import loom2d.display.MovieClip;
   import loom2d.textures.Texture;

   public class PlayerRenderer extends AnimatedComponent
   {
      [Inject]
      public var playfield:Sprite;

      public var player:MovieClip;

      private var playerTexture1:Texture;
      private var playerTexture2:Texture;
      private var playerTextureIndex:int;
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
            trace("Falling");
            _falling = value;
         }
      }

      protected function onAdd():Boolean
      {
         if(!super.onAdd())
            return false;

         playerTextureIndex = 1;
         playerTexture1 = Texture.fromAsset("assets/images/player.png");
         playerTexture2 = Texture.fromAsset("assets/images/player2.png");

         var playerTextures:Vector.<Texture> = new Vector.<Texture>();
         playerTextures.pushSingle(playerTexture1);
         playerTextures.pushSingle(playerTexture2);

         player = new MovieClip(playerTextures, 2);
         player.loop = true;
         player.pivotX = player.width / 2;
         player.pivotY = player.height / 2;
         playfield.addChild(player);

         Loom2D.juggler.add(player);
         player.play();

         return true;
      }

      protected function onRemove():void
      {
         playfield.removeChild(player);
         player = null;
         playfield = null;

         super.onRemove();
      }
   }
}
