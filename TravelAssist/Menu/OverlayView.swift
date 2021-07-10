//
//  OverlayView.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 10.07.2021.
//

import Foundation
import UIKit

protocol EditEndDelegate{
    func onCompleteButton(country: String)
}

class OverlayView: UIViewController {
    
    var delegate: EditEndDelegate?
    
    @IBOutlet weak var setCountryPickerView: UIPickerView!
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var countrySelected: String?
    
    var countriesData: [String] = [
        "Соединенные Штаты Америки",
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
        
        countriesData = UserDefaults.standard.stringArray(forKey: "countriesData")!
        
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
        dismiss(animated: true)
    }
    
    @IBAction func completeButtonAction(_ sender: Any) {
        if countrySelected == nil{
            countrySelected = countriesData[0]
        }
    
        delegate?.onCompleteButton(country: countrySelected!)
        dismiss(animated: true)
        
        countriesData.append(UserDefaults.standard.string(forKey: "selectedCountry")!)
        var countriesData = Array(Set(countriesData))
        
        countriesData.remove(at: countriesData.firstIndex(of: countrySelected!)!)
        countriesData.sort()
        UserDefaults.standard.set(countrySelected, forKey: "selectedCountry")
        UserDefaults.standard.set(countriesData, forKey: "countriesData")
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
        countrySelected = countriesData[row]
    }
}
