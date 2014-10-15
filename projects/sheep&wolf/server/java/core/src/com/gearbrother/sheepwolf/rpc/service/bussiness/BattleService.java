package com.gearbrother.sheepwolf.rpc.service.bussiness;

import java.awt.geom.Rectangle2D;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.gearbrother.sheepwolf.model.ISession;
import com.gearbrother.sheepwolf.pojo.Battle;
import com.gearbrother.sheepwolf.pojo.BattleItem;
import com.gearbrother.sheepwolf.pojo.BattleItemUser;
import com.gearbrother.sheepwolf.pojo.BattleRoom;
import com.gearbrother.sheepwolf.pojo.BattleSignalBattleItemChange;
import com.gearbrother.sheepwolf.pojo.BattleSignalEnd;
import com.gearbrother.sheepwolf.pojo.BattleSignalMethodDo;
import com.gearbrother.sheepwolf.pojo.BattleSignalSkillUse;
import com.gearbrother.sheepwolf.pojo.BattleSignalUpdate;
import com.gearbrother.sheepwolf.pojo.BattleSignalUserUpdate;
import com.gearbrother.sheepwolf.pojo.BattleUserActionSkillUsing;
import com.gearbrother.sheepwolf.pojo.BattleUserActionWalk;
import com.gearbrother.sheepwolf.pojo.Bounds;
import com.gearbrother.sheepwolf.pojo.Direction;
import com.gearbrother.sheepwolf.pojo.GameConf;
import com.gearbrother.sheepwolf.pojo.PointBean;
import com.gearbrother.sheepwolf.pojo.Skill;
import com.gearbrother.sheepwolf.pojo.SkillLevel;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethod;
import com.gearbrother.sheepwolf.rpc.annotation.RpcServiceMethodParameter;
import com.gearbrother.sheepwolf.rpc.error.RpcException;
import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleItemUserProtocol;
import com.gearbrother.sheepwolf.rpc.protocol.bussiness.BattleProtocol;
import com.gearbrother.sheepwolf.util.GMathUtil;

/**
 * @author feng.lee
 * @create on 2013-12-30
 */
@Service
public class BattleService {
	static Logger logger = LoggerFactory.getLogger(BattleService.class);
	
	private GameConf _conf;
	public GameConf getConf() {
		return _conf;
	}
	public void setConf(GameConf newValue) {
		_conf = newValue;
	}
	
	public final Map<String, ITouchHandler> touchHandlers;
	
	public final Map<String, ISkillHandler> skillHandlers;
	
