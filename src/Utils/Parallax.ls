package totd.utils
{
   import loom2d.display.Sprite;
   import loom2d.display.Image;
   import loom2d.display.Quad;

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

      private var _quadList:Vector.<Quad>;
      private var _imageList:Vector.<Image>;

      public function initialize(_name:String = null):void
      {
        super.initialize(_name);

        if(_quadList){
            for (var i:int=0; i<_quadList.length; i++){
                playfield.addChild(_quadList[i]);
            }
        }
        if(_imageList){
            for (i=0; i<_imageList.length; i++){
                playfield.addChild(_imageList[i]);
            }
        }
        _speed = playerMover.speed;
        timeManager.addAnimatedObject(this);
      }

      public function destroy():void
      { 
         timeManager.removeAnimatedObject(this);

         if(_quadList){
            for (var i:int=0; i<_quadList.length; i++){
                playfield.removeChild(_quadList[i]);
            }
         }

         if(_imageList){
            for (i=0; i<_imageList.length; i++){
                playfield.removeChild(_imageList[i]);
            }
         }

         super.destroy();
      }

      public function onFrame():void
      {
        if(_quadList){
            loopQuads();
        }

        if(_imageList){
            loopImages();
        }
      }

      private function loopQuads():void
      {
        if (_quadList.length){
            _speed = playerMover.speed;
            var i:int=0;
            var loopIndex:int;
            var currentQuad:Quad;
            if (_speed > 0){
                //Bottom to top
                for (i; i<_quadList.length; i++){
                    currentQuad = _quadList[i];
                    if (currentQuad.y >= playfield.stage.stageHeight){
                        loopIndex = (i+(_quadList.length-1))%_quadList.length;
                        currentQuad.y = _quadList[loopIndex].y - currentQuad.height;
                        if (i < loopIndex){
                            currentQuad.y += _speed * _parallax;
                        }
                    } else{
                        currentQuad.y += _speed * _parallax;
                    }
                }
            }else{
                //Top Bottom
                for (i=_quadList.length-1; i>=0; i--){
                    currentQuad = _quadList[i];
                    if (currentQuad.y + currentQuad.height <= 0){
                        loopIndex = (i-(_quadList.length-1))%_quadList.length;
                        currentQuad.y = _quadList[loopIndex].y + _quadList[loopIndex].height;
                        if (i > loopIndex){
                            currentQuad.y += _speed * _parallax;
                        }
                    } else{
                        currentQuad.y += _speed * _parallax;
                    }
                }
            }
        }
      }

      private function loopImages():void
      {
        if (_imageList.length){
            _speed = playerMover.speed;
            var i:int=0;
            var loopIndex:int;
            var currentImage:Image;
            if (_speed > 0){
                //Bottom to top
                for (i; i<_imageList.length; i++){
                    currentImage = _imageList[i];
                    if (currentImage.y >= playfield.stage.stageHeight){
                        loopIndex = (i+(_imageList.length-1))%_imageList.length;
                        currentImage.y = _imageList[loopIndex].y - currentImage.height;
                        if (i < loopIndex){
                            currentImage.y += _speed * _parallax;
                        }
                    } else{
                        currentImage.y += _speed * _parallax;
                    }
                }
            }else{
                //Top Bottom
                for (i=_imageList.length-1; i>=0; i--){
                    currentImage = _imageList[i];
                    if (currentImage.y + currentImage.height <= 0){
                        loopIndex = (i-(_imageList.length-1))%_imageList.length;
                        currentImage.y = _imageList[loopIndex].y + _imageList[loopIndex].height;
                        if (i > loopIndex){
                            currentImage.y += _speed * _parallax;
                        }
                    } else{
                        currentImage.y += _speed * _parallax;
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

      public function set quadList(quads:Vector.<Quad>){
        _quadList = quads;
      }

      public function set imageList(images:Vector.<Image>){
        _imageList = images;
      }

      public function set speed(value:Number){
        _speed = value;
      }

      public function set parallax(value:Number){
        _parallax = value;
      }
   }
}
