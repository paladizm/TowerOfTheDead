package totd.views
{
   import totd.ui.View;
   import loom2d.ui.SimpleLabel;
   import loom2d.display.Sprite;

   import loom.gameframework.LoomGroup;

   import totd.gameplay.TowerLevel;

   import loom2d.display.DisplayObjectContainer;

   /**
    * View that manages the simulation.
    */
   public class GamePlayView extends View
   {
      public var group:LoomGroup;
      public var level:TowerLevel;

      public function enter(owner:DisplayObjectContainer):void
      {
         super.enter(owner);
         trace("In Game");
         if (!level){
            level = new TowerLevel();
            level.owningGroup = group;
            level.initialize();
         }
      }

      public function exit():void
      {
         if(level){
            level.destroy();
            level = null;
         }
         // Shut down game.
         super.exit();
      }
   }
}
