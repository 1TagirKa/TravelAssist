//
//  DoneNoteTableViewController.swift
//  TravelAssist
//
//  Created by Tagir Kabirov on 07.07.2021.
//

import UIKit

class DoneNoteTableViewController: UITableViewController {

    @IBOutlet weak var clearButton: UIBarButtonItem!
    var note = Standart(title: "", description: "", emoji: "", isDone: false)
    var doneNotes = [Standart]()
    
    override func viewDidLoad() {
        clearButtonState()
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func clearAllNotes(_ sender: Any) {
        guard doneNotes.count > 0  else {return}
        for i in stride(from: doneNotes.count - 1, to: 0, by: 1){
            self.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
        doneNotes.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        doneNotes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath) as! StandartNotesTableViewCell
        let object = doneNotes[indexPath.row]
        
        cell.set(object: object)
        return cell
    }
    
    private func clearButtonState(){
        clearButton.isEnabled = doneNotes.count > 0
    }


}
