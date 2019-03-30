//
//  AppDelegate.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    var timer: Timer = Timer()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSUserNotificationCenter.default.delegate = self

        self.startCheckingAlerts()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    @objc func startCheckingAlerts() {
        print("Start checking alerts")
        timer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(AppDelegate.checkAlerts),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func stopCheckingAlerts() {
        print("Stop checking alerts")
        timer.invalidate()
    }

    @objc func showAlert() {
        print("Show alert")

        let nt = NSUserNotification()

        nt.title = "Hello"
        nt.subtitle = "How are you?"
        nt.informativeText = "This is a very long text acting as the notification content."
        nt.soundName = NSUserNotificationDefaultSoundName
        nt.actionButtonTitle = "Close"
        nt.hasActionButton = true

        NSUserNotificationCenter.default.deliver(nt)
    }

    @objc func checkAlerts() {
        print("Check alerts")
    }
}

