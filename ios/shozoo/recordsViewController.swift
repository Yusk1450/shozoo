import Foundation
import UIKit
import CoreBluetooth
import RealmSwift

class recordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var data: Results<animals>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        // realmからデータを取得
        data = realm.objects(animals.self)
        
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Basic-Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        let animal = data[indexPath.row]
        
        let iconView = cell!.viewWithTag(1) as? UIImageView
        let dateLbl = cell!.viewWithTag(2) as? UILabel
        let countLbl = cell!.viewWithTag(3) as? UILabel
        
        iconView?.image = UIImage(named: "\(animal.name)_icon")
        print(animal.self)

        let Formatter = DateFormatter()
        Formatter.dateStyle = .short
        dateLbl?.text = Formatter.string(from: animal.date)
        
        countLbl?.text = "\(animal.count)"
        
        return cell!
    }
}
