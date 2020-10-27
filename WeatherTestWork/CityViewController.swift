//
//  CityViewController.swift
//  ToDoListWithCoreData
//
//  Created by Дмитрий Жучков on 14.10.2020.


import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
struct Weather {
    var date:String?
    var Weather:Double?
    
}
class CityViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var WeatherTod: UICollectionView!
    @IBOutlet weak var WeatherTomor: UICollectionView!
    @IBOutlet weak var CityName: UILabel!
    var Name:String?
    var coor:CLLocationCoordinate2D?
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DateTomorrowLabel: UILabel!
    @IBOutlet weak var googleMap: GMSMapView!
    var temperaturetoday = [Weather]()
    var temperaturetomorrow = [Weather]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WeatherTod.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.reuseId)
        self.WeatherTod.delegate = self
        self.WeatherTod.dataSource = self
        self.WeatherTomor.register(WeatherCollectionViewCellTomor.self, forCellWithReuseIdentifier: WeatherCollectionViewCellTomor.reuseId)
        self.WeatherTomor.delegate = self
        self.WeatherTomor.dataSource = self
        CityName.text = Name
        let camera = GMSCameraPosition(latitude: coor!.latitude, longitude: coor!.longitude, zoom: 10)
        googleMap.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coor!.latitude, longitude: coor!.longitude)
        marker.title = Name
        marker.map = googleMap
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(coor!.latitude)&lon=\(coor!.longitude)&exclude=daily&appid=aa9a9ec89f3dc1bb124ea5860a1cadae&units=metric").responseJSON {
            response in
            let json = JSON(response.value!)
            let currentdate = json["hourly"][0]["dt"].double
            let date = Date(timeIntervalSince1970: currentdate!)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeZone = .current
            let current = dateFormatter.string(from: date)
            for n in 0...23 {
                let timeResult = json["hourly"][n]["dt"].double
                let date = Date(timeIntervalSince1970: timeResult!)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.short
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                if current.compare(localDate) == .orderedSame {
                    self.DateLabel.text = "Погода на сегодня (\(localDate))"
                    let tempToday = json["hourly"][n]["temp"].double
                    let timeResult1 = json["hourly"][n]["dt"].double
                    let date = Date(timeIntervalSince1970: timeResult1!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
                    dateFormatter.dateStyle = DateFormatter.Style.none
                    dateFormatter.timeZone = .current
                    let localDate1 = dateFormatter.string(from: date)
                    let temmp = Weather(date: localDate1, Weather: tempToday!)
                    self.temperaturetoday.append(temmp)
                } else if current.compare(localDate) == .orderedAscending {
                    self.DateTomorrowLabel.text = "Погода на завтра (\(localDate))"
                    let tempTomorrow = json["hourly"][n]["temp"].double
                    let timeResult1 = json["hourly"][n]["dt"].double
                    let date = Date(timeIntervalSince1970: timeResult1!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
                    dateFormatter.dateStyle = DateFormatter.Style.none
                    dateFormatter.timeZone = .current
                    let localDate1 = dateFormatter.string(from: date)
                    let temmp1 = Weather(date: localDate1, Weather: tempTomorrow!)
                    self.temperaturetomorrow.append(temmp1)
                    
                }
            }
            OperationQueue.main.addOperation({
                self.WeatherTod.reloadData()
                self.WeatherTomor.reloadData()
            })
        }.resume()
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.WeatherTod {
        return temperaturetoday.count
        } else {
            return temperaturetomorrow.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.WeatherTod {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        cell.smallDescriptionLabel.text = temperaturetoday[indexPath.row].date
        cell.nameLabel.text = String(temperaturetoday[indexPath.row].Weather!)
        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCellTomor", for: indexPath) as! WeatherCollectionViewCellTomor
            cell.smallDescriptionLabel.text = temperaturetomorrow[indexPath.row].date
            cell.nameLabel.text = String(temperaturetomorrow[indexPath.row].Weather!)
            return cell
        }
    }
    
    @IBAction func nextScene(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Place") as? PlaceViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.nameOfCity = Name
        navigationController?.pushViewController(vc, animated: true)
    }
}
