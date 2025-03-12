//
//  ViewController.swift
//  shozoo
//
//  Created by ichinose-PC on 2025/02/10.
//

import UIKit
import CoreBluetooth

class BLEConnectViewController: UIViewController,BLEManagerDelegate,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var Lbl: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    var bleArray = [String]()
    var BLEitems = [CBPeripheral]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        BLEManager.shared.delegate = self
        BLEManager.shared.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        
    }
    
    func bleManagerFoundPeripheral(bleManager: BLEManager, peripheral: CBPeripheral)
    {
        print("見つかったBLEデバイス:\(peripheral.name ?? "Unknown Device")")
        let selectedDevice = peripheral.name ?? "Unknown Device"
        
        if !bleArray.contains(selectedDevice)
        {
            bleArray.append(selectedDevice)
            BLEitems.append(peripheral)
            tableview.reloadData()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) ->Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "Basic-Cell"
        //再利用するcellがあったら
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        //なかったら
        if (cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        let deviceLbl = cell?.contentView.viewWithTag(300) as? UILabel
        deviceLbl?.text = "\(bleArray[indexPath.row])"
        
        return cell!
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedDevice = bleArray[indexPath.row]
        
//        if selectedDevice == "BLE名前"
//        {
        print("selectedDevice:\(selectedDevice)")
        if let selectedPeripheral = BLEitems[indexPath.row] as CBPeripheral? {
            BLEManager.shared.connect(peripheral: selectedPeripheral)
           
            returnToMainScreen()
        }
//        }
    }
    
    @IBAction func testbtn(_ sender: Any)
    {
        returnToMainScreen()
    }

    func returnToMainScreen() {
        BLEManager.shared.isConnected = true
        self.navigationController?.popViewController(animated: true)
    }


}

