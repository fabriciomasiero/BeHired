//
//  APIClient.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import Foundation

protocol APIClient {
    
    var path: String { get }

    init(session: URLSession)
}
