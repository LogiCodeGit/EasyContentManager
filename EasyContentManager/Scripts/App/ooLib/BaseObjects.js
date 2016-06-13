var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", 'ooLib/Globals'], function (require, exports, Globals_1) {
    "use strict";
    /**
    *    Base classes for all library components
    */
    var BaseObjects;
    (function (BaseObjects) {
        //module BaseObjects {
        /**
        * Define shortcut alias
        */
        var _typs = Globals_1.Types; //ooLib.Types;      // http://www.typescriptlang.org/Handbook#modules-alias
        /**
        * Base class for all components
        */
        var Component = (function () {
            function Component(type, description) {
                this._types = 0;
                this._descriptions = [];
                this._types |= type.valueOf();
                if (description)
                    this._descriptions.push(description);
            }
            /** Return true if the component is of the specified type
            */
            Component.prototype.isType = function (type) {
                return (this._types & type.valueOf()) != 0;
            };
            /** Return the component description/s
            */
            Component.prototype.getDescription = function () {
                return this._descriptions;
            };
            return Component;
        }());
        BaseObjects.Component = Component;
        /** Base class for variable components
        */
        var Variable = (function (_super) {
            __extends(Variable, _super);
            function Variable(description) {
                _super.call(this, _typs.Object.Variable, description);
            }
            return Variable;
        }(Component));
        BaseObjects.Variable = Variable;
        /** Base class for constant components
        */
        var Constant = (function (_super) {
            __extends(Constant, _super);
            function Constant(description) {
                _super.call(this, _typs.Object.Constant, description);
            }
            return Constant;
        }(Component));
        BaseObjects.Constant = Constant;
        /** Base class for semaphore components
        */
        var Semaphore = (function (_super) {
            __extends(Semaphore, _super);
            function Semaphore(description) {
                _super.call(this, _typs.Object.Semaphore, description);
            }
            return Semaphore;
        }(Component));
        BaseObjects.Semaphore = Semaphore;
        /** Base class for function components
        */
        var Function = (function (_super) {
            __extends(Function, _super);
            function Function(description) {
                _super.call(this, _typs.Object.Function, description);
            }
            return Function;
        }(Component));
        BaseObjects.Function = Function;
        /** Base class for bheavhior components
        */
        var Behavior = (function (_super) {
            __extends(Behavior, _super);
            function Behavior(description) {
                _super.call(this, _typs.Object.Behavior, description);
            }
            return Behavior;
        }(Component));
        BaseObjects.Behavior = Behavior;
        /** Base class for data components
        */
        var Data = (function (_super) {
            __extends(Data, _super);
            function Data(description) {
                _super.call(this, _typs.Object.Data, description);
            }
            return Data;
        }(Component));
        BaseObjects.Data = Data;
        /** Base class for connection components
        */
        var Connection = (function (_super) {
            __extends(Connection, _super);
            function Connection(description) {
                _super.call(this, _typs.Object.Connection, description);
            }
            return Connection;
        }(Component));
        BaseObjects.Connection = Connection;
        /** Base class for binding components
        */
        var Binding = (function (_super) {
            __extends(Binding, _super);
            function Binding(description) {
                _super.call(this, _typs.Object.Binding, description);
            }
            return Binding;
        }(Component));
        BaseObjects.Binding = Binding;
        /** Base class for presentation components
        */
        var Presentation = (function (_super) {
            __extends(Presentation, _super);
            function Presentation(description) {
                _super.call(this, _typs.Object.Presentation, description);
            }
            return Presentation;
        }(Component));
        BaseObjects.Presentation = Presentation;
        /** Base class for hardware I/O components
        */
        var HardwareIO = (function (_super) {
            __extends(HardwareIO, _super);
            function HardwareIO(description) {
                _super.call(this, _typs.Object.HardwareIO, description);
            }
            return HardwareIO;
        }(Component));
        BaseObjects.HardwareIO = HardwareIO;
    })(BaseObjects = exports.BaseObjects || (exports.BaseObjects = {}));
});
//# sourceMappingURL=BaseObjects.js.map