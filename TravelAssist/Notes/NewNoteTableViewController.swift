//
//  NewNoteTableViewController.swift
//  TravelAssist
//
//  Created by Tagir Kabirov on 06.07.2021.
//

import UIKit

class NewNoteTableViewController: UITableViewController {
   
    var note = Standart(title: "", description: "", emoji: "", isFavourite: false)
    
    @IBOutlet weak var emojiTL: UITextField!
    @IBOutlet weak var nameTL: UITextField!
    @IBOutlet weak var descriptionTL: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState(){
        let emojiText = emojiTL.text ?? ""
        let nameText = nameTL.text ?? ""
        let descriptionText = descriptionTL.text ?? ""
        
        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else {return}
        let emoji = emojiTL.text ?? ""
        let name = nameTL.text ?? ""
        let description = descriptionTL.text ?? ""
        
        self.note = Standart(title: name, description: description, emoji: emoji, isFavourite: self.note.isFavourite)
    }
    

}
