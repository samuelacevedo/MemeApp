//
//  Resource.swift
//  MemeApp
//
//  Created by UbiiPagos on 4/6/23.
//

import Foundation


struct Resource<T> {
    let url: URL
    var httpMethos: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}
