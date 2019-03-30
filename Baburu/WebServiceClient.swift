//
//  WebServiceClient.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Foundation

class WebServiceClient {
    func fetch() {
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
