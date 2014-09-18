package com.gearbrother.sheepwolf.rpc.service.bussiness {
	import com.gearbrother.sheepwolf.rpc.service.*;
	import com.gearbrother.sheepwolf.rpc.channel.RpcSocketChannel;

	/**
	 * Don't modify manually
	 *
	 * @generated by tool
	 * @create on 2014-05-26 15:10:38
	 */
	public class CompeteModeService extends RpcService {
		public function CompeteModeService(channel:RpcSocketChannel) {
			super(channel);
		}

		/**
		 * 准备
		 *
		 * @avatarUuid 模型Id
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function ready(avatarUuid:String, successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.ready", [avatarUuid], successCallback, errorCallback);
		}

		/**
		 * 进入大厅
		 *
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function enterHall(successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.enterHall", [], successCallback, errorCallback);
		}

		/**
		 * 离开大厅
		 *
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function outHall(successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.outHall", [], successCallback, errorCallback);
		}

		/**
		 * 创建房间
		 *
		 * @battleConfId 
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function createRoom(battleConfId:String, successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.createRoom", [battleConfId], successCallback, errorCallback);
		}

		/**
		 * 进入房间
		 *
		 * @roomUuid 房间ID
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function enterRoom(roomUuid:String, successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.enterRoom", [roomUuid], successCallback, errorCallback);
		}

		/**
		 * 取消准备
		 *
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function unready(successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.unready", [], successCallback, errorCallback);
		}

		/**
		 * 开启房间(只有房主可以)
		 *
		 * @roomUuid 房间ID
		 * @successCallback 成功回调
		 * @errorCallback 失败回调
		 */
		public function startRoom(roomUuid:String, successCallback:Function = null, errorCallback:Function = null):RpcServiceCall {
			return call("competeModeService.startRoom", [roomUuid], successCallback, errorCallback);
		}
	}
}
