//
//  InjectSK.swift
//  GlucoWatch
//
//  Created by Genuine on 24.12.2024.
//

//import Foundation
//import Frida
//
//// Hook a specific function
//let session = try! Frida_Private.attach(toProcessNamed: "targetApp")
//
//let script = """
//Interceptor.attach(Module.findExportByName(null, "targetFunction"), {
//    onEnter: function (args) {
//        console.log("Target function called with args: " + args[0].toInt32());
//    },
//    onLeave: function (retval) {
//        console.log("Original return value: " + retval.toInt32());
//        retval.replace(42); // Modify return value
//    }
//});
//"""
//
//session.createScript(withSource: script).load()
