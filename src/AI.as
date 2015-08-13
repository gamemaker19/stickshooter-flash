package 
{
	import entities.Waypoint;
	public class AI 
	{
		public var host:Unit;
		public function get ctl():Controller
		{
			return host.ctl;
		}

		//AI Enums
		public static var STAY_AT_WAYPOINT:int = 0;
		public static var MOVE_TO_POSITION:int = 1;
		public static var CONFUSED:int = 2;
		
		//Idle behavior enum
		public static var IB_STILL:int = 0;	//Be absolutely still. Don't even turn
		public static var IB_PATROL:int = 1;	//Patrol about
		public static var IB_TURN:int = 2;	//Only turn, don't patrol
		
		//Alert behavior enum
		public static var AB_STAY:int = 0;	//Hold ground at waypoint
		public static var AB_NORMAL:int = 1;	//Normal: can be called upon as an investigator
		public static var AB_STILL:int = 2;	//Be absolutely still, even in a waypoint
		
		/*
		//AI enemy types
		CIVILIAN = -2;
		POLICE = -1;
		THUG_MINOR = 0;
		THUG_MAJOR = 1;
		BODYGUARD_MINOR = 2;
		BODYGUARD_MAJOR = 3;
		DARK_AGENT = 4;
		ELITE_MINOR = 5;
		ELITE_MAJOR = 6;
		DA_BOSS = 7;
		*/
		
		//The main data variables
		
		public var idle_behavior = IB_PATROL;
		public var alert_behavior = AB_NORMAL;
		
		public var is_following_player:Boolean = false;
		public var shoot_time:Number = 0;
		public var max_shoot_time:Number = 0.75;

		public var vigor:Number = 1;  //The lower the vigor, the more quickly they will act
		
		//squad = noone;
		//squad_num = 0;
		
		public var waypoint:Waypoint;       //The enemy's waypoint (won't be removed if no longer colliding with it)
		public var cur_waypoint:Waypoint;   //The enemy's current waypoint (it will be noone if no longer colliding with one)
		public var dest_waypoint:Waypoint;
		public var best_neighbor:Waypoint;

		public var is_investigator:Boolean;

		public var is_alerted:Boolean = false;
		public var last_known_x:Number = 0;
		public var last_known_y:Number = 0;
		public var dest_x:Number = 0;
		public var dest_y:Number = 0;

		public var target:Base;
		public var last_target:Base;

		public var ai_state:int = AIS_PATROL;
		public var state:int = IDLE;

		public var sight_range:Number = 500;

		//public var ladder;
		//public var ladder_dir = 0;
		
		//Jump points
		jump_point;
		ai_num_jump_frames = 0;
		max_ai_num_jump_frames = 0;

		//Random movement
		ai_move_dist = 0;
		ai_max_move_dist = 0;
		ai_move_dir = 0;
		ai_last_x = 0;

		//Non-alert patrol
		ai_turn_time = 0;
		max_ai_turn_time = 4;

		//Alert patrol

		ALERT_ACTION_TURN = 0;
		ALERT_ACTION_MOVE = 2;

		ai_alert_action = ALERT_ACTION_TURN;
		ai_alert_dir_change_num = 0;
		ai_max_alert_dir_change_num = 3;

		change_dir_time = 0;
		max_change_dir_time = 0.37;

		//Random action

		ai_random_action = 0;
		ai_random_action_time = 0;
		ai_max_random_action_time = 0;
		DUCK = 1;
		JUMP = 2;
		
		//Angles
		def_look_angle = 0;
		cur_look_angle = 0;
		dest_look_angle = 0;

		saved_helmet_off = true;

		public function AI() 
		{
			
		}
		
		public function update():void
		{
			
		}
		
		//Attempt to get a target
		public function get_target(asight_range:int):Base
		{
			
		}
		
		//If we can see the target or not.
		public function can_see_target():Boolean
		{
			
		}
		
		//Look at the target passed in.
		public function look_at_target(target:Base):void
		{
			
		}
		
		//Gets the nearest adjacent waypoint to the target.
		public function get_nearest_neighbor(target:Base):void
		{
			
		}
		
	}

}