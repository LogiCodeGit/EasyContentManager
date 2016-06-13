/// <reference path="../BaseObjects.ts"/>
//
// Kendo UI DataSource with Typescript
// http://docs.telerik.com/kendo-ui/typescript
// http://docs.telerik.com/kendo-ui/framework/datasource/overview
/* /// <reference path="../../typings/kendo/kendo.custom.d.ts" /> */
//import * as _oo from '../BaseObjects'
//import '../BaseObjects'
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", 'ooLib/BaseObjects'], function (require, exports, BaseObjects_1) {
    "use strict";
    //namespace ooLib {
    var Connections;
    (function (Connections) {
        /**
        * Define shortcut alias
        */
        var _objs = BaseObjects_1.BaseObjects;
        /**
        * @description Data connection component
        */
        var Connection = (function (_super) {
            __extends(Connection, _super);
            //
            /**
            * @description Connection constructor
            * @param {typeConnection} type of connection
            * @param {stging} cnnstr is the connection string for the specific type
            */
            function Connection(type, cnnStr, description) {
                _super.call(this, description);
                this._type = type;
                this._cnnStr = cnnStr;
            }
            return Connection;
        }(_objs.Connection));
        Connections.Connection = Connection;
    })(Connections = exports.Connections || (exports.Connections = {}));
});
//}
//declare namespace ooLib {
//    export namespace Connections { }
//}
//# sourceMappingURL=Connection.js.map