//
//  AppDelegate.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var item : NSStatusItem? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        item?.button?.title = "🔔"

        let menu = NSMenu()
        menu.addItem(withTitle: "Preferences", action: #selector(AppDelegate.preferences), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "")
        item?.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func preferences() {
        print("Preferences")
    }

    @objc func quit() {
        NSApplication.shared.terminate(self)
    }

}

