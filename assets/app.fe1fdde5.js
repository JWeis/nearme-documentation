webpackJsonp([0],{DOvA:function(a,b,c){"use strict";function d(){m.classList.add(k),m.addEventListener("keydown",g),m.addEventListener("click",e)}function f(){m.classList.remove(k),m.removeEventListener("keydown",g),m.removeEventListener("click",e)}function e(a){a.defaultPrevented||null===(0,h.closest)(a.target,l)&&f()}function g(a){a.defaultPrevented||27===a.keyCode&&(a.preventDefault(),f())}var h=c("XLKP"),i=c("rxKx"),j=function(a){return a&&a.__esModule?a:{default:a}}(i),k="nav-visible",l=".nav-section",m=(0,h.findElement)("body"),n=(0,h.findElement)(".masthead"),o=document.querySelector(l);o instanceof HTMLElement&&(function(a){var b=new j.default.Manager(a);b.add(new j.default.Swipe({direction:j.default.DIRECTION_LEFT,threshold:50})),b.on("swipe",function(a){a.direction===j.default.DIRECTION_LEFT&&f()})}(o),n.appendChild(function(){var a=document.createElement("button");return a.setAttribute("type","button"),a.classList.add("navigation-toggler"),a.innerHTML="Menu",a.addEventListener("click",function(a){a.preventDefault(),d()}),a}()))},Vp6e:function(){},XLKP:function(a){"use strict";a.exports.closest=function(a,b){var c=2<arguments.length&&void 0!==arguments[2]?arguments[2]:!0,d=a.matches||a.webkitMatchesSelector||a.mozMatchesSelector||a.msMatchesSelector;if(c&&d.call(a,b))return a;for(;a&&!d.call(a,b);)a=a.parentElement;return a},a.exports.findButton=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLButtonElement))throw new Error("Unable to locate "+a);return c},a.exports.findElement=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLElement))throw new Error("Unable to locate "+a);return c},a.exports.findInput=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLInputElement))throw new Error("Unable to locate "+a);return c},a.exports.findSelect=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLSelectElement))throw new Error("Unable to locate "+a);return c},a.exports.findTextArea=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLTextAreaElement))throw new Error("Unable to locate "+a);return c},a.exports.findForm=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLFormElement))throw new Error("Unable to locate "+a);return c},a.exports.findMeta=function(a){var b=1<arguments.length&&void 0!==arguments[1]?arguments[1]:document,c=b.querySelector(a);if(!(c instanceof HTMLMetaElement))throw new Error("Unable to locate "+a);return c}},vGYV:function(a,b,c){"use strict";c("Vp6e"),c("DOvA")}},["vGYV"]);
//# sourceMappingURL=app.fe1fdde5.js.map