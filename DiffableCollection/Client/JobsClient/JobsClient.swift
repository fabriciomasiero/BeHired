//
//  JobsClient.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation
import Combine

public class JobsClient: APIClient {
    
    public typealias Jobs = [Job]
    
//    var path: String = "https://jobs.github.com/positions.json?page=1&search=code"
    var path: String = "https://jobs.github.com/positions.json?description=ios"
    
    private let session: URLSession
//    private let domain: URL?

    required public init(session: URLSession) {
        self.session = session
//        self.domain = domain
    }
    
    func getJobs(page: Int, search: String?) -> AnyPublisher<Jobs, JobsError> {
        func jobsUrl() -> URLRequest? {
            guard let url = URL(string: path) else {
                  return nil
              }
            return URLRequest(url: url)
        }
        return jobs(urlRequest: jobsUrl())
    }
    private func jobs<T>(urlRequest: URLRequest?) -> AnyPublisher<T, JobsError> where T : Decodable {
        guard let urlRequest = urlRequest else {
            let error = JobsError.intern(description: "Couldnt create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest).mapError { error in
            .network(description: error.localizedDescription)
        }.flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
        }.eraseToAnyPublisher()
    }
}
