package
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Coin;
	import com.citrusengine.objects.platformer.box2d.Crate;
	import com.citrusengine.objects.platformer.box2d.Enemy;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.MovingPlatform;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	import com.citrusengine.physics.box2d.Box2D;
	import com.citrusengine.physics.box2d.Box2DUtils;
	
	import flash.geom.Rectangle;
	
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class GameState extends StarlingState
	{
		private var engine:CitrusEngine;
		private var hero:Hero;
		private var book:Coin;
		private var chew:Coin;
		private var song:Coin;
		private var potty:Coin;
		private var kiss:Coin;
		
		[Embed(source="/images/bg.png")]
		private var bgPng:Class;
		
		[Embed(source="/images/startmessage.png")]
		private var startmessagePng:Class;
		
		[Embed(source="/images/babbymessage.png")]
		private var babbymessagePng:Class;
		
		
		[Embed(source="/images/moving.png")]
		private var movingPng:Class;
		
		[Embed(source="/images/hero.xml", mimeType="application/octet-stream")]
		private var heroConfig:Class;
		
		[Embed(source="/images/father.png")]
		private var heroPng:Class;
		
		[Embed(source="/images/enemy.png")]
		private var enemyPng:Class;
		
		[Embed(source="/images/baby.png")]
		private var babyPng:Class;
		
		[Embed(source="/images/crate.png")]
		private var cratePng:Class;
		
		
		
		[Embed(source="/images/book.png")]
		private var bookPng:Class;
		
		[Embed(source="/images/chew.png")]
		private var chewPng:Class;
		
		[Embed(source="/images/song.png")]
		private var songPng:Class;
		
		[Embed(source="/images/potty.png")]
		private var pottyPng:Class;
		
		[Embed(source="/images/kiss.png")]
		private var kissPng:Class;
		
		
		[Embed(source="/images/bookicon.png")]
		private var bookiconPng:Class;
		
		[Embed(source="/images/chewicon.png")]
		private var chewiconPng:Class;
		
		[Embed(source="/images/songicon.png")]
		private var songiconPng:Class;
		
		[Embed(source="/images/pottyicon.png")]
		private var pottyiconPng:Class;
		
		[Embed(source="/images/kissicon.png")]
		private var kissiconPng:Class;
		
		
		private var heroLife:int;
		private var bookCollected:Boolean;
		private var chewCollected:Boolean;
		private var songCollected:Boolean;
		private var pottyCollected:Boolean;
		private var kissCollected:Boolean;
		private var lifeField:TextField;
		private var itemsCollected:Number;
		private var startPopup:Image;
		private var babbyPopup:Image;
		
		public function GameState()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			engine = CitrusEngine.getInstance();
			
			engine.sound.playSound("BGM", 0.5);
			
			heroLife = 3;
			itemsCollected = 0;
			
			var bg:CitrusSprite = new CitrusSprite("BG");
			bg.view = new bgPng();
			add(bg);
			
			var physics:Box2D = new Box2D("B2D");
			//physics.visible = true;
			add(physics);
			
			var floor:Platform = new Platform("floor", {x:1024, y:448, width:2048, height:10});
			add(floor);
			
			var leftWall:Platform = new Platform("leftWall", {x:0, y:224, width:10, height:stage.stageHeight});
			add(leftWall);
			
			var rightWall:Platform = new Platform("rightWall", {x:1890, y:224, width:10, height:stage.stageHeight});
			add(rightWall);
			
			//upperbranch
			var p1:Platform = new Platform("p1", {x:300, y:195, width:140, height:10, oneWay:true});
			add(p1);
			
			//lowerbranch
			var p2:Platform = new Platform("p2", {x:270, y:305, width:80, height:10, oneWay:true});
			add(p2);
			
			//entrywall
			var p3:Platform = new Platform("p3", {x:500, y:155, width:10, height:280});
			add(p3);
			
			//upperleft
			var p4:Platform = new Platform("p4", {x:700, y:230, width:400, height:10});
			add(p4);
			
			//upperright
			var p5:Platform = new Platform("p5", {x:1660, y:230, width:440, height:10});
			add(p5);
			
			//uppermoving
			var p6:MovingPlatform = new MovingPlatform("p6", {x:1000, y:230, width:160, height:10, startX:990, endX:1360, startY:230, endY:230});
			p6.view = new movingPng();
			add(p6);
			
			//furniture
			var p7:Platform = new Platform("p7", {x:1020, y:340, width:100, height:10, oneWay:true});
			add(p7);
			var p8:Platform = new Platform("p8", {x:1120, y:380, width:150, height:10, oneWay:true});
			add(p8);
			
			
			
			book = new Coin("book", {x:350, y:170, width:30, height:30});
			book.view = new bookPng();
			book.onBeginContact.add(bookTouched);
			add(book);
			
			chew = new Coin("chew", {x:1115, y:50, width:30, height:30});
			chew.view = new chewPng();
			chew.onBeginContact.add(chewTouched);
			add(chew);
			
			song = new Coin("song", {x:1830, y:212, width:30, height:30});
			song.view = new songPng();
			song.onBeginContact.add(songTouched);
			add(song);
			
			potty = new Coin("potty", {x:1850, y:420, width:30, height:30});
			potty.view = new pottyPng();
			potty.onBeginContact.add(pottyTouched);
			add(potty);
			
			kiss = new Coin("kiss", {x:530, y:210, width:30, height:30});
			kiss.view = new kissPng();
			kiss.onBeginContact.add(kissTouched);
			add(kiss);
			
			
			
			
			
			var kilMsg:Sensor = new Sensor("kilMsg", {x:45, y:415, width:20, height:45});
			kilMsg.onEndContact.add(killStartMessage);
			add(kilMsg);
			
			
			
			//wall
			var crate:Crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1460, y:400, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			
			
			//wall 2
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1750, y:185, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			
			//pottycover
			crate = new Crate("crate", {x:1820, y:420, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1820, y:390, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			crate = new Crate("crate", {x:1790, y:420, width:30, height:30});
			crate.view = new cratePng();
			add(crate);
			
			
			
			var baby:Sensor = new Sensor("baby", {x:620, y:188, width:120, height:60});
			baby.view = new babyPng();
			baby.onBeginContact.add(checkBaby);
			baby.onEndContact.add(killMessage);
			add(baby);
			
			
			
			
			hero = new Hero("hero", {x:10, y:410, width:20, height:45, jumpHeight:10, acceleration:0.1, maxVelocity:3});
			hero.view = new heroPng();
			hero.onJump.add(heroJump);
			hero.onGiveDamage.add(heroFight);
			hero.onTakeDamage.add(heroHurt);
			add(hero);
			
			
			
			var enemy:Enemy = new Enemy("enemy", {x:250, y:50, height:30, width:30, leftBound:235, rightBound:360});
			enemy.view = new enemyPng();
			add(enemy);
			
			
			enemy = new Enemy("enemy", {x:1450, y:200, height:30, width:30, leftBound:1450, rightBound:1560});
			enemy.view = new enemyPng();
			add(enemy);
			
			enemy = new Enemy("enemy", {x:740, y:200, height:30, width:30, leftBound:740, rightBound:890});
			enemy.view = new enemyPng();
			add(enemy);
			
			enemy = new Enemy("enemy", {x:660, y:420, height:30, width:30, leftBound:660, rightBound:930});
			enemy.view = new enemyPng();
			add(enemy);
			
			enemy = new Enemy("enemy", {x:1060, y:360, height:30, width:30, leftBound:1060, rightBound:1180});
			enemy.view = new enemyPng();
			add(enemy);
			
			enemy = new Enemy("enemy", {x:1300, y:420, height:30, width:30, leftBound:1300, rightBound:1420});
			enemy.view = new enemyPng();
			add(enemy);
			
			enemy = new Enemy("enemy", {x:1860, y:420, height:30, width:30, leftBound:1850, rightBound:1880});
			enemy.view = new enemyPng();
			add(enemy);
			
			
			
			
			lifeField = new TextField(100, 20, "LIFE: +++", "Arial");
			lifeField.fontSize = 20;
			lifeField.color = Color.RED;
			lifeField.autoScale = true;
			lifeField.x = (stage.stageWidth - lifeField.width) +5;
			lifeField.y = (0 + lifeField.height)-5;
			lifeField.visible = true;
			addChild(lifeField);
			
			
			
			var startTexture:Texture = Texture.fromBitmap(new startmessagePng());
			startPopup = new Image(startTexture);
			//startPopup.visible = false;
			addChild(startPopup);
			
			var babbyTexture:Texture = Texture.fromBitmap(new babbymessagePng());
			babbyPopup = new Image(babbyTexture);
			babbyPopup.visible = false;
			addChild(babbyPopup);
			
			
			
			view.cameraLensWidth = 512;
			view.cameraLensHeight = 448;
			view.setupCamera(hero, new MathVector(256,224), new Rectangle(0, 0, 2048, 224), new MathVector(.5, 0));
			
		}
		
		private function killStartMessage(contact:b2Contact):void
		{
			startPopup.visible = false;
		}
		
		private function killMessage(contact:b2Contact):void
		{
			babbyPopup.visible = false;
		}
		
		private function checkBaby(contact:b2Contact):void
		{
			if(bookCollected && chewCollected && songCollected && pottyCollected && kissCollected){
				engine.sound.stopSound("BGM");
				engine.state = new WinState();
			}else{
				babbyPopup.visible = true;
			}
		}		
		
		
		
		private function heroJump():void
		{
			engine.sound.playSound("Jump", 1, 0);
		}
		
		private function heroFight():void
		{
			engine.sound.playSound("Pickup", 1, 0);
		}
		
		private function heroHurt():void
		{
			engine.sound.playSound("Hurt", 1, 0);
			if(heroLife == 1){
				engine.sound.stopSound("BGM");
				engine.state = new DieState();
			}else{
				heroLife--;
				switch(heroLife){
					case 0:
						lifeField.text = "LIFE:"
						break;
					case 1:
						lifeField.text = "LIFE: +"
						break;
					case 2:
						lifeField.text = "LIFE: ++"
						break;
					case 3:
						lifeField.text = "LIFE: +++"
						break;
				}
			}
		}
		
		
		
		
		private function bookTouched(contact:b2Contact):void
		{
			if (Box2DUtils.CollisionGetOther(book, contact) is Hero) {
				engine.sound.playSound("Pickup", 1, 0);
				bookCollected = true;
				itemsCollected++;
				var texture:Texture = Texture.fromBitmap(new bookiconPng());
				var icon:Image = new Image(texture);
				icon.x = 5;
				icon.y = itemsCollected*icon.height+5;
				addChild(icon);
			}
		}
		
		private function chewTouched(contact:b2Contact):void
		{
			if (Box2DUtils.CollisionGetOther(chew, contact) is Hero) {
				engine.sound.playSound("Pickup", 1, 0);
				chewCollected = true;
				itemsCollected++;
				var texture:Texture = Texture.fromBitmap(new chewiconPng());
				var icon:Image = new Image(texture);
				icon.x = 5;
				icon.y = itemsCollected*icon.height+5;
				addChild(icon);
			}
		}
		
		private function songTouched(contact:b2Contact):void
		{
			if (Box2DUtils.CollisionGetOther(song, contact) is Hero) {
				engine.sound.playSound("Pickup", 1, 0);
				songCollected = true;
				itemsCollected++;
				var texture:Texture = Texture.fromBitmap(new songiconPng());
				var icon:Image = new Image(texture);
				icon.x = 5;
				icon.y = itemsCollected*icon.height+5;
				addChild(icon);
			}
		}
		
		private function pottyTouched(contact:b2Contact):void
		{
			if (Box2DUtils.CollisionGetOther(potty, contact) is Hero) {
				engine.sound.playSound("Pickup", 1, 0);
				pottyCollected = true;
				itemsCollected++;
				var texture:Texture = Texture.fromBitmap(new pottyiconPng());
				var icon:Image = new Image(texture);
				icon.x = 5;
				icon.y = itemsCollected*icon.height+5;
				addChild(icon);
			}
		}
		
		private function kissTouched(contact:b2Contact):void
		{
			if (Box2DUtils.CollisionGetOther(kiss, contact) is Hero) {
				engine.sound.playSound("Pickup", 1, 0);
				kissCollected = true;
				itemsCollected++;
				var texture:Texture = Texture.fromBitmap(new kissiconPng());
				var icon:Image = new Image(texture);
				icon.x = 5;
				icon.y = itemsCollected*icon.height+5;
				addChild(icon);
			}
		}
	}
}