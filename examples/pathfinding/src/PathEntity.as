package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.pathfinding.Node;
	import net.flashpunk.pathfinding.Path;

	public class PathEntity extends Entity
	{
		private var _node:Node;
		private var _path:Path;

		function PathEntity(x:int, y:int, path:Path)
		{
			super(x, y, Image.createRect(8, 8, 0xff9900ff));
			graphic.x = graphic.y = -4;
			setHitbox(8, 8, 4, 4);
			_path = path;
			_node = path.node;
		}

		override public function update():void
		{
			super.update();
			if (_node)
			{
				if (FP.distance(x, y, _node.x, _node.y) < 1)
				{
					_path = _path.next;
					_node = _path ? _path.node : null;
				}
				else
				{
					FP.stepTowards(this, _node.x, _node.y, 1);
				}
			}
			else world.remove(this);
		}
	}
}
