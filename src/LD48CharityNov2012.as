package
{
	import com.citrusengine.core.StarlingCitrusEngine;
	
	import flash.display.Bitmap;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	
	[SWF(width="512", height="448", frameRate="60", backgroundColor="#CCCCCC")]
	
	public class LD48CharityNov2012 extends StarlingCitrusEngine
	{	
		[Embed(source="/sounds/bgm.mp3")]
		private var bgmSound:Class;
		
		[Embed(source="/sounds/hurt.mp3")]
		private var hurtSound:Class;
		
		[Embed(source="/sounds/jump.mp3")]
		private var jumpSound:Class;
		
		[Embed(source="/sounds/pickup.mp3")]
		private var pickupSound:Class;
		
		[Embed(source="/sounds/select.mp3")]
		private var selectSound:Class;
		
		[Embed(source="/images/overlay.png")]
		private var overlayPng:Class;
		
		
		public function LD48CharityNov2012()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			var stageSize:Rectangle = new Rectangle(0, 0, 512, 448);
			
			setSounds();
			
			setUpStarling(false, 1, stageSize);
			state = new BeginState();
			
			var overlay:Bitmap = new overlayPng();
			addChild(overlay);
		}
		
		public function setSounds():void
		{
			sound.addSound("BGM", "", bgmSound);
			sound.addSound("Hurt", "", hurtSound);
			sound.addSound("Jump", "", jumpSound);
			sound.addSound("Pickup", "", pickupSound);
			sound.addSound("Select", "", selectSound);
		}
	}
}