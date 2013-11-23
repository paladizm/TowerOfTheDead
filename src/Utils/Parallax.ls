package totd.utils
{
   import loom2d.display.Sprite;
   import loom2d.display.DisplayObject;

   import loom.gameframework.LoomGroup;
   import loom.gameframework.IAnimated;
   import loom.gameframework.TimeManager;

   import totd.gameplay.PlayerMover;

   public class Parallax extends LoomGroup implements IAnimated
   {
      [Inject]
      public var timeManager:TimeManager;

      [Inject]
      public var playfield:Sprite;

      [Inject]
      public var playerMover:PlayerMover;

      public var _parallax:Number; 
      public var _speed:Number;

      private var _displayObjectList:Vector.<DisplayObject>;

      public function initialize(_name:String = null):void
      {
        super.initialize(_name);

        if(_displayObjectList){
            for (var i:int=0; i<_displayObjectList.length; i++){
                playfield.addChild(_displayObjectList[i]);
            }
        }

        _speed = playerMover.speed;
        timeManager.addAnimatedObject(this);
      }

      public function destroy():void
      { 
         timeManager.removeAnimatedObject(this);

         if(_displayObjectList){
            for (var i:int=0; i<_displayObjectList.length; i++){
                playfield.removeChild(_displayObjectList[i]);
            }
         }

         super.destroy();
      }

      public function onFrame():void
      {
        if(_displayObjectList){
            loopDisplayObjects();
        }
      }

      private function loopDisplayObjects():void
      {
        if (_displayObjectList.length){
            _speed = playerMover.speed;
            var i:int=0;
            var loopIndex:int;
            var currentDisplayObject:DisplayObject;
            if (_speed > 0){
                //Bottom to top
                for (i; i<_displayObjectList.length; i++){
                    currentDisplayObject = _displayObjectList[i];
                    if (currentDisplayObject.y >= playfield.stage.stageHeight){
                        loopIndex = (i+(_displayObjectList.length-1))%_displayObjectList.length;
                        currentDisplayObject.y = _displayObjectList[loopIndex].y - currentDisplayObject.height;
                        if (i < loopIndex){
                            currentDisplayObject.y += _speed * _parallax;
                        }
                    } else{
                        currentDisplayObject.y += _speed * _parallax;
                    }
                }
            }else{
                //Top Bottom
                for (i=_displayObjectList.length-1; i>=0; i--){
                    currentDisplayObject = _displayObjectList[i];
                    if (currentDisplayObject.y + currentDisplayObject.height <= 0){
                        loopIndex = (i-(_displayObjectList.length-1))%_displayObjectList.length;
                        currentDisplayObject.y = _displayObjectList[loopIndex].y + _displayObjectList[loopIndex].height;
                        if (i > loopIndex){
                            currentDisplayObject.y += _speed * _parallax;
                        }
                    } else{
                        currentDisplayObject.y += _speed * _parallax;
                    }
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

      public function set displayObjectList(displayObjects:Vector.<DisplayObject>){
        _displayObjectList = displayObjects;
      }

      public function set speed(value:Number){
        _speed = value;
      }

      public function set parallax(value:Number){
        _parallax = value;
      }
   }
}
