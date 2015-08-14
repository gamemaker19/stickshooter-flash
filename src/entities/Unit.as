package entities 
{
	import Controller;
	import flash.accessibility.AccessibilityImplementation;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/*
	 * Generally speaking, a unit is a class that represents an entity that can fight, take damage, move, etc.
	 * Think of it as a unit in RTS terms.
	 * 
	 * Projectiles and weapons won't be units. Unless:
	 * 	-You want to play as a projectile (i.e. controllable rocket)
	 *  -You have a sentient weapon that can move and fire on its own accord
	 */
	public class Unit extends Collider
	{
		public var is_down:Boolean = false;    //Set to true if KO'd or dead
		public var alliance:int = 0;
		public var look_angle:Number = 0;
		public var hp:Number = 200;
		
		public var move_x:Number = 0;
		public var move_y:Number = 0;
		
		public var ctl:Controller;
		
		public var state:int;
		
		
		/*AI SECTION*/
		
		//AI Enums
		public static var AIS_PATROL:int = -1;
		public static var AIS_STAY_AT_WAYPOINT:int = 0;
		public static var AIS_MOVE_TO_POSITION:int = 1;
		public static var AIS_ARRIVE_CONFUSED:int = 2;
		
		//Idle behavior enum
		public static var IB_STILL:int = 0;	//Be absolutely still. Don't even turn
		public static var IB_PATROL:int = 1;	//Patrol about
		public static var IB_TURN:int = 2;	//Only turn, don't patrol
		
		//Alert behavior enum
		public static var AB_STAY:int = 0;	//Hold ground at waypoint
		public static var AB_NORMAL:int = 1;	//Normal: can be called upon as an investigator
		public static var AB_STILL:int = 2;	//Be absolutely still, even in a waypoint
	
		public var squad:Squad;

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
		
		public var idle_behavior:int = IB_PATROL;
		public var alert_behavior:int = AB_NORMAL;
		
		public var is_following_player:Boolean = false;
		public var shoot_time:Number = 0;
		public var max_shoot_time:Number = 0.75;

		public var vigor:Number = 1;  //The lower the vigor, the more quickly they will act
		
		//squad = null;
		//squad_num = 0;
		
		public var waypoint:Waypoint;       //The enemy's waypoint (won't be removed if no longer colliding with it)
		public var cur_waypoint:Waypoint;   //The enemy's current waypoint (it will be null if no longer colliding with one)
		public var dest_waypoint:Waypoint;
		public var best_neighbor:Waypoint;

		public var is_investigator:Boolean;

		public var is_alerted:Boolean = false;
		public var last_known_x:Number = 0;
		public var last_known_y:Number = 0;
		public var dest_x:Number = 0;
		public var dest_y:Number = 0;

		public var target:Unit;
		public var last_target:Unit;

		public var ai_state:int = AIS_PATROL;

		public var sight_range:Number = 500;

		//public var ladder;
		//public var ladder_dir = 0;
		
		//Jump points
		public var jump_point:JumpPoint;
		public var ai_num_jump_frames:Number = 0;
		public var max_ai_num_jump_frames:Number = 0;

		//Random movement
		public var ai_move_dist:Number = 0;
		public var ai_max_move_dist:Number = 0;
		public var ai_move_dir:Number = 0;
		public var ai_last_x:Number = 0;

		//Non-alert patrol
		public var ai_turn_time:Number = 0;
		public var max_ai_turn_time:Number = 4;

		//Alert patrol
		public var ALERT_ACTION_TURN:int = 0;
		public var ALERT_ACTION_MOVE:int = 2;

		public var ai_alert_action:int = ALERT_ACTION_TURN;
		public var ai_alert_dir_change_num:Number = 0;
		public var ai_max_alert_dir_change_num:Number = 3;

		public var change_dir_time:Number = 0;
		public var max_change_dir_time:Number = 0.37;

		//Random action

		public var ai_random_action:Number = 0;
		public var ai_random_action_time:Number = 0;
		public var ai_max_random_action_time:Number = 0;
		public var DUCK:Number = 1;
		public var JUMP:Number = 2;
		
		//Angles
		public var def_look_angle:Number = 0;
		public var cur_look_angle:Number = 0;
		public var dest_look_angle:Number = 0;
		public var saved_helmet_off:Boolean = true;
		
		//Confusion
		public var confuse_time:Number = 0;
		public var max_confuse_time:Number = 0.4;

		public function get is_human():Boolean
		{
			return true;
		}
		
		public function Unit() 
		{
			ctl = new Controller();
		}
		
		override public function update():void
		{
			if (is_human)
			{
				ctl.update();	//Controls must be the first thing obtained if human player
			}
			else
			{
				update_ai();
			}
			
			super.update();
		}
		
		public function update_ai():void
		{
			
		}
		
	}

}