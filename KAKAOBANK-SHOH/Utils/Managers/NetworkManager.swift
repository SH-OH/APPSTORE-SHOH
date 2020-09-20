//
//  NetworkManager.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/18.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation
import RxSwift
import UIKit.UIView

class NetworkManager {
    
    enum HTTPMethod {
        case get
        case post
    }
    
    enum Queue {
        static let defaultQueue: DispatchQueue = DispatchQueue(label: "queue.NetworkManager.default", qos: .utility)
        static let imageQueue: DispatchQueue = DispatchQueue(label: "queue.NetworkManager.imageCache", qos: .utility)
    }
    
    static let shared = NetworkManager()
    
    var timeout: Double = 20
    
    private(set) var session: URLSession
    
    private let cache: NSCache<NSString, UIImage> = .init()
    
    private init() {
        self.session = .shared
    }
    
    func request<T: Decodable>(_ type: T.Type,
                               urlString: String,
                               method: HTTPMethod = .get,
                               queue: DispatchQueue = Queue.defaultQueue,
                               parameters: [String: Any]? = nil) -> Single<T> {
        return Single<T>.create { (observer) -> Disposable in
            var request: URLRequest!
            var components = URLComponents(string: urlString)
            
            if let parameters = parameters {
                var makeParameters = [URLQueryItem]()
                for (name, value) in parameters {
                    if name.isEmpty { continue }
                    let makeItem = URLQueryItem(name: name, value: "\(value)")
                    makeParameters.append(makeItem)
                }
                components?.queryItems = makeParameters
            }
            if let compUrl = components?.url {
                request = URLRequest(url: compUrl,
                                     timeoutInterval: self.timeout)
            } else {
                request = URLRequest(url: URL(string: urlString)!,
                                     timeoutInterval: self.timeout)
            }
            
            let task = self.performDataTask(request,
                                            method: method,
                                            parameters: parameters,
                                            queue: queue) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let json = try JSONDecoder().decode(T.self, from: data)
                        observer(.success(json))
                        print("success : \(data)")
                    } catch {
                        observer(.error(error))
                        print("parsing error : \(error)")
                    }
                case .failure(let error):
                    observer(.error(error))
                    print("failure error : \(error)")
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func retrieveImage(_ url: URL, queue: DispatchQueue = Queue.imageQueue) -> Single<UIImage> {
        return Single<UIImage>.create { (observer) -> Disposable in
            if let cachedImage = self.getImage(url.absoluteString) {
                DispatchQueue.main.async {
                    observer(.success(cachedImage))
                }
                return Disposables.create()
            }
            let request = URLRequest(url: url,
                                     timeoutInterval: self.timeout)
            let task = self.performDataTask(request) { (result) in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        let _error = ErrorHandler.check(nil)
                        DispatchQueue.main.async {
                            observer(.error(_error))
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.setImage(url.absoluteString, image: image)
                        observer(.success(image))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        observer(.error(error))
                    }
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    @discardableResult
    private func performDataTask(_ request: URLRequest,
                 method: HTTPMethod = .get,
                 parameters: [String: Any]? = nil,
                 queue: DispatchQueue = Queue.defaultQueue,
                 completion: @escaping (Swift.Result<Data, Error>) -> ()) -> URLSessionDataTask {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let newTask: URLSessionDataTask = self.session.dataTask(with: request) { (data, response, error) in
            queue.async {
                guard error == nil,
                    let valuableData = data else {
                        let _error = ErrorHandler.check(error)
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                        completion(.failure(_error))
                        return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                completion(.success(valuableData))
            }
        }
        newTask.resume()
        return newTask
    }
    
    private func urlEncode(_ text: String) -> String? {
        // URL인코딩은 공백을+문자로 바꾸고
        let replace = text.replacingOccurrences(of: " ", with: "+")
        // 대시(-), 밑줄(_)및 별표(*)를 제외한 모든 문자가 인코딩
        let char: CharacterSet = CharacterSet(charactersIn: ".-_*")
        let encoded = replace.addingPercentEncoding(withAllowedCharacters: char.inverted)
        return encoded
    }
}

extension NetworkManager {
    func setImage(_ key: String, image: UIImage) {
        self.cache.setObject(image, forKey: key as NSString)
    }
    func getImage(_ key: String) -> UIImage? {
        return self.cache.object(forKey: key as NSString)
    }
}