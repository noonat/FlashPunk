package
{
	import net.flashpunk.components.Health;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	public class Enemy extends Entity
	{
		protected var _color:uint = 0xffff00;
		protected var _health:Health = new Health(16);
		protected var _hurtTimer:Number = 0;
		protected var _image:Image = Image.createRect(32, 32);
		
		function Enemy()
		{
			super(0, 0, _image);
			setHitbox(32, 32, 16, 16);
			type = 'enemy';
			
			addComponent('health', _health = new Health(16));
			_health.onHurt.add(onHurt);
			_health.onKilled.add(onKilled);
		}
		
		protected function onHurt(damage:Number, hurter:Entity):void
		{
			trace('Enemy.onHurt', damage, hurter);
			_hurtTimer = 1.0;
		}
		
		protected function onKilled(killer:Entity):void
		{
			trace('Enemy.onKilled', killer);
		}
		
		override public function render():void
		{
			if (_hurtTimer > 0)
			{
				_image.color = FP.colorLerp(_color, 0xff0000, _hurtTimer);
			}
			else
			{
				_image.color = _color;
			}
			super.render();
		}
		
		override public function update():void
		{
			super.update();
			_hurtTimer = Math.max(0, _hurtTimer - FP.elapsed);
			
			var player:Entity = world.nearestToEntity('player', this);
			if (player !== null)
			{
				moveTowards(player.x, player.y, 10 * FP.elapsed);
			}
		}
	}
}
