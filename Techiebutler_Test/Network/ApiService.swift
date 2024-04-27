//
//  ApiService.swift
//  MP Papers
//
//  Created by techstalwarts on 30/11/23.
//

import Foundation
import Combine

protocol ApiServiceProtocol {
    func getPosts() -> AnyPublisher<[GetPostsResponse], Error>
    func getComments(request: GetComments.Request) -> AnyPublisher<[GetComments.Response], Error>
}

class ApiService: ApiServiceProtocol {
    
    func getComments(request: GetComments.Request) -> AnyPublisher<[GetComments.Response], any Error> {
        apiClient.request(.getComments(request))
    }
    
    
    func getPosts() -> AnyPublisher<[GetPostsResponse], Error> {
        apiClient.request(.getPosts)
    }
    
    
    
    let apiClient = URLSessionAPIClient<NetworkUtils>()
    
}
