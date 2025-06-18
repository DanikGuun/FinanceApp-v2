

import XCTest
@testable import FinanceApp

final class ImageAndTitleCollectionViewTests: XCTestCase {
    
    var collection: ImageAndTitleCollectionView!
    
    let defaultInsertedItems: [ImageAndTitleItem] = [
        ImageAndTitleItem(id: UUID(), title: "Test 1", image: UIImage(systemName: "house.fill"), allowSelection: false, action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 2", image: UIImage(systemName: "magnifyingglass"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 3", image: UIImage(systemName: "cart.fill"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 4", image: UIImage(systemName: "heart.fill"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 5", image: UIImage(systemName: "person.crop.circle"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 6", image: UIImage(systemName: "gear"), action: nil),
    ]
    
    let newItems: [ImageAndTitleItem] = [
        ImageAndTitleItem(id: UUID(), title: "Test 7", image: UIImage(systemName: "bell.fill"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 8", image: UIImage(systemName: "clock.fill"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Test 9", image: UIImage(systemName: "questionmark.circle"), action: nil),
        ImageAndTitleItem(id: UUID(), title: "Teset 10", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), action: nil)
    ]
    
    override func setUp() {
        collection = ImageAndTitleCollectionView()
        collection.setItems(defaultInsertedItems)
        super.setUp()
    }
    
    override func tearDown() {
        collection = nil
        super.tearDown()
    }
    
    //Здесь тестируем выделение и по индексу и по самому предмету, потом только по индексу
    //ибо логика выделения не зависит от типа, она переложена на коллекцию
    func testSelectItem_SelectionAllowed_ByIndex() {
        collection.selectItem(at: 1)
        let selected = collection.selectedItem
        XCTAssertEqual(selected, defaultInsertedItems[1])
    }
    
    func testSelectItem_SelectionAllowed_ByItem() {
        collection.selectItem(defaultInsertedItems[1])
        let selected = collection.selectedItem
        XCTAssertEqual(selected, defaultInsertedItems[1])
    }
    
    func testSelectItem_SelectionAllowed_ButItemNotAllow() {
        collection.selectItem(at: 0)
        let selected = collection.selectedItem
        XCTAssertNil(selected)
    }
    
    func testSelectItem_SelectionNotAllowed() {
        collection.isSelectionAllowed = false
        collection.selectItem(at: 1)
        let selected = collection.selectedItem
        XCTAssertNil(selected)
    }
    
    func testSetItems_ItemDoesNotExist_PreviousItemSelected() {
        collection.selectItem(at: 1)
        collection.selectItem(at: -1)
        let selected = collection.selectedItem
        XCTAssertEqual(selected, defaultInsertedItems[1])
    }
    
    func testSetItems_LessThanMaxCount() {
        collection.setItems(newItems)
        let items = collection.items
        XCTAssertEqual(items, newItems)
    }
    
    func testSetItems_EqualMaxCount() {
        collection.setItems(defaultInsertedItems)
        let items = collection.items
        XCTAssertEqual(items, defaultInsertedItems)
    }
    
    func testSetItems_GreaterThanMaxCount() {
        let shuffeldItems = (defaultInsertedItems + newItems).shuffled()
        let requiredItems = Array(shuffeldItems[0 ..< collection.maxItemsCount])
        
        collection.setItems(shuffeldItems)
        let items = collection.items
        
        XCTAssertEqual(items, requiredItems)
    }
    
    func testInsertItem_HaveEnoughSpace() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = [newItem] + newItems
        
        collection.setItems(newItems)
        collection.insertItem(newItem, at: 0)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_HaveNotEnoughSpace_NoNedSaveLastItem() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = [newItem] + Array(defaultInsertedItems[0 ..< 5])
        
        collection.insertItem(newItem, at: 0)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_HaveNotEnoughSpace_NeedSaveLastItem() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = [newItem] + Array(defaultInsertedItems[0 ..< 4]) + [defaultInsertedItems[5]]
        
        collection.insertItem(newItem, at: 0, needSaveLastItem: true)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInserItem_AtIndexOutOfBounds() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = defaultInsertedItems
        
        collection.setItems(defaultInsertedItems)
        collection.insertItem(newItem, at: 100)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_InBounds() {
        let newItem = ImageAndTitleItem(id: UUID())
        let startItems = Array(defaultInsertedItems[0 ..< 4])
        let targetItems = Array(defaultInsertedItems[0 ..< 2]) + [newItem] + Array(defaultInsertedItems[2..<4])
        
        collection.setItems(startItems)
        collection.insertItem(newItem, at: 2)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_Full_NoNeedSaveLastItem() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = Array(defaultInsertedItems[0..<4]) + [newItem] + [defaultInsertedItems[4]]
        
        collection.setItems(defaultInsertedItems)
        collection.insertItem(newItem, at: 4, needSaveLastItem: false)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_Full_NeedSaveLastItem() {
        let newItem = ImageAndTitleItem(id: UUID())
        let targetItems = Array(defaultInsertedItems[0..<4]) + [newItem] + [defaultInsertedItems[5]]
        
        collection.setItems(defaultInsertedItems)
        collection.insertItem(newItem, at: 4, needSaveLastItem: true)
        let items = collection.items
        
        XCTAssertEqual(items, targetItems)
    }
    
    func testInsertItem_Full_AtLast_NeedSaveLastItem() {
        let newItem = ImageAndTitleItem(id: UUID())
        
        collection.setItems(defaultInsertedItems)
        collection.insertItem(newItem, at: 5, needSaveLastItem: true)
        let items = collection.items
        
        XCTAssertEqual(items, defaultInsertedItems)
    }
    
    func testAction_AllowSelectionItem() {
        var wasExecuted = false
        let item = ImageAndTitleItem(id: UUID(), action: { _ in
            wasExecuted = true
        })
        
        collection.insertItem(item, at: 0)
        collection.selectItem(at: 0)
        
        XCTAssertTrue(wasExecuted)
    }
    
    func testAction_NotAllowSelectionItem() {
        var wasExecuted = false
        let item = ImageAndTitleItem(id: UUID(), allowSelection: false, action: { _ in
            wasExecuted = true
        })
        
        collection.insertItem(item, at: 0)
        collection.selectItem(at: 0)
        
        XCTAssertFalse(wasExecuted)
    }
    
}
