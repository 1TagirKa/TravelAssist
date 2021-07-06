//
//  NotesTableViewController.swift
//  TravelAssist
//
//  Created by Tagir Kabirov on 05.07.2021.
//

import UIKit

class NotesTableViewController: UITableViewController {

    var objects = [
        Standart(title: "Купить продукты", description: "молоко и тд", emoji: "🍔", isFavourite: false),
        Standart(title: "Забронировать авто", description: "На 7 дней ", emoji: "🚗", isFavourite: false),
        Standart(title: "Сдать комнату", description: "+5747499", emoji: "🏯", isFavourite: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.title = "Notes"
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! NewNoteTableViewController
        let note = sourceVC.note
        
        let indexPath = IndexPath(row: objects.count, section: 0)
        objects.append(note)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath) as! StandartNotesTableViewCell
        let object = objects[indexPath.row]
        
        cell.set(object: object)
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCell = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedCell, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        //let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.objects.remove(at: indexPath.row)
            self .tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(false)
        }
        action.backgroundColor = .systemPurple
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
//    func favouriteAction(at indexPath: IndexPath) -> UIContextualAction{
//        var object = objects[indexPath.row]
//        let action = UIContextualAction(style: .normal, title: "Favourite") { (action, view, complition)  in
//            object.isFavourite = !object.isFavourite
//            self.objects[indexPath.row] = object
//            complition(true)
//        }
//        action.backgroundColor = object.isFavourite ? .systemRed : .systemGray
//        action.image = UIImage(systemName: "heart")
//        return action
//    }

}
