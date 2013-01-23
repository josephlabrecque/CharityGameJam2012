package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	
	import starling.events.TouchEvent;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class DieState extends StarlingState
	{
		[Embed(source="/images/die.png")]
		private var diePng:Class;
		
		public function DieState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var texture:Texture = Texture.fromBitmap(new diePng());
			var bg:Image = new Image(texture);
			addChild(bg);
			
			bg.addEventListener(TouchEvent.TOUCH, gameStart);
		}
		
		private function gameStart(t:TouchEvent):void
		{
			if(t.touches[0].phase == "ended"){
				stage.removeEventListener(TouchEvent.TOUCH, gameStart);
				CitrusEngine.getInstance().state = new BeginState();
			}
		}
	}
}