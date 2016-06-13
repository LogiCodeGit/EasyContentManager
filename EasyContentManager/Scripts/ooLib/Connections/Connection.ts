/// <reference path="../BaseObjects.ts"/>
//
// Kendo UI DataSource with Typescript
// http://docs.telerik.com/kendo-ui/typescript
// http://docs.telerik.com/kendo-ui/framework/datasource/overview
/* /// <reference path="../../typings/kendo/kendo.custom.d.ts" /> */
//import * as _oo from '../BaseObjects'
//import '../BaseObjects'

//import ooLib = require('ooLib/Globals');
//import _base = require('ooLib/BaseObjects');
import {Types} from 'ooLib/Globals'
import {BaseObjects} from 'ooLib/BaseObjects'

//namespace ooLib {
    export namespace Connections {

        /**
        * Define shortcut alias
        */
        import _objs = BaseObjects;
        import _typs = Types;

        /**
        * @description Data connection component
        */
        export class Connection extends _objs.Connection {
            private _type: _typs.Connection;
            private _cnnStr: string;
            //
            /**
            * @description Connection constructor
            * @param {typeConnection} type of connection
            * @param {stging} cnnstr is the connection string for the specific type
            */
            constructor(type: _typs.Connection,
                cnnStr: string,
                description?: string) {
                super(description);
                this._type = type;
                this._cnnStr = cnnStr;
            }
        }
    }
//}

//declare namespace ooLib {
//    export namespace Connections { }
//}

