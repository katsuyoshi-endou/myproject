<%@ page contentType="text/html; charset=utf-8" %>
<%-- Template ----------------------------------------------------------------------------------------------------------------%>

<div class="ui-modal" @close="dismissModal" v-if="isModal">
	<div class="ui-modal_overlay" @click="dismissModal">
		<div class="ui-modal_container ui-modal_size75" @click.stop>
			<div class="ui-modal_head">
				<div class="ui-modal_navbar">
					<div class="ui-modal_navbar_left"></div>
					<div class="ui-modal_navbar_center">
						<div class="ui-modal_navbar_title">{{ lbl.LTLPTC_FIND_TITLE }}</div>
					</div>
					<div class="ui-modal_navbar_right">
						<button type="button" class="btn btn-transp" @click="dismissModal"><i class="fa fa-close"></i></button>
					</div>
				</div>
				<div class="ui-navihead">
					<div class="ui-navihead_body">
						<div class="ui-srchconds">
							<div class="fm-item" style="flex:1;">
								<div class="fm-lbl"><span class="lbl">{{ lbl.LTLPTC_FIND_NAME }}</span></div>
								<div class="fm-val"><input type="text" class="block" v-model="conds.name" @keyup.enter="findSharePtc" maxlength="40"></div>
							</div>
							<div class="fm-item" style="flex:1.5;">
								<div class="fm-lbl"><span class="lbl">{{ lbl.LTLPTC_FIND_DEPT }}</span></div>
								<div class="fm-val"><input type="text" class="block" v-model="conds.dept" @keyup.enter="findSharePtc" maxlength="100"></div>
							</div>
							<div class="fm-item" style="flex:1;">
								<div class="fm-lbl"><span class="lbl">{{ lbl.LTLPTC_FIND_YKSK }}</span></div>
								<div class="fm-val"><input type="text" class="block" v-model="conds.yksk" @keyup.enter="findSharePtc" maxlength="20"></div>
							</div>
							<div class="fm-item">
								<div class="fm-lbl">&nbsp;</div>
								<div class="fm-val"><button type="button" class="btn btn-center" @click="findSharePtc">{{ lbl.LTLPTC_FIND_BTN }}</button></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="ui-modal_body">
				<div class="ui-guide ui-guid-info">
					{{ lbl.LTLPTC_FIND_GUIDE }}
				</div>
				<div class="ui-millef">
					<div class="ui-millef_leaves">
						<div v-if="find.isLoading" class="x-loading-well">
							<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i>
						</div>
						<template v-else v-for="one in find.result">
							<div class="ui-millef_leaf" v-bind:class="{ 'ui-millef_leaf_grayout': isAlreadyAdded(one) }">
								<div class="ui-millef_leaf_body">
									<img class="avatar" :src="getAvatarUrl(one)">
									<div class="talent-head fb fb-column">
										<span class="talent-name">{{ one.empName }}</span>
										<span class="talent-stfno">{{ one.empDesc }}</span>
									</div>
									<div class="profile-attrs fb fb-lr">
										<div class="fm-item x-dept">
											<div class="fm-lbl">
												<div class="lbl">{{ lbl.LTLPTC_LIST_DEPT }}</div>
												<span class="x-kenmu" v-if="one.primFlg === '0'">{{ lbl.LTLPTC_LIST_KENMU }}</span>
											</div>
											<div class="fm-val">{{ one.dept }}</div>
										</div>
										<div class="fm-item x-yksk">
											<div class="fm-lbl"><div class="lbl">{{ lbl.LTLPTC_LIST_YKSK }}</div></div>
											<div class="fm-val">{{ one.yksk }}</div>
										</div>
									</div>
								</div>

								<div class="ui-millef_leaf_ctrl">
									<div class="ui-millef_leaf_ctrl_item">
										<template v-if="isAlreadyAdded(one)">
											<i class="fa fa-check"></i>
											<span>{{ lbl.LTLPTC_FIND_PTC_ING }}</span>
										</template>
										<template v-else>
											<i class="fa fa-spinner fa-spin" v-if="one.isProcessing"></i>
											<button v-else type="button" class="btn btn-neon" @click="addPtc(one)">{{ lbl.LTLPTC_FIND_BTN_ADD }}</button>
										</template>
									</div>
								</div>

							</div>
						</template>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
