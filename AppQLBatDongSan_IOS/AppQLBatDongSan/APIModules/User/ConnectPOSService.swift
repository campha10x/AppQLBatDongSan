//
//  ConnectPOSService.swift
//  ConnectPOS
//
//  Created by HarryNg on 11/6/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import SwiftyJSON

public enum ConnectPOSServiceError: Error {
    case unknownError
    case dataNil
    case invalidData
    case noInternetConnect
    case noWirelessConnect
    case invalidJsonData
    case downLoadFailure
}

typealias CompletionHandler = (JSON?, Error?) -> Void

// MagentoService service processing
class ConnectPOSServiceProcessing {
    var id: String
    var completionHandlers: [CompletionHandler]
    
    init(_ id:String) {
        self.id = id
        self.completionHandlers = []
    }
    
    convenience init(_ id: String, completionHandler: @escaping CompletionHandler) {
        self.init(id)
        self.completionHandlers.append(completionHandler)
    }
    
    func add(_ completionHandler: @escaping CompletionHandler) -> Void {
        self.completionHandlers.append(completionHandler)
    }
    
    func finishProcessingService(_ result: Data?, error: Error?) -> Void {
        var parseError = error
        var json : JSON?
        if let validData = result, validData.count > 0 {
            do {
                //debugPrint(String(bytes: validData, encoding: String.Encoding.utf8))
                let convertedJson = try JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                json = JSON(convertedJson)
                // Check error
                if let fail = json?["error"].boolValue, fail {
                    let message = json?["message"].stringValue ?? "ERROR"
                    parseError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : message,
                                                                         NSLocalizedFailureReasonErrorKey : message])
                    json = nil
                }
            } catch let err as NSError {
                if let message = String(data: validData, encoding: String.Encoding.utf8) {
                    debugPrint(message)
                    json = JSON(["data": message])
                }
                else{
                    print(err.localizedDescription)
                }
            }
        }
        // Log error request only
        if let message = parseError?.localizedDescription {
            debugPrint(message)
        }
        // Push notice
        DispatchQueue.main.async {
            for completionHandler in self.completionHandlers {
                completionHandler(json, parseError)
            }
            self.completionHandlers.removeAll()
        }
    }
}


//SOSC Service
class ConnectPOSService {
    static let shared = ConnectPOSService()
    private var processService = [String: ConnectPOSServiceProcessing]()
    