	public BattleService() {
		touchHandlers = new HashMap<String, ITouchHandler>();
		touchHandlers.put("blink"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						Object currentAction = collisionUser.currentAction;
						if (currentAction instanceof BattleUserActionWalk) {
							long currentTime = System.currentTimeMillis();
							BattleUserActionWalk walk = (BattleUserActionWalk) collisionUser.currentAction;
							walk.startTime = currentTime;
							walk.endTime = Long.MAX_VALUE;
							BattleItem linkTo = collisionItem.getBattle().items.get(params.get("id").asText());
							walk.startPos = new PointBean(linkTo.x, linkTo.y);
							
							BattleItemUserProtocol userProto = new BattleItemUserProtocol();
							userProto.setUuid(collisionUser.uuid);
							userProto.setCurrentAction(collisionUser.currentAction);
							session.getRoom().board(new BattleSignalUserUpdate(userProto));
						}
					}
				}
			);
		touchHandlers.put("buy"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						int price = params.get("price").asInt();
						BattleItemUserProtocol userProto = new BattleItemUserProtocol();
						userProto.setUuid(collisionUser.uuid);
						if (collisionUser.money >= price) {
							if ("house".equals(params.get("item").asText())) {
								collisionUser.addSkill(GameConf.instance.house);
								userProto.setSkills(collisionUser.skills);
							} else if ("hp".equals(params.get("item").asText())) {
								collisionUser.hp = Math.min(collisionUser.maxHp, collisionUser.hp + params.get("value").asInt());
								userProto.setHp(collisionUser.hp);
							} else if ("speed".equals(params.get("item").asText())) {
								collisionUser.orginalSpeed += params.get("value").asDouble();
								userProto.setOrginalSpeed(collisionUser.orginalSpeed);
							}
							collisionUser.money -= price;
							userProto.setMoney(collisionUser.money);
						}
						session.getRoom().board(new BattleSignalUserUpdate(userProto));
					}
				}
			);
		touchHandlers.put("pickUpFromGroup"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						collisionUser.pickUpedPuzzle = collisionItem;
						
						//notify
						BattleItemUserProtocol userProto = new BattleItemUserProtocol();
						userProto.setUuid(collisionUser.uuid);
						userProto.setPickUpedPuzzle(collisionItem);
						session.getRoom().board(new BattleSignalUserUpdate(userProto));
					}
				}
			);
		touchHandlers.put("pickUp"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						collisionUser.pickUpedPuzzle = collisionItem;
						collisionItem.setBattle(null);
						session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_REMOVE, collisionItem));
						
						//notify
						BattleItemUserProtocol userProto = new BattleItemUserProtocol();
						userProto.setUuid(collisionUser.uuid);
						userProto.setPickUpedPuzzle(collisionItem);
						session.getRoom().board(new BattleSignalUserUpdate(userProto));
					}
				}
			);
		touchHandlers.put("dropDown"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						BattleRoom battleRoom = (BattleRoom) session.getRoom();
						Battle battle = battleRoom.battle;
						BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
						if (loginedUser.pickUpedPuzzle != null) {
							battle.puzzleFinishedTotal++;
							battleRoom.board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_UPDATE, collisionItem));
							
							loginedUser.pickUpedPuzzle = null;
							loginedUser.money += 7;
							BattleItemUserProtocol userProto = new BattleItemUserProtocol();
							userProto.setUuid(loginedUser.uuid);
							userProto.setMoney(loginedUser.money);
							userProto.setPickUpedPuzzle(loginedUser.pickUpedPuzzle);
							battleRoom.board(new BattleSignalUserUpdate(userProto));
							
							BattleProtocol battleProto = new BattleProtocol();
							battleProto.setPuzzleFinishedTotal(battle.puzzleFinishedTotal);
							session.getRoom().board(new BattleSignalUpdate(battleProto));
							
							if (battle.puzzleFinishedTotal >= battle.puzzleTotal) {
								session.getRoom().board(new BattleSignalEnd("邪恶的羊羊胜利了~"));
							}
						}
					}
				}
			);
		touchHandlers.put("rescue"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser collisionUser, BattleItem collisionItem, JsonNode params) {
						BattleItemUser survivor = (BattleItemUser) collisionItem;
						if (collisionUser.color == survivor.color && collisionUser != survivor) {
							survivor.hp = survivor.maxHp;
							survivor.isCaptured = false;
							survivor.touchAutoRemoteCall = null;
							survivor.lifes = 1;
							BattleItemUserProtocol userProto = new BattleItemUserProtocol();
							userProto.setUuid(survivor.uuid);
							userProto.setHp(survivor.hp);
							userProto.setIsCaptured(survivor.isCaptured);
							userProto.setTouchAutoRemoteCall(survivor.touchAutoRemoteCall);
							userProto.setLifes(survivor.lifes);
							session.getRoom().board(new BattleSignalUserUpdate(userProto));
						}
					}
				}
			);
		touchHandlers.put("slow"
				, new ITouchHandler() {
					
					@Override
					public void handle(ISession session, BattleItemUser user, BattleItem item, JsonNode params) {
//						long currentTime = System.currentTimeMillis();
//						double changeSpeed = (currentTime > battleUser.changedSpeedExpiredPeriodTime ? battleUser.getOrginalSpeed() : battleUser.changedSpeed) - slow;
//						changeSpeed = Math.max(0, changeSpeed);
//						BattleUserActionWalk walk = new BattleUserActionWalk(
//								currentTime
//								, battleUser.getPosition(currentTime)
//								, battleUser.direction
//								, battleUser.direction
//								, battleUser.getOrginalSpeed()
//								, changeSpeed
//								, currentTime + 5000);
//						walk.endTime = ((BattleUserActionWalk) battleUser.currentAction).endTime;
//						battleUser.changedSpeed = changeSpeed;
//						battleUser.changedSpeedExpiredPeriodTime = currentTime + 5000;
//						battleUser.currentAction = walk;
//						battleUser.hp = Math.max(0, battleUser.hp - damage);
//						if (battleUser.hp == 0) {
//							boolean isEnd = true;
//							Map<String, BattleItem> battleUsers = battleUser.getBattle().sortItems.get(BattleUser.class);
//							for (BattleItem usr : battleUsers.values()) {
//								isEnd = isEnd && ((BattleUser) usr).hp == 0;
//							}
//							if (isEnd)
//								session.getRoom().board(new BattleSignalEnd("结束"));
//						}
//						
//						BattleUserProtocol userProto = new BattleUserProtocol();
//						userProto.setUuid(battleUser.uuid);
//						userProto.setCurrentAction(battleUser.currentAction);
//						userProto.setHp(battleUser.hp);
//						session.getRoom().board(new BattleSignalUserUpdate(userProto));
//			
//						setBattle(null);
//						session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_REMOVE, this));
					}
				}
			);

		skillHandlers = new HashMap<String, ISkillHandler>();
		skillHandlers.put("attack"
				, new ISkillHandler() {

					@Override
					public boolean handle(ISession session, Skill skill, JsonNode params) {
						BattleRoom room = (BattleRoom) session.getRoom();
						Battle battle = room.battle;
						long currentTime = System.currentTimeMillis();
						BattleItemUser logineUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
						PointBean ps = logineUser.getPosition(currentTime);
						double xAdd = .0;
						double yAdd = .0;
						if (logineUser.direction == Direction.DIRECTION_UP)
							yAdd = -1.0;
						else if (logineUser.direction == Direction.DIRECTION_DOWN)
							yAdd = 1.0;
						else if (logineUser.direction == Direction.DIRECTION_LEFT)
							xAdd = -1.0;
						else if (logineUser.direction == Direction.DIRECTION_RIGHT)
							xAdd = 1.0;
						Rectangle2D damageRect = new Rectangle2D.Double(ps.x + xAdd, ps.y + yAdd, logineUser.width + Math.abs(xAdd), logineUser.height + Math.abs(yAdd));
						int cFloor = (int) Math.floor(damageRect.getX());
						int cCeil = (int) Math.ceil(damageRect.getX() + damageRect.getWidth());
						int rFloor = (int) Math.floor(damageRect.getY());
						int rCeil = (int) Math.ceil(damageRect.getY() + damageRect.getHeight());
						
						//first attack house
						for (int c = cFloor; c < cCeil; c++) {
							for (int r = rFloor; r < rCeil; r++) {
								BattleItem collisionItem = battle.getCollision(r, c);
								if (collisionItem != null && collisionItem.isDestoryable) {
									collisionItem.hp -= skill.getLevel().remoteMethodParams.get("damage").asInt();
									if (collisionItem.hp < 1) {
										Map<String, BattleItem> allUsers = battle.getItems(BattleItemUser.class);
										for (Iterator<String> iterator = allUsers.keySet().iterator(); iterator.hasNext();) {
											String userUuid = (String) iterator.next();
											BattleItemUser user = (BattleItemUser) allUsers.get(userUuid);
											if (user.currentAction instanceof BattleUserActionWalk) {
												((BattleUserActionWalk) user.currentAction).update(user, currentTime);
												BattleItemUserProtocol userproto = new BattleItemUserProtocol();
												userproto.setUuid(user.uuid);
												userproto.setCurrentAction(user.currentAction);
												session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_UPDATE, userproto));
											}
										}
										collisionItem.setBattle(null);
										session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_REMOVE, collisionItem));
									} else {
										session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_UPDATE, collisionItem));
									}
									return true;
								}
							}
						}
						Map<String, BattleItem> users = battle.getItems(BattleItemUser.class);
						for (Iterator<String> iterator = users.keySet().iterator(); iterator.hasNext();) {
							String userUuid = (String) iterator.next();
							BattleItemUser collisionUser = (BattleItemUser) users.get(userUuid);
							if (collisionUser == logineUser || collisionUser.color == logineUser.color)
								continue;

							PointBean userPos = collisionUser.getPosition(currentTime);
							if (Bounds.intersects(damageRect.getX(), damageRect.getY(), damageRect.getWidth(), damageRect.getHeight()
									, userPos.x, userPos.y, collisionUser.width, collisionUser.height)) {
								//then attack user
								collisionUser.hp = Math.max(0, collisionUser.hp - skill.getLevel().remoteMethodParams.get("damage").asInt());
								BattleItemUserProtocol userProto = new BattleItemUserProtocol();
								userProto.setUuid(collisionUser.uuid);
								userProto.setHp(collisionUser.hp);
								if (collisionUser.hp <= 0) {
									if (collisionUser.pickUpedPuzzle != null) {
										collisionUser.pickUpedPuzzle.x = collisionUser.x;
										collisionUser.pickUpedPuzzle.y = collisionUser.y;
										collisionUser.pickUpedPuzzle.setBattle(battle);
										BattleItem lostPuzzle = collisionUser.pickUpedPuzzle;
										collisionUser.pickUpedPuzzle = null;
										session.getRoom().board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_ADD, lostPuzzle));
										userProto.setPickUpedPuzzle(collisionUser.pickUpedPuzzle);
									}
									collisionUser.lifes = Math.max(0, collisionUser.lifes - 1);
									userProto.setLifes(collisionUser.lifes);
									logineUser.money += collisionUser.money;
									BattleItemUserProtocol skillUserProto = new BattleItemUserProtocol();
									skillUserProto.setUuid(logineUser.uuid);
									skillUserProto.setMoney(logineUser.money);
									room.board(new BattleSignalUserUpdate(skillUserProto));
									if (collisionUser.lifes == 0) {
										collisionUser.isCaptured = true;
										collisionUser.x = battle.caughtBounds.x + GMathUtil.random(battle.caughtBounds.width);
										collisionUser.y = battle.caughtBounds.y + GMathUtil.random(battle.caughtBounds.height);
										collisionUser.touchAutoRemoteCall = "rescue";
										userProto.setIsCaptured(collisionUser.isCaptured);
										userProto.setTouchAutoRemoteCall(collisionUser.touchAutoRemoteCall);
									} else {
										collisionUser.money = Battle.INIT_SHEEP_MONEY;
										userProto.setMoney(collisionUser.money);
										collisionUser.hp = collisionUser.maxHp = collisionUser.seat.avatar.getLevel().hp;
										userProto.setHp(collisionUser.hp);
										collisionUser.x = battle.sheepBornBounds.x + GMathUtil.random(battle.sheepBornBounds.width);
										collisionUser.y = battle.sheepBornBounds.y + GMathUtil.random(battle.sheepBornBounds.height);
									}
									collisionUser.orginalSpeed = collisionUser.changedSpeed = collisionUser.seat.avatar.getLevel().move;
									collisionUser.direction = (Integer) GMathUtil.random(Direction.All);
									collisionUser.currentAction = BattleUserActionWalk.buildStop(battle.startTime
											, new PointBean(collisionUser.x, collisionUser.y), collisionUser.direction, collisionUser);
									userProto.setOrginalSpeed(collisionUser.orginalSpeed);
									userProto.setX(collisionUser.x);
									userProto.setY(collisionUser.y);
									userProto.setDirection(collisionUser.direction);
									userProto.setCurrentAction(collisionUser.currentAction);
								}
								session.getRoom().board(new BattleSignalUserUpdate(userProto));
							}
						}
						return true;
					}
				}
			);
		skillHandlers.put("buildHouse"
				, new ISkillHandler() {
					
					@Override
					public boolean handle(ISession session, Skill skill, JsonNode params) {
						BattleRoom room = (BattleRoom) session.getRoom();
						Battle battle = room.battle;
						BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
						long currentTime = System.currentTimeMillis();
						PointBean loginedPosition = loginedUser.getPosition(currentTime);
						int r = (int) (loginedPosition.y);
						int c = (int) (loginedPosition.x);
						BattleItem house = new BattleItem();
						house.x = c;
						house.y = r;
						house.width = 2;
						house.height = 2;
						house.cartoon = "static/asset/item/house_0.swf";
						house.layer = "over";
						house.isCollisionable = true;
						house.isSheepPassable = true;
						house.isDestoryable = true;
						house.hp = house.maxHp = 20;
						//check is empty
						for (int x = 0; x < house.width; x++) {
							for (int y = 0; y < house.height; y++) {
								if (battle.getCollision(y + r, x + c) != null) {
									return false;
								}
							}
						}
						house.setBattle(battle);
						room.board(new BattleSignalBattleItemChange(BattleSignalBattleItemChange.TYPE_ADD, house));
						return true;
					}
				}
			);
		skillHandlers.put("invisible"
				, new ISkillHandler() {
					
					@Override
					public boolean handle(ISession session, Skill skill, JsonNode params) {
						BattleRoom battleRoom = (BattleRoom) session.getRoom();
						Battle battle = battleRoom.battle;
						long expirePeriod = skill.getLevel().remoteMethodParams.get("expiredPeriod").asLong();
						BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
						long currentTime = System.currentTimeMillis();

						//notify
						BattleItemUserProtocol userProto = new BattleItemUserProtocol();
						userProto.setUuid(loginedUser.uuid);
						session.getRoom().board(new BattleSignalUserUpdate(userProto));
						return true;
					}
				}
			);
	}
	
	@RpcServiceMethod(desc = "测试跑动方法")
	public PointBean testWalk(ISession session
			, @RpcServiceMethodParameter(name = "fromX") double fromX
			, @RpcServiceMethodParameter(name = "fromY") double fromY
			, @RpcServiceMethodParameter(name = "orginalSpeed") double orginalSpeed
			, @RpcServiceMethodParameter(name = "changedSpeed") double changedSpeed
			, @RpcServiceMethodParameter(name = "changedSpeedExpiredPeriodTime") long changedSpeedExpiredPeriodTime
			, @RpcServiceMethodParameter(name = "direction") int direction
			, @RpcServiceMethodParameter(name = "time") long time) {
		return null;
//		BattleUserActionWalk walk = new BattleUserActionWalk(new DPoint(fromX, fromY), orginalSpeed, changedSpeed, changedSpeedExpiredPeriodTime, direction, 0);
//		walk.endTime = time;
//		return walk.getPoint(battle, battle.users.get(session.getLogined().uuid), 0 + time);
	}

	@RpcServiceMethod(desc = "重新连接战场")
	public Battle reload(ISession session) {
		return null;
	}
	
	@RpcServiceMethod(desc = "广播调用方法")
	public void methodCall(ISession session
			, @RpcServiceMethodParameter(name = "method") String method
			, @RpcServiceMethodParameter(name = "argusJson") String argusJson) {
//		BattleUser battleUser = session.getRoom().get(session.getLogined().uuid);//session.getBattleUsers().get(session.getUser().uuid);
//		if (battleUser.npcable) {
		BattleSignalMethodDo methodDo = new BattleSignalMethodDo();
		methodDo.method = method;
		methodDo.argusJson = argusJson;
		session.getRoom().board(methodDo);
//		}
	}
	
	@RpcServiceMethod(desc = "超时获得比赛结果")
	public void getResult(ISession session) {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		long currentTimeMillis = System.currentTimeMillis();
		if (currentTimeMillis > (battle.startTime + battle.expiredPeriod)) {
			BattleSignalEnd message = new BattleSignalEnd("时间到，正义的狼狼胜利了~");
			session.getRoom().board(message);
		}
	}

	@RpcServiceMethod(desc = "移动")
	public void move(ISession session
			, @RpcServiceMethodParameter(name = "direction") int direction) {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
		long currentTimeMillis = System.currentTimeMillis();
		loginedUser.currentAction = new BattleUserActionWalk(currentTimeMillis, loginedUser.getPosition(currentTimeMillis), loginedUser.direction, direction, loginedUser.orginalSpeed, loginedUser.changedSpeed, loginedUser.changedSpeedExpiredPeriodTime);
		loginedUser.direction = direction;
		//ignore different forward, when move not complete
		BattleItemUserProtocol userProto = new BattleItemUserProtocol();
		userProto.setUuid(loginedUser.uuid);
		userProto.setDirection(loginedUser.direction);
		userProto.setCurrentAction(loginedUser.currentAction);
		session.getRoom().board(new BattleSignalUserUpdate(userProto));
	}
	
	@RpcServiceMethod(desc = "停下")
	public void stop(ISession session) throws CloneNotSupportedException, RpcException {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
		if (loginedUser.currentAction instanceof BattleUserActionWalk) {
			long currentTimeMillis = System.currentTimeMillis();
			((BattleUserActionWalk) loginedUser.currentAction).endTime = currentTimeMillis;
			
			//notify all
			BattleItemUserProtocol userProto = new BattleItemUserProtocol();
			userProto.setUuid(loginedUser.uuid);
			userProto.setCurrentAction(loginedUser.currentAction);
			BattleSignalUserUpdate userUpdate = new BattleSignalUserUpdate(userProto);
			session.getRoom().board(userUpdate);
		}
	}
	
	@RpcServiceMethod(desc = "触碰地图元素，所有客户端计算传送给服务器以防止有的客户端故意不想触碰不发送包.")
	public void touchAuto(ISession session
			, @RpcServiceMethodParameter(name = "userUUid") String userUuid
			, @RpcServiceMethodParameter(name = "itemUuids") ArrayNode itemUuids) throws RpcException, CloneNotSupportedException {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		long currentTime = System.currentTimeMillis();
		BattleItemUser collisionUser = (BattleItemUser) battle.items.get(userUuid);
		for (Iterator<JsonNode> iterator = itemUuids.iterator(); iterator.hasNext();) {
			JsonNode itemUuidNode = (JsonNode) iterator.next();
			String itemUuid = itemUuidNode.asText();
			if (battle.items.containsKey(itemUuid)) {
				BattleItem item = battle.items.get(itemUuid);
				//check collision
				if (item.intersect(collisionUser, currentTime) && item != collisionUser) {
					touchHandlers.get(item.touchAutoRemoteCall).handle(session, collisionUser, item, item.touchAutoRemoteCallParams);
				}
			}
		}
	}
	
	@RpcServiceMethod(desc = "人为选择触发")
	public void touchManual(ISession session
			, @RpcServiceMethodParameter(name = "userUUid") String userUuid
			, @RpcServiceMethodParameter(name = "itemUuids") String itemUuid) throws RpcException, CloneNotSupportedException {
		BattleRoom room = (BattleRoom) session.getRoom();
		Battle battle = room.battle;
		BattleItem item = battle.items.get(itemUuid);
		BattleItem collisionUser = battle.items.get(userUuid);
		long currentTime = System.currentTimeMillis();
		if (item.intersect(collisionUser, currentTime) && item != collisionUser) {
			touchHandlers.get(item.touchManualRemoteCall).handle(session, (BattleItemUser) collisionUser, item, item.touchManualRemoteCallParams);
		}
	}

	@RpcServiceMethod(desc = "使用技能")
	public void skillUse(ISession session
			, @RpcServiceMethodParameter(name = "skillIndex") int skillIndex
			, @RpcServiceMethodParameter(name = "argus") JsonNode params) throws Throwable {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
		Skill skill = loginedUser.skills.get(skillIndex);
		SkillLevel level = skill.getLevel();
		long currentTimeMillis = System.currentTimeMillis();
		if (skill.lastUseTime + level.cooldown < currentTimeMillis && (skill.num == - 1 || skill.num > 0)) {
			if (level.preUseCause == 0) {
				doSkill(session, skill, params);
			} else {
				if (loginedUser.currentAction instanceof BattleUserActionSkillUsing
						&& ((BattleUserActionSkillUsing) loginedUser.currentAction).currentTime + level.preUseCause < currentTimeMillis) {
					doSkill(session, skill, params);
				} else {
					BattleUserActionSkillUsing skillUsing = new BattleUserActionSkillUsing(loginedUser.getPosition(currentTimeMillis), currentTimeMillis, loginedUser.direction);
					skillUsing.skill = skill;
					loginedUser.currentAction = skillUsing;
					
					//notify
					BattleItemUserProtocol userProto = new BattleItemUserProtocol();
					userProto.setUuid(loginedUser.uuid);
					userProto.setCurrentAction(loginedUser.currentAction);
					session.send(new BattleSignalUserUpdate(userProto));
				}
			}
		}
	}

	private void doSkill(ISession session, Skill skill, JsonNode params) throws Throwable {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
		SkillLevel skillLevel = skill.getLevel();
		boolean res = skillHandlers.get(skillLevel.remoteMethod).handle(session, skill, params);
		if (res) {
			skill.lastUseTime = System.currentTimeMillis();
			if (skill.num == -1) {
				//do nothing
			} else {
				skill.num--;
			}
			if (skill.num == 0)
				loginedUser.removeSkill(skill);
//		long currentTimeMillis = System.currentTimeMillis();
			if (skillLevel.preUseCause > 0)
				loginedUser.currentAction = BattleUserActionWalk.buildStop(System.currentTimeMillis(), loginedUser.getPosition(System.currentTimeMillis()), Direction.DIRECTION_DOWN, loginedUser);
			BattleSignalSkillUse skillUse = new BattleSignalSkillUse();
			skillUse.userUuid = loginedUser.uuid;
			skillUse.skill = skill;
			session.getRoom().board(skillUse);
			
			//notify
			BattleItemUserProtocol userProto = new BattleItemUserProtocol();
			userProto.setUuid(loginedUser.uuid);
			userProto.setSkills(loginedUser.skills);
			session.send(new BattleSignalUserUpdate(userProto));
		}
	}
	
	/**
	 * 加速
	 * @param session
	 * @param rate
	 * @param expiredPeriod
	 * @throws RpcException
	 * @throws CloneNotSupportedException 
	 */
	public void _changeSpeed(ISession session, Skill skill) {
		BattleRoom battleRoom = (BattleRoom) session.getRoom();
		Battle battle = battleRoom.battle;
		BattleItemUser loginedUser = (BattleItemUser) battle.items.get(session.getLogined().uuid);
		double rate = skill.getLevel().remoteMethodParams.get("rate").asDouble();
		long expiredPeriod = skill.getLevel().remoteMethodParams.get("expiredPeriod").asLong();
		long currentTime = System.currentTimeMillis();
		loginedUser.changedSpeed = loginedUser.orginalSpeed * rate;
		loginedUser.changedSpeedExpiredPeriodTime = currentTime + expiredPeriod;
		if (loginedUser.currentAction instanceof BattleUserActionWalk) {
			BattleUserActionWalk walk = new BattleUserActionWalk(currentTime, loginedUser.getPosition(currentTime)
					, loginedUser.direction, loginedUser.direction, loginedUser.orginalSpeed, loginedUser.changedSpeed, loginedUser.changedSpeedExpiredPeriodTime);
			walk.endTime = ((BattleUserActionWalk) loginedUser.currentAction).endTime;
			loginedUser.currentAction = walk;
			
			//notify
			BattleItemUserProtocol userProto = new BattleItemUserProtocol();
			userProto.setUuid(loginedUser.uuid);
			userProto.setCurrentAction(loginedUser.currentAction);
			session.getRoom().board(new BattleSignalUserUpdate(userProto));
		}
	}
	
	interface ITouchHandler {
		void handle(ISession session, BattleItemUser user, BattleItem item, JsonNode params);
	}
	
	interface ISkillHandler {
		boolean handle(ISession session, Skill skill, JsonNode params);
	}
}