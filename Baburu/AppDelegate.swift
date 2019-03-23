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

    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func clickedQuit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func clickedPreferences(_ sender: NSMenuItem) {
        print("Open preferences")
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self

        self.startCheckingAlerts()
        self.drawMenuBarExtra()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    @objc func drawMenuBarExtra() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // Source: https://icons8.com/icon/20685/google-alerts
        statusItem.button?.image = NSImage(named: "StatusIcon")
        statusItem.button?.image?.isTemplate = true

        statusItem.menu = self.statusMenu
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

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://cixtor.com/ifconfig/post")!
        var req = URLRequest(url: url)

        req.httpMethod = "POST"

        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Xcode 11.1 (11A1027)", forHTTPHeaderField: "X-Powered-By")
        req.setValue("Mozilla/5.0 (KHTML, like Gecko) Safari/537.36", forHTTPHeaderField: "User-Agent")

        let json = ["username": "root", "password": "P455w0rd"]
        let input = try! JSONSerialization.data(withJSONObject: json, options: [])
        req.httpBody = input

        let task = session.dataTask(with: req) { data, response, error in
            guard error == nil else {
                self.handleClientError(error: error)
                return
            }

            guard let res = response as? HTTPURLResponse,
                (200...299).contains(res.statusCode) else {
                    self.handleServerError(response: response)
                    return
            }

            guard let mime = res.mimeType, mime == "application/json" else {
                print("invalid mime type")
                return
            }

            guard let content = data else {
                print("empty data")
                return
            }

            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("invalid json: \(content)")
                return
            }

            print("json: \(json)")
        }

        task.resume()
    }

    @objc func handleClientError(error: Error?) {
        print("client: \(error?.localizedDescription ?? "unknown")")
    }

    @objc func handleServerError(response: URLResponse?) {
        print("server: \(response?.mimeType ?? "unknown")")
    }
}

