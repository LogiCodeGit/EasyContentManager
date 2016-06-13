define(["require", "exports"], function (require, exports) {
    "use strict";
    /**
   * Global module for base constants & definitions
   */
    var Types;
    (function (Types) {
        /**
            @description Components base types
        */
        (function (Object) {
            Object[Object["Variable"] = 1] = "Variable";
            Object[Object["Constant"] = 2] = "Constant";
            Object[Object["Semaphore"] = 4] = "Semaphore";
            Object[Object["Function"] = 8] = "Function";
            Object[Object["Behavior"] = 16] = "Behavior";
            Object[Object["Data"] = 32] = "Data";
            Object[Object["Connection"] = 64] = "Connection";
            Object[Object["Binding"] = 128] = "Binding";
            Object[Object["Presentation"] = 256] = "Presentation";
            Object[Object["HardwareIO"] = 512] = "HardwareIO"; /* Identify Hardware I/O Components */
        })(Types.Object || (Types.Object = {}));
        var Object = Types.Object;
        ;
        /**
            * Connections types
            */
        (function (Connection) {
            Connection[Connection["odata"] = 1] = "odata"; /* Identify connections with odata protocol, http://www.odata.org/ */
        })(Types.Connection || (Types.Connection = {}));
        var Connection = Types.Connection;
        ;
    })(Types = exports.Types || (exports.Types = {}));
});
//# sourceMappingURL=Globals.js.map