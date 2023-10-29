# Italiano

Promotional: Discover the flavors of Italy with our Italian Restaurant App. Experience the essence of authentic Italian cuisine from the comfort of your mobile device. Explore a diverse menu of pasta dishes, wood-fired pizzas, rich sauces, and delectable desserts. Easily browse our restaurant's offerings, place orders for dine-in, takeout, or delivery, and make reservations for a taste of Italy in every bite. Stay updated with special promotions, loyalty rewards, and culinary events. Buon appetito!

## Description

Italian restaurant app prototype
- Allows user to redeem special offers
- Browse menu with unlimited assorted items, read details about a dish and customize it with some options
- Mark customized dish as your favorite
- Add/remove/modify items in the cart, select delivery & payment method, enter card details and complete your order
- Browse locations on the map and see which one is closer to you, get directions in Maps
- Review completed orders

## Code features
- Dependency injection, MVVM
- SwiftData, VersionedSchemas, ModelContainers, @Model, @Query, @Bindable for flawless data managing
- New Observable framework for more efficient code
- Integration with MapKit for better UX
- Calculating ETA for Maps in real time
- Parsing data like Menu, Locations, Offers from JSON
- Credit card data input validation
- Cache managing for better performance
- Custom navigation flow using enums
- Generics, protocols and much much more

## Screenshots

<div>
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/home.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/offer.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/order.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/favorite.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/map.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/menu.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/menu_section.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/item.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/item_added.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/cart.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/overview.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/card_details.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/confirmation.png?raw=true" alt="App Screenshot" width="250" />
  <img src="https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/complete.png?raw=true" alt="App Screenshot" width="250" />
</div>

### From Design to Real implementation

