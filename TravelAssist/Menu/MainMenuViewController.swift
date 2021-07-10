//
//  MainMenuViewController.swift
//  TravelAssist
//
//  Created by Arslan Rashidov on 07.07.2021.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var factsTextLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var factsTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var latestNewsLabel: UILabel!
    
    var factsData: [FactCellData]?
    var newsData: [SingleNewsData]?
    
    var countriesData: [String] = [
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
        
        
        if UserDefaults.standard.string(forKey: "selectedCountry") == nil{
            print(1)
            factsData = getFactsData(country: "Япония")
            newsData = getNewsData(country: "Япония")
            countriesData.sort()
            UserDefaults.standard.set("Япония", forKey: "selectedCountry")
            UserDefaults.standard.set(countriesData, forKey:"countriesData")
        } else{
            print(UserDefaults.standard.string(forKey: "selectedCountry")!)
            let country: String = UserDefaults.standard.string(forKey: "selectedCountry")!
            let correctForm: String = getWelcomeCorrectForm(country: country)
            if country == "Франция"{
                welcomeTextLabel.text = "Добро пожаловать во \(correctForm)!"
            } else{
                welcomeTextLabel.text = "Добро пожаловать в \(correctForm)!"
            }
            
            let imageName: String = getImageName(country: country)
            topImageView.image = UIImage(named: imageName)
            factsData = getFactsData(country: UserDefaults.standard.string(forKey: "selectedCountry")!)
            newsData = getNewsData(country: UserDefaults.standard.string(forKey: "selectedCountry")!)
        }
        
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
        
        slideVC.delegate = self
    }
}

extension MainMenuViewController: EditEndDelegate{
    func onCompleteButton(country: String) {
        factsData = getFactsData(country: country)
        newsData = getNewsData(country: country)
        
        factsTableView.reloadData()
        
        factsTableView.estimatedRowHeight = 140
        factsTableView.rowHeight = UITableView.automaticDimension
        
        newsTableView.reloadData()
        
        newsTableView.estimatedRowHeight = 140
        newsTableView.rowHeight = UITableView.automaticDimension
        
        
        let correctForm: String = getWelcomeCorrectForm(country: country)
        if country == "Франция"{
            welcomeTextLabel.text = "Добро пожаловать во \(correctForm)!"
        } else{
            welcomeTextLabel.text = "Добро пожаловать в \(correctForm)!"
        }
        
        
        let imageName: String = getImageName(country: country)
        topImageView.image = UIImage(named: imageName)
        topImageView.layer.cornerRadius = 24
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
            count = factsData?.count
        } else if tableView == newsTableView {
            count = newsData?.count
        }
        return count!

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == factsTableView{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FactTableViewCell", for: indexPath)
                    as? FactTableViewCell else { return UITableViewCell() }
            cell.setData(factCellData: factsData![indexPath.row])
            
            var frame = factsTableView.frame // Следующие 3 строчки делают динамичную высоту таблицы в зависимости от количества ячеек и их высоты
            frame.size.height = factsTableView.contentSize.height
            factsTableView.frame = frame
            factsTableView.layoutIfNeeded()
            
            if indexPath.row == factsData!.count - 1{
                let factsTableViewFrameMaxY = factsTableView.frame.maxY
                ChangeUILabelPosition(xCoord: 8.0, yCoord: factsTableViewFrameMaxY, label: latestNewsLabel)
                latestNewsLabel.layoutIfNeeded()
                
                print("latestNewsLabel - \(factsTableView.frame.maxY)")
            }
            
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath)
                    as? NewsTableViewCell else { return UITableViewCell() }
            cell.setData(singleNews: newsData![indexPath.row])
            
            var frame = newsTableView.frame   // Следующие 3 строчки делают динамичную высоту таблицы в зависимости от количества ячеек и их высоты
            frame.size.height = newsTableView.contentSize.height
            newsTableView.frame = frame
            newsTableView.layoutIfNeeded()
            
