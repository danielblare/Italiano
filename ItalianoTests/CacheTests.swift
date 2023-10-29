//
//  CacheTests.swift
//  ItalianoTests
//
//  Created by Daniel on 10/24/23.
//

import XCTest
@testable import Italiano

final class CacheTests: XCTestCase {

    private var cacheManager: CacheManager!
    
    override func setUp() {
        cacheManager = CacheManager()
    }

    override func tearDown() {
        cacheManager = nil
    }
    
    func testNoObjectInitially() {
        let key = "test_key"
        let cachedImage = cacheManager.getFrom(cacheManager.imagesCache, forKey: key)
        XCTAssertNil(cachedImage)
    }
    
    func testObjectSaving() {
        let key = "test_key"
        let image = UIImage(systemName: "star")!
        cacheManager.addTo(cacheManager.imagesCache, forKey: key, value: image)
        let cachedImage = cacheManager.getFrom(cacheManager.imagesCache, forKey: key)
        XCTAssertEqual(image, cachedImage)
    }
    
    func testObjectDeletion() {
        let key = "test_key"
        let image = UIImage(systemName: "star")!
        cacheManager.addTo(cacheManager.imagesCache, forKey: key, value: image)
        cacheManager.delete(from: cacheManager.imagesCache, forKey: key)
        
        let cachedImage = cacheManager.getFrom(cacheManager.imagesCache, forKey: key)
        XCTAssertNil(cachedImage)

    }
}