![App Screenshot](https://github.com/stuffeddanny/Italiano/blob/main/Screenshots/design.png?raw=true)
## Code snippets

### Menu section example in JSON Format

```swift
"name": "Pizza",
"image": "https://github.com/stuffeddanny/Italiano_files/blob/main/menu/pizza/section_image.png?raw=true",
"items": [
    {
        "name": "Margherita",
        "info": "30 cm, 8 pcs",
        "price": 10.99,
        "image": "https://github.com/stuffeddanny/Italiano_files/blob/main/menu/pizza/items/margherita.png?raw=true",
        "ingredients": [
            {"name": "Tomato Sauce"},
            {"name": "Mozzarella Cheese"},
            {"name": "Basil"}
        ],
        "options": [
            {"name": "Gluten free base"},
            {"name": "Extra cheese"}
        ]
    }
]
```
### Cached Image struct

```swift
/// Image view which fetches data from cache if present or downloads it and saves to the cache if not
struct CachedImage: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies

    /// URL for the image
    let url: URL
    
    /// Main Image returned by the view
    @State private var image: UIImage?
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            
            Image(uiImage: image ?? UIImage())
                .resizable()
            
            if image == nil {
                ProgressView()
            }
        }
        .task {
            let manager = dependencies.cacheManager
            let cache = manager.imagesCache
            
            /// Generates key under which image will be cached
            let key = url.relativePath
            
            if let savedImage = manager.getFrom(cache, forKey: key) { // Tries to get image from cache
                self.image = savedImage
            } else if let data = try? await URLSession.shared.data(from: url).0, // Tries to get data from the url
                      let image = UIImage(data: data) {
                self.image = image
                // Adding image to the cache
                manager.addTo(cache, forKey: key, value: image)
            }
        }
    }
}
```
### Preview container struct

```swift
/// Model container for preview providers
struct PreviewContainer {
    let container: ModelContainer!
    
    /// Initializing with Persistent model types
    init(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) {
        
        let schema = Schema(types)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
    }
    
    /// Initializing with versioned schema
    init(schema: VersionedSchema.Type, isStoredInMemoryOnly: Bool = true) {
        let schema = Schema(versionedSchema: schema)
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
    }
    
    /// Adding any Persistent Model to the container
    func add(_ items: [any PersistentModel]) {
        Task { @MainActor in
            items.forEach { container.mainContext.insert($0) }
        }
    }
}
```
### Preview with SwiftData injection

```swift
/// Generates preview taking container and optional items in
struct SwiftDataPreview<T: View>: View {
    private let content: T
    private let preview: PreviewContainer
    private let items: [any PersistentModel]?
    
    init(preview: PreviewContainer, items: [any PersistentModel]? = nil, @ViewBuilder _ content: () -> T) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    
    var body: some View {
        content
            .modelContainer(preview.container)
            .onAppear {
                if let items {
                    preview.add(items)
                }
            }
    }
}
```
### Route manager

```swift
/// Route value for navigation path
enum Route: Hashable {
    case offer(_ offer: Offer)
    case menuSection(_ section: MenuSection)
    case menuItem(_ item: MenuItem)
    case cart, cartItemOverview(_ item: CartItemSwiftData)
    case cardDetails(info: DeliveryInfo)
    case orderConfirmation(info: DeliveryInfo)
    case recentOrder(order: Order)
}

@Observable final class RouteManager {
    /// Tab view tabs
    enum Tab {
        case home, map, menu
        
        var title: String {
            switch self {
            case .home: "Home"
            case .map: "Map"
            case .menu: "Menu"
            }
        }
    }

    /// Selected tab in TabView
    var tabSelection: Tab = .home
    
    /// Navigation path
    var routes = [Route]()
    
    /// Pushing navigation to the `route` only if it's not in path already
    func push(to route: Route) {
        guard !routes.contains(route) else {
            return
        }
        routes.append(route)
    }
    
    /// Resets navigation path to the root and selects home tab
    func reset() {
        routes = []
        tabSelection = .home
    }
    
    /// Removes last components from navigation path navigating user to the previous screen
    func back() {
        _ = routes.popLast()
    }
}
```

### Directions manager

```swift
actor DirectionManager {
    
    /// Shared instance
    static let shared = DirectionManager()
    
    private init() {}
    
    /// Gets ETA to `coordinate`
    func getETA(to coordinate: CLLocationCoordinate2D) async throws -> MKDirections.ETAResponse {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        
        return try await directions.calculateETA()
    }
    
    /// Opens `location` in Apple Maps
    nonisolated func openInMaps(_ location: Location) {
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps()
    }
}
```

### JSON Decoding

```swift
extension JSONDecoder {
    
    /// Decodes type from JSON file in Bundle.main
    static func decode<T: Decodable>(from file: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else { throw URLError(.fileDoesNotExist) }
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
```

### Card details with simple validation

```swift
/// Card details model
struct CardDetails {
    
    /// Fields for card details entering
    enum Field: CaseIterable {
        case number, expiration, cvv
        
        /// Validates field in `input`
        func validate(input: CardDetails) -> Bool {
            switch self {
            case .number: input.number.filter({ "0123456789".contains($0) }).count == 16
            case .expiration: input.expiration.filter({ "0123456789".contains($0) }).count == 4
            case .cvv: input.cvv.filter({ "0123456789".contains($0) }).count == 3
            }
        }
    }
    
    /// Card number
    var number: String
    
    /// Card expiration date
    var expiration: String
    
    /// Card CVV code
    var cvv: String
    
    /// Validates `field`
    func validate(field: Field? = nil) -> Bool {
        if let field {
            return field.validate(input: self)
        } else {
            return Field.allCases.allSatisfy({ $0.validate(input: self) })
        }
    }
    
    init(number: String = "", expiration: String = "", cvv: String = "") {
        self.number = number
        self.expiration = expiration
        self.cvv = cvv
    }    
}

```

## Lessons Learned
In this project my main goal was to master new SwiftData and Observable frameworks.
 
- I implemented design created by customer making code scalable and many components reusable.
- I mastered Navigation flow using custom enum to make the flow flexible, customizable and scalable
- Input data entry is done through JSON which allows customer to easily modify it or tie it to a backend. 
- I integrated app with Apple Maps and using MapKit I conveniently display locations, calculate ETA based on user's location and allow to build route with just single click
- I also implemented Unit and UI tests.


## 🛠 Skills
Swift, SwiftUI, SwiftData, Observable, MapKit, Unit/UI Tests, JSON, Navigation Flow, MVVM, Async environment, Actors, Multithreading, Git, UX/UI, Figma, URLRequests

