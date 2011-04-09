package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	public class Game extends World
	{
		public var player:Entity;
		
		function Game()
		{
			player = create(Player);
			player.x = FP.halfWidth;
			player.y = FP.halfHeight;
			for (var i:uint = 0; i < 10; ++i)
			{
				var enemy:Entity = create(Enemy);
				enemy.x = FP.rand(FP.width);
				enemy.y = FP.rand(FP.height);
			}
		}
	}
}
