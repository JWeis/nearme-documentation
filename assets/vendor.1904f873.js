!function(t){function e(n){if(i[n])return i[n].exports;var r=i[n]={i:n,l:!1,exports:{}};return t[n].call(r.exports,r,r.exports,e),r.l=!0,r.exports}var n=window.webpackJsonp;window.webpackJsonp=function(i,s,o){for(var a,A,c,h=0,u=[];h<i.length;h++)A=i[h],r[A]&&u.push(r[A][0]),r[A]=0;for(a in s)Object.prototype.hasOwnProperty.call(s,a)&&(t[a]=s[a]);for(n&&n(i,s,o);u.length;)u.shift()();if(o)for(h=0;h<o.length;h++)c=e(e.s=o[h]);return c};var i={},r={1:0};e.e=function(t){function n(){a.onerror=a.onload=null,clearTimeout(A);var e=r[t];0!==e&&(e&&e[1](new Error("Loading chunk "+t+" failed.")),r[t]=void 0)}var i=r[t];if(0===i)return new Promise(function(t){t()});if(i)return i[2];var s=new Promise(function(e,n){i=r[t]=[e,n]});i[2]=s;var o=document.getElementsByTagName("head")[0],a=document.createElement("script");a.type="text/javascript",a.charset="utf-8",a.async=!0,a.timeout=12e4,e.nc&&a.setAttribute("nonce",e.nc),a.src=e.p+""+({0:"app"}[t]||t)+"."+{0:"d39a77e5"}[t]+".js";var A=setTimeout(n,12e4);return a.onerror=a.onload=n,o.appendChild(a),s},e.m=t,e.c=i,e.d=function(t,n,i){e.o(t,n)||Object.defineProperty(t,n,{configurable:!1,enumerable:!0,get:i})},e.n=function(t){var n=t&&t.__esModule?function(){return t.default}:function(){return t};return e.d(n,"a",n),n},e.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},e.p="/assets/",e.oe=function(t){throw console.error(t),t}}({KmvJ:function(t,e){var n,i,r;!function(s,o){"use strict";i=[],n=o,void 0!==(r="function"==typeof n?n.apply(e,i):n)&&(t.exports=r)}(0,function(){"use strict";return function(t){function e(t){t.icon=t.hasOwnProperty("icon")?t.icon:"",t.visible=t.hasOwnProperty("visible")?t.visible:"hover",t.placement=t.hasOwnProperty("placement")?t.placement:"right",t.ariaLabel=t.hasOwnProperty("ariaLabel")?t.ariaLabel:"Anchor",t.class=t.hasOwnProperty("class")?t.class:"",t.truncate=t.hasOwnProperty("truncate")?Math.floor(t.truncate):64}function n(t){var e;if("string"==typeof t||t instanceof String)e=[].slice.call(document.querySelectorAll(t));else{if(!(Array.isArray(t)||t instanceof NodeList))throw new Error("The selector provided to AnchorJS was invalid.");e=[].slice.call(t)}return e}function i(){if(null===document.head.querySelector("style.anchorjs")){var t,e=document.createElement("style");e.className="anchorjs",e.appendChild(document.createTextNode("")),t=document.head.querySelector('[rel="stylesheet"], style'),void 0===t?document.head.appendChild(e):document.head.insertBefore(e,t),e.sheet.insertRule(" .anchorjs-link {   opacity: 0;   text-decoration: none;   -webkit-font-smoothing: antialiased;   -moz-osx-font-smoothing: grayscale; }",e.sheet.cssRules.length),e.sheet.insertRule(" *:hover > .anchorjs-link, .anchorjs-link:focus  {   opacity: 1; }",e.sheet.cssRules.length),e.sheet.insertRule(" [data-anchorjs-icon]::after {   content: attr(data-anchorjs-icon); }",e.sheet.cssRules.length),e.sheet.insertRule(' @font-face {   font-family: "anchorjs-icons";   src: url(data:n/a;base64,AAEAAAALAIAAAwAwT1MvMg8yG2cAAAE4AAAAYGNtYXDp3gC3AAABpAAAAExnYXNwAAAAEAAAA9wAAAAIZ2x5ZlQCcfwAAAH4AAABCGhlYWQHFvHyAAAAvAAAADZoaGVhBnACFwAAAPQAAAAkaG10eASAADEAAAGYAAAADGxvY2EACACEAAAB8AAAAAhtYXhwAAYAVwAAARgAAAAgbmFtZQGOH9cAAAMAAAAAunBvc3QAAwAAAAADvAAAACAAAQAAAAEAAHzE2p9fDzz1AAkEAAAAAADRecUWAAAAANQA6R8AAAAAAoACwAAAAAgAAgAAAAAAAAABAAADwP/AAAACgAAA/9MCrQABAAAAAAAAAAAAAAAAAAAAAwABAAAAAwBVAAIAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAMCQAGQAAUAAAKZAswAAACPApkCzAAAAesAMwEJAAAAAAAAAAAAAAAAAAAAARAAAAAAAAAAAAAAAAAAAAAAQAAg//0DwP/AAEADwABAAAAAAQAAAAAAAAAAAAAAIAAAAAAAAAIAAAACgAAxAAAAAwAAAAMAAAAcAAEAAwAAABwAAwABAAAAHAAEADAAAAAIAAgAAgAAACDpy//9//8AAAAg6cv//f///+EWNwADAAEAAAAAAAAAAAAAAAAACACEAAEAAAAAAAAAAAAAAAAxAAACAAQARAKAAsAAKwBUAAABIiYnJjQ3NzY2MzIWFxYUBwcGIicmNDc3NjQnJiYjIgYHBwYUFxYUBwYGIwciJicmNDc3NjIXFhQHBwYUFxYWMzI2Nzc2NCcmNDc2MhcWFAcHBgYjARQGDAUtLXoWOR8fORYtLTgKGwoKCjgaGg0gEhIgDXoaGgkJBQwHdR85Fi0tOAobCgoKOBoaDSASEiANehoaCQkKGwotLXoWOR8BMwUFLYEuehYXFxYugC44CQkKGwo4GkoaDQ0NDXoaShoKGwoFBe8XFi6ALjgJCQobCjgaShoNDQ0NehpKGgobCgoKLYEuehYXAAAADACWAAEAAAAAAAEACAAAAAEAAAAAAAIAAwAIAAEAAAAAAAMACAAAAAEAAAAAAAQACAAAAAEAAAAAAAUAAQALAAEAAAAAAAYACAAAAAMAAQQJAAEAEAAMAAMAAQQJAAIABgAcAAMAAQQJAAMAEAAMAAMAAQQJAAQAEAAMAAMAAQQJAAUAAgAiAAMAAQQJAAYAEAAMYW5jaG9yanM0MDBAAGEAbgBjAGgAbwByAGoAcwA0ADAAMABAAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAH//wAP) format("truetype"); }',e.sheet.cssRules.length)}}this.options=t||{},this.elements=[],e(this.options),this.isTouchDevice=function(){return!!("ontouchstart"in window||window.DocumentTouch&&document instanceof DocumentTouch)},this.add=function(t){var r,s,o,a,A,c,h,u,l,p,f,d=[];if(e(this.options),f=this.options.visible,"touch"===f&&(f=this.isTouchDevice()?"always":"hover"),t||(t="h2, h3, h4, h5, h6"),r=n(t),0===r.length)return this;for(i(),s=document.querySelectorAll("[id]"),o=[].map.call(s,function(t){return t.id}),A=0;A<r.length;A++)if(this.hasAnchorJSLink(r[A]))d.push(A);else{if(r[A].hasAttribute("id"))a=r[A].getAttribute("id");else if(r[A].hasAttribute("data-anchor-id"))a=r[A].getAttribute("data-anchor-id");else{u=this.urlify(r[A].textContent),l=u,h=0;do{void 0!=c&&(l=u+"-"+h),c=o.indexOf(l),h+=1}while(-1!==c);c=void 0,o.push(l),r[A].setAttribute("id",l),a=l}a.replace(/-/g," "),p=document.createElement("a"),p.className="anchorjs-link "+this.options.class,p.href="#"+a,p.setAttribute("aria-label",this.options.ariaLabel),p.setAttribute("data-anchorjs-icon",this.options.icon),"always"===f&&(p.style.opacity="1"),""===this.options.icon&&(p.style.font="1em/1 anchorjs-icons","left"===this.options.placement&&(p.style.lineHeight="inherit")),"left"===this.options.placement?(p.style.position="absolute",p.style.marginLeft="-1em",p.style.paddingRight="0.5em",r[A].insertBefore(p,r[A].firstChild)):(p.style.paddingLeft="0.375em",r[A].appendChild(p))}for(A=0;A<d.length;A++)r.splice(d[A]-A,1);return this.elements=this.elements.concat(r),this},this.remove=function(t){for(var e,i,r=n(t),s=0;s<r.length;s++)(i=r[s].querySelector(".anchorjs-link"))&&(e=this.elements.indexOf(r[s]),-1!==e&&this.elements.splice(e,1),r[s].removeChild(i));return this},this.removeAll=function(){this.remove(this.elements)},this.urlify=function(t){var n=/[& +$,:;=?@"#{}|^~[`%!'<>\]\.\/\(\)\*\\]/g;return this.options.truncate||e(this.options),t.trim().replace(/\'/gi,"").replace(n,"-").replace(/-{2,}/g,"-").substring(0,this.options.truncate).replace(/^-+|-+$/gm,"").toLowerCase()},this.hasAnchorJSLink=function(t){var e=t.firstChild&&-1<(" "+t.firstChild.className+" ").indexOf(" anchorjs-link "),n=t.lastChild&&-1<(" "+t.lastChild.className+" ").indexOf(" anchorjs-link ");return e||n||!1}}})},rxKx:function(t,e,n){var i;!function(r,s,o){"use strict";function a(t,e,n){return setTimeout(l(t,n),e)}function A(t,e,n){return!!Array.isArray(t)&&(c(t,n[e],n),!0)}function c(t,e,n){if(t)if(t.forEach)t.forEach(e,n);else if(void 0!==t.length)for(i=0;i<t.length;)e.call(n,t[i],i,t),i++;else for(var i in t)t.hasOwnProperty(i)&&e.call(n,t[i],i,t)}function h(t,e,n){return function(){var i=new Error("get-stack-trace"),s=i&&i.stack?i.stack.replace(/^[^\(]+?[\n$]/gm,"").replace(/^\s+at\s+/gm,"").replace(/^Object.<anonymous>\s*\(/gm,"{anonymous}()@"):"Unknown Stack Trace",o=r.console&&(r.console.warn||r.console.log);return o&&o.call(r.console,"DEPRECATED METHOD: "+e+"\n"+n+" AT \n",s),t.apply(this,arguments)}}function u(t,e,n){var i,r=e.prototype;i=t.prototype=Object.create(r),i.constructor=t,i._super=r,n&&pt(i,n)}function l(t,e){return function(){return t.apply(e,arguments)}}function p(t,e){return typeof t==mt?t.apply(e?e[0]||void 0:void 0,e):t}function f(t,e){return void 0===t?e:t}function d(t,e,n){c(y(e),function(e){t.addEventListener(e,n,!1)})}function v(t,e,n){c(y(e),function(e){t.removeEventListener(e,n,!1)})}function m(t,e){for(;t;){if(t==e)return!0;t=t.parentNode}return!1}function g(t,e){return-1<t.indexOf(e)}function y(t){return t.trim().split(/\s+/g)}function T(t,e,n){if(t.indexOf&&!n)return t.indexOf(e);for(var i=0;i<t.length;){if(n&&t[i][n]==e||!n&&t[i]===e)return i;i++}return-1}function E(t){return Array.prototype.slice.call(t,0)}function w(t,e,n){for(var i,r=[],s=[],o=0;o<t.length;)i=e?t[o][e]:t[o],0>T(s,i)&&r.push(t[o]),s[o]=i,o++;return n&&(r=e?r.sort(function(t,n){return t[e]>n[e]}):r.sort()),r}function C(t,e){for(var n,i,r=e[0].toUpperCase()+e.slice(1),s=0;s<dt.length;){if(n=dt[s],(i=n?n+r:e)in t)return i;s++}}function b(){return Ct++}function D(t){var e=t.ownerDocument||t;return e.defaultView||e.parentWindow||r}function I(t,e){var n=this;this.manager=t,this.callback=e,this.element=t.element,this.target=t.options.inputTarget,this.domHandler=function(e){p(t.options.enable,[t])&&n.handler(e)},this.init()}function x(t){var e=t.options.inputClass;return new(e||(It?B:xt?G:Dt?H:k))(t,P)}function P(t,e,n){var i=n.pointers.length,r=n.changedPointers.length,s=e&Mt&&0==i-r;n.isFirst=!!s,n.isFinal=!!(e&(Nt|Rt)&&0==i-r),s&&(t.session={}),n.eventType=e,S(t,n),t.emit("hammer.input",n),t.recognize(n),t.session.prevInput=n}function S(t,e){var n=t.session,i=e.pointers,r=i.length;n.firstInput||(n.firstInput=O(e)),1<r&&!n.firstMultiple?n.firstMultiple=O(e):1===r&&(n.firstMultiple=!1);var s=n.firstInput,o=n.firstMultiple,a=o?o.center:s.center,A=e.center=N(i);e.timeStamp=Tt(),e.deltaTime=e.timeStamp-s.timeStamp,e.angle=j(a,A),e.distance=Q(a,A),Y(n,e),e.offsetDirection=_(e.deltaX,e.deltaY);var c=R(e.deltaTime,e.deltaX,e.deltaY);e.overallVelocityX=c.x,e.overallVelocityY=c.y,e.overallVelocity=yt(c.x)>yt(c.y)?c.x:c.y,e.scale=o?X(o.pointers,i):1,e.rotation=o?z(o.pointers,i):0,e.maxPointers=n.prevInput?e.pointers.length>n.prevInput.maxPointers?e.pointers.length:n.prevInput.maxPointers:e.pointers.length,M(n,e);var h=t.element;m(e.srcEvent.target,h)&&(h=e.srcEvent.target),e.target=h}function Y(t,e){var n=e.center,i=t.offsetDelta||{},r=t.prevDelta||{},s=t.prevInput||{};(e.eventType===Mt||s.eventType===Nt)&&(r=t.prevDelta={x:s.deltaX||0,y:s.deltaY||0},i=t.offsetDelta={x:n.x,y:n.y}),e.deltaX=r.x+(n.x-i.x),e.deltaY=r.y+(n.y-i.y)}function M(t,e){var n,i,r,s,o=t.lastInterval||e,a=e.timeStamp-o.timeStamp;if(e.eventType!=Rt&&(a>Yt||void 0===o.velocity)){var A=e.deltaX-o.deltaX,c=e.deltaY-o.deltaY,h=R(a,A,c);i=h.x,r=h.y,n=yt(h.x)>yt(h.y)?h.x:h.y,s=_(A,c),t.lastInterval=e}else n=o.velocity,i=o.velocityX,r=o.velocityY,s=o.direction;e.velocity=n,e.velocityX=i,e.velocityY=r,e.direction=s}function O(t){for(var e=[],n=0;n<t.pointers.length;)e[n]={clientX:gt(t.pointers[n].clientX),clientY:gt(t.pointers[n].clientY)},n++;return{timeStamp:Tt(),pointers:e,center:N(e),deltaX:t.deltaX,deltaY:t.deltaY}}function N(t){var e=t.length;if(1===e)return{x:gt(t[0].clientX),y:gt(t[0].clientY)};for(var n=0,i=0,r=0;r<e;)n+=t[r].clientX,i+=t[r].clientY,r++;return{x:gt(n/e),y:gt(i/e)}}function R(t,e,n){return{x:e/t||0,y:n/t||0}}function _(t,e){return t===e?_t:yt(t)>=yt(e)?0>t?Qt:jt:0>e?zt:Xt}function Q(t,e,n){n||(n=Lt);var i=e[n[0]]-t[n[0]],r=e[n[1]]-t[n[1]];return Math.sqrt(i*i+r*r)}function j(t,e,n){n||(n=Lt);var i=e[n[0]]-t[n[0]],r=e[n[1]]-t[n[1]];return 180*Math.atan2(r,i)/Math.PI}function z(t,e){return j(e[1],e[0],Gt)+j(t[1],t[0],Gt)}function X(t,e){return Q(e[0],e[1],Gt)/Q(t[0],t[1],Gt)}function k(){this.evEl=Ht,this.evWin=qt,this.pressed=!1,I.apply(this,arguments)}function B(){this.evEl=Kt,this.evWin=Vt,I.apply(this,arguments),this.store=this.manager.session.pointerEvents=[]}function F(){this.evTarget=$t,this.evWin=te,this.started=!1,I.apply(this,arguments)}function L(t,e){var n=E(t.touches),i=E(t.changedTouches);return e&(Nt|Rt)&&(n=w(n.concat(i),"identifier",!0)),[n,i]}function G(){this.evTarget=ne,this.targetIds={},I.apply(this,arguments)}function W(t,e){var n=E(t.touches),i=this.targetIds;if(e&(Mt|Ot)&&1===n.length)return i[n[0].identifier]=!0,[n,n];var r,s,o=E(t.changedTouches),a=[],A=this.target;if(s=n.filter(function(t){return m(t.target,A)}),e===Mt)for(r=0;r<s.length;)i[s[r].identifier]=!0,r++;for(r=0;r<o.length;)i[o[r].identifier]&&a.push(o[r]),e&(Nt|Rt)&&delete i[o[r].identifier],r++;return a.length?[w(s.concat(a),"identifier",!0),a]:void 0}function H(){I.apply(this,arguments);var t=l(this.handler,this);this.touch=new G(this.manager,t),this.mouse=new k(this.manager,t),this.primaryTouch=null,this.lastTouches=[]}function q(t,e){t&Mt?(this.primaryTouch=e.changedPointers[0].identifier,U.call(this,e)):t&(Nt|Rt)&&U.call(this,e)}function U(t){var e=t.changedPointers[0];if(e.identifier===this.primaryTouch){var n={x:e.clientX,y:e.clientY};this.lastTouches.push(n);var i=this.lastTouches,r=function(){var t=i.indexOf(n);-1<t&&i.splice(t,1)};setTimeout(r,ie)}}function J(t){for(var e=t.srcEvent.clientX,n=t.srcEvent.clientY,i=0;i<this.lastTouches.length;i++){var r=this.lastTouches[i],s=ft(e-r.x),o=ft(n-r.y);if(s<=re&&o<=re)return!0}return!1}function K(t,e){this.manager=t,this.set(e)}function V(t){if(g(t,he))return he;var e=g(t,ue),n=g(t,le);return e&&n?he:e||n?e?ue:le:g(t,ce)?ce:Ae}function Z(t){this.options=pt({},this.defaults,t||{}),this.id=b(),this.manager=null,this.options.enable=f(this.options.enable,!0),this.state=fe,this.simultaneous={},this.requireFail=[]}function $(t){return t&ye?"cancel":t&me?"end":t&ve?"move":t&de?"start":""}function tt(t){return t==Xt?"down":t==zt?"up":t==Qt?"left":t==jt?"right":""}function et(t,e){var n=e.manager;return n?n.get(t):t}function nt(){Z.apply(this,arguments)}function it(){nt.apply(this,arguments),this.pX=null,this.pY=null}function rt(){nt.apply(this,arguments)}function st(){Z.apply(this,arguments),this._timer=null,this._input=null}function ot(){nt.apply(this,arguments)}function at(){nt.apply(this,arguments)}function At(){Z.apply(this,arguments),this.pTime=!1,this.pCenter=!1,this._timer=null,this._input=null,this.count=0}function ct(t,e){return e=e||{},e.recognizers=f(e.recognizers,ct.defaults.preset),new ht(t,e)}function ht(t,e){this.options=pt({},ct.defaults,e||{}),this.options.inputTarget=this.options.inputTarget||t,this.handlers={},this.session={},this.recognizers=[],this.oldCssProps={},this.element=t,this.input=x(this),this.touchAction=new K(this,this.options.touchAction),ut(this,!0),c(this.options.recognizers,function(t){var e=this.add(new t[0](t[1]));t[2]&&e.recognizeWith(t[2]),t[3]&&e.requireFailure(t[3])},this)}function ut(t,e){var n=t.element;if(n.style){var i;c(t.options.cssProps,function(r,s){i=C(n.style,s),e?(t.oldCssProps[i]=n.style[i],n.style[i]=r):n.style[i]=t.oldCssProps[i]||""}),e||(t.oldCssProps={})}}function lt(t,e){var n=s.createEvent("Event");n.initEvent(t,!0,!0),n.gesture=e,e.target.dispatchEvent(n)}var pt,ft=Math.abs,dt=["","webkit","Moz","MS","ms","o"],vt=s.createElement("div"),mt="function",gt=Math.round,yt=ft,Tt=Date.now;pt="function"==typeof Object.assign?Object.assign:function(t){if(void 0===t||null===t)throw new TypeError("Cannot convert undefined or null to object");for(var e,n=Object(t),i=1;i<arguments.length;i++)if(void 0!==(e=arguments[i])&&null!==e)for(var r in e)e.hasOwnProperty(r)&&(n[r]=e[r]);return n};var Et=h(function(t,e,n){for(var i=Object.keys(e),r=0;r<i.length;)(!n||n&&void 0===t[i[r]])&&(t[i[r]]=e[i[r]]),r++;return t},"extend","Use `assign`."),wt=h(function(t,e){return Et(t,e,!0)},"merge","Use `assign`."),Ct=1,bt=/mobile|tablet|ip(ad|hone|od)|android/i,Dt="ontouchstart"in r,It=void 0!==C(r,"PointerEvent"),xt=Dt&&bt.test(navigator.userAgent),Pt="touch",St="mouse",Yt=25,Mt=1,Ot=2,Nt=4,Rt=8,_t=1,Qt=2,jt=4,zt=8,Xt=16,kt=Qt|jt,Bt=zt|Xt,Ft=kt|Bt,Lt=["x","y"],Gt=["clientX","clientY"];I.prototype={handler:function(){},init:function(){this.evEl&&d(this.element,this.evEl,this.domHandler),this.evTarget&&d(this.target,this.evTarget,this.domHandler),this.evWin&&d(D(this.element),this.evWin,this.domHandler)},destroy:function(){this.evEl&&v(this.element,this.evEl,this.domHandler),this.evTarget&&v(this.target,this.evTarget,this.domHandler),this.evWin&&v(D(this.element),this.evWin,this.domHandler)}};var Wt={mousedown:Mt,mousemove:Ot,mouseup:Nt},Ht="mousedown",qt="mousemove mouseup";u(k,I,{handler:function(t){var e=Wt[t.type];e&Mt&&0===t.button&&(this.pressed=!0),e&Ot&&1!==t.which&&(e=Nt),this.pressed&&(e&Nt&&(this.pressed=!1),this.callback(this.manager,e,{pointers:[t],changedPointers:[t],pointerType:St,srcEvent:t}))}});var Ut={pointerdown:Mt,pointermove:Ot,pointerup:Nt,pointercancel:Rt,pointerout:Rt},Jt={2:Pt,3:"pen",4:St,5:"kinect"},Kt="pointerdown",Vt="pointermove pointerup pointercancel";r.MSPointerEvent&&!r.PointerEvent&&(Kt="MSPointerDown",Vt="MSPointerMove MSPointerUp MSPointerCancel"),u(B,I,{handler:function(t){var e=this.store,n=!1,i=t.type.toLowerCase().replace("ms",""),r=Ut[i],s=Jt[t.pointerType]||t.pointerType,o=T(e,t.pointerId,"pointerId");r&Mt&&(0===t.button||s==Pt)?0>o&&(e.push(t),o=e.length-1):r&(Nt|Rt)&&(n=!0),0>o||(e[o]=t,this.callback(this.manager,r,{pointers:e,changedPointers:[t],pointerType:s,srcEvent:t}),n&&e.splice(o,1))}});var Zt={touchstart:Mt,touchmove:Ot,touchend:Nt,touchcancel:Rt},$t="touchstart",te="touchstart touchmove touchend touchcancel";u(F,I,{handler:function(t){var e=Zt[t.type];if(e===Mt&&(this.started=!0),!!this.started){var n=L.call(this,t,e);e&(Nt|Rt)&&0==n[0].length-n[1].length&&(this.started=!1),this.callback(this.manager,e,{pointers:n[0],changedPointers:n[1],pointerType:Pt,srcEvent:t})}}});var ee={touchstart:Mt,touchmove:Ot,touchend:Nt,touchcancel:Rt},ne="touchstart touchmove touchend touchcancel";u(G,I,{handler:function(t){var e=ee[t.type],n=W.call(this,t,e);n&&this.callback(this.manager,e,{pointers:n[0],changedPointers:n[1],pointerType:Pt,srcEvent:t})}});var ie=2500,re=25;u(H,I,{handler:function(t,e,n){var i=n.pointerType==Pt,r=n.pointerType==St;if(!(r&&n.sourceCapabilities&&n.sourceCapabilities.firesTouchEvents)){if(i)q.call(this,e,n);else if(r&&J.call(this,n))return;this.callback(t,e,n)}},destroy:function(){this.touch.destroy(),this.mouse.destroy()}});var se=C(vt.style,"touchAction"),oe=void 0!==se,ae="compute",Ae="auto",ce="manipulation",he="none",ue="pan-x",le="pan-y",pe=function(){if(!oe)return!1;var t={},e=r.CSS&&r.CSS.supports;return["auto","manipulation","pan-y","pan-x","pan-x pan-y","none"].forEach(function(n){t[n]=!e||r.CSS.supports("touch-action",n)}),t}();K.prototype={set:function(t){t==ae&&(t=this.compute()),oe&&this.manager.element.style&&pe[t]&&(this.manager.element.style[se]=t),this.actions=t.toLowerCase().trim()},update:function(){this.set(this.manager.options.touchAction)},compute:function(){var t=[];return c(this.manager.recognizers,function(e){p(e.options.enable,[e])&&(t=t.concat(e.getTouchAction()))}),V(t.join(" "))},preventDefaults:function(t){var e=t.srcEvent,n=t.offsetDirection;if(this.manager.session.prevented)return void e.preventDefault();var i=this.actions,r=g(i,he)&&!pe[he],s=g(i,le)&&!pe[le],o=g(i,ue)&&!pe[ue];if(r){var a=1===t.pointers.length,A=2>t.distance,c=250>t.deltaTime;if(a&&A&&c)return}return o&&s?void 0:r||s&&n&kt||o&&n&Bt?this.preventSrc(e):void 0},preventSrc:function(t){this.manager.session.prevented=!0,t.preventDefault()}};var fe=1,de=2,ve=4,me=8,ge=me,ye=16;Z.prototype={defaults:{},set:function(t){return pt(this.options,t),this.manager&&this.manager.touchAction.update(),this},recognizeWith:function(t){if(A(t,"recognizeWith",this))return this;var e=this.simultaneous;return t=et(t,this),e[t.id]||(e[t.id]=t,t.recognizeWith(this)),this},dropRecognizeWith:function(t){return A(t,"dropRecognizeWith",this)?this:(t=et(t,this),delete this.simultaneous[t.id],this)},requireFailure:function(t){if(A(t,"requireFailure",this))return this;var e=this.requireFail;return t=et(t,this),-1===T(e,t)&&(e.push(t),t.requireFailure(this)),this},dropRequireFailure:function(t){if(A(t,"dropRequireFailure",this))return this;t=et(t,this);var e=T(this.requireFail,t);return-1<e&&this.requireFail.splice(e,1),this},hasRequireFailures:function(){return 0<this.requireFail.length},canRecognizeWith:function(t){return!!this.simultaneous[t.id]},emit:function(t){function e(e){n.manager.emit(e,t)}var n=this,i=this.state;i<me&&e(n.options.event+$(i)),e(n.options.event),t.additionalEvent&&e(t.additionalEvent),i>=me&&e(n.options.event+$(i))},tryEmit:function(t){return this.canEmit()?this.emit(t):void(this.state=32)},canEmit:function(){for(var t=0;t<this.requireFail.length;){if(!(this.requireFail[t].state&(32|fe)))return!1;t++}return!0},recognize:function(t){var e=pt({},t);return p(this.options.enable,[this,e])?(this.state&(ge|ye|32)&&(this.state=fe),this.state=this.process(e),void(this.state&(de|ve|me|ye)&&this.tryEmit(e))):(this.reset(),void(this.state=32))},process:function(){},getTouchAction:function(){},reset:function(){}},u(nt,Z,{defaults:{pointers:1},attrTest:function(t){var e=this.options.pointers;return 0===e||t.pointers.length===e},process:function(t){var e=this.state,n=t.eventType,i=e&(de|ve),r=this.attrTest(t);return i&&(n&Rt||!r)?e|ye:i||r?n&Nt?e|me:e&de?e|ve:de:32}}),u(it,nt,{defaults:{event:"pan",threshold:10,pointers:1,direction:Ft},getTouchAction:function(){var t=this.options.direction,e=[];return t&kt&&e.push(le),t&Bt&&e.push(ue),e},directionTest:function(t){var e=this.options,n=!0,i=t.distance,r=t.direction,s=t.deltaX,o=t.deltaY;return r&e.direction||(e.direction&kt?(r=0===s?_t:0>s?Qt:jt,n=s!=this.pX,i=ft(t.deltaX)):(r=0===o?_t:0>o?zt:Xt,n=o!=this.pY,i=ft(t.deltaY))),t.direction=r,n&&i>e.threshold&&r&e.direction},attrTest:function(t){return nt.prototype.attrTest.call(this,t)&&(this.state&de||!(this.state&de)&&this.directionTest(t))},emit:function(t){this.pX=t.deltaX,this.pY=t.deltaY;var e=tt(t.direction);e&&(t.additionalEvent=this.options.event+e),this._super.emit.call(this,t)}}),u(rt,nt,{defaults:{event:"pinch",threshold:0,pointers:2},getTouchAction:function(){return[he]},attrTest:function(t){return this._super.attrTest.call(this,t)&&(ft(t.scale-1)>this.options.threshold||this.state&de)},emit:function(t){if(1!==t.scale){var e=1>t.scale?"in":"out";t.additionalEvent=this.options.event+e}this._super.emit.call(this,t)}}),u(st,Z,{defaults:{event:"press",pointers:1,time:251,threshold:9},getTouchAction:function(){return[Ae]},process:function(t){var e=this.options,n=t.pointers.length===e.pointers,i=t.distance<e.threshold,r=t.deltaTime>e.time;if(this._input=t,!i||!n||t.eventType&(Nt|Rt)&&!r)this.reset();else if(t.eventType&Mt)this.reset(),this._timer=a(function(){this.state=ge,this.tryEmit()},e.time,this);else if(t.eventType&Nt)return ge;return 32},reset:function(){clearTimeout(this._timer)},emit:function(t){this.state!==ge||(t&&t.eventType&Nt?this.manager.emit(this.options.event+"up",t):(this._input.timeStamp=Tt(),this.manager.emit(this.options.event,this._input)))}}),u(ot,nt,{defaults:{event:"rotate",threshold:0,pointers:2},getTouchAction:function(){return[he]},attrTest:function(t){return this._super.attrTest.call(this,t)&&(ft(t.rotation)>this.options.threshold||this.state&de)}}),u(at,nt,{defaults:{event:"swipe",threshold:10,velocity:.3,direction:kt|Bt,pointers:1},getTouchAction:function(){return it.prototype.getTouchAction.call(this)},attrTest:function(t){var e,n=this.options.direction;return n&(kt|Bt)?e=t.overallVelocity:n&kt?e=t.overallVelocityX:n&Bt&&(e=t.overallVelocityY),this._super.attrTest.call(this,t)&&n&t.offsetDirection&&t.distance>this.options.threshold&&t.maxPointers==this.options.pointers&&yt(e)>this.options.velocity&&t.eventType&Nt},emit:function(t){var e=tt(t.offsetDirection);e&&this.manager.emit(this.options.event+e,t),this.manager.emit(this.options.event,t)}}),u(At,Z,{defaults:{event:"tap",pointers:1,taps:1,interval:300,time:250,threshold:9,posThreshold:10},getTouchAction:function(){return[ce]},process:function(t){var e=this.options,n=t.pointers.length===e.pointers,i=t.distance<e.threshold,r=t.deltaTime<e.time;if(this.reset(),t.eventType&Mt&&0===this.count)return this.failTimeout();if(i&&r&&n){if(t.eventType!=Nt)return this.failTimeout();var s=!this.pTime||t.timeStamp-this.pTime<e.interval,o=!this.pCenter||Q(this.pCenter,t.center)<e.posThreshold;this.pTime=t.timeStamp,this.pCenter=t.center,o&&s?this.count+=1:this.count=1,this._input=t;if(0==this.count%e.taps)return this.hasRequireFailures()?(this._timer=a(function(){this.state=ge,this.tryEmit()},e.interval,this),de):ge}return 32},failTimeout:function(){return this._timer=a(function(){this.state=32},this.options.interval,this),32},reset:function(){clearTimeout(this._timer)},emit:function(){this.state==ge&&(this._input.tapCount=this.count,this.manager.emit(this.options.event,this._input))}}),ct.VERSION="2.0.7",ct.defaults={domEvents:!1,touchAction:ae,enable:!0,inputTarget:null,inputClass:null,preset:[[ot,{enable:!1}],[rt,{enable:!1},["rotate"]],[at,{direction:kt}],[it,{direction:kt},["swipe"]],[At],[At,{event:"doubletap",taps:2},["tap"]],[st]],cssProps:{userSelect:"none",touchSelect:"none",touchCallout:"none",contentZooming:"none",userDrag:"none",tapHighlightColor:"rgba(0,0,0,0)"}};ht.prototype={set:function(t){return pt(this.options,t),t.touchAction&&this.touchAction.update(),t.inputTarget&&(this.input.destroy(),this.input.target=t.inputTarget,this.input.init()),this},stop:function(t){this.session.stopped=t?2:1},recognize:function(t){var e=this.session;if(!e.stopped){this.touchAction.preventDefaults(t);var n,i=this.recognizers,r=e.curRecognizer;(!r||r&&r.state&ge)&&(r=e.curRecognizer=null);for(var s=0;s<i.length;)n=i[s],2===e.stopped||r&&n!=r&&!n.canRecognizeWith(r)?n.reset():n.recognize(t),!r&&n.state&(de|ve|me)&&(r=e.curRecognizer=n),s++}},get:function(t){if(t instanceof Z)return t;for(var e=this.recognizers,n=0;n<e.length;n++)if(e[n].options.event==t)return e[n];return null},add:function(t){if(A(t,"add",this))return this;var e=this.get(t.options.event);return e&&this.remove(e),this.recognizers.push(t),t.manager=this,this.touchAction.update(),t},remove:function(t){if(A(t,"remove",this))return this;if(t=this.get(t)){var e=this.recognizers,n=T(e,t);-1!==n&&(e.splice(n,1),this.touchAction.update())}return this},on:function(t,e){if(void 0!==t&&void 0!==e){var n=this.handlers;return c(y(t),function(t){n[t]=n[t]||[],n[t].push(e)}),this}},off:function(t,e){if(void 0!==t){var n=this.handlers;return c(y(t),function(t){e?n[t]&&n[t].splice(T(n[t],e),1):delete n[t]}),this}},emit:function(t,e){this.options.domEvents&&lt(t,e);var n=this.handlers[t]&&this.handlers[t].slice();if(n&&n.length){e.type=t,e.preventDefault=function(){e.srcEvent.preventDefault()};for(var i=0;i<n.length;)n[i](e),i++}},destroy:function(){this.element&&ut(this,!1),this.handlers={},this.session={},this.input.destroy(),this.element=null}},pt(ct,{INPUT_START:Mt,INPUT_MOVE:Ot,INPUT_END:Nt,INPUT_CANCEL:Rt,STATE_POSSIBLE:fe,STATE_BEGAN:de,STATE_CHANGED:ve,STATE_ENDED:me,STATE_RECOGNIZED:ge,STATE_CANCELLED:ye,STATE_FAILED:32,DIRECTION_NONE:_t,DIRECTION_LEFT:Qt,DIRECTION_RIGHT:jt,DIRECTION_UP:zt,DIRECTION_DOWN:Xt,DIRECTION_HORIZONTAL:kt,DIRECTION_VERTICAL:Bt,DIRECTION_ALL:Ft,Manager:ht,Input:I,TouchAction:K,TouchInput:G,MouseInput:k,PointerEventInput:B,TouchMouseInput:H,SingleTouchInput:F,Recognizer:Z,AttrRecognizer:nt,Tap:At,Pan:it,Swipe:at,Pinch:rt,Rotate:ot,Press:st,on:d,off:v,each:c,merge:wt,extend:Et,assign:pt,inherit:u,bindFn:l,prefixed:C}),(void 0===r?"undefined"==typeof self?{}:self:r).Hammer=ct,void 0!==(i=function(){return ct}.call(e,n,e,t))&&(t.exports=i)}(window,document)}});