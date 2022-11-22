# CoreData
An App Example made to explain to myself the way CoreData operates in an App. 
README COREDATA EXAMPLE

App is a To-Do list that saves the data locally using the CoreData library locally. The CoreData has the advantages of creating xcdatamodels automatically, where the information can be customized through types and relationships, which makes the usage of CoreData very efficient, in that it mimics operating ways of a database, without actually being a database.

The context (of type NSManagedObjectContext) tracks changes to your app’s types. This uses a persistentContainer to pass data model filename to its initialisers. 

The TableView is our UI Item that will handle the data accordingly. We define TableViewDelegate and TableViewDataSource to be able to pass the data from one place to another. 

The function getAllItems() refreshes data and is a function called in viewDidLoad and in other CoreData functions that need update on the stored data. For instance, createItem() will add a new item and, in order for it to appear in the tableView, the data must be refreshed, so the getAllItems() will be called in here too. DeleteItem() acts just the same, but for removing a data point in the array. UpdateItem() will just allow user to change the name in the data. Afterwards, data will be refreshed. 

The relationships within the xcdatamodel are done by adding an Entity (can be renamed), where there will be attributes added. These attributes have a name and a type, which can then be used to define a relationship to another Entity. This must not be done reciprocally, but CoreData best practices advise to se the relationships from both ends. This is where the “inverse” attribute of the relationship comes into play. This defines which is that “other end” of the relationship. 

