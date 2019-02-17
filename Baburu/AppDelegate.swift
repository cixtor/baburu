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

    // Menu Bar Extras
    //
    // A menu bar extra exposes app-specific functionality via an icon that
    // appears in the menu bar when your app is running, even when it’s not the
    // frontmost app. Menu bar extras are on the opposite side of the menu bar
    // from your app's menus. The system hides menu bar extras to make room for
    // app menus. Similarly, if there are too many menu bar extras, the system
    // may hide some to avoid crowding app menus.
    //
    // https://developer.apple.com/design/human-interface-guidelines/macos/extensions/menu-bar-extras/
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let statusBar = NSStatusBar.system

        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)

        statusItem.button?.title = "🔔"

        let menu = NSMenu(title: "Menu")
        menu.addItem(withTitle: "Preferences", action: #selector(AppDelegate.preferences), keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "")
        statusItem.menu = menu
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