            if indexPath.row == newsData!.count - 1{
                let latestNewsLabelFrameMaxY = latestNewsLabel.frame.maxY
                ChangeUITableViewPosition(xCoord: 8.0, yCoord: latestNewsLabelFrameMaxY, tableView: newsTableView)
                newsTableView.layoutIfNeeded()
                
                print("newsTableView - \(latestNewsLabel.frame.maxY)")
               
                scrollViewHeightConstraint.constant = newsTableView.frame.maxY
                mainScrollView.layoutIfNeeded()
                
                print("scrollViewHeightConstraint - \(newsTableView.frame.maxY)")
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





func getFactsData(country: String) -> [FactCellData] {
    var factsData: [FactCellData]
    
    switch country {
        case "Япония":
            factsData = [
                FactCellData(id: 0, factText: "В состав Японии входит более 6 800 островов. Самые крупные из них – это Хоккайдо, Хонсю, Сикоку и Кюсю."),
                FactCellData(id: 1, factText:"Ежегодно в Японии случается около 1,5 тысячи землетрясений. Одно из самых разрушительных за всю историю страны произошло в марте 2011 года. Оно вызвало цунами, которое унесло жизни 15 869 человек."),
                FactCellData(id: 2, factText:"Япония и Россия до сих пор не разрешили спор относительно принадлежности Курильских островов. Эта дискуссия длится уже более 70 лет, с момента окончания Второй мировой войны."),
                FactCellData(id: 3, factText:"Около 1 млн японцев являются \"хикикомори\", то есть людьми, добровольно отказавшимися от социальной жизни. Они сознательно выбирают уединение, руководствуясь разными личными и социальными причинами."),
                FactCellData(id: 4, factText:"Большинство улиц в Японии не имеют названия. В качестве адресов используются номера кварталов.")
            ]
        case "Соединенные Штаты Америки":
            factsData = [
                FactCellData(id: 0, factText:"В стране отсутствует государственный язык."),
                FactCellData(id: 1, factText:"На сегодняшний день около 10% американских граждан нигде не работают и даже не пытаются трудоустроиться. И это объяснимо: пособие по безработице примерно равно минимальному жалованью."),
                FactCellData(id: 2, factText:"Более 60% американцев не могут найти на карте мира Ирак. Еще хуже дела обстоят с Афганистаном. Где находится эта страна, не знают 9 из 10 жителей Штатов."),
                FactCellData(id: 3, factText:"Символ США – Статуя Свободы – является подарком от Франции."),
                FactCellData(id: 4, factText:"В Штатах есть памятник четырех углов, который установлен в уникальном месте – на пересечении сразу четырех американских штатов – Юты, Колорадо, Нью-Мексико и Аризоны.")
            ]
        case "Швейцария":
            factsData = [
                FactCellData(id: 0, factText:"Только две страны в мире имеют квадратный флаг – Швейцария и Ватикан."),
                FactCellData(id: 1, factText:"Швейцария не управляется единолично. В стране работает исполнительный совет из семи членов, который и является коллективным главой государства. Из членов совета избирается президент сроком на один год, который рассматривается как primus inter pares – первый среди равных."),
                FactCellData(id: 2, factText:" Швейцария является одним из лучших мест в мире, чтобы родиться, жить и быть счастливым. Страна в целом и ее города занимают топ-места в различных глобальных рейтингах качества жизни."),
                FactCellData(id: 3, factText:"В Швейцарии 1500 озер, самым большим из которых является Женевское. По слухам, на его дне покоится более 40 затонувших кораблей."),
                FactCellData(id: 4, factText:"В Швейцарии труд учителя хорошо оплачивается. Местные учителя получают в среднем 68 тыс. долларов США в год, что является самым высоким показателем среди стран ОЭСР.")
            ]
        case "Франция":
            factsData = [
                FactCellData(id: 0, factText:"Во Франции существуют определённые лимиты для радио и телевидения, которые выделяются на иностранные фильмы, музыку и т.п. Превышать их нельзя — основная масса всего этого должна быть французской."),
                FactCellData(id: 1, factText:"По воскресеньям все магазины во Франции закрыты."),
                FactCellData(id: 2, factText:"Франция импортирует много лягушек, занимая по этому параметру первое место в мире."),
                FactCellData(id: 3, factText:"Парижские полицейские иногда ездят на роликовых коньках."),
                FactCellData(id: 4, factText:"Законы Франции позволяют сочетаться браком с человеком, который уже умер. Правда, для этого требуется разрешение президента страны.")
            ]
        case "Германия":
            factsData = [
                FactCellData(id: 0, factText:"Германия имеет границы сразу с девятью странами - Польшей, Австрией, Люксембургом, а также Францией, Швейцарией, Бельгией, Данией, Нидерландами и Чехией."),
                FactCellData(id: 1, factText:"Германия стала первой среди европейских стран, которая перешла на летнее время ради экономии электроэнергии. Это произошло 30 апреля 1916 года, в разгар Первой Мировой войны."),
                FactCellData(id: 2, factText:"В Германии насчитывается более 30 диалектов, которые делятся на три основных типа - верхненемецкий, нижненемецкий и средненемецкий. Их различие настолько сильно, что немцы с юга не могут понять немцев с севера."),
                FactCellData(id: 3, factText:"Самым большим пивным фестивалем в мире считается Октоберфест, который ежегодно проходит в Мюнхене. Его посещают около 6 млн туристов со всех уголков земного шара."),
                FactCellData(id: 4, factText:"Большинство таксистов в этой стране ездят на автомобилях Mercedes.")
            ]
        case "Испания":
            factsData = [
                FactCellData(id: 0, factText:"В Испании 45 объектов, которые попали в список всемирного наследия ЮНЕСКО. Среди них работы Антонио Гауди, наскальные рисунки, пальмовый лес в Эльче, башня Геркулеса и многое другое."),
                FactCellData(id: 1, factText:"У испанцев особое отношение к браку, процент разводов составляет всего 17. При этом только 5% детей рождается и воспитывается в семьях с одним родителем."),
                FactCellData(id: 2, factText:"Испанская рождественская лотерея имеет самый большой призовой фонд в мире. По состоянию на 2017 год она имеет джекпот размером 720 млн евро и общую призовую выплату суммой 2,3 миллиарда евро."),
                FactCellData(id: 3, factText:"Мадрид - официальная столица Испании. Кроме этого он - географический центр страны. В столице находится площадь Пуэрта-дель-Соль, которая является также центром государства и испанской радиальной дорожной системой."),
                FactCellData(id: 4, factText:"Испания считается одной из самых лучших стран для пляжного отдыха. Если сложить протяженность всех пляжей, то получится целых 8 тысяч километров!")
            ]
        case "Италия":
            factsData = [
                FactCellData(id: 0, factText:"Италию моря омывают сразу с трех сторон - на западе Тирренское и Лигурийское, с восточной стороны - Адриатическое, а с южной - Ионическое и Средиземное."),
                FactCellData(id: 1, factText:"На территории Италии находится самое большое количество вулканов среди европейских стран. Чего только один Везувий стоит!"),
                FactCellData(id: 2, factText:"Италия признана страной, где заключаются самые крепкие браки. Еще бы, ведь бракоразводный процесс в этой стране занимает от трех лет!"),
                FactCellData(id: 3, factText:"Болонский университет в Италии является старейшим в Европе. Он был основан в 1088 году и никогда не прекращал работу."),
                FactCellData(id: 4, factText:"Итальянцы используют в своей речи более 250 жестов руками. Активная жестикуляция связана с различиями в диалектах и эмоциональностью жителей этой страны.")
            ]
        case "Турция":
            factsData = [
                FactCellData(id: 0, factText:"На протяжении всей истории территория, на которой расположена Турция в наше время, принадлежала разным государствам - Персии, Риму, Византии, Армении."),
                FactCellData(id: 1, factText:"Крупнейший город в Турции - Стамбул (он же назывался Константинополем). Он был основан в 667 году до нашей эры и являлся центром четырех империй - Римской, Латинской, Византийской и Османской."),
                FactCellData(id: 2, factText:"Голландские тюльпаны на самом деле были завезены в Европу из Турции в XVI веке. Османская империя считалась мировым центром культивирования тюльпанов с XV века."),
                FactCellData(id: 3, factText:"В Турции очень любят пить чай, даже больше, чем в Великобритании. Согласно исследованиям 2004 года, на одного турка приходится 2,5 кг чая, а на англичанина 2,1 кг."),
                FactCellData(id: 4, factText:"Турецкий кофе знаменит на весь мир, неудивительно, что в Турции очень трепетно относятся к этому напитку. Первая кофейня появилась в середине XVI с подачи тогдашнего правителя - султана Сулеймана Великолепного, который был в восторге от напитка.")
            ]
        case "Португалия":
            factsData = [
                FactCellData(id: 0, factText:"В Португалии находится самая западная точка Европы – мыс Рока, на 140 метров возвышающийся над гладью Атлантического океана."),
                FactCellData(id: 1, factText:"Первое упоминание о Португалии датируется 868 годом."),
                FactCellData(id: 2, factText:"На территории Португалии производят знаменитое крепленое вино «Портвейн»."),
                FactCellData(id: 3, factText:"Португалия, великая колониальная держава, на полвека раньше Испании, Франции и Великобритании выступила за отмену рабства. Произошло это в 1761 году."),
                FactCellData(id: 4, factText:"В Лиссабоне расположен самый длинный мост Европы – протяженность моста Васко да Гамы составляет 17 185 метров.")
            ]
        case "Великобритания":
            factsData = [
                FactCellData(id: 0, factText:"Форма правления на острове - парламентарная монархия. Это значит, правительство избирается гражданами и обладает большей властью, чем монарх, роль которого больше - представительная. Глава правительства - премьер-министр."),
                FactCellData(id: 1, factText:"В Уэльсе, Шотландии и Северной Ирландии также есть местное правительство, которое отвечает за внутреннюю политику и дела в сферах здоровья, образования, культуры, транспорта, окружающей среды."),
                FactCellData(id: 2, factText:"Известные музыканты из Великобритании: The Beatles, Queen, Led Zeppelin, Rolling Stones, The Sex Pistols, Radiohead, Coldplay, Pink Floyd."),
                FactCellData(id: 3, factText:"На английском языке говорит более 70% жителей Соединенного королевства. Также на острове говорят на других языках: валлийский (Уэльс), шотландский гэльский и англо-шотландский (Шотландия), ирландский и ольстерско-шотландский (Ирландия)."),
                FactCellData(id: 4, factText:"Ирландцы, шотландцы и валлийцы очень гордятся своими странами и корнями и не любят, когда их называют британцами. И уж тем более не совершите ошибку, назвав их англичанами.")
            ]
        default:
            factsData = [
                FactCellData(id: 0, factText:"Error"),
                FactCellData(id: 1, factText:""),
                FactCellData(id: 2, factText:""),
                FactCellData(id: 3, factText:""),
                FactCellData(id: 4, factText:"")
            ]
    }
    return factsData
}

func getNewsData(country: String) -> [SingleNewsData]{
    var newsData: [SingleNewsData]
    
    switch country{
        case "Япония":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Заместитель исполнительного директора оргкомитета летних Олимпийских игр в Токио Хидэнори Судзуки прослезился, извиняясь за проведение соревнований без зрителей."),
                SingleNewsData(id: 1, singleNewsText: "В период с 12 июля по 22 августа в Токио японские власти вводят режим ЧС из-за ситуации с коронавирусной инфекцией, заявил министр по восстановлению экономики Японии Ясутоси Нисимура. Таким образом, режим чрезвычайной ситуации охватывает время проведения Олимпиады в столице Японии."),
                SingleNewsData(id: 2, singleNewsText: "В Росавиации сообщили, что «в целях обеспечения перевозки Олимпийской делегации Российской Федерации на период с 19 июля по 6 августа 2021 года временно увеличивается частота регулярных полётов в государство Япония по маршрутам Владивосток — Токио — Владивосток с семи до десяти рейсов в неделю и Хабаровск — Токио — Хабаровск с частотой два рейса в неделю»."),
                SingleNewsData(id: 3, singleNewsText: "В Токио начались выборы в законодательное собрание столичной префектуры, голосование продлится до 20:00."),
                SingleNewsData(id: 4, singleNewsText: "Оползень, сошедший в японском городе Атами, мог уничтожить, согласно предварительным оценкам, примерно 80 домов.")
            ]
        case "Соединенные Штаты Америки":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Число погибших в результате обрушения многоэтажного дома в американском штате Флорида увеличилось до 86."),
                SingleNewsData(id: 1, singleNewsText: "Грузовой корабль Dragon американской компании SpaceX приводнился недалеко от побережья штата Флорида."),
                SingleNewsData(id: 2, singleNewsText: "Жители Гаити собираются у посольства США в районе Табарр столичного округа Порт-о-Пренс, чтобы просить об убежище после убийства президента страны Жовенеля Моиза."),
                SingleNewsData(id: 3, singleNewsText: "США продолжат консультироваться с Францией по поводу «вызовов со стороны России» в Европе, заявил глава Пентагона Ллойд Остин."),
                SingleNewsData(id: 4, singleNewsText: "Санкции США против ряда российских компаний являются конфронтационным шагом, заявил посол России в США Анатолий Антонов.")
            ]
        case "Швейцария":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Бывший президент Международной федерации лыжного спорта (FIS) Джанфранко Каспер скончался на 78-м году жизни."),
                SingleNewsData(id: 1, singleNewsText: "Швейцарский теннисист Роджер Федерер потерпел поражение от поляка Хуберта Хуркача в матче 1/4 финала третьего в сезоне теннисного турнира Большого шлема — Уимблдона."),
                SingleNewsData(id: 2, singleNewsText: "Сборная Швейцарии по пляжному футболу заменит команду Украины на чемпионате мира 2021 года в Москве."),
                SingleNewsData(id: 3, singleNewsText: "Главный тренер сборной Швейцарии Владимир Петкович может возглавить национальную команду России."),
                SingleNewsData(id: 4, singleNewsText: "Полузащитник сборной Италии по футболу Мануэль Локателли признан лучшим игроком матча второго тура группового этапа чемпионата Европы со Швейцарией.")
            ]
        case "Франция":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Продавец, ставший жертвой нападения, которое было совершено во французской коммуне Кле-Суйи, умер от ножевых ранений."),
                SingleNewsData(id: 1, singleNewsText: "США продолжат консультироваться с Францией по поводу «вызовов со стороны России» в Европе, заявил глава Пентагона Ллойд Остин."),
                SingleNewsData(id: 2, singleNewsText: "Тесты заболевших во Франции показали, что штамм «дельта» стал доминирующим во всех регионах Франции."),
                SingleNewsData(id: 3, singleNewsText: "Россиянина Александра Винника должны освободить из французской тюрьмы 21 августа, сообщила его мать Вера Винник."),
                SingleNewsData(id: 4, singleNewsText: "Российский истребитель Су-27 поднимался для сопровождения самолёта-разведчика Atlantique 2 ВВС Франции над Балтийским морем. Об этом сообщили в Минобороны России.")
            ]
        case "Германия":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Российский футбольный союз (РФС) в приоритетном порядке рассматривает специалиста из Германии на должность главного тренера сборной России."),
                SingleNewsData(id: 1, singleNewsText: "Главный тренер грозненского «Ахмата» Андрей Талалаев прокомментировал переход бывшего вратаря петербургского «Зенита» в немецкий «Байер»."),
                SingleNewsData(id: 2, singleNewsText: "Немецкий футбольный клуб «Байер» официально объявил о трансфере российского экс-вратаря «Зенита» Андрея Лунёва."),
                SingleNewsData(id: 3, singleNewsText: "Имеющиеся между Украиной и Германией разногласия по поводу «Северного потока — 2» могут быть улажены путём предоставления Киеву компенсации в случае утраты роли транзитёра газа."),
                SingleNewsData(id: 4, singleNewsText: "Бывший главный тренер сборной Нидерландов Луи ван Гал высказал мнение о национальных командах Португалии, Франции и Германии, вылетевших с чемпионата Европы по футболу.")
            ]
        case "Испания":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Защитник и капитан сборной по футболу Италии Джорджо Кьеллини сравнил соперника по финале чемпионата Европы, национальную команду Англии со сборной Испании, которую итальянцы победили в 1/2 финала."),
                SingleNewsData(id: 1, singleNewsText: "Глава испанской Ла Лиги Хавьер Тебас высказал мнение о ситуации с контрактом аргентинского форварда Лионеля Месси и каталонского клуба «Барселона»."),
                SingleNewsData(id: 2, singleNewsText: "Мадридский футбольный клуб «Атлетико» объявил о продлении контракта с главным тренером команды Диего Симеоне."),
                SingleNewsData(id: 3, singleNewsText: "Два российских бомбардировщика Су-24 в четверг, 8 июля, выполнили плановый полёт над нейтральными водами Балтийского моря, не нарушая границ других государств."),
                SingleNewsData(id: 4, singleNewsText: "Пресс-конференция с участием премьера Испании Педро Санчеса и президента Литвы Гитанаса Науседы на базе НАТО была прервана из-за сигнала о тревоге.")
            ]
        case "Италия":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Нападающий сборной Италии по футболу Федерико Кьеза признан лучшим игроком полуфинального матча чемпионата Европы по футболу с Испанией."),
                SingleNewsData(id: 1, singleNewsText: "Италия обыграла Испанию в серии пенальти первого полуфинала Евро-2020. Основное и дополнительное время матча закончилось вничью. Точными ударами во втором тайме отметились Федерико Кьеза и Альваро Мората. Последний позднее стал антигероем «лотереи», позволив Джанлуиджи Доннарумме парировать свой удар. RT вёл текстовую трансляцию из Лондона со стадиона «Уэмбли»."),
                SingleNewsData(id: 2, singleNewsText: "Сборная Италии одержала победу над командой Испании в полуфинальном матче чемпионата Европы по футболу."),
                SingleNewsData(id: 3, singleNewsText: "Нападающий сборной Италии по футболу Федерико Кьеза обошёл своего отца по количеству забитых мячей на чемпионатах Европы."),
                SingleNewsData(id: 4, singleNewsText: "Италия и Испания в первом тайме полуфинального матча Евро-2020 нанесли на двоих всего один удар в створ.")
            ]
        case "Турция":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "205 лет назад родился выдающийся российский военный деятель и дипломат Дмитрий Милютин, который провёл в армии Российской империи реформы, позволившие вывести её на качественно новый уровень и одержать победу в Русско-турецкой войне 1877—1878 годов. Эксперты называют Дмитрия Милютина одним из лучших руководителей оборонного ведомства в истории Российской империи."),
                SingleNewsData(id: 1, singleNewsText: "Глава Пентагона Ллойд Остин обсудил с министром обороны Турции Хулуси Акаром по телефону вопросы двустороннего сотрудничества между странами и вывод американских войск из Афганистана."),
                SingleNewsData(id: 2, singleNewsText: "МИД Турции выразил соболезнования родственникам погибших при крушении пассажирского самолёта на Камчатке."),
                SingleNewsData(id: 3, singleNewsText: "Вице-президент Российского союза туриндустрии Юрий Барзыкин в беседе с RT прокомментировал сообщение Росавиации об увеличении числа городов, из которых возобновят рейсы в Турцию."),
                SingleNewsData(id: 4, singleNewsText: "В Турции ввели свыше 50 млн доз вакцин против коронавирусной инфекции COVID-19, заявил турецкий лидер Реджеп Тайип Эрдоган.")
            ]
        case "Португалия":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "В Португалии за сутки зарегистрировали 2605 случаев инфицирования COVID-19, это самое высокое число выявленных заболеваний с февраля этого года."),
                SingleNewsData(id: 1, singleNewsText: "Полузащитник сборной Бельгии Торган Азар рассказал о своём победном голе в матче 1/8 финала чемпионата Европы по футболу с национальной командой Португалии."),
                SingleNewsData(id: 2, singleNewsText: "Союз европейских футбольных ассоциаций (УЕФА) определил обладателя награды лучшему игроку матча 1/8 финала Евро-2020 между сборными Бельгии и Португалии."),
                SingleNewsData(id: 3, singleNewsText: "Нападающий сборной Португалии Криштиану Роналду забил свой четвёртый мяч на чемпионате Европы — 2020."),
                SingleNewsData(id: 4, singleNewsText: "Главный тренер сборной Португалии Фернанду Сантуш поделился ожиданиями от матча третьего тура группового этапа чемпионата Европы по футболу — 2020 с национальной командой Франции.")
            ]
        case "Великобритания":
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "В Великобритании за сутки коронавирусную инфекцию COVID-19 выявили у 32 367 человек."),
                SingleNewsData(id: 1, singleNewsText: "Власти Великобритании в ближайшие две недели могут отменить карантин для туристов, вакцинированных от COVID-19. Об этом заявил глава Минтранса Соединённого Королевства Грант Шаппс."),
                SingleNewsData(id: 2, singleNewsText: "Пресс-секретарь российского лидера Дмитрий Песков сообщил, что в настоящее время Москва и Лондон не ведут консультации по вопросу прохода кораблей в Чёрном море."),
                SingleNewsData(id: 3, singleNewsText: "ВМС Великобритании продолжат заходить в «территориальные воды Украины», заявил глава МИД страны Доминик Рааб, комментируя инцидент с эсминцем Defender."),
                SingleNewsData(id: 4, singleNewsText: "Соединённые Штаты и Британия во время провокации с эсминцем Defender в Чёрном море пытались вскрыть систему береговой обороны России, рассказал замглавы российского МИД Сергей Рябков.")
            ]
        default:
            newsData = [
                SingleNewsData(id: 0, singleNewsText: "Error"),
                SingleNewsData(id: 1, singleNewsText: ""),
                SingleNewsData(id: 2, singleNewsText: ""),
                SingleNewsData(id: 3, singleNewsText: ""),
                SingleNewsData(id: 4, singleNewsText: "")
            ]
    }
    return newsData
}

func getWelcomeCorrectForm(country: String) -> String{
    switch country{
        case "Япония":
            return "Японию"
        case "Соединенные Штаты Америки":
            return "Соединенные Штаты Америки"
        case "Швейцария":
            return "Швейцарию"
        case "Франция":
            return "Францию"
        case "Германия":
            return "Германию"
        case "Испания":
            return "Испанию"
        case "Италия":
            return "Италию"
        case "Турция":
            return "Турцию"
        case "Португалия":
            return "Португалию"
        case "Великобритания":
            return "Великобританию"
        default:
            return "Error"
    }
}

func getImageName(country: String) -> String{
    switch country{
        case "Япония":
            return "Japan Image"
        case "Соединенные Штаты Америки":
            return "USA Image"
        case "Швейцария":
            return "Switzerland Image"
        case "Франция":
            return "France Image"
        case "Германия":
            return "Germany Image"
        case "Испания":
            return "Spain Image"
        case "Италия":
            return "Italy Image"
        case "Турция":
            return "Turkey Image"
        case "Португалия":
            return "Portugal Image"
        case "Великобритания":
            return "Britain Image"
        default:
            return "Error"
    }
}
