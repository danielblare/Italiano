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
        [CartItemSwiftData.self, Order.self, Offer.self, Location.self, MenuSection.self, FavoriteItem.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}

extension SchemaV1 {
    
    /// Order model
    @Model final class Order {
        /// Items ordered
        let items: [CartItemModel]
        /// Delivery info
        let deliveryInfo: DeliveryInfo
        /// Date order was placed
        let date: Date
        
        /// Total price for entire order + delivery
        var totalPrice: Double {
            items.map({ $0.totalPrice }).reduce(0, +) + deliveryInfo.option.price
        }
        
        init(items: [CartItemSwiftData], deliveryInfo: DeliveryInfo, date: Date = .now) {
            self.items = items.map({ .init(from: $0) })
            self.deliveryInfo = deliveryInfo
            self.date = date
        }
        
        static var dummy: Order {
            Order(items: [.dummy], deliveryInfo: .dummy)
        }
    }
      
    /// Cart item model for swiftData
    @Model final class CartItemSwiftData: CartItem {
        /// Menu item
        let item: MenuItem
        /// Quantity of `item`
        var quantity: Int
        
        init(item: MenuItem, quantity: Int = 1) {
            self.item = item
            self.quantity = quantity
        }
        
        /// Total price quantity selected
        var totalPrice: Double {
            Double(quantity) * item.price
        }
        
        static var dummy: CartItemSwiftData {
            CartItemSwiftData(item: MenuItem.dummy, quantity: 2)
        }
    }
    
    /// Offer model
    @Model final class Offer: Decodable {
        var id: String { title }
        /// Offer title
        let title: String
        /// Offer marketing text
        let text: String
        
        /// Offer description telling exactly what's the deal
        let offerDescription: String
        
        /// Badge showed in the corner of offer cell
        let badge: String?
        /// Promo code for offer
        let promoCode: String
        /// Offer image
        let image: URL
        
        init(title: String, text: String, offerDescription: String, badge: String? = nil, promoCode: String, image: URL) {
            self.title = title
            self.text = text
            self.offerDescription = offerDescription
            self.badge = badge
            self.promoCode = promoCode
            self.image = image
        }
        
        enum CodingKeys: String, CodingKey {
            case title
            case text
            case offerDescription = "offer_description"
            case promoCode = "promo_code"
            case badge
            case image
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
            self.text = try container.decode(String.self, forKey: .text)
            self.offerDescription = try container.decode(String.self, forKey: .offerDescription)
            self.badge = try container.decodeIfPresent(String.self, forKey: .badge)
            self.promoCode = try container.decode(String.self, forKey: .promoCode)
            self.image = try container.decode(URL.self, forKey: .image)
        }
        
        static var dummy: Offer {
            Offer(title: "Taste of Tuscany", text: "Transport your taste buds to Tuscany with our rustic antipasto platter. Enjoy olives, cured meats, and fresh mozzarella, perfectly complemented by a bottle of red wine.", offerDescription: "Special Offer: Free bottle of wine with orders over $50!", badge: "50% OFF", promoCode: "1DIA4N49", image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!)
        }
    }
    
    /// Location model
    @Model final class Location: Decodable {
        var id: String { name }
        /// Name of the location
        let name: String
        /// Location address
        let address: String
        /// Location description
        let info: String
        /// Location image
        let image: URL
        /// Location schedule
        let schedule: String
        
        /// Location coordinate
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
    
    /// Menu section model
    @Model final class MenuSection: Decodable {
        var id: String { name }
        /// Section name
        let name: String
        /// Section image
        let image: URL
        
        /// Menu items in the section
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
    
    /// Favorite model
    @Model final class FavoriteItem {
        /// Item itself
        let item: MenuItem
        
        init(item: MenuItem) {
            self.item = item
        }
        
        static var dummy: FavoriteItem {
            FavoriteItem(item: .dummy)
        }
    }
}
