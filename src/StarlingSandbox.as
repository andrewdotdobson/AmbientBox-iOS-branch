package  
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
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
	import starling.core.Starling;
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ParticleDesignerPS;
	
	/**
	 * ...
	 * @author Andrew Dobson
	 */
	public class StarlingSandbox extends Sprite 
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
	private var wallThickness:Number = 20;
	private var _gravity:Number = 0;
	
	private var _maxBalls:Number = 0;
	private var ballCount:Number = 0;
	
	public var ballArray:Array = new Array();
	private var vecArray:Array = new Array();

	private var particle:ParticleEmitter;
	private var particleArray:Array = new Array();
	public var activeID:Number;
	public var cArray:Array = new Array(0x602D91, 0x2E1C92, 0x00AEC0, 0xD25322, 0xA9179A, 0xE80C79, 0xA2BD35, 0x39C24A, 0xff9900,0xffffff );
	//public var cArray:Array = new Array(0xff0000, 0xffff00, 0x0033cc, 0xff9900, 0x00cc00, 0x660099, 0xffffff, 0x000000 );
	public var mousePos:Vec2 = new Vec2(0,0);
	
		public function StarlingSandbox() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void 
		{
		
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
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
			
			// Rigid body to act as a mouse handler //
			handBody = new Body(BodyType.STATIC);
		//	handBody.shapes.add(new Circle(1));
			handBody.space = space;
		
			
			hand = new PivotJoint(handBody, null, new Vec2(), new Vec2());
			hand.active = false;
			hand.stiff = false;
			hand.space = space;
			
			//event listeners
			//refactored for mobile
			addEventListener(Event.ENTER_FRAME, loop);
			
			//mainStage.addEventListener(MouseEvent.MOUSE_DOWN, _md);
			//mainStage.addEventListener(MouseEvent.MOUSE_UP, _mup);
			mainStage.addEventListener(TouchEvent.TOUCH_BEGIN, _md);
			mainStage.addEventListener(TouchEvent.TOUCH_END, _mup);
			mainStage.addEventListener(TouchEvent.TOUCH_TAP, _dc);
			mainStage.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			for (var i:uint; i < 8; i++)
			{
				createParticle(i);
				addBall(i);
			}
			
			
			
			//tell the main stage that the application is ready!
			//dispatchEvent(new Event("starlingready", true));
			mainStage.dispatchEvent(new flash.events.Event("ready"));
		}
		
		private function touchMoveHandler(e:TouchEvent):void 
		{
			var id:int = e.touchPointID;
			mousePos = new Vec2(e.stageX, e.stageY);
			
		}
		
		private function loop(e:Event):void
		{
		//	mousePos = new Vec2(mainStage.mouseX, mainStage.mouseY);
			handBody.position = mousePos;
			space.step(1 / 60);
			var b:Body = space.bodies.at(0);
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
		
		private function _dc(e:TouchEvent = null):void
		{
			var bl:BodyList = space.bodiesUnderPoint(mousePos);
			for (var i:int = 0; i < bl.length; i++)
			{
				var b:Body = bl.at(i);
				if (!b.isDynamic()) continue;
				var mainClass:Orb = b.graphic as Orb;
				if (mainClass.isActive)
				{
					mainClass.isActive = false;
				} else {
					mainClass.isActive = true;
				}
				
				break;
			}
		}
		
		private function _md(e:TouchEvent = null):void
		{

			var bl:BodyList = space.bodiesUnderPoint(mousePos);
	
			for (var i:int = 0; i < bl.length; i++)
			{
				var b:Body = bl.at(i);
				activeID = b.graphic.id;
				if (!b.isDynamic()) continue;
				hand.body2 = b;
				hand.active = true;
				break;
			}
			
			mainStage.dispatchEvent(new flash.events.Event("selected"));
			
		}
		
		private function _mup(e:TouchEvent= null):void
		{
			hand.active = false;
		}
		
		private function hasCollided(a:Body,b:Body,c:*):void
		{
			
			var particleTarget:ParticleEmitter = particleArray[(a.graphic as Orb).id];
			trace("particle A id: " + particleTarget.id +  " which has color:" + particleTarget.color.toString(16)); 
			particleTarget.x = a.position.x;
			particleTarget.y = a.position.y;
			particleTarget.triggerParticles();
			
			particleTarget = particleArray[(b.graphic as Orb).id];
			trace("particle B id: " + particleTarget.id +  " which has color:" + particleTarget.color.toString(16)); 
			particleTarget.x = b.position.x;
			particleTarget.y = b.position.y;
			particleTarget.triggerParticles();
			
			mainStage.dispatchEvent(new flash.events.Event("collide"));
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