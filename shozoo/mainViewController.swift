//
//  mainViewController.swift
//  shozoo
//
//  Created by ichinose-PC on 2025/02/17.
//

import Foundation
import UIKit
import CoreBluetooth
import RealmSwift
import Alamofire

enum AnimalName: String, CaseIterable
{
	case bird = "bird"
	case cat = "cat"
	case dog = "dog"
	case frog = "frog"
	
	static var allCases: [AnimalName] {
		return [.bird, .cat, .dog, .frog]
	}
}

class mainViewController: UIViewController,BLEManagerDelegate
{
    let realm = try! Realm()
    
    @IBOutlet weak var counter: UILabel!
    
    @IBOutlet weak var animalImg: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let data = realm.objects(animals.self)
            print("data:\(data)")
        
        BLEManager.shared.delegate = self

        
        if (!BLEManager.shared.isConnected)
        {
            showBLEConnectScreen()
        }
    }
    
    func showBLEConnectScreen()
    {
        if let BLEConnectVC = self.storyboard?.instantiateViewController(withIdentifier: "BLEConnectVC")
        {
            self.navigationController?.pushViewController(BLEConnectVC, animated: false)
        }

    }
    
    func bleManagerDidDisconnectPeripheral(bleManager: BLEManager)
    {

        if let disConnectVC = self.storyboard?.instantiateViewController(withIdentifier: "disConnectVC")
        {

            self.navigationController?.pushViewController(disConnectVC, animated: true)
        }
    }

    func bleManagerDidUpdateValue(bleManager: BLEManager, characteristic: CBCharacteristic, data: Data)
    {
            print("ok")
            if let receivedString = String(data: data, encoding: .utf8) {
                print("Micro:bitからのデータ: \(receivedString)")
                
                let animalsName = receivedString
                
                var calendar = Calendar(identifier: .gregorian)
                let timeZone = TimeZone(identifier: "Asia/Tokyo")!
                calendar.timeZone = timeZone
                
                let today = calendar.startOfDay(for: Date())
                
				var stepCount = 0
				
                if let existingAnimal = realm.objects(animals.self).filter("name == %@ AND date == %@", animalsName, today).first
                {
                    print("データあり")
                    do
                    {
                        try realm.write
                        {
                            existingAnimal.count += 1
                        }
                        if let tabBarController = self.tabBarController,
                        tabBarController.selectedIndex == 0
                        {
                            DispatchQueue.main.async
                            {
                                self.counter.text = "\(existingAnimal.count)"
                                self.animalImg.image = UIImage(named: "\(existingAnimal.name)_icon")
                            }
                        }
						stepCount = existingAnimal.count
                        
                    }
                    catch
                    {
                        print("書き込みエラー:\(error)")
                    }
                }
                else
                {
                    let animals = animals()
                    animals.name = animalsName
                    animals.count = 1
                    animals.date = today
                    counter.text = "\(animals.count)"
                    animalImg.image = UIImage(named: "\(animals.name)_icon")
                    
                    try! realm.write
                    {
                        realm.add(animals)
                    }
                    if let tabBarController = self.tabBarController,
                    tabBarController.selectedIndex == 0
                    {
                        self.counter.text = "\(animals.count)"
                        self.animalImg.image = UIImage(named: "\(animals.name)_icon")
                    }
                    
					stepCount = animals.count
                }
				
				if let animal = AnimalName(rawValue: animalsName)
				{
				   let index = AnimalName.allCases.firstIndex(of: animal) ?? -1
					
					if (index != -1)
					{
						self.uploadSpreadSheet(number: index + 1, stepCount: stepCount)
					}
				}
				
            }
            let data = realm.objects(animals.self)
            print("data:\(data)")
    }
	
	func uploadSpreadSheet(number:Int, stepCount:Int)
	{
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ja_JP")
		dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
		
		let now = Date()
		
		dateFormatter.dateFormat = "yyyy/MM/dd"
		let dateString = dateFormatter.string(from: now)
		dateFormatter.dateFormat = "HH:ss"
		let timeString = dateFormatter.string(from: now)
		
		AF.request("https://script.google.com/macros/s/AKfycbwAJkd0ppdoJpbxjt1bO3M_JcODQRumYODLXZUkF4s0mBJos_S15mWv6Sd8TYeqbq4/exec",
				   method: .post,
				   parameters: [
					"users": [
						[
						"date": dateString,
						"id": String(format: "%04d", number),
						"lastupdate": timeString,
						"stepcount": stepCount.description,
						"status": "1"
						]
					]
				   ],
				   encoding: JSONEncoding.default
		)
		.response { data in
			
			print(data.result)
			
			
		}
	}
}
