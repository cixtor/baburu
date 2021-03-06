//
//  PreferencesWindow.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var hostname: NSTextField!
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSTextField!
    @IBOutlet weak var interval: NSTextField!
    @IBOutlet weak var txtlabel: NSTextField!

    var delegate: PreferencesWindowDelegate?

    override var windowNibName: NSNib.Name? {
        return "PreferencesWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        let defaults = UserDefaults.standard
        hostname.stringValue = defaults.string(forKey: "hostname") ?? DEFAULT_HOSTNAME
        username.stringValue = defaults.string(forKey: "username") ?? DEFAULT_USERNAME
        password.stringValue = defaults.string(forKey: "password") ?? DEFAULT_PASSWORD
        interval.stringValue = defaults.string(forKey: "interval") ?? DEFAULT_INTERVAL
    }

    @IBAction func clickedSave(_ sender: NSButton) {
        print("Save preferences")
        self.window?.close()
    }

    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(hostname.stringValue, forKey: "hostname")
        defaults.setValue(username.stringValue, forKey: "username")
        defaults.setValue(password.stringValue, forKey: "password")
        defaults.setValue(interval.doubleValue, forKey: "interval")
        delegate?.preferencesDidUpdate()
    }
}
