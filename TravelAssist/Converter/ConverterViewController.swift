//
//  ConverterViewController.swift
//  TravelAssist
//
//  Created by Илья on 06.07.2021.
//

import UIKit

class ConverterViewController: UIViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
    // MARK - IBOOutlets
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerViewFrom: UIPickerView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var resultTextLabel: UILabel!
    
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    var pastCurrency = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewFrom.delegate = self
        pickerViewFrom.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchJSON()
        textField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    
    @objc func updateViews(input: Double) {
        guard let amountText = textField.text, let theAmountText = Double(amountText) else { return }
        if textField.text != "" {
            let total = (theAmountText * activeCurrency) / pastCurrency
            resultTextLabel.text = String(format: "%.2f", total)
        }
    }
    
    //Funcs
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewFrom {
            pastCurrency = values[row]
            updateViews(input: pastCurrency)
        } else {
            activeCurrency = values[row]
            updateViews(input: activeCurrency)
        }
    }
    
    //Функция Декода Джейсона
    func fetchJSON() {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/48ec7323890f02ef34cd3f05/latest/USD") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let safeData = data else { return }
            
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                self.currencyCode.append(contentsOf: results.conversion_rates.keys)
                self.values.append(contentsOf: results.conversion_rates.values)
                DispatchQueue.main.async {
                    self.pickerViewFrom.reloadAllComponents()
                    self.pickerView.reloadAllComponents()
                    
                }
            } catch {
                print(error)

            }
        }.resume()
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
