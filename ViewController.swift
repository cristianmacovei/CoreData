//
//  ViewController.swift
//  CoreData Example
//
//  Created by Cristian Macovei on 17.11.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreData To Do List"
        getAllItems()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
    }
    
    /*
        Relationships are made by creating new Entities in the xcdatamodel file. After defining the Attributes, the relationship will be defined with a NAME, DESTINATION AND INVERT.
        
     The destination is the Entity that the current object will be referring to. After complete implementation, the first Entity has to be updated with the INVERT, for double referencing
     
     The CoreDataClasses that were created cand be MOVED TO TRASH and replaced with new ones via Editor -> "Create NSManagedObject Subclass"
    */
    func relationshipDemo() {
        
        //Create a Category
        let category = Category(context: context)
        category.name = "ABC Category"
    
        
        //Create a Chore
        var chore = ToDoListItem(context: context)
        chore.name = "Homework"
        
        //reference the category to the chore
        chore.category = category
        
        /*invert - reference the chore to the category
         
         The relationships that you define always go both ways. You can refuse to declare them in the xcdatamodel, however, iOS Dev & xCode best practices strongly recommend thorough relationship declaration.
         
         This means that the relationships can go both ways: category will point to chores and chores will point to a category.
         
         */
        category.addToChores(chore)
        
        //Save Context
        try! context.save()
        
    }
    
    

    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self.createItem(name: text)
        }))
        
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit",
                                          message: "Edit your item",
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Saved", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
        
    }
    
    // CORE DATA FUNCTIONS
    func getAllItems() {
        do {
            
            /*
             models = try context.fetch(ToDoListItem.fetchRequest())
            */
            
            //try a sorting option when fetching data
            
            let request = ToDoListItem.fetchRequest()        //if ERROR "Ambiguous use of fetchRequest" -> cast 'as! NSFetchRequest<Type>'
            
            //Filtering conditions are set by NSPredicate
            
            //let pred = NSPredicate(format: "name CONTAINS 'Mercedes'") //will ONLY show items containing 'Mercedes'
            //request.predicate = pred
            
            //Sorting conditions
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]  //NSSortDescriptor is an array so you can just set the sort in an array [sort]
            
            
            models = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
    }
    
    func createItem(name: String) {
        
        //create items
        
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        //save items
        do {
            try context.save()
            //refresh database
            getAllItems()
        }
        catch {
            //error
        }
        
    }
    
    func deleteItem(item: ToDoListItem) {
        
        //delete item
        context.delete(item)
        
        //save again to update the items
        do {
            try context.save()
            //refresh database
            getAllItems()
        } catch {
            //error
        }
        
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        
        //update
        item.name = newName
        
        do {
            try context.save()
            //refresh database
            getAllItems()
        } catch {
            //error
        }
    }
    
}

 
