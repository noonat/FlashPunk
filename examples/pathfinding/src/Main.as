// Usually you'd have separate classes for different entities, the world, etc.
// One big file is just easier for playing around.

package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.pathfinding.Path;
	import net.flashpunk.pathfinding.PathGrid;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;

	public class Main extends Engine
	{
		private var _level:Entity;
		private var _levelData:String = [
			'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0',
			'0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0',
			'0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0',
			'0,0,0,0,1,1,1,1,1,1,0,1,1,1,0,0,0,0,0,0',
			'0,0,0,0,1,1,1,1,0,0,0,1,1,1,0,0,0,0,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0',
			'0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,1,1,0',
			'0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0',
			'0,0,0,0,1,1,1,0,0,1,1,1,1,1,1,1,0,0,0,0',
			'0,0,0,0,1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0',
			'0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'].join('\n');
		private var _goal:Entity;
		private var _grid:PathGrid;
		private var _player:Entity;
		private var _tilemap:Tilemap;
		private var _tiles:BitmapData;

		function Main()
		{
			super(400, 300, 60, true);
			FP.screen.scale = 2;
			FP.console.enable();
			FP.world = new World();
		}

		override public function init():void
		{
			super.init();

			_tiles = new BitmapData(32, 16, true, 0);
			_tiles.fillRect(new Rectangle(0, 0, 16, 16), 0xff000000);
			_tiles.fillRect(new Rectangle(16, 0, 16, 16), 0xffffffff);
			_tilemap = new Tilemap(_tiles, 320, 240, 16, 16);
			_tilemap.loadFromString(_levelData);
			_grid = new PathGrid(320, 240, 16, 16);
			_grid.loadFromString(_levelData);
			_level = new Entity(0, 0, _tilemap, _grid);
			_level.layer = 1;
			_level.type = "level";
			FP.world.add(_level);

			_player = new Entity(16, 16, Image.createRect(8, 8, 0x00ffff));
			_player.graphic.x = _player.graphic.y = -4;
			_player.type = "player";
			_player.setHitbox(8, 8, 4, 4);
			FP.world.add(_player);

			_goal = new Entity(16 * 9 + 8, 16 * 8 + 8, Image.createRect(16, 16, 0x00ff00));
			_goal.graphic.x = _goal.graphic.y = -8;
			_goal.setHitbox(16, 16, 8, 8);
			_goal.type = "goal";
			FP.world.add(_goal);
		}

		override public function update():void
		{
			super.update();

			var x:Number = 0, y:Number = 0;
			if (Input.check(Key.LEFT)) --x;
			if (Input.check(Key.RIGHT)) ++x;
			if (Input.check(Key.UP)) --y;
			if (Input.check(Key.DOWN)) ++y;
			_player.moveBy(x * 32 * FP.elapsed, y * 32 * FP.elapsed, "level", true);

			if (Input.pressed(Key.Z) || Input.mousePressed)
			{
				var path:Path = _grid.findPath(
					Input.mouseX, Input.mouseY, _goal.centerX, _goal.centerY);
				if (path)
				{
					FP.world.add(new PathEntity(Input.mouseX, Input.mouseY, path));
				}
			}
		}

		override public function render():void
		{
			super.render();
			var path:Path = _grid.findPath(
				_player.centerX, _player.centerY, _goal.centerX, _goal.centerY);
			while (path)
			{
				Draw.rect(path.x - 2, path.y - 2, 4, 4, 0xffff00);
				path = path.next;
			}
		}
	}
}
