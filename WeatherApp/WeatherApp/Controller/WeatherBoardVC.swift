//
//  WeatherBoardVC.swift
//  WeatherBoard
//
//  Created by Berkin Kabadayi on 3.01.2021.
//

import UIKit
import Alamofire


class WeatherBoardVC: UIViewController {
    
    var city = String()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "WeatherBoard"
        
        cityLabel.text = city.uppercased()
        getData(cityName: city)
        
        Spinner.start()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    /*
    func getData(cityName: String) {
        
        AF.request("https://www.metaweather.com/api/location/search/?query=\(city)").responseJSON { response in
            if let data = response.data {
                let user = try! JSONDecoder().decode(City.self, from: data)
                //print(user.results?[0].name?.first ?? "")
            } else {
                invalidCityNameAlert
            }
        }
    }
    */
    
    //-----------------------------------------
    
    func getData(cityName: String) {
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=0f6112b1d663b03202ffabe9788c51ef") {
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    if let incomingData = data {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            if let main = json["main"] as? NSDictionary {
                                if let temp = main["temp"] as? Double {
                                    let state = Int(temp - 273.15)
                                    DispatchQueue.main.sync {
                                        self.weatherLabel.text = "\(String(state))°C"
                                    }
                                }
                            }
                        } catch {
                            //Error
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
 //-------------------------------------------

    func invalidCityNameAlert() {
        let invalidCityNameAlert = UIAlertController.init(title: "ERROR", message: "Invalid city name. Please enter correct name of the city.", preferredStyle: .alert)
        self.present(invalidCityNameAlert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            invalidCityNameAlert.dismiss(animated: true, completion: nil)
        }
    }

}
