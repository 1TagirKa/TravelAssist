//
//  OverlayView.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 10.07.2021.
//

import Foundation
import UIKit

class OverlayView: UIViewController {
    
    @IBOutlet weak var setCountryPickerView: UIPickerView!
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var countriesData: [String] = [
        "Япония",
        "Соединенные Штаты Америки",
        "Швейцария",
        "Франция",
        "Германия",
        "Испания",
        "Италия",
        "Турция",
        "Португалия",
        "Великобритания",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        setCountryPickerView.dataSource = self
        setCountryPickerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        presentedViewController?.dismiss(animated: true)
    }
    
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

extension OverlayView: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesData.count
    }
}

extension OverlayView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesData[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(countriesData[row])
    }
}
