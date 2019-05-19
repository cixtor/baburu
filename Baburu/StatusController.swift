//
//  StatusController.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Cocoa

class StatusController: NSObject, WebServiceDelegate, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!

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
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    // WebServiceClient allows the application to communicate with a web API.
    var client: WebServiceClient!

    var prefs: PreferencesWindow!

    override func awakeFromNib() {
        // Source: https://icons8.com/icon/20685/google-alerts
        statusItem.button?.image = NSImage(named: "StatusIcon")
        statusItem.button?.image?.isTemplate = true
        statusItem.menu = self.statusMenu

        client = WebServiceClient(delegate: self)
        client.start()

        prefs = PreferencesWindow()
        prefs.delegate = self
    }

    func webServiceDidUpdate(_ alert: Alert) {
        print("Fire user notification")
        let nt = NSUserNotification()

        nt.title = alert.title
        nt.subtitle = alert.subtitle
        nt.informativeText = alert.informativeText
        nt.soundName = NSUserNotificationDefaultSoundName
        nt.actionButtonTitle = "Close"
        nt.hasActionButton = true

        NSUserNotificationCenter.default.deliver(nt)
    }

    func preferencesDidUpdate() {
        print("Preferences did update")
        client.stop()
        client.start()
    }

    @IBAction func clickedRefresh(_ sender: NSMenuItem) {
        print("Force alert check")
        client.fetch()
    }

    @IBAction func clickedPreferences(_ sender: NSMenuItem) {
        print("Open preferences")
        prefs.showWindow(nil)
    }

    @IBAction func clickedQuit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
