/*!
 * @author electricessence / https://github.com/electricessence/
 * Licensing: MIT https://github.com/electricessence/TypeScript.NET/blob/master/LICENSE.md
 */
!function(e){if("object"==typeof module&&"object"==typeof module.exports){var t=e(require,exports);void 0!==t&&(module.exports=t)}else"function"==typeof define&&define.amd&&define(["require","exports","../Collections/Array/Utility","../Utility/shallowCopy","../Disposable/DisposableBase","../Disposable/dispose","./EventDispatcherEntry","../../extends"],e)}(function(e,t){"use strict";function i(){var e=this.params;e.dispatcher.removeEntry(this),e.dispatcher=null}var r=e("../Collections/Array/Utility"),n=e("../Utility/shallowCopy"),s=e("../Disposable/DisposableBase"),o=e("../Disposable/dispose"),p=e("./EventDispatcherEntry"),a=e("../../extends"),c=a["default"],u="disposing",l="disposed",f=function(e){function t(){e.apply(this,arguments),this._isDisposing=!1}return c(t,e),t.prototype.addEventListener=function(e,t,r){void 0===r&&(r=0);var n=this._entries;n||(this._entries=n=[]),n.push(new p.EventDispatcherEntry(e,t,{priority:r||0,dispatcher:this},i))},t.prototype.removeEntry=function(e){return!!this._entries&&0!=r.remove(this._entries,e)},t.prototype.registerEventListener=function(e,t,i){void 0===i&&(i=0),this.hasEventListener(e,t)||this.addEventListener(e,t,i)},t.prototype.hasEventListener=function(e,t){var i=this._entries;return i&&i.some(function(i){return e==i.type&&(!t||t==i.listener)})},t.prototype.removeEventListener=function(e,t){o.dispose.these(this._entries.filter(function(i){return i.matches(e,t)}))},t.prototype.dispatchEvent=function(e,t){var i=this,r=this,s=r._entries;if(!s||!s.length)return!1;var o;"string"==typeof e?(o=Event&&Object.create(Event)||{},t||(t={}),t.cancellable&&(o.cancellable=!0),o.target=r,o.type=e):o=e;var p=o.type,a=s.filter(function(e){return e.type==p});return a.length?(a.sort(function(e,t){return t.params.priority-e.params.priority}),a.forEach(function(e){var t=Object.create(Event);n.shallowCopy(o,t),t.target=i,e.dispatch(t)}),!0):!1},Object.defineProperty(t,"DISPOSING",{get:function(){return u},enumerable:!0,configurable:!0}),Object.defineProperty(t,"DISPOSED",{get:function(){return l},enumerable:!0,configurable:!0}),Object.defineProperty(t.prototype,"isDisposing",{get:function(){return this._isDisposing},enumerable:!0,configurable:!0}),t.prototype.dispose=function(){var t=this;if(!t.wasDisposed&&!t._isDisposing){t._isDisposing=!0,t.dispatchEvent(u),e.prototype.dispose.call(this),t.dispatchEvent(l);var i=t._entries;i&&(this._entries=null,i.forEach(function(e){return e.dispose()}))}},t}(s.DisposableBase);Object.defineProperty(t,"__esModule",{value:!0}),t["default"]=f});
//# sourceMappingURL=EventDispatcherBase.js.map
