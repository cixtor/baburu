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
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSTextField!

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
        username.stringValue = defaults.string(forKey: "username") ?? DEFAULT_USERNAME
        password.stringValue = defaults.string(forKey: "password") ?? DEFAULT_PASSWORD
    }

    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        defaults.setValue(username.stringValue, forKey: "username")
        defaults.setValue(password.stringValue, forKey: "password")
        delegate?.preferencesDidUpdate()
    }
}
