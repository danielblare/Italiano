//
//  VersionedSchemas.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import Foundation
import SwiftData

enum SchemaV1: VersionedSchema {
    
    static var models: [any PersistentModel.Type] {
        [Offer.self]
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
            
            let urlString = try container.decode(String.self, forKey: .image)
            guard let image = URL(string: urlString) else { throw URLError(.badURL) }
            
            self.title = try container.decode(String.self, forKey: .title)
            self.text = try container.decode(String.self, forKey: .text)
            self.offerText = try container.decode(String.self, forKey: .offerText)
            self.badge = try container.decodeIfPresent(String.self, forKey: .badge)
            self.promoCode = try container.decode(String.self, forKey: .promoCode)
            self.image = image
        }
        
        static let dummy = Offer(title: "Taste of Tuscany", text: "Transport your taste buds to Tuscany with our rustic antipasto platter. Enjoy olives, cured meats, and fresh mozzarella, perfectly complemented by a bottle of red wine.", offerText: "Special Offer: Free bottle of wine with orders over $50!", badge: "50% OFF", promoCode: "1DIA4N49", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!)
    }
}
