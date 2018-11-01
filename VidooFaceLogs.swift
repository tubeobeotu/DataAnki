//
//  Copyright © 2018 eZLO. All rights reserved.
//

import Foundation



//MARK: VidooActivity
public struct VidooFaceLog: VidooEntity {
    //MARK: Public
public private(set) var id: Int!
public private(set) var name: String?
public private(set) var firstSeen: Date?
public private(set) var firstSeenCamera: String?
public private(set) var lastSeen: Date?
public private(set) var lastSeenCamera: String?
}



extension VidooFaceLog: VidooDecodableEntity {
    //MARK: Public
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id             = try container.decode(Int.self, forKey: .id)
        self.name             = try container.decode(String.self, forKey: .name)
        self.firstSeen             = try container.decode(Date.self, forKey: .firstSeen)
        self.firstSeenCamera             = try container.decode(String.self, forKey: .firstSeenCamera)
        self.lastSeen             = try container.decode(Date.self, forKey: .lastSeen)
        self.lastSeenCamera             = try container.decode(String.self, forKey: .lastSeenCamera)
    }
    
    
    
    //MARK: Private
    private enum CodingKeys: String, CodingKey {
        case id, name, firstSeen, firstSeenCamera, lastSeen, lastSeenCamera
    }
}



public struct VidooFaceLogs: VidooEntity {
    //MARK: Public
    public private(set) var faceLogs: [VidooFaceLog]!
}


//MARK: VidooActivities
extension VidooFaceLogs: VidooDecodableEntity {
    //MARK: Public
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.faceLogs = try container.decode([VidooFaceLog].self, forKey: .data)
    }
    
    
    
    //MARK: Private
    private enum CodingKeys: String, CodingKey {
        case error, data
    }
}



extension VidooFaceLogs: VidooRequestingEntity {
    //MARK: Public
    public struct VidooFaceLogsRequestEntityParams {
        public static let emptyParams: [Int: Int] = [:]
        static let offset = "offset"
        static let limit = "limit"
    }
    
    public static func requestEntity<T>(with params: T, _ session: VidooSession, _ callback: @escaping VidooRequestCallback) where T : Encodable {
        session.authorizedRequest(withAuthorizationType: .device) { (authorizedRequest: URLRequest?, error: Error?) in
            if var ar = authorizedRequest {
                ar.url?.appendPathComponent("face_logs/today")
                ar.httpMethod = "GET"
                
                if let p = params as? Dictionary<String, Encodable> {
                    var queryItems = [URLQueryItem]()
                    p.forEach { (key: String, value: Encodable) in
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                    
                    var components = URLComponents(string: ar.url?.absoluteString ?? "")
                    components?.queryItems = queryItems
                    ar.url = components?.url
                }
                
                URLSession.shared.dataTask(with: ar, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    handle(data, response, error, callback)
                }).resume()
            } else {
                callback(nil, error)
            }
        }
    }
    
    
    
    //MARK: Private
    private static func handle(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ callback: @escaping VidooRequestCallback) {
        if let er = error {
            callback(nil, er)
            return
        }
        
        if let dt = data, dt.count > 0 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            
            if let faceLogs = try? decoder.decode(VidooFaceLogs.self, from: dt) {
                callback(faceLogs, nil)
            } else if let error = try? decoder.decode(VidooError.self, from: dt) {
                callback(error, nil)
            }
        }
    }
}

