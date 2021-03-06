﻿package uk.co.andrewdobson.drawing
{
        import flash.display.*;
		
        public class Arc
        {
                public static function draw(t:Sprite, radius:Number,  arc:Number, sx:Number=0, sy:Number=0, startAngle:Number=-90, isCentered:Boolean = true):void
                {
						//trace("drawing arc");
						
						if(isCentered){
						sy = sy - radius;
						}
                        t.graphics.moveTo(sx, sy);
						
                        var segAngle:Number;
                        var angle:Number;
                        var angleMid:Number;
                        var numOfSegs:Number;
                        var ax:Number;
                        var ay:Number;
                        var bx:Number;
                        var by:Number;
                        var cx:Number;
                        var cy:Number;
						
						
                        if (Math.abs(arc) > 360) 
                        {
                                arc = 360;
                        }
                
                        numOfSegs = Math.ceil(Math.abs(arc) / 45);
                        segAngle = arc / numOfSegs;
                        segAngle = (segAngle / 180) * Math.PI;
                        angle = (startAngle / 180) * Math.PI;
                
                        ax = sx - Math.cos(angle) * radius;
                        ay = sy - Math.sin(angle) * radius;
                
                        for(var i:int=0; i<numOfSegs; i++) 
                        {
                                angle += segAngle;
                                // find the angle halfway between the last angle and the new
                                angleMid = angle - (segAngle / 2);
                                // calculate our end point
                                bx = ax + Math.cos(angle) * radius;
                                by = ay + Math.sin(angle) * radius;
                                // calculate our control point
                                cx = ax + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
                                cy = ay + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
                                // draw the arc segment
                                t.graphics.curveTo(cx, cy, bx, by);
                        }
                }
        }
}