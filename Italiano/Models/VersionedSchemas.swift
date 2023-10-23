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
        [CartItem.self, Order.self, Offer.self, Location.self, MenuSection.self, FavoriteItem.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV1 {
    @Model
    final class Order {
        let items: [CartItemModel]
        let deliveryInfo: DeliveryInfo
        let date: Date
        
        var totalPrice: Double {
            items.map({ $0.totalPrice }).reduce(0, +) + deliveryInfo.option.price
        }
        
        init(items: [CartItem], deliveryInfo: DeliveryInfo, date: Date = .now) {
            self.items = items.map({ .init(from: $0) })
            self.deliveryInfo = deliveryInfo
            self.date = date
        }
        
        static var dummy: Order {
            Order(items: [.dummy], deliveryInfo: .dummy)
        }
    }
        
    @Model
    final class CartItem {
        let item: MenuItem
        var quantity: Int
        
        init(item: MenuItem, quantity: Int = 1) {
            self.item = item
            self.quantity = quantity
        }
        
        var totalPrice: Double {
            Double(quantity) * item.price
        }
        
        static var dummy: CartItem {
            CartItem(item: MenuItem.dummy, quantity: 2)
        }
    }
    
    @Model
    final class Offer: Decodable {
        var id: String { title }
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
        var id: String { name }
        let name: String
        let address: String
        let info: String
        let image: URL
        let schedule: String
        
        let coordinate: CLLocationCoordinate2D
        
        init(name: String, address: String, info: String, schedule: String, image: URL, coordinate: CLLocationCoordinate2D) {
            self.name = name
            self.address = address
            self.info = info
            self.schedule = schedule
            self.coordinate = coordinate
            self.image = image
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case address
            case info = "description"
            case schedule
            case image
            case coordinate
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.address = try container.decode(String.self, forKey: .address)
            self.info = try container.decode(String.self, forKey: .info)
            self.schedule = try container.decode(String.self, forKey: .schedule)
            self.image = try container.decode(URL.self, forKey: .image)
            self.coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
        }
        
        static let empty = Location(name: "", address: "", info: "", schedule: "", image: URL(fileURLWithPath: ""), coordinate: CLLocationCoordinate2DMake(0, 0))
        
        static var dummy: Location {
            Location(name: "Apex Business Center", address: "Apex Business Cntr, Blackthorn Rd", info: "Nestled in the heart of the business district, our Apex location offers a modern Italian dining experience with a stunning view of the city skyline", schedule: "10am - 8pm", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!, coordinate: CLLocationCoordinate2D(latitude: 53.342025, longitude: -6.267628))
        }
    }
    
    @Model
    final class MenuSection: Decodable {
        var id: String { name }
        let name: String
        let image: URL
        
        let items: [MenuItem]
        
        init(name: String, image: URL, items: [MenuItem]) {
            self.name = name
            self.image = image
            self.items = items
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case image
            case items
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
            self.image = try container.decode(URL.self, forKey: .image)
            self.items = try container.decode([MenuItem].self, forKey: .items)
        }
        
        static var dummy: MenuSection {
            MenuSection(name: "Pizza", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/menu/pizza/section_image.png?raw=true")!, items: [.dummy])
        }
    }
    
    @Model
    final class FavoriteItem {
        let item: MenuItem
        
        init(item: MenuItem) {
            self.item = item
        }
        
        static var dummy: FavoriteItem {
            FavoriteItem(item: .dummy)
        }
    }
}
