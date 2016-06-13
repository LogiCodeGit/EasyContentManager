define(["require","exports","../Types","./Utility"],function(r,e,n,t){"use strict";function i(r,e,n){return void 0===n&&(n=d),n&&e>0?t.repeat(n,e-r.length)+r:r}function u(r,e,n){return void 0===n&&(n=d),n&&e>0?r+t.repeat(n,e-r.length):r}function o(r,e,u){if(void 0===u&&(u=s),!n.Type.isNumber(r))throw new Error("Cannot pad non-number.");return r||(r=0),i(r+t.EMPTY,e,u+t.EMPTY)}function p(r,e,i){if(void 0===i&&(i=s),!n.Type.isNumber(r))throw new Error("Cannot pad non-number.");return r||(r=0),u(r+t.EMPTY,e,i+t.EMPTY)}function f(r,e,t){if(n.Type.isString(r))return i(r,e,t);if(n.Type.isNumber(r))return o(r,e,t);throw new Error("Invalid source type.")}function a(r,e,t){if(n.Type.isString(r))return u(r,e,t);if(n.Type.isNumber(r))return p(r,e,t);throw new Error("Invalid source type.")}var d=" ",s="0";e.padStringLeft=i,e.padStringRight=u,e.padNumberLeft=o,e.padNumberRight=p,e.padLeft=f,e.padRight=a});
//# sourceMappingURL=Padding.js.map
