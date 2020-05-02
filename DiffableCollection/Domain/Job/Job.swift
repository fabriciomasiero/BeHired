//
//  Job.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation

public struct Job: Codable, Hashable {
    private let id: String
    public let type: String
    public let url: String
    public let createdDate: String?
    public let company: String?
    public let companyUrl: String?
    public let location: String?
    public let title: String
    public let description: String
    public let applyUrl: String?
    public let imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case url
        case createdDate = "created_at"
        case company
        case companyUrl = "company_url"
        case location
        case title
        case description
        case applyUrl = "how_to_apply"
        case imageUrl = "company_logo"
    }
    
//    public func createDate() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d"
//        dateFormatter.timeZone = Calendar.current.timeZone
//
//    }
}
