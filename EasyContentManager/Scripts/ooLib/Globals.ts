/**
* Global module for base constants & definitions
*/
export namespace Types {

    /**
        @description Components base types
    */
    export enum Object {
        Variable = 1,           /* Identify Variable Components */
        Constant = 2,           /* Identify Constant Components */
        Semaphore = 4,          /* Identify Semaphore Components */
        Function = 8,           /* Identify Function Components */
        Behavior = 16,          /* Identify Behavior Components */
        Data = 32,              /* Identify Data Components */
        Connection = 64,        /* Identify Connection Components */
        Binding = 128,          /* Identify Binding Components */
        Presentation = 256,     /* Identify Presentation Components */
        HardwareIO = 512        /* Identify Hardware I/O Components */
    };

    /**
        * Connections types
        */
    export enum Connection {
        odata = 1               /* Identify connections with odata protocol, http://www.odata.org/ */
    };
}