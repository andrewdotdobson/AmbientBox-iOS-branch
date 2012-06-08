package  
{
	import controller.EventDispatcherExtension;
	import flash.display.Stage;
	import flash.geom.Point;
	import model.ApplicationModel;
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
	import views.StarlingControls;
	import starling.text.TextField;
	//import flash.events.Event;
	
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
	private var _gravity:Number = 0;
	private var textOutput:TextField;
	private var _maxBalls:Number = 0;
	private var ballCount:Number = 0;
	private var _m:ApplicationModel;
	private var _isParticles:Boolean = true;
	
	public var ballArray:Array = new Array();
	private var vecArray:Array = new Array();
	public var activeID:Number = 0;
	public var cArray:Array = new Array(0x602D91, 0x2E1C92, 0x00AEC0, 0xD25322, 0xA9179A, 0xE80C79, 0xA2BD35, 0x39C24A, 0xff9900 );
	//public var cArray:Array = new Array(0xff0000, 0xffff00, 0x0033cc, 0xff9900, 0x00cc00, 0x660099, 0xffffff, 0x3499ca );
	//public var cArray:Array = new Array(0x660000, 0xA30000, 0x660066, 0x00A3A3, 0x663300, 0x006666, 0x330066, 0x336600 );
	public var mousePos:Vec2 = new Vec2(0,0);
	
	private var controlPanel:StarlingControls;
	
		public function StarlingSandboxMobile() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
			
		private function init(e:Event):void 
		{
		
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//entry point
			
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
			//addChild(textOutput);
			
			for (var i:uint; i < 8; i++)
			{
				
				addBall(i);
			}
			
			//initControls();
			//tell the main stage that the application is ready!
			dispatchEvent(new Event("starlingready", true));
			//mainStage.dispatchEvent(new flash.events.Event("yo", true, true));
			
		}
		
		public function setModel(m:ApplicationModel):void
		{
			_m = m;
			gravity = _m.gravity;
		}
		private function initControls():void
		{
			controlPanel = new StarlingControls();
			//controlPanel.y = 600;
			addChild(controlPanel);
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
		
		
		private function createParticle(posX:Number,posY:Number):void
		{
			//this needs refactoring so that the particles are created on the fly...
			//http://www.leebrimelow.com/?p=3189
			var particles:ParticleEmitter = new ParticleEmitter();
			particles.addEventListener("complete", removeParticle);
			Starling.juggler.add(particles);
			particles.x = posX;
			particles.y = posY;
			addChild(particles);
			particles.start(0.1);
			
		}
		
		private function removeParticle(e:Event):void
		{
			var p:ParticleEmitter = e.target as ParticleEmitter;
			p.stop();
			Starling.juggler.remove(p);
			removeChild(p, true);
		}
		
		private function updateGraphics(b:Body):void 
		{
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			b.graphic.rotation = b.rotation;
		}
		
		private function hasCollided(cb:InteractionCallback):void
		{
			if(_isParticles){
			var a:Body = cb.int1 as Body;
			var b:Body = cb.int2 as Body;
			
			var p1:Point = new Point(a.position.x, a.position.y);
			var p2:Point = new Point(b.position.x, b.position.y);
			
			//this logic plots a point directly between the two points - very useful code!!
			var posX:Number = p1.x + 0.5 * (p2.x - p1.x);
			var posY:Number = p1.y + 0.5 * (p2.y - p1.y);			
			createParticle(posX,posY);
			}
			dispatchEvent(new Event("collided", true));
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