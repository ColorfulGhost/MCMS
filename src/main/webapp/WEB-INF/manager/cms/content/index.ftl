<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>文章</title>
	<#include "../../include/head-file.ftl">
	<#include "../../include/increase-search.ftl">
</head>
<body style="overflow: hidden">
<div id="index"  v-cloak>
	<!--左侧-->
	<el-container class="index-menu">
		<div class="left-tree">
			<el-scrollbar style="height: 100vh;">
				<el-tree :indent="5" v-loading="loading" highlight-current :expand-on-click-node="false" default-expand-all :empty-text="emptyText" :data="treeData" :props="defaultProps" @node-click="handleNodeClick" style="padding: 10px;height: 100%;"></el-tree>
			</el-scrollbar>
		</div>
		<iframe :src="action" class="ms-iframe-style">
		</iframe>
	</el-container>
</div>
</body>
</html>
<script>
	var indexVue = new Vue({
		el: "#index",
		data: {
			action:"", //跳转页面
			defaultProps: {
				children: 'children',
				label: 'categoryTitle'
			},
			treeData:[],
			loading:true,
			emptyText:'',
		},
		methods:{
			handleNodeClick: function(data){
				if(data.categoryType == '1'){
                    this.action = ms.manager +"/cms/content/main.do?categoryId="+data.id;
                } else if(data.categoryType == '2'){
                    this.action = ms.manager +"/cms/content/form.do?categoryId="+data.id+"&type=2";
                } else{
                    this.action = ms.manager +"/cms/content/main.do";
                }
			},
			treeList: function(){
				var that = this;
				this.loadState = false;
				this.loading = true;
				ms.http.get(ms.manager+"/cms/category/list.do",{
					pageSize:999,
				}).then(
						function(res) {
							if(that.loadState){
								that.loading = false;
							}else {
								that.loadState = true
							}
							if (!res.result||res.data.total <= 0) {
								that.emptyText = '暂无数据';
								that.treeData = [];
							} else {
								that.emptyText = '';
								that.treeData = ms.util.treeData(res.data.rows,'id','categoryId','children');
								that.treeData = [{
									id:0,
									categoryTitle:'全部',
									children: that.treeData,
								}]
							}
						}).catch(function(err) {
					console.log(err);
				});
				setTimeout(()=>{
					if(that.loadState){
						that.loading = false;
					}else {
						that.loadState = true
					}
				}, 500);
			},
		},
		mounted(){
			this.action = ms.manager +"/cms/content/main.do";
			this.treeList();
		}
	})
</script>
<style>
	#index .index-menu {
		min-height: 100vh;
		min-width: 140px;
	}
	#index .ms-iframe-style {
		width: 100%;
		border: 0;
	}

	#index .index-menu .el-main {
		padding: 0;
	}
	#index .left-tree{
		min-height: 100vh;
		background: #fff;
		width: 180px;
		border-right: solid 1px #e6e6e6;
	}

	#index .index-menu .el-main .index-menu-menu .el-menu-item {
		min-width: 140px;
		width: 100%;
	}
	#index .index-menu .el-main .index-material-item {
		min-width: 100% !important
	}
	#index .index-menu-menu-item , .el-submenu__title {
		height: 40px !important;
		line-height: 46px !important;
	}
	body{
		overflow: hidden;
	}
</style>
