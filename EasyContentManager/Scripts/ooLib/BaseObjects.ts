// Reference for Intellisense and Import/s for dynamic module loading (see also requireModules.js)
//
// Include global definitions
/// <reference path="Globals.ts"/>
//** <amd-dependency path="ooLib/Globals"/>
import {Types} from 'ooLib/Globals'

/**
*    Base classes for all library components
*/
export namespace BaseObjects {
    //module BaseObjects {

    /**
    * Define shortcut alias
    */
    import _typs = Types;   //ooLib.Types;      // http://www.typescriptlang.org/Handbook#modules-alias

    /**
    * Base class for all components
    */
    export class Component {
        private _types: number = 0;
        private _descriptions: Array<string> = [];
        constructor(type: _typs.Object, description?: string) {
            this._types |= type.valueOf();
            if (description)
                this._descriptions.push(description);
        }

        /** Return true if the component is of the specified type
        */
        public isType(type: _typs.Object): boolean {
            return (this._types & type.valueOf()) != 0;
        }

        /** Return the component description/s
        */
        public getDescription(): Array<string> {
            return this._descriptions;
        }
    }

    /** Base class for variable components
    */
    export class Variable extends Component {
        constructor(description?: string) {
            super(_typs.Object.Variable, description);
        }
    }

    /** Base class for constant components
    */
    export class Constant extends Component {
        constructor(description?: string) {
            super(_typs.Object.Constant, description);
        }
    }

    /** Base class for semaphore components
    */
    export class Semaphore extends Component {
        constructor(description?: string) {
            super(_typs.Object.Semaphore, description);
        }
    }

    /** Base class for function components
    */
    export class Function extends Component {
        constructor(description?: string) {
            super(_typs.Object.Function, description);
        }
    }

    /** Base class for bheavhior components
    */
    export class Behavior extends Component {
        constructor(description?: string) {
            super(_typs.Object.Behavior, description);
        }

    }

    /** Base class for data components
    */
    export class Data extends Component {
        constructor(description?: string) {
            super(_typs.Object.Data, description);
        }
    }

    /** Base class for connection components
    */
    export class Connection extends Component {
        constructor(description?: string) {
            super(_typs.Object.Connection, description);
        }
    }

    /** Base class for binding components
    */
    export class Binding extends Component {
        constructor(description?: string) {
            super(_typs.Object.Binding, description);
        }
    }

    /** Base class for presentation components
    */
    export class Presentation extends Component {
        constructor(description?: string) {
            super(_typs.Object.Presentation, description);
        }
    }

    /** Base class for hardware I/O components
    */
    export class HardwareIO extends Component {
        constructor(description?: string) {
            super(_typs.Object.HardwareIO, description);
        }
    }
}
