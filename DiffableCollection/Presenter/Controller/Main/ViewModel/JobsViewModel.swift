//
//  JobsViewModel.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation
import Combine

public class JobsViewModel {
    
    private var disposables = Set<AnyCancellable>()
    
    private var jobsClient: JobsClient
    let errorSubject = PassthroughSubject<JobsError, Never>()
    public let jobsSubject = PassthroughSubject<[Job], Never>()
    public var page: Int = 1
    public var search: String = ""
    
    init(jobsClient: JobsClient) {
        self.jobsClient = jobsClient
    }
    func fetchJobs() {
//        jobsClient.getJobs(page: page, search: search).sink(receiveCompletion: { event in
//        }) { response in
////            self.$jobs.publisher
//            self.jobsSubject.send(response)
//        }.store(in: &disposables)
//        passthroughSubject.sink(receiveCompletion: {  in
//
//        }, receiveValue: T##(([Job]) -> Void)##(([Job]) -> Void)##([Job]) -> Void)
//        jobsClient.getJobs(page: page, search: search).flatMap {
//            return $0
//
//        }
        jobsClient.getJobs(page: page, search: search).map { response in
            DispatchQueue.main.async {
                self.jobsSubject.send(response)
            }
        }.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorSubject.send(error)
                case .finished:
                    print("completed")
                }
            }) {()}.store(in: &disposables)
    }
}
