//
//  main.swift
//  MaciASL
//
//  Created by SkyrilHD on 24.12.23.
//

import Cocoa

func handleException(_ exception: NSException) {
    let file = "/tmp/\(Date().timeIntervalSince1970).plist"
    var dictionary: [String: Any] = [:]
    if !exception.name.rawValue.isEmpty {
        dictionary["name"] = exception.name
    }
    if exception.reason != nil {
        dictionary["reason"] = exception.reason
    }
    if exception.userInfo != nil {
        dictionary["userInfo"] = exception.userInfo
    }
    if !exception.callStackReturnAddresses.isEmpty {
        dictionary["callStackReturnAddresses"] = exception.callStackReturnAddresses
    }
    if !exception.callStackSymbols.isEmpty {
        dictionary["callStackSymbols"] = exception.callStackSymbols
    }
    (dictionary as NSDictionary).write(toFile: file, atomically: true)

    let alert = NSAlert()
    alert.messageText = "Uncaught Exception"
    alert.informativeText = "An uncaught exception has occurred, and the program will now terminate. Please post the revealed file (may contain personal information), to http://github.com/acidanthera/bugtracker/issues"
    alert.alertStyle = .critical
    alert.runModal()

    NSWorkspace.shared.selectFile(file, inFileViewerRootedAtPath: file)
}

NSSetUncaughtExceptionHandler(handleException)
let coreTypes = Bundle(path: "/System/Library/CoreServices/CoreTypes.bundle")
let temp = NSOpenGLContext.instancesRespond(to: #selector(NSOpenGLContext.lock)) ? coreTypes?.image(forResource: "ToolbarCustomizeIcon") : coreTypes?.image(forResource: "ToolbarUtilitiesFolderIcon")
temp?.setName("ToolbarUtilitiesFolderIcon")

let argc = CommandLine.argc
let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>?.self, capacity: Int(CommandLine.argc))
_ = NSApplicationMain(argc, argv)
