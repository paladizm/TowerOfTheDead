package totd.gameplay
{
   import loom.gameframework.AnimatedComponent;
   import loom2d.display.Image;
   import loom2d.display.Quad;
   import loom2d.display.Sprite;
   import loom2d.textures.Texture;

   public class EnemyRenderer extends AnimatedComponent
   {
      [Inject]
      public var playfield:Sprite;

      public var enemy:Quad;
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

         enemy = new Quad(50,  50, 0xFF0000, true);
         enemy.pivotX = enemy.width / 2;
         enemy.pivotY = enemy.height / 2;
         TowerLevel.enemyBatch.addChild(enemy);

         return true;
      }

      protected function onRemove():void
      {
         TowerLevel.enemyBatch.removeChild(enemy);
         enemy = null;
         playfield = null;

         super.onRemove();
      }
   }
}
