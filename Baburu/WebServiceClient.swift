//
//  WebServiceClient.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Foundation

let DEFAULT_HOSTNAME: String = "https://baburu.test"
let DEFAULT_USERNAME: String = "foo"
let DEFAULT_PASSWORD: String = "bar"
let DEFAULT_INTERVAL: String = "20.0"

struct Alert {
    var title: String
    var subtitle: String
    var informativeText: String
}

protocol WebServiceDelegate {
    func webServiceDidUpdate(_ alert: Alert)
}

class WebServiceClient {
    var delegate: WebServiceDelegate?

    var timer: Timer = Timer()

    init(delegate: WebServiceDelegate) {
        self.delegate = delegate
    }

    func start() {
        let ti: TimeInterval = tickInterval()
        print("Start scheduled timer: \(ti)")
        self.timer = Timer.scheduledTimer(
            timeInterval: ti,
            target: self,
            selector: #selector(self.tick),
            userInfo: nil,
            repeats: true
        )

        self.timer.fire()
    }

    func stop() {
        print("Stop scheduled timer")
        self.timer.invalidate()
    }

    @objc func tick() {
        print("Tick scheduled timer")
        self.fetch()
    }

    func fetch() {
        print("Fetch service alerts")
        let defaults = UserDefaults.standard
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let hostname = defaults.string(forKey: "hostname") ?? DEFAULT_HOSTNAME
        let username = defaults.string(forKey: "username") ?? DEFAULT_USERNAME
        let password = defaults.string(forKey: "password") ?? DEFAULT_PASSWORD

        let url = URL(string: hostname+"/alerts")!
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let encodedLogin = loginData.base64EncodedString()

        req.setValue("Basic \(encodedLogin)", forHTTPHeaderField: "Authorization")
        req.setValue("Xcode 11.1 (11A1027)", forHTTPHeaderField: "X-Powered-By")
        req.setValue(self.uniqueUserID(), forHTTPHeaderField: "X-Unique-User-ID")
        req.setValue("Mozilla/5.0 (KHTML, like Gecko) Safari/537.36", forHTTPHeaderField: "User-Agent")

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

            if let alert = self.jsonData(content) {
                self.delegate?.webServiceDidUpdate(alert)
            }
        }

        task.resume()
    }

    func jsonData(_ data: Data) -> Alert? {
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? Alert else {
            print("invalid json: \(data)")
            return nil
        }

        return json
    }

    func tickInterval() -> TimeInterval {
        let defaults = UserDefaults.standard
        let interval = defaults.string(forKey: "interval") ?? DEFAULT_INTERVAL
        if let value = Double(interval) { return value }
        return Double(DEFAULT_INTERVAL)!
    }

    func uniqueUserID() -> String {
        let defaults = UserDefaults.standard
        if let uuid = defaults.string(forKey: "uuid") { return uuid }
        let uuid = UUID().uuidString
        defaults.setValue(uuid, forKey: "uuid")
        return uuid
    }

    @objc func handleClientError(error: Error?) {
        print("client: \(error?.localizedDescription ?? "unknown")")
    }

    @objc func handleServerError(response: URLResponse?) {
        print("server: \(response?.mimeType ?? "unknown")")
    }
}
