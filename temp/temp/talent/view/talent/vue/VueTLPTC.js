function mountVueTLPTC(vm, loginUser) {
	var store = new Vuex.Store({
		state: {
			changedMap: {},
			deletedList: [],
		},
		getters: {
		},
		mutations: {
			pushChangedList: function (state, payload) {
				Vue.set(state.changedMap, payload.guid, payload.editable);
			},
			popChangedList: function (state, payload) {
				Vue.delete(state.changedMap, payload.guid);
			},
			pushDeletedList: function (state, payload) {
				state.deletedList.push(payload.guid);
			},
			popDeletedList: function (state, payload) {
				state.deletedList = _.filter(state.deletedList, function(d){
					return d !== payload.guid
				});
			}
		},
		actions: {
			addChangedList: function (context, payload) {
				context.commit('pushChangedList', payload);
			},
			removeChangedList: function (context, payload) {
				context.commit('popChangedList', payload);
			},
			addDeletedList: function (context, payload) {
				context.commit('pushDeletedList', payload);
			},
			removeDeletedList: function (context, payload) {
				context.commit('popDeletedList', payload);
			}
		}
	});

	var app = new Vue({
		el: '#VueTLPTC',
		store: store,
		data: function () {
			return {
				vm: vm,
				loginUser: loginUser,
				isLoading: false,
				ptcList: [],
				isChangingOwner: false,
				isEditing: false,
				isModal: false,
				conds: {
					name: '',
					dept: '',
					yksk: '',
				},
				find: {
					isLoading: false,
					result: [],
				},
				lbl: $.extend({}, App.LabelMap, vm.vlMap)
			}
		},
		computed: {
			albumTitle: function() {
				if (vm.albumMode === "SEARCH") { return vm.mySearch.mysrchNm; }
				if (vm.albumMode === "FOLDER") { return vm.myFolder.myfoldNm; }
			},
			owner: function () {
				var ptc = _.find(this.ptcList, function(p){ return p.ownerFlg === '1'; });
				return ptc ? ptc : {};
			},
			ptcs: function () {
				var list = _.filter(this.ptcList, function(p){ return p.ownerFlg === '0'; });
				var _self = this;
				return _.map(list, function(ptc){
					ptc.isEditable = ptc.editableFlg === '1';
					ptc.isLoginUser = loginUser.guid === ptc.guid;
					ptc.after = { editable: ptc.editableFlg === '1', deleted: null }
					return ptc;
				});
			},
			isOwner: function() {
				return this.owner.guid === loginUser.guid;
			}
		},
		mounted: function () {
			this.fetchSharePtcList();
		},
		updated: function () {
		},
		methods: {
			fetchSharePtcList: function (callback) {
				var _self = this;
				_self.isLoading = true;
				var params = { amd: vm.albumMode, aid: vm.albumId };
				App.API.GET('/shareptc', params, function(res){
					_self.isLoading = false;
					_self.ptcList = res.ptcList;
					if (typeof callback === 'function') { callback(); }
				});
			},
			getAvatarUrl: function (one) {
				if (_.isEmpty(one)) { return ''; }
				return App.root + "/api/profile/avatar?g=" + one.guid;
			},
			backToVTLSRL: function() {
				pageSubmit('/app/list/index.jsp', 'RESTORE');
			},
			reloadPage: function () {
				addRequestParameter('amd', vm.albumMode);
				addRequestParameter('aid', vm.albumId);
				pageSubmit('/servlet/SharePtcServlet', 'INIT');
			},
			goChangingOwner: function () {
				this.isChangingOwner = true;
			},
			goChangingOwnerCancel: function () {
				this.isChangingOwner = false;
			},
			goEditing: function () {
				this.isEditing = true;
			},
			cancelEditing: function () {
				this.reloadPage();
			},
			hasChanged: function (one) {
				if (_.isEmpty(one.hasChanged)) { return false; }
				return one.hasChanged;
			},
			toggleEditable: function (one) {
				var hasChanged = (one.isEditable !== one.after.editable);
				if (hasChanged) {
					store.dispatch('addChangedList', { guid: one.guid, editable: one.after.editable });
				} else {
					store.dispatch('removeChangedList', { guid: one.guid, editable: one.after.editable });
				}
			},
			switchDelete: function (one) {
				store.dispatch('addDeletedList', { guid: one.guid });
			},
			switchDeleteCancel: function (one) {
				store.dispatch('removeDeletedList', { guid: one.guid });
			},
			isChanged: function (one) {
				return this.$store.state.changedMap.hasOwnProperty(one.guid);
			},
			isDeleted: function (one) {
				return $.inArray(one.guid, this.$store.state.deletedList) > -1;
			},
			submitEditing: function () {
				var params = { action: 'edit_ptc', amd: vm.albumMode, aid: vm.albumId };
				var editables = this.$store.state.changedMap;
				var deleteds = this.$store.state.deletedList;
				_.each(Object.keys(editables), function(k){
					params['editable__' + k] = editables[k];
				});
				_.each(deleteds, function(guid){
					params['deleted__' + guid] = guid;
				});
				var _self = this;
				App.API.PUT('/shareptc', params, function(res){
					_self.reloadPage();
				});
			},
			submitChangingOwner: function (one) {
				var params = { action: 'change_owner', amd: vm.albumMode, aid: vm.albumId };
				params['next_owner'] = one.guid;
				var _self = this;
				App.API.PUT('/shareptc', params, function(res){
					_self.reloadPage();
				});
			},
			leavePtc: function () {
				if (!confirm(this.lbl.LTLPTC_MSG_LEAVE_CONFIRM)) { return false; }
				var params = { action: 'leave_ptc', amd: vm.albumMode, aid: vm.albumId };
				var _self = this;
				App.API.PUT('/shareptc', params, function(res){
					pageSubmit('/servlet/HomeServlet', 'INIT');
				});
			},
			showModal: function () {
				this.isModal = true;

				var _self = this;
				_self.find.isLoading = true;
				var params = { name: this.conds.name, dept: this.conds.dept, yksk: this.conds.yksk };
				App.API.GET('/shareptc/find', params, function(res){
					_self.find.isLoading = false;
					_self.find.result = res.findResult;
				});
			},
			dismissModal: function () {
				this.isModal = false;
			},
			findSharePtc: function () {
				var _self = this;
				_self.find.isLoading = true;
				var params = { name: this.conds.name, dept: this.conds.dept, yksk: this.conds.yksk };
				App.API.GET('/shareptc/find', params, function(res){
					_self.find.isLoading = false;
					_self.find.result = res.findResult;
				});
			},
			isAlreadyAdded: function (one) {
				var it = _.find(this.ptcList, function(p){ return p.guid === one.guid; });
				return !_.isEmpty(it);
			},
			addPtc: function (one) {
				one.isProcessing = true;
				var _self = this;
				var params = { amd: vm.albumMode, aid: vm.albumId, guid: one.guid };
				App.API.POST('/shareptc', params, function(res){
					_self.fetchSharePtcList(function(){
						one.isProcessing = false;
					});
				});
			}
		}
	});

}
