(function(e){function t(n){if(o[n])return o[n].exports;var i=o[n]={i:n,l:!1,exports:{}};return e[n].call(i.exports,i,i.exports,t),i.l=!0,i.exports}var n=window.webpackJsonp;window.webpackJsonp=function(o,s,a){for(var p,l,c,d=0,i=[];d<o.length;d++)l=o[d],r[l]&&i.push(r[l][0]),r[l]=0;for(p in s)Object.prototype.hasOwnProperty.call(s,p)&&(e[p]=s[p]);for(n&&n(o,s,a);i.length;)i.shift()();if(a)for(d=0;d<a.length;d++)c=t(t.s=a[d]);return c};var o={},r={1:0};t.e=function(e){function n(){a.onerror=a.onload=null,clearTimeout(p);var t=r[e];0!==t&&(t&&t[1](new Error("Loading chunk "+e+" failed.")),r[e]=void 0)}var o=r[e];if(0===o)return new Promise(function(e){e()});if(o)return o[2];var i=new Promise(function(t,n){o=r[e]=[t,n]});o[2]=i;var s=document.getElementsByTagName("head")[0],a=document.createElement("script");a.type="text/javascript",a.charset="utf-8",a.async=!0,a.timeout=1.2e5,t.nc&&a.setAttribute("nonce",t.nc),a.src=t.p+""+({0:"app"}[e]||e)+"."+{0:"eb4a06f3"}[e]+".js";var p=setTimeout(n,1.2e5);return a.onerror=a.onload=n,s.appendChild(a),i},t.m=e,t.c=o,t.d=function(e,n,o){t.o(e,n)||Object.defineProperty(e,n,{configurable:!1,enumerable:!0,get:o})},t.n=function(e){var n=e&&e.__esModule?function(){return e["default"]}:function(){return e};return t.d(n,"a",n),n},t.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},t.p="/assets/",t.oe=function(e){throw console.error(e),e}})({rxKx:function(e,t,n){var o;(function(i,r,s){"use strict";function a(e,t,n){return setTimeout(u(e,n),t)}function p(e,t,n){return!!Array.isArray(e)&&(l(e,n[t],n),!0)}function l(e,t,n){if(e)if(e.forEach)e.forEach(t,n);else if(void 0!==e.length)for(o=0;o<e.length;)t.call(n,e[o],o,e),o++;else for(var o in e)e.hasOwnProperty(o)&&t.call(n,e[o],o,e)}function c(t,n,o){return function(){var r=new Error("get-stack-trace"),e=r&&r.stack?r.stack.replace(/^[^\(]+?[\n$]/gm,"").replace(/^\s+at\s+/gm,"").replace(/^Object.<anonymous>\s*\(/gm,"{anonymous}()@"):"Unknown Stack Trace",s=i.console&&(i.console.warn||i.console.log);return s&&s.call(i.console,"DEPRECATED METHOD: "+n+"\n"+o+" AT \n",e),t.apply(this,arguments)}}function d(e,t,n){var o,i=t.prototype;o=e.prototype=Object.create(i),o.constructor=e,o._super=i,n&&he(o,n)}function u(e,t){return function(){return e.apply(t,arguments)}}function h(e,t){return typeof e==Te?e.apply(t?t[0]||void 0:void 0,t):e}function m(e,t){return void 0===e?t:e}function g(e,t,n){l(f(t),function(t){e.addEventListener(t,n,!1)})}function v(e,t,n){l(f(t),function(t){e.removeEventListener(t,n,!1)})}function T(e,t){for(;e;){if(e==t)return!0;e=e.parentNode}return!1}function y(e,t){return-1<e.indexOf(t)}function f(e){return e.trim().split(/\s+/g)}function E(e,t,n){if(e.indexOf&&!n)return e.indexOf(t);for(var o=0;o<e.length;){if(n&&e[o][n]==t||!n&&e[o]===t)return o;o++}return-1}function I(e){return Array.prototype.slice.call(e,0)}function _(e,t,n){for(var o,r=[],s=[],a=0;a<e.length;)o=t?e[a][t]:e[a],0>E(s,o)&&r.push(e[a]),s[a]=o,a++;return n&&(t?r=r.sort(function(e,n){return e[t]>n[t]}):r=r.sort()),r}function A(e,t){for(var n,o,r=t[0].toUpperCase()+t.slice(1),s=0;s<ge.length;){if(n=ge[s],o=n?n+r:t,o in e)return o;s++}}function C(){return Ae++}function x(e){var t=e.ownerDocument||e;return t.defaultView||t.parentWindow||i}function P(e,t){var n=this;this.manager=e,this.callback=t,this.element=e.element,this.target=e.options.inputTarget,this.domHandler=function(t){h(e.options.enable,[e])&&n.handler(t)},this.init()}function S(e){var t,n=e.options.inputClass;return t=n?n:Pe?W:Se?U:xe?j:M,new t(e,D)}function D(e,t,n){var o=n.pointers.length,i=n.changedPointers.length,r=t&Re&&0==o-i;n.isFirst=!!r,n.isFinal=!!(t&(ke|ze)&&0==o-i),r&&(e.session={}),n.eventType=t,N(e,n),e.emit("hammer.input",n),e.recognize(n),e.session.prevInput=n}function N(e,t){var n=e.session,o=t.pointers,i=o.length;n.firstInput||(n.firstInput=b(t)),1<i&&!n.firstMultiple?n.firstMultiple=b(t):1===i&&(n.firstMultiple=!1);var r=n.firstInput,s=n.firstMultiple,a=s?s.center:r.center,p=t.center=k(o);t.timeStamp=Ee(),t.deltaTime=t.timeStamp-r.timeStamp,t.angle=w(a,p),t.distance=Y(a,p),O(n,t),t.offsetDirection=X(t.deltaX,t.deltaY);var l=z(t.deltaTime,t.deltaX,t.deltaY);t.overallVelocityX=l.x,t.overallVelocityY=l.y,t.overallVelocity=fe(l.x)>fe(l.y)?l.x:l.y,t.scale=s?H(s.pointers,o):1,t.rotation=s?F(s.pointers,o):0,t.maxPointers=n.prevInput?t.pointers.length>n.prevInput.maxPointers?t.pointers.length:n.prevInput.maxPointers:t.pointers.length,R(n,t);var c=e.element;T(t.srcEvent.target,c)&&(c=t.srcEvent.target),t.target=c}function O(e,t){var n=t.center,o=e.offsetDelta||{},i=e.prevDelta||{},r=e.prevInput||{};(t.eventType===Re||r.eventType===ke)&&(i=e.prevDelta={x:r.deltaX||0,y:r.deltaY||0},o=e.offsetDelta={x:n.x,y:n.y}),t.deltaX=i.x+(n.x-o.x),t.deltaY=i.y+(n.y-o.y)}function R(e,t){var n,o,i,r,s=e.lastInterval||t,a=t.timeStamp-s.timeStamp;if(t.eventType!=ze&&(a>Oe||void 0===s.velocity)){var p=t.deltaX-s.deltaX,l=t.deltaY-s.deltaY,c=z(a,p,l);o=c.x,i=c.y,n=fe(c.x)>fe(c.y)?c.x:c.y,r=X(p,l),e.lastInterval=t}else n=s.velocity,o=s.velocityX,i=s.velocityY,r=s.direction;t.velocity=n,t.velocityX=o,t.velocityY=i,t.direction=r}function b(e){for(var t=[],n=0;n<e.pointers.length;)t[n]={clientX:ye(e.pointers[n].clientX),clientY:ye(e.pointers[n].clientY)},n++;return{timeStamp:Ee(),pointers:t,center:k(t),deltaX:e.deltaX,deltaY:e.deltaY}}function k(e){var t=e.length;if(1===t)return{x:ye(e[0].clientX),y:ye(e[0].clientY)};for(var n=0,o=0,r=0;r<t;)n+=e[r].clientX,o+=e[r].clientY,r++;return{x:ye(n/t),y:ye(o/t)}}function z(e,t,n){return{x:t/e||0,y:n/e||0}}function X(e,t){return e===t?Xe:fe(e)>=fe(t)?0>e?Ye:we:0>t?Fe:He}function Y(e,t,n){n||(n=Le);var o=t[n[0]]-e[n[0]],i=t[n[1]]-e[n[1]];return Math.sqrt(o*o+i*i)}function w(e,t,n){n||(n=Le);var o=t[n[0]]-e[n[0]],i=t[n[1]]-e[n[1]];return 180*Math.atan2(i,o)/Math.PI}function F(e,t){return w(t[1],t[0],Ue)+w(e[1],e[0],Ue)}function H(e,t){return Y(t[0],t[1],Ue)/Y(e[0],e[1],Ue)}function M(){this.evEl=je,this.evWin=Ge,this.pressed=!1,P.apply(this,arguments)}function W(){this.evEl=Ze,this.evWin=Je,P.apply(this,arguments),this.store=this.manager.session.pointerEvents=[]}function q(){this.evTarget=$e,this.evWin=et,this.started=!1,P.apply(this,arguments)}function L(e,t){var n=I(e.touches),o=I(e.changedTouches);return t&(ke|ze)&&(n=_(n.concat(o),"identifier",!0)),[n,o]}function U(){this.evTarget=nt,this.targetIds={},P.apply(this,arguments)}function V(e,t){var n=I(e.touches),o=this.targetIds;if(t&(Re|be)&&1===n.length)return o[n[0].identifier]=!0,[n,n];var r,i,s=I(e.changedTouches),a=[],p=this.target;if(i=n.filter(function(e){return T(e.target,p)}),t===Re)for(r=0;r<i.length;)o[i[r].identifier]=!0,r++;for(r=0;r<s.length;)o[s[r].identifier]&&a.push(s[r]),t&(ke|ze)&&delete o[s[r].identifier],r++;return a.length?[_(i.concat(a),"identifier",!0),a]:void 0}function j(){P.apply(this,arguments);var e=u(this.handler,this);this.touch=new U(this.manager,e),this.mouse=new M(this.manager,e),this.primaryTouch=null,this.lastTouches=[]}function G(e,t){e&Re?(this.primaryTouch=t.changedPointers[0].identifier,K.call(this,t)):e&(ke|ze)&&K.call(this,t)}function K(e){var t=e.changedPointers[0];if(t.identifier===this.primaryTouch){var n={x:t.clientX,y:t.clientY};this.lastTouches.push(n);var o=this.lastTouches,i=function(){var e=o.indexOf(n);-1<e&&o.splice(e,1)};setTimeout(i,ot)}}function B(e){for(var n=e.srcEvent.clientX,o=e.srcEvent.clientY,r=0;r<this.lastTouches.length;r++){var i=this.lastTouches[r],t=me(n-i.x),s=me(o-i.y);if(t<=it&&s<=it)return!0}return!1}function Z(e,t){this.manager=e,this.set(t)}function J(e){if(y(e,ct))return ct;var t=y(e,dt),n=y(e,ut);return t&&n?ct:t||n?t?dt:ut:y(e,lt)?lt:pt}function Q(e){this.options=he({},this.defaults,e||{}),this.id=C(),this.manager=null,this.options.enable=m(this.options.enable,!0),this.state=mt,this.simultaneous={},this.requireFail=[]}function $(e){return e&ft?"cancel":e&Tt?"end":e&vt?"move":e&gt?"start":""}function ee(e){return e==He?"down":e==Fe?"up":e==Ye?"left":e==we?"right":""}function te(e,t){var n=t.manager;return n?n.get(e):e}function ne(){Q.apply(this,arguments)}function oe(){ne.apply(this,arguments),this.pX=null,this.pY=null}function ie(){ne.apply(this,arguments)}function re(){Q.apply(this,arguments),this._timer=null,this._input=null}function se(){ne.apply(this,arguments)}function ae(){ne.apply(this,arguments)}function pe(){Q.apply(this,arguments),this.pTime=!1,this.pCenter=!1,this._timer=null,this._input=null,this.count=0}function le(e,t){return t=t||{},t.recognizers=m(t.recognizers,le.defaults.preset),new ce(e,t)}function ce(e,t){this.options=he({},le.defaults,t||{}),this.options.inputTarget=this.options.inputTarget||e,this.handlers={},this.session={},this.recognizers=[],this.oldCssProps={},this.element=e,this.input=S(this),this.touchAction=new Z(this,this.options.touchAction),de(this,!0),l(this.options.recognizers,function(e){var t=this.add(new e[0](e[1]));e[2]&&t.recognizeWith(e[2]),e[3]&&t.requireFailure(e[3])},this)}function de(e,t){var n=e.element;if(n.style){var o;l(e.options.cssProps,function(i,r){o=A(n.style,r),t?(e.oldCssProps[o]=n.style[o],n.style[o]=i):n.style[o]=e.oldCssProps[o]||""}),t||(e.oldCssProps={})}}function ue(e,t){var n=r.createEvent("Event");n.initEvent(e,!0,!0),n.gesture=t,t.target.dispatchEvent(n)}var he,me=Math.abs,ge=["","webkit","Moz","MS","ms","o"],ve=r.createElement("div"),Te="function",ye=Math.round,fe=me,Ee=Date.now;he="function"==typeof Object.assign?Object.assign:function(e){if(void 0===e||null===e)throw new TypeError("Cannot convert undefined or null to object");for(var t,n=Object(e),o=1;o<arguments.length;o++)if(t=arguments[o],void 0!==t&&null!==t)for(var i in t)t.hasOwnProperty(i)&&(n[i]=t[i]);return n};var Ie=c(function(e,t,n){for(var o=Object.keys(t),r=0;r<o.length;)(!n||n&&void 0===e[o[r]])&&(e[o[r]]=t[o[r]]),r++;return e},"extend","Use `assign`."),_e=c(function(e,t){return Ie(e,t,!0)},"merge","Use `assign`."),Ae=1,Ce=/mobile|tablet|ip(ad|hone|od)|android/i,xe="ontouchstart"in i,Pe=void 0!==A(i,"PointerEvent"),Se=xe&&Ce.test(navigator.userAgent),De="touch",Ne="mouse",Oe=25,Re=1,be=2,ke=4,ze=8,Xe=1,Ye=2,we=4,Fe=8,He=16,Me=Ye|we,We=Fe|He,qe=Me|We,Le=["x","y"],Ue=["clientX","clientY"];P.prototype={handler:function(){},init:function(){this.evEl&&g(this.element,this.evEl,this.domHandler),this.evTarget&&g(this.target,this.evTarget,this.domHandler),this.evWin&&g(x(this.element),this.evWin,this.domHandler)},destroy:function(){this.evEl&&v(this.element,this.evEl,this.domHandler),this.evTarget&&v(this.target,this.evTarget,this.domHandler),this.evWin&&v(x(this.element),this.evWin,this.domHandler)}};var Ve={mousedown:Re,mousemove:be,mouseup:ke},je="mousedown",Ge="mousemove mouseup";d(M,P,{handler:function(e){var t=Ve[e.type];t&Re&&0===e.button&&(this.pressed=!0),t&be&&1!==e.which&&(t=ke),this.pressed&&(t&ke&&(this.pressed=!1),this.callback(this.manager,t,{pointers:[e],changedPointers:[e],pointerType:Ne,srcEvent:e}))}});var Ke={pointerdown:Re,pointermove:be,pointerup:ke,pointercancel:ze,pointerout:ze},Be={2:De,3:"pen",4:Ne,5:"kinect"},Ze="pointerdown",Je="pointermove pointerup pointercancel";i.MSPointerEvent&&!i.PointerEvent&&(Ze="MSPointerDown",Je="MSPointerMove MSPointerUp MSPointerCancel"),d(W,P,{handler:function(e){var t=this.store,n=!1,o=e.type.toLowerCase().replace("ms",""),i=Ke[o],r=Be[e.pointerType]||e.pointerType,s=E(t,e.pointerId,"pointerId");i&Re&&(0===e.button||r==De)?0>s&&(t.push(e),s=t.length-1):i&(ke|ze)&&(n=!0),0>s||(t[s]=e,this.callback(this.manager,i,{pointers:t,changedPointers:[e],pointerType:r,srcEvent:e}),n&&t.splice(s,1))}});var Qe={touchstart:Re,touchmove:be,touchend:ke,touchcancel:ze},$e="touchstart",et="touchstart touchmove touchend touchcancel";d(q,P,{handler:function(e){var t=Qe[e.type];if(t===Re&&(this.started=!0),!!this.started){var n=L.call(this,e,t);t&(ke|ze)&&0==n[0].length-n[1].length&&(this.started=!1),this.callback(this.manager,t,{pointers:n[0],changedPointers:n[1],pointerType:De,srcEvent:e})}}});var tt={touchstart:Re,touchmove:be,touchend:ke,touchcancel:ze},nt="touchstart touchmove touchend touchcancel";d(U,P,{handler:function(e){var t=tt[e.type],n=V.call(this,e,t);n&&this.callback(this.manager,t,{pointers:n[0],changedPointers:n[1],pointerType:De,srcEvent:e})}});var ot=2500,it=25;d(j,P,{handler:function(e,t,n){var o=n.pointerType==De,i=n.pointerType==Ne;if(!(i&&n.sourceCapabilities&&n.sourceCapabilities.firesTouchEvents)){if(o)G.call(this,t,n);else if(i&&B.call(this,n))return;this.callback(e,t,n)}},destroy:function(){this.touch.destroy(),this.mouse.destroy()}});var rt=A(ve.style,"touchAction"),st=void 0!==rt,at="compute",pt="auto",lt="manipulation",ct="none",dt="pan-x",ut="pan-y",ht=function(){if(!st)return!1;var e={},t=i.CSS&&i.CSS.supports;return["auto","manipulation","pan-y","pan-x","pan-x pan-y","none"].forEach(function(n){e[n]=!t||i.CSS.supports("touch-action",n)}),e}();Z.prototype={set:function(e){e==at&&(e=this.compute()),st&&this.manager.element.style&&ht[e]&&(this.manager.element.style[rt]=e),this.actions=e.toLowerCase().trim()},update:function(){this.set(this.manager.options.touchAction)},compute:function(){var e=[];return l(this.manager.recognizers,function(t){h(t.options.enable,[t])&&(e=e.concat(t.getTouchAction()))}),J(e.join(" "))},preventDefaults:function(e){var t=e.srcEvent,n=e.offsetDirection;if(this.manager.session.prevented)return void t.preventDefault();var o=this.actions,i=y(o,ct)&&!ht[ct],r=y(o,ut)&&!ht[ut],s=y(o,dt)&&!ht[dt];if(i){var a=1===e.pointers.length,p=2>e.distance,l=250>e.deltaTime;if(a&&p&&l)return}return s&&r?void 0:i||r&&n&Me||s&&n&We?this.preventSrc(t):void 0},preventSrc:function(e){this.manager.session.prevented=!0,e.preventDefault()}};var mt=1,gt=2,vt=4,Tt=8,yt=Tt,ft=16,Et=32;Q.prototype={defaults:{},set:function(e){return he(this.options,e),this.manager&&this.manager.touchAction.update(),this},recognizeWith:function(e){if(p(e,"recognizeWith",this))return this;var t=this.simultaneous;return e=te(e,this),t[e.id]||(t[e.id]=e,e.recognizeWith(this)),this},dropRecognizeWith:function(e){return p(e,"dropRecognizeWith",this)?this:(e=te(e,this),delete this.simultaneous[e.id],this)},requireFailure:function(e){if(p(e,"requireFailure",this))return this;var t=this.requireFail;return e=te(e,this),-1===E(t,e)&&(t.push(e),e.requireFailure(this)),this},dropRequireFailure:function(e){if(p(e,"dropRequireFailure",this))return this;e=te(e,this);var t=E(this.requireFail,e);return-1<t&&this.requireFail.splice(t,1),this},hasRequireFailures:function(){return 0<this.requireFail.length},canRecognizeWith:function(e){return!!this.simultaneous[e.id]},emit:function(e){function t(t){n.manager.emit(t,e)}var n=this,o=this.state;o<Tt&&t(n.options.event+$(o)),t(n.options.event),e.additionalEvent&&t(e.additionalEvent),o>=Tt&&t(n.options.event+$(o))},tryEmit:function(e){return this.canEmit()?this.emit(e):void(this.state=Et)},canEmit:function(){for(var e=0;e<this.requireFail.length;){if(!(this.requireFail[e].state&(Et|mt)))return!1;e++}return!0},recognize:function(e){var t=he({},e);return h(this.options.enable,[this,t])?void(this.state&(yt|ft|Et)&&(this.state=mt),this.state=this.process(t),this.state&(gt|vt|Tt|ft)&&this.tryEmit(t)):(this.reset(),void(this.state=Et))},process:function(){},getTouchAction:function(){},reset:function(){}},d(ne,Q,{defaults:{pointers:1},attrTest:function(e){var t=this.options.pointers;return 0===t||e.pointers.length===t},process:function(e){var t=this.state,n=e.eventType,o=t&(gt|vt),i=this.attrTest(e);return o&&(n&ze||!i)?t|ft:o||i?n&ke?t|Tt:t&gt?t|vt:gt:Et}}),d(oe,ne,{defaults:{event:"pan",threshold:10,pointers:1,direction:qe},getTouchAction:function(){var e=this.options.direction,t=[];return e&Me&&t.push(ut),e&We&&t.push(dt),t},directionTest:function(e){var t=this.options,n=!0,o=e.distance,i=e.direction,r=e.deltaX,s=e.deltaY;return i&t.direction||(t.direction&Me?(i=0===r?Xe:0>r?Ye:we,n=r!=this.pX,o=me(e.deltaX)):(i=0===s?Xe:0>s?Fe:He,n=s!=this.pY,o=me(e.deltaY))),e.direction=i,n&&o>t.threshold&&i&t.direction},attrTest:function(e){return ne.prototype.attrTest.call(this,e)&&(this.state&gt||!(this.state&gt)&&this.directionTest(e))},emit:function(e){this.pX=e.deltaX,this.pY=e.deltaY;var t=ee(e.direction);t&&(e.additionalEvent=this.options.event+t),this._super.emit.call(this,e)}}),d(ie,ne,{defaults:{event:"pinch",threshold:0,pointers:2},getTouchAction:function(){return[ct]},attrTest:function(e){return this._super.attrTest.call(this,e)&&(me(e.scale-1)>this.options.threshold||this.state&gt)},emit:function(e){if(1!==e.scale){var t=1>e.scale?"in":"out";e.additionalEvent=this.options.event+t}this._super.emit.call(this,e)}}),d(re,Q,{defaults:{event:"press",pointers:1,time:251,threshold:9},getTouchAction:function(){return[pt]},process:function(e){var t=this.options,n=e.pointers.length===t.pointers,o=e.distance<t.threshold,i=e.deltaTime>t.time;if(this._input=e,!o||!n||e.eventType&(ke|ze)&&!i)this.reset();else if(e.eventType&Re)this.reset(),this._timer=a(function(){this.state=yt,this.tryEmit()},t.time,this);else if(e.eventType&ke)return yt;return Et},reset:function(){clearTimeout(this._timer)},emit:function(e){this.state!==yt||(e&&e.eventType&ke?this.manager.emit(this.options.event+"up",e):(this._input.timeStamp=Ee(),this.manager.emit(this.options.event,this._input)))}}),d(se,ne,{defaults:{event:"rotate",threshold:0,pointers:2},getTouchAction:function(){return[ct]},attrTest:function(e){return this._super.attrTest.call(this,e)&&(me(e.rotation)>this.options.threshold||this.state&gt)}}),d(ae,ne,{defaults:{event:"swipe",threshold:10,velocity:0.3,direction:Me|We,pointers:1},getTouchAction:function(){return oe.prototype.getTouchAction.call(this)},attrTest:function(e){var t,n=this.options.direction;return n&(Me|We)?t=e.overallVelocity:n&Me?t=e.overallVelocityX:n&We&&(t=e.overallVelocityY),this._super.attrTest.call(this,e)&&n&e.offsetDirection&&e.distance>this.options.threshold&&e.maxPointers==this.options.pointers&&fe(t)>this.options.velocity&&e.eventType&ke},emit:function(e){var t=ee(e.offsetDirection);t&&this.manager.emit(this.options.event+t,e),this.manager.emit(this.options.event,e)}}),d(pe,Q,{defaults:{event:"tap",pointers:1,taps:1,interval:300,time:250,threshold:9,posThreshold:10},getTouchAction:function(){return[lt]},process:function(e){var t=this.options,n=e.pointers.length===t.pointers,o=e.distance<t.threshold,i=e.deltaTime<t.time;if(this.reset(),e.eventType&Re&&0===this.count)return this.failTimeout();if(o&&i&&n){if(e.eventType!=ke)return this.failTimeout();var r=!this.pTime||e.timeStamp-this.pTime<t.interval,s=!this.pCenter||Y(this.pCenter,e.center)<t.posThreshold;this.pTime=e.timeStamp,this.pCenter=e.center,s&&r?this.count+=1:this.count=1,this._input=e;var p=this.count%t.taps;if(0==p)return this.hasRequireFailures()?(this._timer=a(function(){this.state=yt,this.tryEmit()},t.interval,this),gt):yt}return Et},failTimeout:function(){return this._timer=a(function(){this.state=Et},this.options.interval,this),Et},reset:function(){clearTimeout(this._timer)},emit:function(){this.state==yt&&(this._input.tapCount=this.count,this.manager.emit(this.options.event,this._input))}}),le.VERSION="2.0.7",le.defaults={domEvents:!1,touchAction:at,enable:!0,inputTarget:null,inputClass:null,preset:[[se,{enable:!1}],[ie,{enable:!1},["rotate"]],[ae,{direction:Me}],[oe,{direction:Me},["swipe"]],[pe],[pe,{event:"doubletap",taps:2},["tap"]],[re]],cssProps:{userSelect:"none",touchSelect:"none",touchCallout:"none",contentZooming:"none",userDrag:"none",tapHighlightColor:"rgba(0,0,0,0)"}};var It=2;ce.prototype={set:function(e){return he(this.options,e),e.touchAction&&this.touchAction.update(),e.inputTarget&&(this.input.destroy(),this.input.target=e.inputTarget,this.input.init()),this},stop:function(e){this.session.stopped=e?It:1},recognize:function(e){var t=this.session;if(!t.stopped){this.touchAction.preventDefaults(e);var n,o=this.recognizers,r=t.curRecognizer;(!r||r&&r.state&yt)&&(r=t.curRecognizer=null);for(var s=0;s<o.length;)n=o[s],t.stopped!==It&&(!r||n==r||n.canRecognizeWith(r))?n.recognize(e):n.reset(),!r&&n.state&(gt|vt|Tt)&&(r=t.curRecognizer=n),s++}},get:function(e){if(e instanceof Q)return e;for(var t=this.recognizers,n=0;n<t.length;n++)if(t[n].options.event==e)return t[n];return null},add:function(e){if(p(e,"add",this))return this;var t=this.get(e.options.event);return t&&this.remove(t),this.recognizers.push(e),e.manager=this,this.touchAction.update(),e},remove:function(e){if(p(e,"remove",this))return this;if(e=this.get(e),e){var t=this.recognizers,n=E(t,e);-1!==n&&(t.splice(n,1),this.touchAction.update())}return this},on:function(e,t){if(void 0!==e&&void 0!==t){var n=this.handlers;return l(f(e),function(e){n[e]=n[e]||[],n[e].push(t)}),this}},off:function(e,t){if(void 0!==e){var n=this.handlers;return l(f(e),function(e){t?n[e]&&n[e].splice(E(n[e],t),1):delete n[e]}),this}},emit:function(e,t){this.options.domEvents&&ue(e,t);var n=this.handlers[e]&&this.handlers[e].slice();if(n&&n.length){t.type=e,t.preventDefault=function(){t.srcEvent.preventDefault()};for(var o=0;o<n.length;)n[o](t),o++}},destroy:function(){this.element&&de(this,!1),this.handlers={},this.session={},this.input.destroy(),this.element=null}},he(le,{INPUT_START:Re,INPUT_MOVE:be,INPUT_END:ke,INPUT_CANCEL:ze,STATE_POSSIBLE:mt,STATE_BEGAN:gt,STATE_CHANGED:vt,STATE_ENDED:Tt,STATE_RECOGNIZED:yt,STATE_CANCELLED:ft,STATE_FAILED:Et,DIRECTION_NONE:Xe,DIRECTION_LEFT:Ye,DIRECTION_RIGHT:we,DIRECTION_UP:Fe,DIRECTION_DOWN:He,DIRECTION_HORIZONTAL:Me,DIRECTION_VERTICAL:We,DIRECTION_ALL:qe,Manager:ce,Input:P,TouchAction:Z,TouchInput:U,MouseInput:M,PointerEventInput:W,TouchMouseInput:j,SingleTouchInput:q,Recognizer:Q,AttrRecognizer:ne,Tap:pe,Pan:oe,Swipe:ae,Pinch:ie,Rotate:se,Press:re,on:g,off:v,each:l,merge:_e,extend:Ie,assign:he,inherit:d,bindFn:u,prefixed:A});var _t="undefined"==typeof i?"undefined"==typeof self?{}:self:i;_t.Hammer=le,(o=function(){return le}.call(t,n,t,e),!(void 0!==o&&(e.exports=o)))})(window,document,"Hammer")}});