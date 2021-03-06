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
    var unfulfilledNotes: [Standart] {
        get {
            guard let data = UserDefaults.standard.value(forKey: "unfulfilledNotes") as? Data else { return [] }
            
            do {
                let categories = try PropertyListDecoder().decode(Array<Standart>.self, from: data)
                return categories
            }
            catch {
                return []
            }
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "unfulfilledNotes")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Править"
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! NewNoteTableViewController
        let note = sourceVC.note
        
        if let selectedCell = tableView.indexPathForSelectedRow{
            unfulfilledNotes[selectedCell.row] = note
            tableView.reloadRows(at: [selectedCell], with: .automatic)
        } else {
        let indexPath = IndexPath(row: unfulfilledNotes.count, section: 0)
        unfulfilledNotes.append(note)
        tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
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
        self.navigationItem.leftBarButtonItem?.title = "Готово"
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
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editNote" else {
            guard let dvc = segue.destination as? DoneNoteTableViewController else{return}
            for element in self.doneNote {
                dvc.doneNotes.append(element)
            }
            self.doneNote.removeAll()
            return
        }
        let indexPath = tableView.indexPathForSelectedRow!
        let note = unfulfilledNotes[indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newNoteVC = navigationVC.topViewController as! NewNoteTableViewController
        newNoteVC.note = note
        newNoteVC.title = "Редактировать"
    }

}
