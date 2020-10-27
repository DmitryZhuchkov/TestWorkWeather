//
//  DescriptionViewController.swift
//  ToDoListWithCoreData
//
//  Created by Дмитрий Жучков on 15.10.2020.
//  Copyright © 2020 Mohammed S A Kwaik. All rights reserved.
//

import UIKit
import GoogleMaps
class DescriptionViewController: UIViewController {

    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var fullDescription: UILabel!
    @IBOutlet weak var googleMap: GMSMapView!
    var stringcCityImage: String?
    var stringName: String?
    var stringFullDescription: String?
    var latitude: Double?
    var longtitude: Double?
    var image1: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDescription.text = stringFullDescription
        Name.text = stringName
        let camera = GMSCameraPosition(latitude: latitude!, longitude: longtitude!, zoom: 13)
        googleMap.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longtitude!)
        marker.title = stringName
        marker.map = googleMap
        cityImage.image = image1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
