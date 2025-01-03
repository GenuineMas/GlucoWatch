// Hook sandbox_check function
Interceptor.attach(Module.findExportByName(null, 'sandbox_check'), {
    onEnter: function (args) {
        let entitlement = args[1].readUtf8String();
        console.log('[*] Sandbox Check for Entitlement: ' + entitlement);

        // Detect SensorKit entitlement and bypass it
        if (entitlement === 'com.apple.developer.sensorkit.reader.allow') {
            console.log('[*] Found SensorKit entitlement check! Bypassing...');
            this.bypass = true;
        }
    },
    onLeave: function (retval) {
        if (this.bypass) {
            console.log('[*] Overriding sandbox_check result to allow access');
            retval.replace(0); // Return 0 (allowed)
        }
    }
});

// Hook _os_entitlement_check function
Interceptor.attach(Module.findExportByName(null, '_os_entitlement_check'), {
    onEnter: function (args) {
        let entitlement = args[0].readUtf8String();
        console.log('[*] Checking entitlement: ' + entitlement);

        // Detect SensorKit entitlement and allow it
        if (entitlement === 'com.apple.developer.sensorkit.reader.allow') {
            console.log('[*] Found SensorKit entitlement! Bypassing...');
            this.bypass = true;
        }
    },
    onLeave: function (retval) {
        if (this.bypass) {
            console.log('[*] Modifying _os_entitlement_check result to authorized');
            retval.replace(1); // Return true (authorized)
        }
    }
});
