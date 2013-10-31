package totd.gameplay
{
   import loom.gameframework.AnimatedComponent;
   import loom2d.Loom2D;
   import loom2d.display.Image;
   import loom2d.display.Quad;
   import loom2d.display.Sprite;
   import loom2d.display.MovieClip;
   import loom2d.textures.Texture;

   public class EnemyRenderer extends AnimatedComponent
   {
      [Inject]
      public var playfield:Sprite;

      public var enemy:MovieClip;
      public var enemyTexture1:Texture;
      public var enemyTexture2:Texture;
      public var mover:EnemyMover;

      public function set x(value:Number):void
      {
         if(enemy)
            enemy.x = value;
      }

      public function set y(value:Number):void
      {
         if(enemy)
            enemy.y = value;
      }

      public function set scale(value:Number):void
      {
         if(enemy)
            enemy.scale = value;
      }

      protected function onAdd():Boolean
      {
         if(!super.onAdd())
            return false;

         enemyTexture1 = Texture.fromAsset("assets/images/enemyHead.png");
         enemyTexture2 = Texture.fromAsset("assets/images/enemyHead2.png");

         var enemyTextures:Vector.<Texture> = new Vector.<Texture>();
         enemyTextures.pushSingle(enemyTexture1);
         enemyTextures.pushSingle(enemyTexture2);

         enemy = new MovieClip(enemyTextures, 12);
         enemy.loop = true;
         enemy.pivotX = enemy.width / 2;
         enemy.pivotY = enemy.height / 2;
         TowerLevel.enemyBatch.addChild(enemy);

         Loom2D.juggler.add(enemy);
         enemy.play();

         return true;
      }

      protected function onRemove():void
      {
         TowerLevel.enemyBatch.removeChild(enemy);
         Loom2D.juggler.remove(enemy);
         enemy = null;
         enemyTexture1 = null;
         enemyTexture2 = null;
         playfield = null;

         super.onRemove();
      }
   }
}
