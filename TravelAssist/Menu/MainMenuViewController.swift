//
//  MainMenuViewController.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 07.07.2021.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var setCountryPickerView: UIPickerView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var factsTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var latestNewsLabel: UILabel!
    
    var japanFactsData: [FactCellData] = [
        FactCellData(id: 0, factText: "В состав Японии входит более 6 800 островов. Самые крупные из них – это Хоккайдо, Хонсю, Сикоку и Кюсю."),
        FactCellData(id: 1, factText:"Ежегодно в Японии случается около 1,5 тысячи землетрясений. Одно из самых разрушительных за всю историю страны произошло в марте 2011 года. Оно вызвало цунами, которое унесло жизни 15 869 человек."),
        FactCellData(id: 2, factText:"Япония и Россия до сих пор не разрешили спор относительно принадлежности Курильских островов. Эта дискуссия длится уже более 70 лет, с момента окончания Второй мировой войны."),
        FactCellData(id: 3, factText:"Около 1 млн японцев являются \"хикикомори\", то есть людьми, добровольно отказавшимися от социальной жизни. Они сознательно выбирают уединение, руководствуясь разными личными и социальными причинами."),
        FactCellData(id: 4, factText:"Большинство улиц в Японии не имеют названия. В качестве адресов используются номера кварталов.")
    ]
    
    var japanNewsData: [SingleNewsData] = [
        SingleNewsData(id: 0, singleNewsText: "Заместитель исполнительного директора оргкомитета летних Олимпийских игр в Токио Хидэнори Судзуки прослезился, извиняясь за проведение соревнований без зрителей."),
        SingleNewsData(id: 1, singleNewsText: "В период с 12 июля по 22 августа в Токио японские власти вводят режим ЧС из-за ситуации с коронавирусной инфекцией, заявил министр по восстановлению экономики Японии Ясутоси Нисимура. Таким образом, режим чрезвычайной ситуации охватывает время проведения Олимпиады в столице Японии."),
        SingleNewsData(id: 2, singleNewsText: "В Росавиации сообщили, что «в целях обеспечения перевозки Олимпийской делегации Российской Федерации на период с 19 июля по 6 августа 2021 года временно увеличивается частота регулярных полётов в государство Япония по маршрутам Владивосток — Токио — Владивосток с семи до десяти рейсов в неделю и Хабаровск — Токио — Хабаровск с частотой два рейса в неделю»."),
        SingleNewsData(id: 3, singleNewsText: "В Токио начались выборы в законодательное собрание столичной префектуры, голосование продлится до 20:00."),
        SingleNewsData(id: 4, singleNewsText: "Оползень, сошедший в японском городе Атами, мог уничтожить, согласно предварительным оценкам, примерно 80 домов.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        factsTableView.dataSource = self
        factsTableView.delegate = self
        
        factsTableView.estimatedRowHeight = 140
        factsTableView.rowHeight = UITableView.automaticDimension
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsTableView.estimatedRowHeight = 140
        newsTableView.rowHeight = UITableView.automaticDimension
        
        topImageView.layer.cornerRadius = 24
    }
    
    @IBAction func setCounrtyActionButtion(_ sender: UIButton) {
        showMiracle()
    }
    
    @objc func showMiracle() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
}

extension MainMenuViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MainMenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

extension MainMenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
                
        if tableView == factsTableView {
            count = japanFactsData.count
        } else if tableView == newsTableView {
            count = japanNewsData.count
        }
                
        return count!

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == factsTableView{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FactTableViewCell", for: indexPath)
                    as? FactTableViewCell else { return UITableViewCell() }
            cell.setData(factCellData: japanFactsData[indexPath.row])
            
            var frame = factsTableView.frame // Следующие 3 строчки делают динамичную высоту таблицы в зависимости от количества ячеек и их высоты
            frame.size.height = factsTableView.contentSize.height
            factsTableView.frame = frame
            
            if indexPath.row == japanFactsData.count - 1{
                let factsTableViewFrameMaxY = factsTableView.frame.maxY
                ChangeUILabelPosition(xCoord: 8.0, yCoord: factsTableViewFrameMaxY, label: latestNewsLabel)
            }
            
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath)
                    as? NewsTableViewCell else { return UITableViewCell() }
            cell.setData(singleNews: japanNewsData[indexPath.row])
            
            var frame = newsTableView.frame   // Следующие 3 строчки делают динамичную высоту таблицы в зависимости от количества ячеек и их высоты
            frame.size.height = newsTableView.contentSize.height
            newsTableView.frame = frame
            
            if indexPath.row == japanNewsData.count - 1{
                let latestNewsLabelFrameMaxY = latestNewsLabel.frame.maxY
                ChangeUITableViewPosition(xCoord: 8.0, yCoord: latestNewsLabelFrameMaxY, tableView: newsTableView)
                
                scrollViewHeightConstraint.constant = newsTableView.frame.maxY
                mainScrollView.layoutIfNeeded()
            }
            
            return cell
        }
    }
}



struct FactCellData{
    let id: Int
    var factText: String
}

struct SingleNewsData{
    let id: Int
    var singleNewsText: String
}

func ChangeUILabelPosition(xCoord: CGFloat, yCoord: CGFloat, label: UILabel){ // Меняет координаты UILabel
    var frame: CGRect = label.frame
    frame.origin.y = yCoord //pass the Y cordinate
    frame.origin.x = xCoord //pass the X cordinate
    label.frame = frame
}

func ChangeUITableViewPosition(xCoord: CGFloat, yCoord: CGFloat, tableView: UITableView){
    var frame = tableView.frame
    frame.origin.y = yCoord
    frame.origin.x = xCoord //pass the X cordinate
    tableView.frame = frame
}
