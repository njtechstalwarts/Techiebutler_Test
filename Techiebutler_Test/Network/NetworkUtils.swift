//
//  NetworkUtils.swift
//  MP Papers
//
//  Created by techstalwarts on 30/11/23.
//

import Foundation
import SwiftUI

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

enum NetworkUtils: APIEndpoint {
        
    case getPosts
    case getComments(_ request: GetComments.Request)
    
    var path: String {
        switch self {
        case .getPosts: return ApiNames.getPosts.rawValue
        case .getComments: return ApiNames.getComments.rawValue
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPosts, .getComments: return .get
        }
    }

    var headers: [String: String]? {

        return [:]
    }

    var parameters: [String: Any]? {
        switch self {
        case .getPosts: return [:]
        case .getComments(let request): return  request.asDictionary()
        }
    }
}
