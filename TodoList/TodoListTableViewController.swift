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
        
        homework.titlename = "Do Homework"
        homework.location = "Bangkok"
        homework.lat = 13.763246
        homework.lng = 100.502639
        homework.create_date = "Create: Dec 15, 2018 15:30:54"
        homework.deteil = "Do Homework at 7pm"

        let breakfast = ToDo()
        breakfast.titlename = "Have Breakfast"
        breakfast.location = "Karbi"
        breakfast.lat = 8.090206
        breakfast.lng = 98.905597
        breakfast.create_date = "Create: Dec 15, 2018 15:31:54"
        breakfast.deteil = "Have Breakfasr at 7am"
        

        let lunch = ToDo()
        lunch.titlename = "Have Lunch"
        lunch.location = "Chiang Mai"
        lunch.lat = 18.787333
        lunch.lng = 99.017442
        lunch.create_date = "Create: Dec 15, 2018 15:32:54"
        lunch.deteil = "Have lunch at 12pm"

        let dinner = ToDo()
        dinner.titlename = "Have Dinner"
        dinner.location = "Lopburi"
        dinner.lat = 14.802822
        dinner.lng = 100.653714
        dinner.create_date = "Create: Dec 15, 2018 15:33:54"
        dinner.deteil = "Have dinner at 6pm"
        
        
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
        let deteillbl = cell.detailTextLabel
        deteillbl?.textColor = UIColor.lightGray
        
        cell.textLabel?.text = TodoCell.titlename
        deteillbl?.text = TodoCell.deteil
        
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
