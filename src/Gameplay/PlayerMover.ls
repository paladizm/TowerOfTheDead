package totd.gameplay
{
   import loom.animation.LoomTween;
   import loom.animation.LoomEaseType;
   import loom.gameframework.TickedComponent;

   public class PlayerMover extends TickedComponent
   {
      public var x:Number = 0;
      public var y:Number = 0;
      public var speed:Number = 5;
      public var scale:Number = 1;

      public var stopped:Boolean;
      public var hit:Boolean = false;
      public var falling:Boolean = false;

      public var HP:Number = 3;

      public function PlayerMover()
      {
      }

     public function onTick():void
      {
         if(hit && !falling){
            falling = true;
            LoomTween.to(this, 0.1, {"speed": -10, "ease": LoomEaseType.EASE_IN}).onComplete += hitTweenComplete;
         }

         if(stopped)
            return;
      }

      private function hitTweenComplete(tween:LoomTween){
        LoomTween.to(this, 3.0, {"speed": 0, "ease": LoomEaseType.EASE_OUT}).onComplete += hitTweenComplete2;
      }

      private function hitTweenComplete2(tween:LoomTween){
        speed = 5;
        HP--;
        hit = false;
        falling = false; 
      }
   }
}
