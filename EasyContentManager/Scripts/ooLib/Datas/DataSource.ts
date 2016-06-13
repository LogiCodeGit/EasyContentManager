// References for IntelliSense
/// <reference path="../BaseObjects.ts"/>
/// <reference path="../Connections/Connection.ts"/>
//
// Kendo UI DataSource with Typescript
// http://docs.telerik.com/kendo-ui/typescript
// http://docs.telerik.com/kendo-ui/framework/datasource/overview
/* /// <reference path="../../typings/kendo/kendo.custom.d.ts" /> */

//import ooLib = require('ooLib/BaseObjects');
import {BaseObjects} from 'ooLib/BaseObjects'
//
//namespace ooLib {
    export namespace Datas {

        /**
        * Define shortcut alias
        */
        import _objs = BaseObjects;     //ooLib.BaseObjects;

        /**
        * @description Data source component
        */
        class DataSource extends _objs.Data {

            // For OData implementation this component use Telerik Kendo UI Core
            // see  http://docs.telerik.com/kendo-ui/framework/datasource/basic-usage
            //      http://www.odata.org/
            //
            private _cnn: _objs.Connection;
            private _path: string;
            //
            /**
                * @description DataSource constructor
                * @param {Connection} cnn is Connection component
                * @param {string} dataPath is the data entity or path
                */
            constructor(cnn: _objs.Connection,
                dataPath: string,
                description?: string) {
                super(description);
                this._cnn = cnn;
            }
        }
    }
//}
//declare namespace ooLib {
//    export module Datas { }
//}

