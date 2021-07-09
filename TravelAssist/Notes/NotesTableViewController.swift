//
//  NotesTableViewController.swift
//  TravelAssist
//
//  Created by Tagir Kabirov on 05.07.2021.
//

import UIKit

class NotesTableViewController: UITableViewController {
    var note = Standart(title: "", description: "", emoji: "", isDone: false)
    
    var doneNote = [Standart]()
    
    var unfulfilledNotes = [
        Standart(title: "Купить продукты", description: "молоко и тд", emoji: "🍔", isDone: false),
        Standart(title: "Забронировать авто", description: "На 7 дней ", emoji: "🚗", isDone: false),
        Standart(title: "Сдать комнату", description: "+5747499", emoji: "🏯", isDone: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! NewNoteTableViewController
        let note = sourceVC.note
        
        let indexPath = IndexPath(row: unfulfilledNotes.count, section: 0)
        unfulfilledNotes.append(note)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unfulfilledNotes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath) as! StandartNotesTableViewCell
        let object = unfulfilledNotes[indexPath.row]
        
        cell.set(object: object)
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        unfulfilledNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedCell = unfulfilledNotes.remove(at: sourceIndexPath.row)
        unfulfilledNotes.insert(movedCell, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)

        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.doneNote.append(self.unfulfilledNotes[indexPath.row])
            self.note = self.unfulfilledNotes[indexPath.row]
            self.unfulfilledNotes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(false)
        }
        action.backgroundColor = .systemPurple
        action.image = UIImage(systemName: "cross")
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? DoneNoteTableViewController else{return}
        for element in self.doneNote {
            dvc.doneNotes.append(element)
        }
        self.doneNote.removeAll()
    }

}
