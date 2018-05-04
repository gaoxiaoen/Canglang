<?php

class Mission extends SerializeBase {
	
	static public $MISSION_XML_FILE = '/mission/mission.xml';
	static public $MISSION_LOOP_REWARD_XML_FILE = '/mission/mission_loop_reward.xml';
	
	static public $MISSION_AS3_BASE_FILE = '/../../front-end/missions.txt';
	static public $MISSION_ERLANG_BASE_FILE = '/../../config/src/mission/cfg_mission.erl';
	static public $MISSION_ERLANG_DICT_FILE = '/../../config/src/mission/cfg_mission_dict.erl';
	
	static public $MISSION_NPC_DIALOG_TYPE_NORMAL = 1; //任务NPC对话类型 1正常
	static public $MISSION_NPC_DIALOG_TYPE_QUESTION = 2; //任务NPC对话类型 2为答题
	static public $MISSION_NPC_DIALOG_TYPE_NEXT_MISSION = 3; //任务NPC对话类型 3选择下一个任务id

	public function __construct() {
//		self::$MISSION_AS3_BASE_FILE = (ROOT.self::$MISSION_AS3_BASE_FILE);
//		$this->buildMissionClient();
		self::$MISSION_ERLANG_BASE_FILE = realpath(ROOT.self::$MISSION_ERLANG_BASE_FILE);
		$this->buildMissionErlangBase();
		self::$MISSION_ERLANG_DICT_FILE = realpath(ROOT.self::$MISSION_ERLANG_DICT_FILE);
		$this->buildMissionErlangDict();
	}
	public function buildMissionClient(){
		$amf = array();
		$xml = $this->readXML (DATA_PATH.self::$MISSION_XML_FILE);
		$mission_arr = array();
		$missions = $xml->mission;
		foreach($missions as $mission){
			$id = (string)$mission["id"];
			$name = (string)$mission["name"];
			$pre_mission_id = (string) $mission["pre_mission_id"];
			$pre_mission_id_arr = explode(",",$pre_mission_id);
			
			//查找以此任务为前端任务的其它任务id列表
			$next_mission_id_arr = array();
			$temp_missions = $xml->mission;
			foreach($temp_missions as $temp_mission){
				$temp_id = (string)$temp_mission["id"];
				$temp_pre_mission_id = (string) $temp_mission["pre_mission_id"];
				$temp_pre_mission_id_arr = explode(",",$temp_pre_mission_id);
				if(count($temp_pre_mission_id_arr) != 0 && in_array($id,$temp_pre_mission_id_arr)){
					$next_mission_id_arr[] = intval($temp_id);
				}
			}
			
			
			//任务基本属性
			$mission_desc = $mission->desc;
			$desc = $mission_desc[0];
			
			$base_info = $mission->base_info;
			
			$type = (string) $base_info["type"];
			$show_type = (string) $base_info["show_type"];
			$model = (string) $base_info["model"];
			$big_group = (string) $base_info["big_group"];
			$group_desc = (string) $base_info["group_desc"];
			$color = (string) $base_info["color"];
			
			$min_level = (string) $base_info["min_level"];
			$max_level = (string) $base_info["max_level"];
			$max_do_times = (string) $base_info["max_do_times"];
			$star_level = (string) $base_info["star_level"];
			$sort_id = (string) $base_info["sort_id"];
			
			// 接收任务需要的道具配置
			$need_item_arr = array();
			$need_items = $mission->need_item;
			foreach($need_items as $need_item){
				$need_item_type_id = (string)$need_item["item_type_id"];
				$need_item_num = (string)$need_item["item_num"];
				$need_item_arr[] = array(
					intval($need_item_type_id),
					intval($need_item_num)
				);
			}
			
			// 任务侦听
			$listener_arr = array();
			$listeners = $mission->listener;
			foreach($listeners as $listener){
				$listener_type = (string)$listener["type"];
				$listener_sub_type = (string)$listener["sub_type"];
				$listener_value = (string)$listener["value"];
				$listener_need_num = (string)$listener["need_num"];
				$listener_arr[] = array(
					intval($listener_type),
					intval($listener_sub_type),
					intval($listener_value),
					intval($listener_need_num)
				);
			}
			
			// 任务状态
			$model_status_arr = array();
			$model_statuss = $mission->model_status;
			$max_model_status = count($model_statuss) - 1;
			foreach($model_statuss as $model_status){
				if(empty($model_status->npc)){// 空状态
					$model_status_arr[] = array();
				}else{
					$model_status_npc = $model_status->npc;
					$model_status_npc_npc_id = (string)$model_status_npc["npc_id"];
					$model_status_npc_dialog_arr = array();
					$model_status_npc_dialogs = $model_status_npc->dialog;
					foreach($model_status_npc_dialogs as $model_status_npc_dialog){
						$dialog_content_arr = array();
						foreach($model_status_npc_dialog->content as $dialog_content){
							$dialog_content_id = (string)$dialog_content["id"];
							$dialog_content_say_type = (string)$dialog_content["say_type"];
							$dialog_content_content = $dialog_content[0];
							$dialog_content_arr[] = array(
								intval($dialog_content_id),
								intval($dialog_content_say_type),
								trim($dialog_content_content)
							);
						}
						if(!empty($model_status_npc_dialog->question)){
							$questions = $model_status_npc_dialog->question;
							$question_arr = array();
							$answer = 0;
							foreach($questions as $question){
								$option = (string)$question["option"];
								$option_tips = (string)$question["tips"];
								if($question["answer"] == "true"){
									$answer = (string)$question["option"];
								}
								$question_desc = $question[0];
								$question_arr["\"".$option."\""] = array(intval($option),trim($question_desc),trim($option_tips));
							}
							$model_status_npc_dialog_arr[] = array(
								intval(Mission::$MISSION_NPC_DIALOG_TYPE_QUESTION),
								trim($dialog_content_arr),
								trim($answer),
								$question_arr
							);
						}elseif(!empty($model_status_npc_dialog->option)){
							$require_id=(string)$model_status_npc_dialog["require_id"];
							$options = $model_status_npc_dialog->option;
							$option_arr = array();
							foreach($options as $option){
								$option_id = (string)$option["id"];
								$option_next_mission_id = (string)$option["next_mission_id"];
								$option_tips = (string)$option["tips"];
								$option_desc = (string)$option[0];
								$option_arr["\"".$option_id."\""] = array(
									intval($option_id),
									intval($option_next_mission_id),
									trim($option_desc),
									trim($option_tips)
								);
							}
							$model_status_npc_dialog_arr[] = array(
								intval(Mission::$MISSION_NPC_DIALOG_TYPE_NEXT_MISSION),
								trim($dialog_content_arr),
								intval($require_id),
								$option_arr
							);
						}else{
							$model_status_npc_dialog_arr[] = array(
								intval(Mission::$MISSION_NPC_DIALOG_TYPE_NORMAL),
								trim($dialog_content_arr)
							);
						}
					}
					$model_status_arr[] = array(
						intval($model_status_npc_npc_id),
						$model_status_npc_dialog_arr
					);
				}
				
			}
			
			// 任务奖励（基本）
			$reward = $mission->reward;
			
			$rollback_times = (string) $reward["rollback_times"];
			$is_category = (string) $reward["is_category"];
			$formula_base = (string) $reward["formula_base"];
			$formula_item = (string) $reward["formula_item"];
			$exp = (string) $reward["exp"];
			$silver = (string) $reward["silver"];
			$coin = (string) $reward["coin"];
			
			$reward_arr = array(
				intval($rollback_times),
				intval($is_category),
				intval($formula_base),
				intval($formula_item),
				intval($exp),
				intval($silver),
				intval($coin)
			);
			
			// 任务道具奖励
			$reward_item_arr = array();
			$reward_items = $mission->reward_item;
			foreach($reward_items as $reward_item){
				$reward_item_item_type_id = (string)$reward_item["item_type_id"];
				$reward_item_item_type = (string)$reward_item["item_type"];
				$reward_item_item_num = (string)$reward_item["item_num"];
				$reward_item_bind_type = (string)$reward_item["bind_type"];
				$reward_item_color = (string)$reward_item["color"];
				$reward_item_arr[] = array(
					intval($reward_item_item_type_id),
					intval($reward_item_item_type),
					intval($reward_item_item_num),
					intval($reward_item_bind_type),
					intval($reward_item_color)
				);
			}
			$mission_arr["\"".$id."\""] = array(
				intval($id),
				trim($name),
				trim($desc),
				intval($type),
				intval($show_type),
				intval($model),
				intval($big_group),
				trim($group_desc),
				intval($color),
				$pre_mission_id_arr,
				intval($min_level),
				intval($max_level),
				intval($max_do_times),
				intval($star_level),
				intval($sort_id),
				$next_mission_id_arr,
				$need_item_arr,
				$listener_arr,
				$model_status_arr,
				intval($max_model_status),
				$reward_arr,
				$reward_item_arr
			);
		}
		
		//分组奖励配置
		$mission_loop_reward_arr = array();
		$loop_xml = $this->readXML (DATA_PATH.self::$MISSION_LOOP_REWARD_XML_FILE);
		$groups = $loop_xml->group;
		foreach($groups as $group){
			$id = (string)$group["id"];
			$rewards = $group->reward;
			foreach($rewards as $reward){
				//基本奖励
				$level = (string)$reward["level"];
				$exp = (string)$reward["exp"];
				$silver = (string)$reward["silver"];
				$coin = (string)$reward["coin"];
				
				$rollback_times = "0";$is_category="0";$formula_base="0";$formula_item="0";
				
				//道具奖励
				$reward_arr = array();
				if(empty($reward->reward_items)){// 没有道具奖励
					$reward_arr = array();
				}else{
					$reward_itemss = $reward->reward_items;
					$do_times_arr = array();
					foreach($reward_itemss as $reward_items){
						$do_times=(string)$reward_items["do_times"];
						$reward_items = $reward_items->reward_item;
						$reward_item_arr = array();
						foreach($reward_items as $reward_item){
							$item_type_id = (string)$reward_item["item_type_id"];
							$item_type = (string)$reward_item["item_type"];
							$item_num = (string)$reward_item["item_num"];
							$bind_type = (string)$reward_item["bind_type"];
							$color = (string)$reward_item["color"];
							$reward_item_arr[] = array(
								intval($item_type_id),
								intval($item_type),
								intval($item_num),
								intval($bind_type),
								intval($color)
							);
						}// end for reward_item
						$do_times_arr["\"".$do_times."\""] = $reward_item_arr;
					}// end for reward_items
					$reward_arr = $do_times_arr;
				}// end if
				$mission_loop_reward_arr["\"".$id."_".$level."\""] = array(
					intval($rollback_times),
					intval($is_category),
					intval($formula_base),
					intval($formula_item),
					intval($exp),
					intval($silver),
					intval($coin),
					$reward_arr
				);
			}// end for reward
		}// end for group
//		print_r($mission_arr);
		$amf_arr = array($mission_arr,$mission_loop_reward_arr);
		$amf = $this->getArrayAMF($amf_arr);
		$this->writeToFile ( $amf, self::$MISSION_AS3_BASE_FILE );
		echo ('导出任务【前端】数据成功，path='. self::$MISSION_AS3_BASE_FILE . "\n");
	}
	public function buildMissionErlangDict() {
		$erlang = "";
		$erlang .= "%% -*- coding: latin-1 -*-\n";
		$erlang .= "%% Author: caochuncheng2002@gmail.com\n";
		$erlang .= "%% Created: 2013-7-3\n";
		$erlang .= "%% Description: 任务字典信息\n\n\n";
		$erlang .= "-module(cfg_mission_dict).\n\n";
		$erlang .= "-export([\n";
		$erlang .= "         get_mission_dict/0\n";
		$erlang .= "        ]).\n";
		
		$erlang .= "\n\n";
		$xml = $this->readXML (DATA_PATH.self::$MISSION_XML_FILE);
		$mission_dict_arr = array();
		
		$missions = $xml->mission;
		foreach($missions as $mission){
			$id = (string)$mission["id"];
			$name = (string)$mission["name"];
			$base_info = $mission->base_info;
			
			$type = (string) $base_info["type"];
			$big_group = (string) $base_info["big_group"];
			//%% [{"id":23600155,"name":"奇妙微笑","type":1,"big_group":0},...].
			$temp_json = "{\\\"id\\\":".$id;
			$temp_json .= ",\\\"name\\\":\\\"".$name."\\\"";
			$temp_json .= ",\\\"type\\\":".$type;
			$temp_json .= ",\\\"big_group\\\":".$big_group;
			$temp_json .= "}";
			$mission_dict_arr[] = $temp_json;
		}
		
		$mission_dict_erl = "\"[".implode(",\n      ",$mission_dict_arr)."]\"";
		
		$erlang .= "%% 获取信息字典信息\n";
		$erlang .= "%% 返回 json数据\n";
		$erlang .= "%% [{\"id\":23600155,\"name\":\"奇妙微笑\",\"type\":1,\"big_group\":0},...].\n";
		$erlang .= "get_mission_dict() ->\n";
		$erlang .= "    ".$mission_dict_erl.".\n";
		
		$this->writeToFile ($erlang,self::$MISSION_ERLANG_DICT_FILE,false);
		echo ('导出任务字典数据成功，path='.self::$MISSION_ERLANG_DICT_FILE."\n");
	}
	public function buildMissionErlangBase() {
		$erlang = "";
		$erlang .= "%% -*- coding: latin-1 -*-\n";
		$erlang .= "%% Author: caochuncheng2002@gmail.com\n";
		$erlang .= "%% Created: 2013-7-3\n";
		$erlang .= "%% Description: 任务配置，不可以修改，必须由任务配置表生成\n\n\n";
		$erlang .= "-module(cfg_mission).\n\n";
		$erlang .= "-export([\n";
		$erlang .= "         find/1,\n";
		$erlang .= "         list/0,\n";
		$erlang .= "         get_mission_id_list/1,\n";
		$erlang .= "         get_mission_group/1,\n";
		$erlang .= "         find_mission_loop_reward/1,\n";
		$erlang .= "         get_mission_all_group/0,\n";
		$erlang .= "         get_no_group_mission_id_list/1,\n";
		$erlang .= "         get_no_group_level_list/0\n";
		$erlang .= "        ]).\n";
		
		$erlang .= "\n\n";
		
		$xml = $this->readXML (DATA_PATH.self::$MISSION_XML_FILE);
		$mission_id_arr = array();
		
		$missions = $xml->mission;
		foreach($missions as $mission){
			$id = (string)$mission["id"];
			$name = (string)$mission["name"];
			
			$pre_mission_id = (string) $mission["pre_mission_id"];
			$pre_mission_id_arr = explode(",",$pre_mission_id);
			$pre_mission_id_erl = "[".implode(",",$pre_mission_id_arr)."]";
			
			//查找以此任务为前端任务的其它任务id列表
			$next_mission_id_arr = array();
			$temp_missions = $xml->mission;
			foreach($temp_missions as $temp_mission){
				$temp_id = (string)$temp_mission["id"];
				$temp_pre_mission_id = (string) $temp_mission["pre_mission_id"];
				$temp_pre_mission_id_arr = explode(",",$temp_pre_mission_id);
				if(count($temp_pre_mission_id_arr) != 0 && in_array($id,$temp_pre_mission_id_arr)){
					$next_mission_id_arr[] = intval($temp_id);
				}
			}
			
			$next_mission_id_erl = "[".implode(",",$next_mission_id_arr)."]";
			
			//任务基本属性
			$base_info = $mission->base_info;
			
			$type = (string) $base_info["type"];
			$show_type = (string) $base_info["show_type"];
			$model = (string) $base_info["model"];
			$big_group = (string) $base_info["big_group"];
			$group_desc = (string) $base_info["group_desc"];
			$color = (string) $base_info["color"];
			
			$min_level = (string) $base_info["min_level"];
			$max_level = (string) $base_info["max_level"];
			$max_do_times = (string) $base_info["max_do_times"];
			$star_level = (string) $base_info["star_level"];
			$sort_id = (string) $base_info["sort_id"];
			
			
			
			// 接收任务需要的道具配置
			$need_item_arr = array();
			$need_items = $mission->need_item;
			foreach($need_items as $need_item){
				$need_item_type_id = (string)$need_item["item_type_id"];
				$need_item_num = (string)$need_item["item_num"];
				$need_item_arr[] = "{r_mission_need_item,".$need_item_type_id.",".$need_item_num."}";
			}
			$need_item_erl = "[".implode(",",$need_item_arr)."]";
			
			// 任务侦听
			$listener_arr = array();
			$listeners = $mission->listener;
			foreach($listeners as $listener){
				$listener_type = (string)$listener["type"];
				$listener_sub_type = (string)$listener["sub_type"];
				$listener_value = (string)$listener["value"];
				$listener_need_num = (string)$listener["need_num"];
				$temp_erl = "{r_mission_base_listener";
				$temp_erl .= ",".$listener_type;
				$temp_erl .= ",".$listener_sub_type;
				$temp_erl .= ",".$listener_value;
				$temp_erl .= ",".$listener_need_num;
				$temp_erl .= "}";
				$listener_arr[] = $temp_erl;
			}
			$listener_erl = "[".implode(",",$listener_arr)."]";
			
			// 任务状态
			$model_status_arr = array();
			$model_statuss = $mission->model_status;
			$max_model_status = count($model_statuss) - 1;
			foreach($model_statuss as $model_status){
				if(empty($model_status->npc)){
					$temp_erl = "{r_mission_model_status,[],[]}";
				}else{
					$model_status_npc = $model_status->npc;
					$model_status_npc_npc_id = (string)$model_status_npc["npc_id"];
					$model_status_npc_dialogs = $model_status_npc->dialog;
					$model_status_dialog_arr = array();
					foreach($model_status_npc_dialogs as $model_status_npc_dialog){
						if(!empty($model_status_npc_dialog->option)){
							$option_require_id = (string)$model_status_npc_dialog["require_id"];
							$option_arr = array();
							foreach($model_status_npc_dialog->option as $option){
								$option_id = (string)$option["id"];
								$option_next_mission_id = (string)$option["next_mission_id"];
								$option_arr[] = "{".$option_id.",".$option_next_mission_id."}";
							}
							$option_erl = "[".implode(",",$option_arr)."]";
							$model_status_dialog_arr[] = "{".$option_require_id.",".$option_erl."}";
						}else{
							$model_status_dialog_arr = array();
						}
					}
					$model_status_dialog_erl="[".implode(",",$model_status_dialog_arr)."]";
					$temp_erl = "{r_mission_model_status,[".$model_status_npc_npc_id."],".$model_status_dialog_erl."}";
				}
				$model_status_arr[] = $temp_erl;
			}
			$model_status_erl = "[".implode(",",$model_status_arr)."]";
			
			// 任务奖励（基本）
			$reward = $mission->reward;
			
			$rollback_times = (string) $reward["rollback_times"];
			$is_category = (string) $reward["is_category"];
			$formula_base = (string) $reward["formula_base"];
			$formula_item = (string) $reward["formula_item"];
			$exp = (string) $reward["exp"];
			$silver = (string) $reward["silver"];
			$coin = (string) $reward["coin"];
			
			$reward_erl = "{r_mission_reward";
			$reward_erl .= ",".$rollback_times;
			$reward_erl .= ",".$is_category;
			$reward_erl .= ",".$formula_base;
			$reward_erl .= ",".$formula_item;
			$reward_erl .= ",".$exp;
			$reward_erl .= ",".$silver;
			$reward_erl .= ",".$coin;
			$reward_erl .= "}";
			
			// 任务道具奖励
			$reward_item_arr = array();
			$reward_items = $mission->reward_item;
			foreach($reward_items as $reward_item){
				$reward_item_item_type_id = (string)$reward_item["item_type_id"];
				$reward_item_item_type = (string)$reward_item["item_type"];
				$reward_item_item_num = (string)$reward_item["item_num"];
				$temp_erl = "{r_mission_reward_item";
				$temp_erl .= ",".$reward_item_item_type_id;
				$temp_erl .= ",".$reward_item_item_type;
				$temp_erl .= ",".$reward_item_item_num;
				$temp_erl .= "}";
				$reward_item_arr[] = $temp_erl;
			}
			$reward_item_erl = "[".implode(",",$reward_item_arr)."]";
			
			$mission_erl = "{r_mission_base_info";
			$mission_erl .= ",".$id;
			$mission_erl .= ",\"".$name."\"";
			$mission_erl .= ",".$type;
			$mission_erl .= ",".$show_type;
			$mission_erl .= ",".$model;
			$mission_erl .= ",".$big_group;
			$mission_erl .= ",\"".$group_desc."\"";
			$mission_erl .= ",".$color;
			$mission_erl .= ",".$pre_mission_id_erl;
			$mission_erl .= ",".$min_level;
			$mission_erl .= ",".$max_level;
			$mission_erl .= ",".$max_do_times;
			$mission_erl .= ",".$star_level;
			$mission_erl .= ",".$sort_id;
			$mission_erl .= ",".$next_mission_id_erl;
			$mission_erl .= ",".$need_item_erl;
			$mission_erl .= ",".$listener_erl;
			$mission_erl .= ",".$model_status_erl;
			$mission_erl .= ",".$max_model_status;
			$mission_erl .= ",".$reward_erl;
			$mission_erl .= ",".$reward_item_erl;
			$mission_erl .= "}";
			
			$erlang .= "find(".$id.") ->\n";
			$erlang .= "    [".$mission_erl."];\n";
			
			$mission_id_arr[] = $id;
			
		}
		$erlang .="%% 根据任务Id查找任务信息\n";
		$erlang .="%% 返回 [#r_mission_base_info{}]\n";
		$erlang .= "find(_) ->\n";
		$erlang .= "    [].\n\n";
		
		$erlang .="%% 所有任务Id列表\n";
		$erlang .= "list() ->\n";
		$erlang .= "    [";
		$mission_id_arr_len = count($mission_id_arr);
		for($i = 0; $i < $mission_id_arr_len; $i ++){
			if(($i + 1) < $mission_id_arr_len){
				$separated = ","; 
			}else{
				$separated = ""; 
			}
			if($i != 0 && ($i + 1) % 10 == 0){
				$erlang .= $mission_id_arr[$i].$separated."\n     ";
			}else{
				$erlang .= $mission_id_arr[$i].$separated;
			}
		}
		$erlang .= "].\n\n";
		
		//任务分组id
		$groupMissionIdListA = array();
		$groupMissionIdListB = array();
		$groupMissionIdListC = array();
		$MissionIdListD= array();
		$missions = $xml->mission;
		foreach($missions as $mission){
			$id = (string)$mission["id"];
			$base_info = $mission->base_info;
			$big_group = (string) $base_info["big_group"];
			$min_level = (string) $base_info["min_level"];
			$max_level = (string) $base_info["max_level"];
			if($big_group > 0){
				$groupMissionIdListA[$big_group.$min_level.$max_level][] = array($big_group,$min_level,$max_level,$id);
				$groupMissionIdListB[$big_group][$min_level.$max_level]=array($big_group,$min_level,$max_level);
				if(!in_array($big_group,$groupMissionIdListC)){
					$groupMissionIdListC[] = $big_group;
				}
			}else{
				$MissionIdListD[$min_level.$max_level][]=array($min_level,$max_level,$id);
			}
		}
		foreach($groupMissionIdListA as $key=>$value){
			$value_big_group = "";
			$value_min_level = "";
			$value_max_level = "";
			$value_erl = "[";
			foreach($value as $value_item){
				if($value_big_group == "") {
					$value_big_group = $value_item[0];
					$value_min_level = $value_item[1];
					$value_max_level = $value_item[2];
					$value_erl .= $value_item[3];
				}else{
					$value_erl .= ",".$value_item[3];
				}
				
			}
			$value_erl .= "]";
			$erlang .= "get_mission_id_list({".$value_big_group.",".$value_min_level.",".$value_max_level."}) ->\n";
			$erlang .= "    [{".count($value).",".$value_erl."}];\n";
		}
		
	    $erlang .="%% 根据任务分组，最小等级，最大等级\n";
		$erlang .="%% {{Group,MinLevel,MaxLevel},{TotalMissionIdNumber,[MissionId,....]}}.\n";
		$erlang .="%% 返回 [{TotalMissionIdNumber,[MissionId,...]}] | []\n";
		$erlang .= "get_mission_id_list(_) ->\n";
		$erlang .= "    [].\n\n";
		foreach($groupMissionIdListB as $key=>$value){
			$value_big_group = "";
			$value_erl = "[";
			foreach($value as $key_key=>$value_value){
				if($value_big_group == "") {
					$value_big_group = $value_value[0];
					$value_erl .= "{".$value_value[1].",".$value_value[2]."}";
				}else{
					$value_erl .= ", {".$value_value[1].",".$value_value[2]."}";
				}
			}
			$value_erl .= "]";
			$erlang .= "get_mission_group(".$value_big_group.") ->\n";
			$erlang .= "    ".$value_erl.";\n";
		}
		$erlang .="%% 根据任务大组获取任务分组信息\n";
		$erlang .="%% {Group,[{MinLevel,MaxLevel},...]}.\n";
		$erlang .="%% 返回 [{MinLevel,MaxLevel},...]\n";
		$erlang .= "get_mission_group(_) ->\n";
		$erlang .= "    [].\n\n";
		//所有任务分组
		$erlang .="%% 获取所有任务分组\n";
		$erlang .="%% 返回 [GroupId,...]\n";
		$erlang .= "get_mission_all_group() ->\n";
		$erlang .= "    [".implode(",",$groupMissionIdListC)."].\n\n";
		
		//没有分组的任务，主线和支线的等分布
		$noGroupLevelArr = array();
		foreach($MissionIdListD as $key=>$value){
			$min_level=-1;
			$max_level=-1;
			$noGroupIdArr = array();
			$count_i=1;
			foreach($value as $value_item){
				$value_min_level = $value_item[0];
				$value_max_level = $value_item[1];
				$value_mission_id = $value_item[2];
				if($min_level==-1){
					$min_level=$value_min_level;
					$max_level=$value_max_level;
					$noGroupLevelArr[]="{".$value_min_level.",".$value_max_level."}";
				}
				if($count_i != 1 && $count_i % 10 == 1){
					$noGroupIdArr[]="\n     ".$value_mission_id;
				}else{
					$noGroupIdArr[]="".$value_mission_id;
				}
				$count_i = $count_i +1;
			}
			$erlang .= "get_no_group_mission_id_list({".$min_level.",".$max_level."}) ->\n";
			$erlang .= "    [".implode(",",$noGroupIdArr)."];\n";
		}
		//没有分组的任务，主线和支线的等分布
		$erlang .="%% 根据最小等级、最大等级获取主线和支线可接受的任务id列表\n";
		$erlang .="%% 返回 [MissionId,...]\n";
		$erlang .= "get_no_group_mission_id_list({_MinLevel,_MaxLevel}) ->\n";
		$erlang .= "    [].\n\n";
		
		$erlang .="%% 获取主线和支线所有任务等级段信息列表\n";
		$erlang .="%% 返回 [{MinLevel,MaxLevel},...]\n";
		$erlang .= "get_no_group_level_list() ->\n";
		$erlang .= "    [".implode(",",$noGroupLevelArr)."].\n\n";
		
		
		//分组奖励配置
		$loop_xml = $this->readXML (DATA_PATH.self::$MISSION_LOOP_REWARD_XML_FILE);
		$groups = $loop_xml->group;
		foreach($groups as $group){
			$id = (string)$group["id"];
			$rewards = $group->reward;
			foreach($rewards as $reward){
				//基本奖励
				$level = (string)$reward["level"];
				$exp = (string)$reward["exp"];
				$silver = (string)$reward["silver"];
				$coin = (string)$reward["coin"];
				
				$rollback_times = "0";$is_category="0";$formula_base="0";$formula_item="0";
				$reward_erl = "{r_mission_reward";
				$reward_erl .= ",".$rollback_times;
				$reward_erl .= ",".$is_category;
				$reward_erl .= ",".$formula_base;
				$reward_erl .= ",".$formula_item;
				$reward_erl .= ",".$exp;
				$reward_erl .= ",".$silver;
				$reward_erl .= ",".$coin;
				$reward_erl .= "}";
				
				
				//道具奖励
				if(empty($reward->reward_items)){// 没有道具奖励
					$do_times_erl="[]";
				}else{
					$reward_itemss = $reward->reward_items;
					$do_times_arr = array();
					foreach($reward_itemss as $reward_items){
						$do_times=(string)$reward_items["do_times"];
						$reward_items = $reward_items->reward_item;
						$reward_item_arr = array();
						foreach($reward_items as $reward_item){
							$item_type_id = (string)$reward_item["item_type_id"];
							$item_type = (string)$reward_item["item_type"];
							$item_num = (string)$reward_item["item_num"];
							$temp_erl = "{r_mission_reward_item";
							$temp_erl .= ",".$item_type_id;
							$temp_erl .= ",".$item_type;
							$temp_erl .= ",".$item_num;
							$temp_erl .= "}";
							$reward_item_arr[] = $temp_erl;
						}
						$reward_item_erl = "[".implode(",",$reward_item_arr)."]";
						$do_times_arr[] = "{".$do_times.",".$reward_item_erl."}";
					}
					$do_times_erl="[".implode(",",$do_times_arr)."]";
				}
				
				$erlang .= "find_mission_loop_reward({".$id.",".$level."}) ->\n";
				$erlang .= "    [{".$reward_erl.",".$do_times_erl."}];\n";
			}
		}
		
		$erlang .="%% 循环任务奖励配置\n";
		$erlang .="%% {{BigGroup,Level},{#r_mission_reward{},[{DoTimes,[#r_mission_reward_item{},...]},...]}}.\n";
		$erlang .="%% 返回 [{MissionReward,RewardItemList}] | []\n";
		$erlang .= "find_mission_loop_reward(_) ->\n";
		$erlang .= "    [].\n\n";
		
		$this->writeToFile ($erlang,self::$MISSION_ERLANG_BASE_FILE,false);
		echo ('导出任务【后端】数据成功，path='.self::$MISSION_ERLANG_BASE_FILE."\n");
	}
}
?>