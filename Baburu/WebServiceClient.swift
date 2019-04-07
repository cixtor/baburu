//
//  WebServiceClient.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Foundation

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

    init(delegate: WebServiceDelegate) {
        self.delegate = delegate
    }

    func fetch() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://baburu.test/alerts")!
        var req = URLRequest(url: url)

        req.httpMethod = "POST"

        let username = "root"
        let password = "P455w0rd"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let encodedLogin = loginData.base64EncodedString()

        req.setValue("Basic \(encodedLogin)", forHTTPHeaderField: "Authorization")
        req.setValue("Xcode 11.1 (11A1027)", forHTTPHeaderField: "X-Powered-By")
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
        typealias JSONDict = [String:AnyObject]

        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDict else {
            print("invalid json: \(data)")
            return nil
        }

        print("json: \(json)")

        return nil
    }

    @objc func handleClientError(error: Error?) {
        print("client: \(error?.localizedDescription ?? "unknown")")
    }

    @objc func handleServerError(response: URLResponse?) {
        print("server: \(response?.mimeType ?? "unknown")")
    }
}
