package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class BeginState extends StarlingState
	{
		[Embed(source="/images/begin.png")]
		private var beginPng:Class;
		
		public function BeginState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var texture:Texture = Texture.fromBitmap(new beginPng());
			var bg:Image = new Image(texture);
			addChild(bg);
			
			bg.addEventListener(TouchEvent.TOUCH, gameStart);
		}
		
		private function gameStart(t:TouchEvent):void
		{
			if(t.touches[0].phase == "ended"){
				stage.removeEventListener(TouchEvent.TOUCH, gameStart);
				CitrusEngine.getInstance().state = new GameState();
			}
		}
	}
}