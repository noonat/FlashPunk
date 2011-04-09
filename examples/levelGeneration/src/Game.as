package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Game extends World
	{
		
		[Embed(source = '../assets/dirt.png')] public static const DIRT:Class;
		[Embed(source = '../assets/grass.png')] public static const GRASS:Class;
		[Embed(source = '../assets/level.oel', mimeType = 'application/octet-stream')] public static const LEVEL:Class;
		
		public var sprDirt:Image = new Image(DIRT);
		public var sprGrass:Image = new Image(GRASS);
		
		public var dirt:BitmapData;
		public var grass:BitmapData;
		public var collision:BitmapData;
		
		public var width:int = 640;
		public var height:int = 480;
		
		public var colorDirt:uint = 0xff271f0d;
		public var colorGrass:uint = 0xff20320b;
		
		public var xml:XML;
		
		public function Game() 
		{
			//set the background colour
			FP.screen.color = colorDirt;
			
			// grab the XML data (flashpunk has a lovely function for this)
			xml = FP.getXML(LEVEL);
			
			// get the level size
			width = xml.width;
			height = xml.height;
			
			// create the new bitmapdata's that we will be using
			dirt = new BitmapData(width, height, true, 0x00000000);
			grass = new BitmapData(width, height, true, 0x00000000);
			collision = new BitmapData(width, height, true, 0x00000000);
			
			// center align the dirt/grass sprites that we will be using
			// this just makes it so when we rotate the images, they will
			// basically just stay in the same place.
			sprDirt.centerOO();
			sprGrass.centerOO();
			
			//render the wall
			renderWall();
			
			//make the grass tiles look the same as the collision tiles (for now :O)
			grass.copyPixels(collision, new Rectangle(0, 0, width, height), new Point(0, 0));
			
			var o:XML;
			var n:XML;
			
			//render the grass/dirt tiles
			for each (o in xml.walls[0].wall) 
			{
				// the previous point
				var last:Point = new Point(o.@x, o.@y);
				
				for each (n in o.node)
				{
					// get the current point
					var current:Point = new Point(n.@x, n.@y);
					
					// render tiles from the previous point to the current point
					renderTiles(last, current);
					
					// set the last tile to the current one
					last = new Point(current.x, current.y);
				}
				
				// render tiles from the last position to the first one
				renderTiles(last, new Point(o.@x, o.@y));
			}
			
			//so now display everything
			add(new Entity(0, 0, new Background(dirt)));
			add(new Wall(new Image(grass), collision));
			
			//yaaaaay.
			
		}
		
		public function renderWall():void
		{
			// set the drawing target to the collision bitmapdata
			// Draw is a flashpunk class used to render lines, circles, etc, to a bitmapdata
			Draw.setTarget(collision);
			
			var o:XML;
			var n:XML;
			
			for each (o in xml.walls[0].wall) 
			{
				// set the previous point to the first one (the x/y of the wall)
				var last:Point = new Point(o.@x, o.@y);
				
				for each (n in o.node)
				{
					// the current point
					var current:Point = new Point(n.@x, n.@y);
					
					// draw a line from the previous point to the current one
					Draw.line(last.x, last.y, current.x, current.y, colorGrass);
					
					// set the previous point to the current one
					last = new Point(current.x, current.y);
				}
				
				// draw a line from the last point to the first one
				Draw.line(last.x, last.y, o.@x, o.@y, colorGrass);
			}
			
			// fill the shape
			for each (o in xml.walls[0].filler) 
			{
				// flood fill with the grass colour
				collision.floodFill(o.@x, o.@y, colorGrass);
			}
			
			// reset the drawing target
			Draw.resetTarget()
		}
		
		public function renderTiles(start:Point, end:Point):void
		{
			//how often we should render a tile
			var frequency:int = 16;
			var increment:Point = new Point(end.x - start.x, end.y - start.y);
			increment.normalize(frequency);
			
			//current position (relative to the starting point
			var position:Point = new Point(0, 0);
			
			for (var i:int = 0; i < FP.distance(start.x, start.y, end.x, end.y) / frequency; i ++)
			{
				//get the default angle for this tile
				var angle:Number = FP.angle(start.x, start.y, end.x, end.y);
				
				//Find a point on the side of the wall with this current direction
				var incY:Number = Math.sin((angle + 90) * Math.PI / 180) * 4;
				var incX:Number = Math.cos((angle + 90) * Math.PI / 180) * 4;
				
				//if this point is NOT transparent, then we are facing the WRONG WAY, so turn us around!
				if (collision.getPixel32(start.x + position.x + incX, start.y + position.y - incY) != 0x00000000)
				{
					//increase angle by 180! :O
					angle += 180;
				}
				
				//aaaallllriiighty, time to render them tiles
				sprGrass.angle = angle;
				sprGrass.render(grass, new Point(start.x + position.x, start.y + position.y), new Point(0, 0));
				
				sprDirt.angle = angle;
				sprDirt.render(dirt, new Point(start.x + position.x, start.y + position.y), new Point(0, 0));
				
				//increase the current position by our set amount
				position.x += increment.x;
				position.y += increment.y;
			}
		}
		
	}

}