//
//  TodoListTableViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/15/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var testgit = 1
    var TodoList : [ToDo] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        TodoList = createTodo()

        
    }
    
    // MARK: - Logic
    
    func createTodo() -> [ToDo] {
        
        let homework = ToDo()
        homework.name = "Do Homework"
        homework.important = true

        let breakfast = ToDo()
        breakfast.name = "Have Breakfast"

        let lunch = ToDo()
        lunch.name = "Have Lunch"

        let dinner = ToDo()
        dinner.name = "Have Dinner"
        
        
        return [homework , breakfast , lunch , dinner]
    }
    
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TodoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let TodoCell = TodoList[indexPath.row]
        
        if TodoCell.important {
            cell.textLabel?.text = TodoCell.name + " 🔴"
        } else {
            cell.textLabel?.text = TodoCell.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let TodoCell = TodoList[indexPath.row]
        performSegue(withIdentifier: "showdisplayToDo", sender: TodoCell)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let AddToDoVC = segue.destination as? AddToDoViewController {
            AddToDoVC.backToDoListVC = self
        }
        
        if let showDisplayToDoVC = segue.destination as? CompleteToDoViewController {
            
            if let todo = sender as? ToDo {
                showDisplayToDoVC.selectedToDo = todo
                showDisplayToDoVC.backToDoListVC = self
            }
        }
    }
    
    

  

}
