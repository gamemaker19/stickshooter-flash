package 
{
	import AI;
	public class InfantryAI extends AI
	{
		public function InfantryAI() 
		{
			super();
		}
		
		public var get weapon():Weapon
		{
			return host.weapon;
		}

		public override function update():void
		{
			super.update();
			
			if(host.is_down) { return; }

			if(target != null) {

				look_at_target(target);
				
				/*
				var throw_grenade = (irandom_range(0,300) == 0);
				if(enemy_type < 0) throw_grenade = 0;
				if(throw_grenade && enemy_type > 0 && target != null) {
					ctl.trigger_grenade = true;
				}
				else {
				*/
					var do_shot:Boolean = (Util.irandom_range(0,10*vigor) == 0);

					if(weapon.is_burst) {
						if(shoot_time > 0) {
							do_shot = true;
							shoot_time += FP.elapsed;
							if(shoot_time >= max_shoot_time) {
								shoot_time = 0;
							}
						}
						else if(do_shot) {
							shoot_time = FP.elapsed;
						}
					}

					//Close enough to melee: do it
					if(Math.abs(y - target.y) < 20 && Math.abs(x - target.x) < 35) {
						if(do_shot) {
							ctl.trigger_punch = true;
						}
					}
					else {
						if(do_shot && weapon != null && weapon.clip > 0) {
							ctl.trigger_attack = true;
						}
					}
				//}
			}
			
			//Get the waypoint we are touching
			cur_waypoint = unit.collide("Waypoint",x,y);
			if(cur_waypoint != null) {
			    waypoint = cur_waypoint;
			}
			if(target == null) {

			    target = get_target(sight_range);

			    //Got target? Alert others nearby who don't have a target
			    if(target != null) {
			    	/*
			        var nearby_enemies = get_nearby_enemies(x,y,alliance,1000);
			        for(var i=0;i<ds_list_size(nearby_enemies);i++) {
			            var enemy = ds_list_find_value(nearby_enemies,i);
			            if(enemy.target == null) {
			                with(enemy) {
			                    look_at_target(other.target);
			                }
			            }
			        }
			        ds_list_destroy(nearby_enemies);
			        */
			        last_target = target;
			    }

			}
			else {

			    if(target.is_down) {
			        target = null;
			        //squad.has_disturbance = false;
			    }

			    else {

			    	if(!can_see_target(target))
			    	{
			    		target = null;
			    	}

			    }

			}

			if(target != null) {
			    //with(squad) { 
			    //    set_disturbance(other.target.x,other.target.y);
			    //}
			    is_alerted = true;
			}
			if(cur_waypoint == null && idle_behavior == IB_PATROL) idle_behavior = IB_STILL;

			ctl.trigger_right = false;
			ctl.trigger_left = false;
			ctl.trigger_action = false;
			ctl.trigger_reload = false;
			ctl.trigger_punch = false;
			ctl.trigger_grenade = false;
			ctl.trigger_crouch = false;
			ctl.trigger_zoom = false;
			ctl.trigger_crawl = false;
			ctl.trigger_jump_hold = false;
			ctl.trigger_jump = false;
			ctl.trigger_run = false;
			ctl.trigger_dodge = false;
			ctl.trigger_attack = false;
			ctl.trigger_alt_attack = false;
			ctl.trigger_fallthrough = false;

			//Datapath
			if(is_alerted && ai_state == AIS_PATROL) {
			    ai_state = AIS_STAY_AT_WAYPOINT;
			}

			/*
			if(alliance == PLAYER) {
			    if(distance_to_object(obj_player) > 300 || is_following_player) {
			        ai_state = AIS_MOVE_TO_POSITION;
			        is_following_player = true;
			    }
			    if(distance_to_object(obj_player) < 150) {
			        is_following_player = false;
			    }
			    if(!is_following_player) {
			        if(jump_point == null) {
			            ai_state = AIS_STAY_AT_WAYPOINT;
			        }
			    }
			}
			*/

			//With a target, shoot at it

			if(target != null) {

			    look_at_target(target);

			    /*
			    var throw_grenade = (irandom_range(0,300) == 0);
			    if(enemy_type < 0) throw_grenade = 0;
			    if(throw_grenade && enemy_type > 0 && target != null) {
			        ctl.trigger_grenade = true;
			    }
			    else {
				*/
			        var do_shot = (irandom_range(0,10*vigor) == 0);

			        if(weapon.is_burst) {
			            if(shoot_time > 0) {
			                do_shot = true;
			                shoot_time += FP.elapsed;
			                if(shoot_time >= max_shoot_time) {
			                    shoot_time = 0;
			                }
			            }
			            else if(do_shot) {
			                shoot_time = FP.elapsed;
			            }
			        }

			        //Close enough to melee: do it
			        if(Math.abs(y - target.y) < 20 && Math.abs(x - target.x) < 35) {
			            if(do_shot) {
			                ctl.trigger_punch = true;
			            }
			        }
			        else {
			            if(do_shot && weapon != null && weapon.clip > 0) {
			                ctl.trigger_attack = true;
			            }
			        }
			    //}
			}

			if(!is_alerted) {
			    /*
			    if(squad.has_disturbance) {
			        is_alerted = true;
			        surprise_time = FP.elapsed;
			        ai_change_dir();   
			    }
			    else {
			        var enemy = instance_place(x-(obj_stickman.vel_x+obj_stickman.move_x),y-(obj_stickman.vel_y),obj_stickman);
			        //If player is making contact with enemy, be alerted and turn around
			        if(enemy != null && enemy.alliance != alliance) {
			            with(squad) { set_disturbance(enemy.x,enemy.y); }
			            is_alerted = true;
			            surprise_time = FP.elapsed;
			            ai_change_dir();
			        }
			    }
			    */
			}
			else {

			    ctl.trigger_run = true;

			    /*
			    if(target != null && squad != null && !squad.seen_first_target) {
			        squad.seen_first_target = true;
			        state = POINT;
			    }
			    */

			}

			//Control
			if(ai_state == AIS_PATROL) {
			    do_patrol();
			    do_random_look();
			}
			else if(ai_state == AIS_ARRIVE_CONFUSED) {
			    if(confuse_time >= max_confuse_time - FP.elapsed * 2) {
			        ai_state = AIS_STAY_AT_WAYPOINT;
			    }
			    do_random_look();
			}
			else if(ai_state == AIS_MOVE_TO_POSITION) {

				/*
			    if(!is_following_player) {
			        //dest_x = squad.last_known_x;
			        //dest_y = squad.last_known_y;
			    }
			    else {
			        dest_x = obj_player.x;
			        dest_y = obj_player.y;
			    }
			    */

			    /*
			    //If on ladder
			    if(ladder != null) {

			        //alert("on ladder")

			        jump_point = null;
			        drop_point = null;

			        ladder = instance_place(x,y,obj_ladder);

			        if(ladder_dir == -1) { 
			            ctl.trigger_up = true; 
			        }
			        else if(ladder_dir == 1) { 
			            ctl.trigger_down = true; 
			        }

			        //alert("clibming ladder");

			        return 0;

			    }
			    */

			    //If alerted and we have the target and are at a waypoint: switch to stay at waypoint phase
			    if(!is_following_player && target != null && cur_waypoint != null) {
			        ai_state = AIS_STAY_AT_WAYPOINT;
			    }

			    if(is_grounded) {
			        jump_point = null;
			        ai_jump_vel_x = 0;
			    }

			    /*
			    if(jump_point != null && jump_point.is_ladder_jp) {
			        ctl.trigger_up = true;
			        ladder = instance_place(x,y,obj_ladder);    
			        if(ladder != null) {
			            x = ladder.x;
			            vel_x = 0;
			            ai_jump_vel_x = 0;
			            ai_jump_vel_y = 0;
			            jump_point = null;
			            y--;
			            ladder_dir = -1;
			            return 0;
			        }
			    }
			    */

			    if(jump_point == null) {

			        dest_waypoint = instance_position(dest_x,dest_y,obj_waypoint);
			        if(dest_waypoint == null) {
			            dest_waypoint = get_closest_waypoint(dest_x,dest_y);
			        }

			        //If we are on the destination waypoint, just move to the target
			        if(waypoint == dest_waypoint) {
			            if(x < dest_x) { ctl.trigger_right = true; }
			            else if(x > dest_x) { ctl.trigger_left = true; }
			            if(Math.abs(x-dest_x) < 5) {
			                ctl.trigger_left = false;
			                ctl.trigger_right = false;
			                x = dest_x;

			                //At this point, be confused, and ready to switch to stay-at-waypoint mode
			                
			                if(!is_following_player && is_investigator) {
			                    confuse_time = FP.elapsed;
			                    ai_state = AIS_ARRIVE_CONFUSED;
			                    is_investigator = false;
			                    squad.has_disturbance = false;
			                }

			            }
			        }

			        //Otherwise, find the closest nearest waypoint
			        else if(waypoint != null) {

			            best_neighbor = ds_map_find_value(waypoint.dest_to_neighbor,dest_waypoint);

			            //No best neighbor: complain
			            if(best_neighbor == null) {
			                //alert("No best neighbor. Current waypoint is isolated.");
			            }
			            else {
			                //print(best_neighbor.name)
			            }

			            var jp = ds_map_find_value(waypoint.neighbor_to_jp,best_neighbor);
			            var dp = ds_map_find_value(waypoint.neighbor_to_dp,best_neighbor);

			            //If best neighbor is connected by a drop point and it's below: move to drop point and drop on it
			            if(!is_undefined(dp) && best_neighbor.y > waypoint.y) {

			                if(x < dp.x) { ctl.trigger_right = true; }
			                else if(x > dp.x) { ctl.trigger_left = true; }

			                //If it's a ladder drop point
			                if(dp.is_ladder_dp) {
			                    ctl.trigger_down = true;
			                    ladder = instance_place(x,y,obj_ladder);    
			                    if(ladder != null) {
			                        ladder_dir = 1;
			                        return 0;
			                    }
			                }

			                if(is_grounded && dp == instance_place(x,y,obj_drop_point)) {
			                    ctl.trigger_fallthrough = true;
			                    is_grounded = false;
			                }

			            }
			            //If best neighbor is connected by a jump point, move to the jump point
			            else if(!is_undefined(jp)) {

			                if(x < jp.jump_start_x) { ctl.trigger_right = true; }
			                else if(x > jp.jump_start_x) { ctl.trigger_left = true; }

			                //If at this point we reach the jump point, have the ai jump
			                if(is_grounded && jp == instance_place(x,y,obj_jump_point) && Math.abs(x - jp.jump_start_x) < 15) {
			                    x = jp.jump_start_x;

			                    //If it's a ladder jump point
			                    
			                    if(jp.is_ladder_jp) {
			                        ctl.trigger_up = true;
			                        ladder = instance_place(x,y,obj_ladder);    
			                        if(ladder != null) {
			                            //alert("jumping up to ladder")
			                            y--;
			                            ladder_dir = -1;
			                            return 0;
			                        }
			                    }

			                    if(jp.dir != dir) {
			                        ai_change_dir();
			                    }
			                    var jxy = get_jump_vels(jp);
			                    ai_jump_vel_x = jxy[0];
			                    vel_y = jxy[1];
			                    is_jumping = true;
			                    can_boost_jump = false;
			                    is_grounded = false;
			                    jump_point = jp;
			                    ctl.trigger_left = false;
			                    ctl.trigger_right = false;
			                }
			            }
			            //Otherwise just move to the waypoint normally
			            else {        
			                if(waypoint != null && best_neighbor != null) {
			                    if(waypoint.x < best_neighbor.x) { ctl.trigger_right = true; }
			                    else if(waypoint.x > best_neighbor.x) { ctl.trigger_left = true; }
			                }
			            }
			            
			        }

			    }

			    if(ctl.trigger_right && dir == -1) ai_change_dir();
			    if(ctl.trigger_left && dir == 1) ai_change_dir();

			    if(!is_grounded) {
			        ctl.trigger_left = false;
			        ctl.trigger_right = false;
			    }

			    //If we're running into a wall, stop tracking down
			    if(is_grounded) {
			        
			        var do_stop = false;
			        if(ctl.trigger_left && place_meeting(x-walk_speed,y,obj_wall)) {
			            ctl.trigger_left = false;
			            do_stop = true;
			        }
			        if(ctl.trigger_right && place_meeting(x+walk_speed,y,obj_wall)) {
			            ctl.trigger_right = false;
			            do_stop = true;
			        }

			        if(do_stop) {
			            confuse_time = FP.elapsed;
			            ai_state = AIS_ARRIVE_CONFUSED;
			            is_investigator = false;
			            squad.has_disturbance = false;
			        }

			    }


			}
			else if(ai_state == AIS_STAY_AT_WAYPOINT) {

			    //No target: alert-patrol at the current waypoint
			    if(target == null && alert_behavior != AB_STILL) {
			        do_alert_patrol();
			        do_random_look();
			    }
			    //Target: do the movement thing
			    else {
			        if(alert_behavior != AB_STILL) {
			            do_combat_movement();
			        }
			        do_random_movement();
			    }

			}

			//All overrides happen at this point

			//If distance to a grenade is close

			var nearby_grenade = collision_circle(x,y,200,obj_grenade,false,true);

			if(nearby_grenade != null) {

			    //How "dodgy" enemies will be with grenades. 4 seems to be too high
			    var grenade_dodginess = 8;  

			    var move_out = (irandom_range(1,vigor*grenade_dodginess) == 1);
			    var jump_out = (irandom_range(1,vigor*grenade_dodginess*3) == 1);

			    if(enemy_type == THUG_MINOR || enemy_type == THUG_MAJOR) {
			        move_out = 0;
			        jump_out = 0;
			    }

			    if(move_out) {
			        ctl.trigger_left = false;
			        ctl.trigger_right = false;
			        ctl.trigger_crouch = false;
			        if(x > nearby_grenade.x) ctl.trigger_right = true;
			        else if(x <= nearby_grenade.x) ctl.trigger_left = true;
			    }
			    if(jump_out) {
			        ctl.trigger_jump = true;
			        ctl.trigger_jump_hold = true;
			    }
			}

			//Message
			if(is_alerted && msg_ctl.trigger_pt != null && !msg_ctl.trigger_pt.done && msg_ctl.trigger_pt.activate_on_talker_alert) {
			    obj_global.event_msg_ctl.trigger_pt = msg_ctl.trigger_pt;
			}
		}
	}

}