    //GenerateRequestID
    fileprivate func gennerateRequestId(request: URLRequest)-> String {
        var requestID = ""
        if request.httpMethod == "GET" {
            requestID = request.description
        }else {
            let url = request.description
            if let requestBody  = request.httpBody {
                let httpBodyString = String(data: requestBody, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? requestBody.base64EncodedString()
                requestID = url + httpBodyString
            }
        }
        return requestID
    }
    
    fileprivate func isExited(requset: URLRequest) -> ConnectPOSServiceProcessing? {
        let requestID = self.gennerateRequestId(request: requset)
        return processService[requestID]
    }
    
    //Add a completion
    fileprivate func appendCompletionHandlerRequest(process: ConnectPOSServiceProcessing, completionHandler: @escaping CompletionHandler) {
        process.add(completionHandler)
        
    }
    
    // Finish request
    fileprivate func finishRequest(request: URLRequest, result: Data?, error: Error?){
        if let error = error {
            print("Error \(error)")
        }
        let requestId = gennerateRequestId(request: request)
        if let process = processService[requestId] {
            // Log error request only
            if error != nil {
                debugPrint("=> Request: ", request)
            }
            // Process response
            process.finishProcessingService(result, error: error)
            processService[requestId] = nil
        }
        self.updateNetworkActivityIndicator()
    }
    
    
    //Cancel all request
    func cancelAllRequest() {
        URLSession.shared.getAllTasks { (sessions) in
            sessions.forEach({ (task) in
                task.cancel()
            })
        }
        processService.removeAll()
    }
    
    //ExecuteRequest
    fileprivate func executeRequest(_ request: URLRequest){
        let task =   URLSession.shared.dataTask(with: request) { (data : Data?, respone: URLResponse?, error: Error?) in
            var nsError : Error? = nil
            var responseData = data
            if error != nil || data == nil || data!.count <= 0{
                nsError = self.checkRespone(data: data, error: error)
                responseData = nil
            }
            self.finishRequest(request: request, result: responseData, error: nsError)
        }
        task.resume()
    }
    
    //ExecuteRequest download file
    fileprivate func executeRequestDownLoad(_ request: URLRequest,_ fileName:String, _ fileExtension: String, completionHanlder: @escaping CompletionHandler){
        guard let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL? else {
            return
        }
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName+"."+fileExtension)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.downloadTask(with: request, completionHandler: { (tempLocalUrl, response, error:Error?) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                    self.finishRequest(request: request, result: nil, error: nil)
                }
                do {
                    let fileManager = FileManager.default
                    // check file exist
                    if fileManager.fileExists(atPath: destinationFileUrl.path) {
                        do {
                            try fileManager.removeItem(atPath: destinationFileUrl.path)
                        }
                        catch let error as NSError {
                            print("Error! Something went wrong: \(error)")
                        }
                    }
                    //Store file
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                self.finishRequest(request: request, result: nil, error: ConnectPOSServiceError.downLoadFailure)
            }
        })
        task.resume()
    }
    
    
    
    //Check Respone
    fileprivate func checkRespone(data: Any?, error: Error?) -> Error? {
        if let error = error {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
                return ConnectPOSServiceError.noInternetConnect
            }
            if nsError.domain == NSURLErrorDomain && nsError.code == -1010 {
                return ConnectPOSServiceError.noWirelessConnect
            }
            if nsError.domain == NSURLErrorDomain && nsError.code == 403 {
                cancelAllRequest()
                return ConnectPOSServiceError.unknownError
            }
            
            if let httpResponse = data as? HTTPURLResponse, let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                if contentType != "application/json" {
                    cancelAllRequest()
                    return ConnectPOSServiceError.invalidJsonData
                }
            }
            return ConnectPOSServiceError.unknownError
        }
        guard data != nil else {
            return ConnectPOSServiceError.dataNil
        }
        return nil
    }
    
    //Start request
    fileprivate func preprocessRequest(request: URLRequest, completionHandler: @escaping CompletionHandler){
        let requestID = gennerateRequestId(request: request)
        if let process = processService[requestID] {
            process.add(completionHandler)
        }
        else{
            processService[requestID] = ConnectPOSServiceProcessing(requestID, completionHandler: completionHandler)
        }
        self.updateNetworkActivityIndicator()
    }
    
    
    //Create request
    func createRequest(_ uri: String, httpMethod: String, bodyData: Data?) -> URLRequest? {
        guard let webUrl = AppState.shared.currentBaseUrl else { return nil }
        let urlStr = webUrl + uri
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = httpMethod
        if let bodyData = bodyData {
            request.httpBody = bodyData
        }
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = ConstantConnectPos.timeOutRequest
        return request
    }
    
    
    //downLoad file
    func sendDataToRequestDownload(_ request: URLRequest, fileName:String, fileExtension:String, completionHandler: @escaping CompletionHandler) {
        self.preprocessRequest(request: request, completionHandler: completionHandler)
        self.executeRequestDownLoad(request, fileName,fileExtension, completionHanlder: completionHandler)
    }
    
    //Send request to serice
    func sendDataToRequest(_ request: URLRequest?, completionHandler: @escaping CompletionHandler) {
        guard let request = request else {
            completionHandler(nil, nil)
            return
        }
        // Append process request
        self.preprocessRequest(request: request, completionHandler: completionHandler)
        // Execute request
        self.executeRequest(request)
    }
    
    //Update the network activity indicator
    fileprivate func updateNetworkActivityIndicator() {
        DispatchQueue.main.async(execute: {
            if self.processService.count > 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
        
    }
    
    // Upload
    func createRequestUpload(data: Data, name: String? = nil) -> URLRequest? {
        guard let webUrl = AppState.shared.currentBaseUrl else { return nil }
        let boundary = generateBoundaryString()
        let name = name ?? Date().toString(format: DateFormat.Full) ?? "image-ipad-upload"
        let uri = "/xrest/v1/uploader"
        let urlStr = webUrl + uri
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        // header
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
        request.setValue("http://sales.connectpos.com", forHTTPHeaderField: "Origin")
        request.setValue("http://sales.connectpos.com", forHTTPHeaderField: "Referer")
        if let host = webUrl.components(separatedBy: "://").last {
            request.setValue(host, forHTTPHeaderField: "Host")
        }
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("en-US,en;q=0.9,vi;q=0.8", forHTTPHeaderField: "Accept-Language")
        // body
        let body = NSMutableData()
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(name).jpeg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body as Data
        request.setValue("\(body.length)", forHTTPHeaderField:"Content-Length")
        request.timeoutInterval = ConstantConnectPos.timeOutRequest
        request.httpShouldHandleCookies = false
        return request
    }
    
    func upload(data: Data, completionHandler: @escaping CompletionHandler) {
        let request = createRequestUpload(data: data)
        self.sendDataToRequest(request, completionHandler: completionHandler)
    }
    

    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

// MARK: - Create request with type
extension ConnectPOSService {
    // Make Request Uri + Query -> String
    func makeRequestUri(_ uri: String, query: [String: String]? = nil) -> String? {
        guard let token = AppState.shared.currentUser?.token else { return nil }
        // Query
        var queryString = "?"
        if let query = query {
            queryString += query.map({$0.key + "=" + $0.value + "&"}).reduce("", { $0 + $1 })
        }
        // Token
        queryString += "token_key=\(token)&"
        let cacheTime = Utils.generateCachetime()
        queryString += "forceFullPageCache=\(cacheTime)"
        guard let key = AppState.shared.license?.key, let currentStore = AppState.shared.currentStore else {
            return uri + queryString
        }
        var accessToken: String = key
        if let base64Token = accessToken.base64Encoded() {
            accessToken = base64Token
        }
        return uri + queryString + "&__token_key=\(accessToken)" + "&___store=\(currentStore.id)"
    }
    
    // Make request and send data
    func makeRequestAndSend(requetUrl: String?, method: String, bodyData: Data?, completionHandler: @escaping CompletionHandler) {
        if let url = requetUrl {
            let request = self.createRequest(url, httpMethod: method, bodyData: bodyData)
            // send request
            self.sendDataToRequest(request, completionHandler: completionHandler)
        }
        else{
            completionHandler(nil, nil)
        }
    }
    
    // POST
    func post(uri: String, body: [String: Any]?, completionHandler: @escaping CompletionHandler) {
        // convert data
        var bodyWareHouse = body
        bodyWareHouse?["warehouse_id"] = AppState.shared.currentOutlet?.warehouse_id
        do {
            if JSONSerialization.isValidJSONObject(bodyWareHouse ?? [:]) {
                let data = try JSONSerialization.data(withJSONObject: bodyWareHouse ?? [:], options: .prettyPrinted)
                self.makeRequestAndSend(requetUrl: makeRequestUri(uri), method: "POST", bodyData: data, completionHandler: completionHandler)
            }
            else{
                debugPrint(uri, JSON(bodyWareHouse ?? [:]))
            }
        }
        catch {
            debugPrint(uri, error.localizedDescription)
        }
    }
    
    // GET
    func get(uri: String, query: [String: String]?, completionHandler: @escaping CompletionHandler) {
        // Create request
        self.makeRequestAndSend(requetUrl: makeRequestUri(uri, query: query), method: "GET", bodyData: nil, completionHandler: completionHandler)
    }
    
    // DELETE
    func delete(uri: String, body: [String: Any]?, completionHandler: @escaping CompletionHandler) {
        // convert data
        do {
            if JSONSerialization.isValidJSONObject(body ?? [:]) {
                let data = try JSONSerialization.data(withJSONObject: body ?? [:], options: .prettyPrinted)
                self.makeRequestAndSend(requetUrl: makeRequestUri(uri), method: "DELETE", bodyData: data, completionHandler: completionHandler)
            }
            else{
                debugPrint(JSON(body ?? [:]))
            }
        }
        catch {
            debugPrint(uri, error.localizedDescription)
        }
    }
    
    
}
