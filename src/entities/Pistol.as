package entities 
{
	import Sprites;
	public class Pistol extends Weapon
	{		
		public function Pistol() 
		{
			super();
			
			name = "Pistol";
			max_cooldown_time = 0.375;
			reload_time = 1.25;

			//fire_sound_index = snd_pistol;

			weight = 0.97;

			clip = 8;
			clip_size = 8;

			ammo = 24;  
			max_ammo = 24;

			damage = 6;
			accuracy = 1;

			is_automatic = true;
			headshot_modifier = 2.5;
			projectile = Bullet;
			current_sprite = Sprites.weapon_pistol;
		}
		
	}

}