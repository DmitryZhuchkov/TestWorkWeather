//
//  PlaceViewController.swift
//  WeatherTestWork
//
//  Created by Дмитрий Жучков on 27.10.2020.
//
import UIKit
import CoreData
class PlaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cells = [PlaceDataInfo]()
    @IBOutlet weak var placeMassive: UITableView!
    var data:[Place] = []
    var nameOfCity:String?
    var needCells = [PlaceDataInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        placeMassive.delegate = self
        placeMassive.dataSource = self
        let fetchRequest:NSFetchRequest<Place> = Place.fetchRequest()
        //let results = PresistentStore.
        
        do {
            let data = try PresistentStore.context.fetch(fetchRequest)
            self.data = data
        } catch  {
            
        }
        cells = PlaceDataInfo.fetchSights()
        if data.isEmpty {
        for t in 0...(cells.count - 1) {
            let placeNO = Place(context:PresistentStore.context)
            placeNO.fullDescription = cells[t].fullDescription
            placeNO.smallDescription = cells[t].smallDescription
            placeNO.sightsName = cells[t].sightsName
            placeNO.image = cells[t].mainImage
            placeNO.longitude = cells[t].longitude
            placeNO.latitude = cells[t].latitude
            placeNO.name = cells[t].City
            PresistentStore.saveContext()
            self.data.append(placeNO)
        }
            for t in 0...(data.count - 1) {
                if data[t].name == nameOfCity {
                    let needcell = PlaceDataInfo(mainImage: data[t].image as! UIImage, fullDescription: data[t].fullDescription!, smallDescription: data[t].smallDescription!, latitude: data[t].latitude, longitude: data[t].longitude, City: data[t].name!, sightsName: data[t].sightsName!)
                    needCells.append(needcell)
                }
            }
        
        } else {
            for t in 0...(data.count - 1) {
                if data[t].name == nameOfCity {
                    let needcell = PlaceDataInfo(mainImage: data[t].image as! UIImage, fullDescription: data[t].fullDescription!, smallDescription: data[t].smallDescription!, latitude: data[t].latitude, longitude: data[t].longitude, City: data[t].name!, sightsName: data[t].sightsName!)
                    needCells.append(needcell)
        }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceCell
        cell.placeImage.image = needCells[indexPath.row].mainImage
        cell.placeDescription.text = needCells[indexPath.row].smallDescription
        cell.placeName.text = needCells[indexPath.row].sightsName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "Description") as? DescriptionViewController else { return }
        vc.stringFullDescription = needCells[indexPath.row].fullDescription
        vc.image1 = needCells[indexPath.row].mainImage
        vc.latitude = needCells[indexPath.row].latitude
        vc.longtitude = needCells[indexPath.row].longitude
        vc.stringName = needCells[indexPath.row].sightsName
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
class PlaceCell: UITableViewCell {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
}
