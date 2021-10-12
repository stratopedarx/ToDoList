//
//  TableViewController.swift
//  ToDoList
//
//  Created by Sergey Lobanov on 12.10.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var tasks: [Task] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // получаем контекст, из этого контекста уже получаем наши объекты
        let context = getContext()  // добрались до контекста
        // теперь надо создать запрос, по которому мы можем получить все объекты, хранящиеся по энтити таск
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // можем сделать сортировку
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let context = getContext()
//        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        if let objects = try? context.fetch(fetchRequest) {
//            for object in objects {
//                context.delete(object)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
    }

    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Task", message: "Please add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alertController.textFields?.first
            if let newTaskTitle = textField?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.tableView.reloadData()
            }
        }

        alertController.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    private func saveTask(withTitle title: String) {
        let context = getContext()  // добрались до контекста
        
        // надо добраться до нашей сущности
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        // нужно получить наш таск объект. На основе энтити в контексте
        let taskObject = Task(entity: entity, insertInto: context)
        // надо поместить заголовок в наш таск объект
        taskObject.title = title
        
        // теперь надо сохранить наш контекст
        do {
            try context.save()
            tasks.append(taskObject)
            // можно тут добавить заголов в наш  tasks. либо потом добавим во viewWillAppear
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
