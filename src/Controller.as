package 
{
	import net.flashpunk.utils.Input;
	
	public class Controller 
	{
		public var trigger_up:Boolean = false;
		public var trigger_down:Boolean = false;
		public var trigger_right:Boolean = false;
		public var trigger_left:Boolean = false;
		public var trigger_action:Boolean = false;
		public var trigger_reload:Boolean = false;
		public var trigger_punch:Boolean = false;
		public var trigger_grenade:Boolean = false;
		public var trigger_crouch:Boolean = false;
		public var trigger_zoom:Boolean = false;
		public var trigger_crawl:Boolean = false;
		public var trigger_fallthrough:Boolean = false;
		public var trigger_jump_release:Boolean = false;
		public var trigger_jump_hold:Boolean = false;
		public var trigger_jump:Boolean = false;
		public var trigger_run:Boolean = false;
		public var trigger_dodge:Boolean = false;
		public var trigger_attack:Boolean = false;
		public var trigger_alt_attack:Boolean = false;
		public var trigger_weapon_1:Boolean = false;
		public var trigger_weapon_2:Boolean = false;
		public var trigger_weapon_3:Boolean = false;

		public function Controller() 
		{
			
		}
		
		private function reset()
		{
			trigger_up = false;
			trigger_down = false;
			trigger_right = false;
			trigger_left = false;
			trigger_action = false;
			trigger_reload = false;
			trigger_punch = false;
			trigger_grenade = false;
			trigger_crouch = false;
			trigger_zoom = false;
			trigger_crawl = false;
			trigger_fallthrough = false;
			trigger_jump_release = false;
			trigger_jump_hold = false;
			trigger_jump = false;
			trigger_run = false;
			trigger_dodge = false;
			trigger_attack = false;
			trigger_alt_attack = false;
			trigger_weapon_1 = false;
			trigger_weapon_2 = false;
			trigger_weapon_3 = false;
		}
		
		public function update()
		{
			reset();
			get_input();
		}
		
		private function get_input()
		{
			trigger_up = Input.check(Key.W);
			trigger_down = Input.check(Key.S);
			trigger_right = Input.check(Key.D);
			trigger_left = Input.check(Key.A);
			trigger_action = Input.pressed(Key.E);
			trigger_reload = Input.check(Key.R);
			trigger_punch = Input.pressed(Key.F);
			trigger_crouch = Input.check(Key.S);
			trigger_zoom = Input.pressed(Key.Z);
			trigger_fallthrough = Input.check(Key.LeftControl);
			trigger_jump_hold = Input.check(Key.W);
			trigger_jump = Input.pressed(Key.W);
			trigger_jump_release = keyboard_check_released(W);
			trigger_run = Input.check(Key.LeftShift);
			trigger_dodge = Input.pressed(Key.Space);
			trigger_weapon_1 = Input.pressed(Key.One);
			trigger_weapon_2 = Input.pressed(Key.Two);
			trigger_weapon_3 = Input.pressed(Key.Three);
		}
	}

}