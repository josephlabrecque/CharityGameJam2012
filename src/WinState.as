package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	
	import starling.events.TouchEvent;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class WinState extends StarlingState
	{
		[Embed(source="/images/end.png")]
		private var winPng:Class;
		
		public function WinState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var texture:Texture = Texture.fromBitmap(new winPng());
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