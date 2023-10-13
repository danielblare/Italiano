//
//  VersionedSchemas.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import Foundation
import SwiftData
import MapKit

enum SchemaV1: VersionedSchema {
    
    static var models: [any PersistentModel.Type] {
        [Offer.self, Location.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV1 {
    
    @Model
    final class Offer: Decodable {
        @Attribute(.unique)
        let id: UUID = UUID()
        let title: String
        let text: String
        
        let offerText: String
        let badge: String?
        let promoCode: String
        
        let image: URL
        
        init(title: String, text: String, offerText: String, badge: String? = nil, promoCode: String, image: URL) {
            self.title = title
            self.text = text
            self.offerText = offerText
            self.badge = badge
            self.promoCode = promoCode
            self.image = image
        }

        enum CodingKeys: String, CodingKey {
            case title
            case text
            case offerText = "offer_text"
            case promoCode = "promo_code"
            case badge
            case image
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
            self.text = try container.decode(String.self, forKey: .text)
            self.offerText = try container.decode(String.self, forKey: .offerText)
            self.badge = try container.decodeIfPresent(String.self, forKey: .badge)
            self.promoCode = try container.decode(String.self, forKey: .promoCode)
            self.image = try container.decode(URL.self, forKey: .image)
        }
        
        static var dummy: Offer { 
            Offer(title: "Taste of Tuscany", text: "Transport your taste buds to Tuscany with our rustic antipasto platter. Enjoy olives, cured meats, and fresh mozzarella, perfectly complemented by a bottle of red wine.", offerText: "Special Offer: Free bottle of wine with orders over $50!", badge: "50% OFF", promoCode: "1DIA4N49", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!)
        }
    }
    
    @Model
    final class Location: Decodable {
        @Attribute(.unique)
        let id: UUID = UUID()
        let name: String
        let image: URL
        let schedule: String

        let coordinate: CLLocationCoordinate2D
        
        init(name: String, schedule: String, image: URL, coordinate: CLLocationCoordinate2D) {
            self.name = name
            self.schedule = schedule
            self.coordinate = coordinate
            self.image = image
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case schedule
            case image
            case coordinate
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.schedule = try container.decode(String.self, forKey: .schedule)
            self.image = try container.decode(URL.self, forKey: .image)
            self.coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        }
        
        static var dummy: Location {
            Location(name: "Apex Business Cntr, Blackthorn Rd", schedule: "10am - 8pm", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!, coordinate: CLLocationCoordinate2D(latitude: 53.342025, longitude: -6.267628))
        }
    }
}
