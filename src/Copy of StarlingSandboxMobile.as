package  
{
	import flash.display.Stage;
	import flash.geom.Point;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ParticleDesignerPS;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class StarlingSandboxMobile extends Sprite 
	{
	[Embed(source = "../assets/grad_bg.png")]
	private var back:Class;
	private var space:Space;
	private var hand:PivotJoint;
	private var handBody:Body;
	private var ballcb:CbType;
	private var boundary:Body;
	private var w:Number;
	private var h:Number;
	private var mainStage:Stage;
	private var wallThickness:Number = 500;
	private var _gravity:Number = 30;
	private var textOutput:TextField;
	private var _maxBalls:Number = 0;
	private var ballCount:Number = 0;
	
	public var ballArray:Array = new Array();
	private var vecArray:Array = new Array();
	
	private var particle:ParticleEmitter;
	private var particleArray:Array = new Array();
	public var activeID:Number = 0;
	public var cArray:Array = new Array(0x602D91, 0x2E1C92, 0x00AEC0, 0xD25322, 0xA9179A, 0xE80C79, 0xA2BD35, 0x39C24A, 0xff9900,0xffffff );
	//public var cArray:Array = new Array(0xff0000, 0xffff00, 0x0033cc, 0xff9900, 0x00cc00, 0x660099, 0xffffff, 0x000000 );
	public var mousePos:Vec2 = new Vec2(0,0);
	
		public function StarlingSandboxMobile() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void 
		{
		
			removeEventListener(Event.ADDED_TO_STAGE, init);

			
			this.touchable = true;
			mainStage = Starling.current.nativeStage;
			w = mainStage.stageWidth;
			h = mainStage.stageHeight;
		
			addChild(Image.fromBitmap(new back()));
			
			space = new Space(new Vec2(0, gravity));
			
			ballcb = new CbType();
			space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, ballcb, ballcb, hasCollided));
						
			boundary = new Body(BodyType.STATIC);
			boundary.shapes.add(new Polygon(Polygon.rect(0, -wallThickness, w, wallThickness)));
			boundary.shapes.add(new Polygon(Polygon.rect(w, 0, wallThickness, h)));
			boundary.shapes.add(new Polygon(Polygon.rect(0, h, w, wallThickness)));
			boundary.shapes.add(new Polygon(Polygon.rect( -wallThickness, 0, wallThickness, h)));
			boundary.space = space;
			
			
			hand = new PivotJoint(space.world, space.world, new Vec2(), new Vec2());
			hand.active = false;
			hand.stiff = false;
			hand.space = space;
			
			//event listeners
			//refactored for mobile
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			textOutput = new TextField(500, 75, "testing output", "Arial", 14, 0xff9900, true);
			
			addChild(textOutput);
			
			for (var i:uint; i < 8; i++)
			{
				createParticle(i);
				addBall(i);
			}
				tr(w + ":" + h);
			//tell the main stage that the application is ready!
		//	mainStage.dispatchEvent(new flash.events.Event("ready"));
		}
		
			
		private function loop(e:Event):void
		{
			space.step(1 / 30);
			
		}
		
		public function addBall(i:uint):void 
		{
			var ball:Body = new Body(BodyType.DYNAMIC, new Vec2(Math.random()*w, Math.random()*h));
			ball.shapes.add(new Circle(75/2, null, new Material(10)));
			ball.space = space;
			ball.graphic = new Orb(i,cArray[i]);
			ball.graphicUpdate = updateGraphics;
			ball.cbType = ballcb;
			addChild(ball.graphic);
			ballArray.push(ball);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var t:Touch = e.getTouch(stage);
			var pos:Point = t.getLocation(stage);
			mousePos = new Vec2(pos.x, pos.y);
			hand.anchor1.setxy(mousePos.x, mousePos.y);
			if (t.phase == TouchPhase.BEGAN)
			{
				mouseDown();
			}
			
			if (t.phase == TouchPhase.MOVED)
			{
			}
			
			if (t.phase == TouchPhase.ENDED)
			{
				mouseUp();
			}
		}
		
		public function tr(s:String):void
		{
			textOutput.text = s;
		}	
			
		private function mouseDown():void
		{
			var bodies:BodyList = space.bodiesUnderPoint(mousePos);
			for (var i:int = 0; i < bodies.length; i++)
			{
				var b:Body = bodies.at(i);
				if (!b.isDynamic()) continue;				
				if(b.graphic.id){activeID = b.graphic.id}
				hand.body2 = b;
				hand.anchor2 = b.worldToLocal(mousePos);
				hand.active = true;
				
				
				break;
			}
			
		}
		
		private function mouseUp():void
		{
			hand.active = false;

		}
		
		
		private function createParticle(i:uint):void
		{
			particle = new ParticleEmitter(i, cArray[i]);
			particleArray.push(particle);
			addChild(particle);
		}
		
		private function updateGraphics(b:Body):void 
		{
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			b.graphic.rotation = b.rotation;
		}
		
		private function hasCollided(cb:InteractionCallback):void
		{
			var a:Body = cb.int1 as Body;
			var b:Body = cb.int2 as Body;
			//trigger particles at each body id:
			var particleTarget:ParticleEmitter = particleArray[(a.graphic as Orb).id];
				particleTarget.x = a.position.x;
				particleTarget.y = a.position.y;
				particleTarget.triggerParticles();
			
				particleTarget = particleArray[(b.graphic as Orb).id];
				
				particleTarget.x = b.position.x;
				particleTarget.y = b.position.y;
				particleTarget.triggerParticles();
		}
		
		public function get maxBalls():Number 
		{
			return _maxBalls;
		}
		
		public function set maxBalls(value:Number):void 
		{
			_maxBalls = value;
		}
		
		
		public function get gravity():Number 
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void 
		{
			_gravity = value;
			space.gravity = new Vec2(0,value);
		}
	}

}