<%@ page contentType="text/html; charset=utf-8" %>
<%-- Template ----------------------------------------------------------------------------------------------------------------%>

<div class="navibar">
	<div class="navbar-body">
		<div class="leftArea">
			<button type="button" class="btn btn-back" @click="backToVTLSRL">{{ lbl.LTLPTC_BTN_BACK }}</button>
		</div>
		<div class="centerArea">
			<i class="fa fa-search" v-if="vm.albumMode === 'SEARCH'"></i>
			<i class="fa fa-folder" v-if="vm.albumMode === 'FOLDER'"></i>
			<span>{{ albumTitle }}</span>
			<span class="chip-shared">{{ lbl.LTLAPP_SHARE_CHIP }}</span>
		</div>
		<div class="rightArea">
		</div>
	</div>
</div>

<div class="container container-960 padd-top">
	
	<div class="ui-millef">
		<div class="ui-millef_bar">
			<div class="ui-millef_bar_meta">
				<div class="ui-millef_bar_title">{{ lbl.LTLPTC_OWNER }}</div>
			</div>
		</div>
		<div class="ui-millef_leaves">
			<div v-if="isLoading" class="x-loading-well">
				<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i>
			</div>
			<div v-else class="ui-millef_leaf">
				<div class="ui-millef_leaf_body">
					<img class="avatar" :src="getAvatarUrl(owner)">
					<div class="talent-head fb fb-column">
						<span class="talent-name">{{ owner.empName }}</span>
						<span class="talent-stfno">{{ owner.empDesc }}</span>
					</div>
					<div class="profile-attrs fb fb-lr">
						<div class="fm-item x-dept">
							<div class="fm-lbl"><div class="lbl">{{ lbl.LTLPTC_LIST_DEPT }}</div></div>
							<div class="fm-val">{{ owner.deptNm }}</div>
						</div>
						<div class="fm-item x-yksk">
							<div class="fm-lbl"><div class="lbl">{{ lbl.LTLPTC_LIST_YKSK }}</div></div>
							<div class="fm-val">{{ owner.ykskNm }}</div>
						</div>
					</div>
				</div>
				<div class="ui-millef_leaf_ctrl">
					<template v-if="isOwner && !isEditing">
						<button type="button" class="btn" @click="goChangingOwner" v-if="!isChangingOwner">{{ lbl.LTLPTC_OWNER_BTN_GIVE }}</button>
						<button type="button" class="btn" @click="goChangingOwnerCancel" v-else>{{ lbl.LTLPTC_OWNER_BTN_CANCEL }}</button>
					</template>
				</div>
			</div>
		</div>
	</div>
	
	<div class="ui-millef">
		<div class="ui-millef_bar">
			<div class="ui-millef_bar_meta">
				<div class="ui-millef_bar_title">{{ lbl.LTLPTC_PTC }}</div>
				<div class="ui-millef_bar_badge">{{ ptcs.length }}</div>
			</div>
			<div class="ui-millef_bar_ctrl">
				<template v-if="isOwner && !isChangingOwner">
					<template v-if="isEditing">
						<button type="button" class="btn btn-center btn-neon" @click="cancelEditing">{{ lbl.LTLPTC_PTC_BTN_CANCEL }}</button>
						<button type="button" class="btn btn-center btn-secondary" @click="submitEditing">{{ lbl.LTLPTC_PTC_BTN_OK }}</button>
					</template>
					<template v-else>
						<button type="button" class="btn btn-center btn-neon" @click="goEditing">{{ lbl.LTLPTC_PTC_BTN_EDIT }}</button>
						<button type="button" class="btn btn-center btn-primary" @click="showModal">{{ lbl.LTLPTC_PTC_BTN_ADD }}</button>
					</template>
				</template>
			</div>
		</div>
		<div class="ui-millef_leaves">
			<div v-if="isLoading" class="x-loading-well">
				<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i>
			</div>
			<template v-else v-for="one in ptcs">
				<div class="ui-millef_leaf" v-bind:class="{ 'ui-millef_leaf_grayout': isDeleted(one), 'ui-millef_leaf_highlight': isChanged(one) }">
					<div class="ui-millef_leaf_body">
						<div v-if="isChangingOwner" style="margin-right:15px;">
							<button type="button" class="btn btn-primary" @click="submitChangingOwner(one)">{{ lbl.LTLPTC_PTC_BTN_GIVE }}</button>
						</div>
						<img class="avatar" :src="getAvatarUrl(one)">
						<div class="talent-head fb fb-column">
							<span class="talent-name">{{ one.empName }}</span>
							<span class="talent-stfno">{{ one.empDesc }}</span>
						</div>
						<div class="profile-attrs fb fb-lr">
							<div class="fm-item x-dept">
								<div class="fm-lbl"><div class="lbl">{{ lbl.LTLPTC_LIST_DEPT }}</div></div>
								<div class="fm-val">{{ one.deptNm }}</div>
							</div>
							<div class="fm-item x-yksk">
								<div class="fm-lbl"><div class="lbl">{{ lbl.LTLPTC_LIST_YKSK }}</div></div>
								<div class="fm-val">{{ one.ykskNm }}</div>
							</div>
						</div>
					</div>
					<div class="ui-millef_leaf_ctrl">
						<template v-if="isEditing">
							<div class="ui-millef_leaf_ctrl_item">
								<div class="checkbox">
									<label>
										<input v-model="one.after.editable" type="checkbox" @click="toggleEditable(one)">
										<i class="fa fa-check"></i>
										<span>{{ lbl.LTLPTC_PTC_EDITABLE }}</span>
									</label>
								</div>
							</div>
							<div class="ui-millef_leaf_ctrl_item">
								<button type="button" class="btn btn-delete" @click="switchDeleteCancel(one)" v-if="isDeleted(one)">{{ lbl.LTLPTC_PTC_BTN_DEL_CANCEL }}</button>
								<button type="button" class="btn btn-delete" @click="switchDelete(one)" v-else>{{ lbl.LTLPTC_PTC_BTN_DEL }}</button>
							</div>
						</template>
						<template v-else>
							<div class="ui-millef_leaf_ctrl_item" v-if="one.isEditable">
								<i class="fa fa-check"></i>
								<span>{{ lbl.LTLPTC_PTC_EDITABLE }}</span>
							</div>
							<div class="ui-millef_leaf_ctrl_item" v-if="one.isLoginUser">
								<button type="button" class="btn btn-delete" @click="leavePtc">{{ lbl.LTLPTC_PTC_BTN_LEAVE }}</button>
							</div>
						</template>
					</div>
				</div>
			</template>
		</div>
	</div>
	
</div><!-- /.container -->
