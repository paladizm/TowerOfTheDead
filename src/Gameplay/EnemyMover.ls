package totd.gameplay
{
   import loom.gameframework.TickedComponent;

   public class EnemyMover extends TickedComponent
   {
      public var x:Number = 0;
      public var y:Number = 0;
      public var speed:Number = -15;
      public var scale:Number = 1;
      public var stageHeight:Number = 0;
      public var stageWidth:Number = 0;
      public var renderer:EnemyRenderer;

      public var stopped:Boolean;

      public function EnemyMover()
      {
      }

      public function placeRandomly():void
      {
        x = Math.random() * (stageWidth - 100) + 50;
        y = Math.random() * -stageHeight;
      }

      public function onTick():void
      {
         if(stopped)
            return;

         var dt:Number = timeManager.TICK_RATE;
         y -= speed;
      }

      protected function onRemove():void
      {
         renderer = null;

         super.onRemove();
      }
   }
}
