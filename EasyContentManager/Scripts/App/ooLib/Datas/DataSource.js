// References for IntelliSense
/// <reference path="../BaseObjects.ts"/>
/// <reference path="../Connections/Connection.ts"/>
//
// Kendo UI DataSource with Typescript
// http://docs.telerik.com/kendo-ui/typescript
// http://docs.telerik.com/kendo-ui/framework/datasource/overview
/* /// <reference path="../../typings/kendo/kendo.custom.d.ts" /> */
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", 'ooLib/BaseObjects'], function (require, exports, BaseObjects_1) {
    "use strict";
    //
    //namespace ooLib {
    var Datas;
    (function (Datas) {
        /**
        * Define shortcut alias
        */
        var _objs = BaseObjects_1.BaseObjects; //ooLib.BaseObjects;
        /**
        * @description Data source component
        */
        var DataSource = (function (_super) {
            __extends(DataSource, _super);
            //
            /**
                * @description DataSource constructor
                * @param {Connection} cnn is Connection component
                * @param {string} dataPath is the data entity or path
                */
            function DataSource(cnn, dataPath, description) {
                _super.call(this, description);
                this._cnn = cnn;
            }
            return DataSource;
        }(_objs.Data));
    })(Datas = exports.Datas || (exports.Datas = {}));
});
//}
//declare namespace ooLib {
//    export module Datas { }
//}
//# sourceMappingURL=DataSource.js.map