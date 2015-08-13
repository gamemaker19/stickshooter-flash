package entities 
{
	import Base;
	import SpriteData;
	import Sprites;
	import IChild;
	import UnitState;
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	public class Arms extends Base implements IChild
	{
		public var punch_once:Boolean = false;
		
		public function Arms() 
		{
			super();
		}
		
		public function get owner():Infantry
		{
			return (parent as Infantry);
		}
		
		public override function update():void
		{
			super.update();

			//visible = true;
			//if(!owner.should_draw_arms()) visible = false;

			color = owner.color;
			image_speed = 0.35;
			xscale = owner.dir;
			yscale = 1;
			angle = 0;

			if(owner.is_down) {
			    return;
			}

			if(owner.state != UnitState.PUNCH) {
			    punch_once = false;
			}
			if(owner.state == UnitState.RELOAD) {
			    //if(owner != null && owner.weapon != noone && owner.weapon.name == "Shotgun") sprite_index = spr_arm_shotgun_reload;
			    //else sprite_index = spr_arm_handgun_reload;
				set_sprite(Sprites.arm_handgun_reload);
			    angle = owner.look_angle;
			    xscale = 1;
			    yscale = owner.dir;
			    if((owner.weapon.reload_time / FP.elapsed) != 0) {
			        image_speed = image_number / (owner.weapon.reload_time / FP.elapsed);
			    }
			}
			else if(owner.state == UnitState.THROW) {
			    /*
				if(!owner.grenade_thrown && image_index >= 6 && image_index <= 7) {
			        image_speed = 0;
			    }
			    else {
			        image_speed = 1;
			    }
			    sprite_index = spr_arm_throw;
			    if(image_index >= image_number - 1) {
			        owner.state = UnitState.IDLE;
			        image_index = 0;
			    }
				*/
			}
			else if(owner.state == UnitState.PUNCH) {
			    /*
				sprite_index = spr_arm_punch;
			    image_angle = owner.look_angle;
			    image_xscale = 1;
			    image_yscale = owner.dir;
			    image_speed = 1.5;
			    if(image_index >= 12 && image_index <= 14) {
			        mask_index = mask_arm_punch;
			    }
			    else {
			        mask_index = mask_empty;
			    }
			    if(image_index >= image_number - 1) {
			        owner.state = UnitState.IDLE;
			        punch_once = false;
			    }
				*/
			}
			else if(owner.state == UnitState.POINT) {
			    /*
				sprite_index = spr_arm_point;
			    
			    image_angle = 0;
			    image_xscale = owner.dir;
			    image_yscale = 1;

			    if((owner.max_alert_others_time / FP.elapsed) != 0) {
			        image_speed = image_number / (owner.max_alert_others_time / FP.elapsed);
			    }
				*/
			}
			else if(owner.state == UnitState.HANDS_UP) {
			    set_sprite(Sprites.arm_handsup);
			}
			else if(owner.state == UnitState.IDLE) {

			    if(!owner.is_grounded) {
			        if(owner.is_jumping) {
			            set_sprite(Sprites.arm_jump);
			        }
			        else {
			           set_sprite(Sprites.arm_fall);
			        }
			    }
			    else {
			        if(owner.is_running) {
			            set_sprite(Sprites.arm_run);
			        }
			        else if(owner.is_crouching) {
			            set_sprite(Sprites.arm_crouch);
			        }
			        else if(owner.is_crawling) {
			            set_sprite(Sprites.arm_crawl);
			        }
			        else {
			            set_sprite(Sprites.arm_walk);
			        }
			    }

			    if(owner.move_x == 0) {
			        image_index = 0;
			    }

			}

			//Punching
			if(!punch_once && owner.state == UnitState.PUNCH) {

				/*
			    var hits = instance_place_all(x,y,obj_stickman);
			    var hit_enemy = noone;
			    for(var i=0;i<ds_list_size(hits);i++) {
			        var cur_hit = ds_list_find_value(hits,i);
			        if(cur_hit.alliance != owner.alliance) {
			            hit_enemy = cur_hit;
			            break;
			        }
			    }
			    ds_list_destroy(hits);

			    var is_acceptable_enemy = hit_enemy != noone && ((!is_obj(hit_enemy,obj_enemy) || hit_enemy.enemy_type < 5) && hit_enemy.dir == obj_player.dir);

			    if(mask_index == mask_arm_punch && hit_enemy != noone) {

			        punch_once = true;

			        if(hit_enemy.state == hit_enemy.DODGE) {
			            var hurt_damage = instance_create(hit_enemy.x,hit_enemy.y,obj_damage_text);
			            hurt_damage.owner = hit_enemy;
			            hurt_damage.damager = owner;
			            hurt_damage.text = "Miss!";
			            ds_list_add(hit_enemy.damage_texts, hurt_damage);
			        }
			        else {

			            apply_damage(hit_enemy,10,owner,true);

			            play_sound(snd_punch,x,y);

			            if(is_obj(hit_enemy,obj_stickman) && !hit_enemy.is_down) {

			                if(is_obj(hit_enemy,obj_enemy) && is_headshot(hit_enemy) && is_acceptable_enemy) {
			                    hit_enemy.state = hit_enemy.KO;
			                }

			                if(hit_enemy.is_grounded) {
			                    hit_enemy.vel_x = owner.dir * 15;
			                }
			                else {
			                    hit_enemy.vel_x = owner.dir * 5;
			                }
			            }
			        }
			    }
			    */
			}

			x = owner.x + owner.arm_x * owner.dir;
			y = owner.y + owner.arm_y;
		}
		
		public override function render():void
		{	
			if (owner.should_draw_arms())
			{
				super.render();
			}
			
			var ox:Number = owner.arm_x;
			var oy:Number = owner.arm_y;

			//Left arm
			var left_arm_sprite:SpriteData;
			var right_arm_sprite:SpriteData;
			var is_left:Boolean = false;

			if(is_obj(owner.weapon,Pistol)) { //|| weapon.name == "Revolver" || weapon.name == "Submachine Gun") {
				left_arm_sprite = Sprites.arm_pistol_left;
				right_arm_sprite = Sprites.arm_pistol_right;
				is_left = true;
			}
			/*
			else if(weapon.name == "Minigun" || weapon.name == "Flamethrower") {
				left_arm_sprite = spr_arm_heavywep_left;
				right_arm_sprite = spr_arm_heavywep_right;
			}
			else {
				left_arm_sprite = spr_arm_rifle_left;
				right_arm_sprite = spr_arm_rifle_right;
			}
			if(state == CLIMB) left_arm_sprite = mask_empty;

			//Bow's arms use a system like no other
			if(weapon.name == "Bow") {

				var img_num;
				if(weapon.cooldown_time == 0) {
					img_num = (weapon.bow_pull_time / weapon.max_bow_pull_time) * weapon.image_number_pull;
				}
				else {
					img_num = weapon.image_number_pull + (weapon.cooldown_time / weapon.max_cooldown_time) * weapon.image_number_release;
				}

				draw_sprite_ext(spr_arm_bow,img_num,floor(ox),floor(oy),image_xscale * dir,image_yscale * dir,look_angle,image_blend,image_alpha);
			}
			else {
			*/
				//The left arm (useless for pistol)
				if(owner.state != UnitState.RELOAD) {
					if (is_left) {
						left_arm_sprite.draw(ox,oy,owner.xscale,owner.yscale,0,owner.color,owner.alpha);
					}
					else {
						left_arm_sprite.draw(ox,oy,owner.xscale*owner.dir,owner.yscale*owner.dir,owner.look_angle,owner.color,owner.alpha);
					}
				}
				/*
				if(weapon.name == "Shotgun" && weapon.cooldown_time > 0) {
					var img_num = (weapon.cooldown_time / weapon.max_cooldown_time) * sprite_get_number(spr_shotgun_reload);
					draw_sprite_ext(spr_shotgun_reload,img_num,floor(ox),floor(oy),image_xscale * dir,image_yscale * dir,look_angle,image_blend,image_alpha);
				}
				else {
				*/
					right_arm_sprite.draw(ox,oy,owner.xscale*owner.dir,owner.yscale*owner.dir,owner.look_angle,owner.color,owner.alpha);
				//}
			//}
			
		}
		
		public function update_position(host:Base):void
		{
			var ihost:Infantry = host as Infantry;
			x = ihost.arm_x;
			y = ihost.arm_y;
			dir = ihost.dir;
		}
		
	}

}