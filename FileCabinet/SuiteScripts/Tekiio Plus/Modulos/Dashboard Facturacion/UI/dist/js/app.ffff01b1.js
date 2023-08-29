(function(){"use strict";var __webpack_modules__={2203:function(e,t,r){r.d(t,{Z:function(){return u}});var a=function(){var e=this,t=e._self._c;return t("div",{class:!0===this.$store.state.toggleSideBar?"collapsed":"hide_bar"},[t("b-row",[t("b-col",{staticClass:"d-flex justify-content-center align-items-center mt-4",attrs:{md:"12",sm:"12"}},[t("b-img",{staticClass:"align-items-center",attrs:{width:"70px",height:"70px",src:this.$store.state.user_data.image_url,rounded:"circle",alt:"Circle image"}})],1),t("b-col",{staticClass:"d-flex justify-content-center mt-2",attrs:{md:"12",sm:"12"}},[t("h4",{staticClass:"userName mb-0"},[e._v(e._s(this.$store.state.user_data.user_name))])]),t("b-col",{staticClass:"d-flex justify-content-center py-0 my-0",attrs:{md:"12",sm:"12"}},[t("p",{staticClass:"userRole"},[e._v(e._s(this.$store.state.user_data.role))])])],1),e._l(e.menuItemsAr,(function(r){return t("b-row",{key:r.id,staticClass:"mb-2",on:{mouseover:function(t){return e.toggleSubMenu(r)},mouseleave:function(t){return e.toggleSubMenuLeave(r)}}},[t("a",{attrs:{href:r.path}},[t("b-col",{staticClass:"menuItem d-flex align-items-center py-2",attrs:{md:"12"}},[t("span",{staticClass:"mx-3"},[t("font-awesome-icon",{attrs:{icon:r.icon,size:"1x"}})],1),t("span",[e._v(e._s(r.title))])])],1),!0===r.hasChildren&&!0===r.toggled?t("div",e._l(r.children,(function(r){return t("ul",{key:r.id,staticClass:"menuSubItem py-2",staticStyle:{"list-style-type":"none"}},[t("a",{attrs:{href:r.path}},[t("li",[t("span",{staticClass:"mx-3"},[t("font-awesome-icon",{attrs:{icon:r.icon,size:"1x"}})],1),t("span",[e._v(e._s(r.subtitle))])])])])})),0):e._e()])}))],2)},o=[];const s=()=>{const e=[{id:0,title:"Timbres consumidos",path:"#/",icon:"fa-solid fa-bars",hasChildren:!1,toggled:!1},{id:1,title:"Carga de CSD",path:"#/carga-csd",icon:"fa-solid fa-bars",hasChildren:!1,toggled:!1},{id:2,title:"Guia de errores",path:"#/",icon:"fa-solid fa-bars",hasChildren:!1,toggled:!1},{id:3,title:"Blog",path:"#/",icon:"fa-solid fa-bars",hasChildren:!1,toggled:!1},{id:4,title:"Contactos",path:"#/",icon:"fa-solid fa-bars",hasChildren:!1,toggled:!1}];return e};var n=s,i={name:"SideNavBar",data:function(){return{isToggle:null,menuItemsAr:[]}},mounted(){this.isToggle=this.$store.state.toggleSideBar,console.log("val of store:",this.$store.state.toggleSideBar),this.menuItemsAr=n(),console.log(this.menuItemsAr)},methods:{toggleSubMenu(e){e.toggled=!0},toggleSubMenuLeave(e){e.toggled=!1}}},_=i,l=r(1001),c=(0,l.Z)(_,a,o,!1,null,null,null),u=c.exports},9530:function(e,t,r){r.d(t,{Z:function(){return l}});var a=function(){var e=this,t=e._self._c;return t("div",[t("b-navbar",{attrs:{toggleable:"sm"}},[t("b-navbar-toggle",{attrs:{target:"nav-text-collapse"}}),t("b-navbar-brand",{staticClass:"pl-1"},[t("img",{attrs:{height:"65px",src:"https://7076975-sb1.app.netsuite.com/core/media/media.nl?id=454074&c=1245760&h=MykoHLXHF55zzVRL3NrtL3AP73FeNcKh_nG4qvAadA5H9m8v",alt:"Logo"}})]),t("b-collapse",{attrs:{id:"nav-text-collapse","is-nav":""}},[t("b-navbar-nav",[t("b-button",{staticClass:"btn_removeBKColor",on:{click:e.handleToggleSideBar}},[t("font-awesome-icon",{attrs:{icon:"fa-solid fa-bars",size:"1x"}})],1)],1),t("p",{staticClass:"titulo_nav"},[e._v("Dashboard de Facturación")])],1)],1)],1)},o=[],s={name:"TopNavBar",components:{},data:function(){return{}},methods:{handleToggleSideBar(){this.$store.commit("setToggleSideBar",!this.$store.state.toggleSideBar)}}},n=s,i=r(1001),_=(0,i.Z)(n,a,o,!1,null,null,null),l=_.exports},8067:function(__unused_webpack_module,__webpack_exports__,__webpack_require__){var _template_SideNavBar_vue__WEBPACK_IMPORTED_MODULE_0__=__webpack_require__(2203),_template_TopNavBar_vue__WEBPACK_IMPORTED_MODULE_1__=__webpack_require__(9530),axios__WEBPACK_IMPORTED_MODULE_2__=__webpack_require__(4161);__webpack_exports__.Z={name:"cargaCSD",components:{SideNavBar:_template_SideNavBar_vue__WEBPACK_IMPORTED_MODULE_0__.Z,TopNavBar:_template_TopNavBar_vue__WEBPACK_IMPORTED_MODULE_1__.Z},data:function(){return{url_to_send_file:""}},mounted(){},methods:{async getExternalURL(){try{let self=this;console.log("handleSubmit -self: ",self);let str="";str+="          var urlMode=null;",str+='require(["N/url"],function(urlMode){',str+="            var url=urlMode.resolveScript({",str+="                scriptId:'customscript_fb_tp_dashboard_service_sl',",str+="                deploymentId:'customdeploy_fb_tp_dashboard_service_sl',",str+="                returnExternalUrl:false,",str+="                params:{}",str+="            });",str+="            self.getConfigAxios2(url)",str+="        });",eval(str)}catch(err){console.error("Error occurred in getExternalURL",err)}},getBase64(e){return new Promise(((t,r)=>{const a=new FileReader;a.readAsDataURL(e),a.onload=()=>t(a.result),a.onerror=e=>r(e)}))},async uploadFile(event){try{await this.getExternalURL(),console.log({event:event});const file=event.target.files[0];this.getBase64(file).then((arc_b64=>{console.log("arc_b64",arc_b64);let self=this;console.log("self val:",self);let script="";script+="var https=null;",script+="require(['N/https'],function(https){",script+=" var headerObj={'Content-Type':'application/x-x509-ca-cert'};",script+="var response=https.post({",script+="url:'"+self.url_to_send_file+"',",script+="body:'"+arc_b64+"',",script+="headers:headerObj",script+="});",script+="self.getResponse(response);",script+="});",eval(script)}))}catch(err){console.log("An error occured:",err)}},getResponse(e){console.log("Received this from NS:",e)},getConfigAxios2(e){this.url_to_send_file=e;const t={method:"GET",url:e,headers:{"Content-Type":"application/json","Access-Control-Allow-Origin":"*","Access-Control-Allow-Methods":"GET,PUT,POST,OPTIONS","Access-Control-Allow-Headers":"authorization"}};axios__WEBPACK_IMPORTED_MODULE_2__.Z.request(t).then((e=>{console.log("RESPONSE FROM SENDING FILE NAME XML: ",e.data)})).catch((e=>{console.log("Hubo errores getConfigAxios2: ",e)}))}}}},1866:function(e,t,r){var a=r(6369),o=function(){var e=this,t=e._self._c;return t("div",{attrs:{id:"app"}},[t("router-view",[t("DashboardFacturacion")],1)],1)},s=[],n=function(){var e=this,t=e._self._c;return t("div",{attrs:{id:"global"}},[t("div",{staticClass:"topNavBarC"},[t("TopNavBar")],1),t("div",{staticClass:"sideNavBarC"},[t("SideNavBar")],1),t("div",{staticClass:"moduleComponent"},[t("b-card",[t("h1",[e._v("holi")])])],1)])},i=[],_=r(2203),l=r(9530),c={name:"DashboardFacturacion",components:{SideNavBar:_.Z,TopNavBar:l.Z},data(){return{}}},u=c,d=r(1001),p=(0,d.Z)(u,n,i,!1,null,null,null),b=p.exports,f={name:"App",components:{DashboardFacturacion:b}},h=f,v=(0,d.Z)(h,o,s,!1,null,null,null),g=v.exports,m=r(2631),w=function(){var e=this,t=e._self._c;return t("div",{attrs:{id:"global"}},[t("div",{staticClass:"topNavBarC"},[t("TopNavBar")],1),t("div",{staticClass:"sideNavBarC"},[t("SideNavBar")],1),t("div",{staticClass:"moduleComponent"},[t("b-card",[t("h1",[e._v("CSD")]),t("b-row",[t("b-col",[t("input",{attrs:{type:"file",name:"archivo_cer",id:"archivo_cer"},on:{change:e.uploadFile}})])],1),t("b-row",[t("b-col",[t("input",{attrs:{type:"file",name:"archivo_key",id:"archivo_key"},on:{change:e.uploadFile}})])],1),t("b-row",[t("b-col",[t("input",{attrs:{type:"text",name:"pswd",id:"pswd"},on:{change:e.uploadFile}})])],1),t("b-row",[t("b-col",[t("button",{attrs:{type:"button"},on:{click:e.uploadFile}},[e._v("Enviar archivos")])])],1)],1)],1)])},C=[],k=r(8067),y=k.Z,x=(0,d.Z)(y,w,C,!1,null,null,null),S=x.exports,B=[{path:"/",component:b},{path:"/carga-csd",component:S}],E=r(3822);a["default"].use(E.ZP);const O=new E.ZP.Store({state:{toggleSideBar:!0,user_data:{email:"ricardo.lopez@freebug.mx",site_permissions:[2,3,5,1],role:"User",user_name:"Ricardo López Ortiz",company_name:"Austin Infectious Disease Consultants",image_url:"https://7076975-sb1.app.netsuite.com/core/media/media.nl?id=44791&c=7076975_SB1&h=zEVspWXTuIyGt-SkcpdSFYwDMEYbb5k1sCvBXC2H5yhycIXj"}},mutations:{setToggleSideBar(e,t){e.toggleSideBar=t},setUser_data(e,t){e.user_data=t}}});var T=O,q=r(6681),N=r(9425),A=(r(7024),r(3494)),M=r(7749),D=r(8539);a["default"].component("font-awesome-icon",M.GN),A.vI.add(D.xiG),a["default"].use(q.XG7),a["default"].use(N.A7),a["default"].use(m.Z);const P=new m.Z({routes:B});a["default"].config.productionTip=!1,new a["default"]({store:T,render:e=>e(g),router:P}).$mount("#app")}},__webpack_module_cache__={};function __webpack_require__(e){var t=__webpack_module_cache__[e];if(void 0!==t)return t.exports;var r=__webpack_module_cache__[e]={exports:{}};return __webpack_modules__[e].call(r.exports,r,r.exports,__webpack_require__),r.exports}__webpack_require__.m=__webpack_modules__,function(){var e=[];__webpack_require__.O=function(t,r,a,o){if(!r){var s=1/0;for(l=0;l<e.length;l++){r=e[l][0],a=e[l][1],o=e[l][2];for(var n=!0,i=0;i<r.length;i++)(!1&o||s>=o)&&Object.keys(__webpack_require__.O).every((function(e){return __webpack_require__.O[e](r[i])}))?r.splice(i--,1):(n=!1,o<s&&(s=o));if(n){e.splice(l--,1);var _=a();void 0!==_&&(t=_)}}return t}o=o||0;for(var l=e.length;l>0&&e[l-1][2]>o;l--)e[l]=e[l-1];e[l]=[r,a,o]}}(),function(){__webpack_require__.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return __webpack_require__.d(t,{a:t}),t}}(),function(){__webpack_require__.d=function(e,t){for(var r in t)__webpack_require__.o(t,r)&&!__webpack_require__.o(e,r)&&Object.defineProperty(e,r,{enumerable:!0,get:t[r]})}}(),function(){__webpack_require__.g=function(){if("object"===typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"===typeof window)return window}}()}(),function(){__webpack_require__.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)}}(),function(){__webpack_require__.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})}}(),function(){var e={143:0};__webpack_require__.O.j=function(t){return 0===e[t]};var t=function(t,r){var a,o,s=r[0],n=r[1],i=r[2],_=0;if(s.some((function(t){return 0!==e[t]}))){for(a in n)__webpack_require__.o(n,a)&&(__webpack_require__.m[a]=n[a]);if(i)var l=i(__webpack_require__)}for(t&&t(r);_<s.length;_++)o=s[_],__webpack_require__.o(e,o)&&e[o]&&e[o][0](),e[o]=0;return __webpack_require__.O(l)},r=self["webpackChunkDashboardFacturacion_vue"]=self["webpackChunkDashboardFacturacion_vue"]||[];r.forEach(t.bind(null,0)),r.push=t.bind(null,r.push.bind(r))}();var __webpack_exports__=__webpack_require__.O(void 0,[998],(function(){return __webpack_require__(1866)}));__webpack_exports__=__webpack_require__.O(__webpack_exports__)})();
//# sourceMappingURL=app.6ee84ffb.js.map