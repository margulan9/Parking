//
//  MapViewController.swift
//  Parking
//
//  Created by Sugirbay Margulan on 2/10/20.
//  Copyright © 2020 Sugirbay Margulan. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var parkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var totalPlacesLabel: UILabel!
    @IBOutlet weak var availablePlacesLabel: UILabel!
    @IBOutlet weak var parkingZoneLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vehicleNumberButton: UIButton!
    
    let db = Firestore.firestore()
    var vehicles: [Vehicles] = []
    
    var myInitialLocation = CLLocationCoordinate2D(latitude: 43.242883, longitude: 76.915043)
    
    private let reuseIdentifier = "MyIdentifier"
    let zone1 = MKPointAnnotation()
    let zone2 = MKPointAnnotation()
    
    var startTime = TimeInterval()
    var timers: Timer = Timer()
    var availableSpacesInt: Int?
    var freeSpace: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.backgroundColor = .clear
        stopButton.layer.cornerRadius = 5
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = #colorLiteral(red: 0.05098039216, green: 0.7137254902, blue: 0.3960784314, alpha: 1)
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: myInitialLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        createTestPolyLine()
        
        
        zone1.title = "Parking Zone 1002"
        zone1.coordinate = CLLocationCoordinate2D(latitude: 43.238851, longitude: 76.898656)
        mapView.addAnnotation(zone1)
        zone2.title = "Parking Zone 1009"
        zone2.coordinate = CLLocationCoordinate2D(latitude: 43.245290, longitude: 76.946362)
        mapView.addAnnotation(zone2)
        
        loadVehicle()
        
        availableSpacesInt = Int(availablePlacesLabel.text!)
    }
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    @IBAction func closePressed(_ sender: Any) {
        setView(view: infoView, hidden: true)
    }
    @IBAction func parkPressed(_ sender: Any) {
        freeSpace = availableSpacesInt! - 1
        availablePlacesLabel.text = "\(freeSpace)"
        
        parkButton.isEnabled = false
        parkButton.alpha = 0.7
        stopButton.isEnabled = true
        stopButton.alpha = 1
        let aSelector = #selector(updateTime)
        timers = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
        print(NSDate.timeIntervalSinceReferenceDate)
        
    }
    @IBAction func stopPressed(_ sender: Any) {
        //alert
        let cash = calculateCash()
        let alert = UIAlertController(title: "Your parking time is over, have a nice day", message: "Your parking fee is \(cash) Tg", preferredStyle: UIAlertController.Style.alert)
        let yes = UIAlertAction(title: "Pay", style: .default) { (UIAlertAction) in
            self.timers.invalidate()
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            self.timer.text = "00:00:00"
            self.stopButton.isEnabled = false
            self.stopButton.alpha = 0.7
            self.parkButton.isEnabled = true
            self.parkButton.alpha = 1
            self.availablePlacesLabel.text = "\(self.freeSpace + 1)"
        }
        let no = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func vehicleNumberPressed(_ sender: Any) {
    }
    
    @objc func updateTime() {
           let currentTime = NSDate.timeIntervalSinceReferenceDate
           var elapsedTime: TimeInterval = currentTime - startTime
           
           let hours = UInt8(elapsedTime / (60.0 * 60.0))
               elapsedTime -= (TimeInterval(hours) * 60 * 60)
           let minutes = UInt8(elapsedTime / 60.0)
               elapsedTime -= (TimeInterval(minutes) * 60)
           let seconds = UInt8(elapsedTime)
               elapsedTime -= TimeInterval(seconds)

           let strHours = String(format: "%02d", hours)
           let strMinutes = String(format: "%02d", minutes)
           let strSeconds = String(format: "%02d", seconds)

           timer.text = "\(strHours):\(strMinutes):\(strSeconds)"
    }
    func calculateCash() -> String {
        let timeLabel = timer.text
        let submin = timeLabel!.components(separatedBy: ":")
        let doubleHour = Double(submin[0])
        let doubleMin = Double(submin[1])
        let doubleSec = Double(submin[2])
        let totalTime = (doubleHour!*3600) + (doubleMin!*60) + (doubleSec!)
        let cash = NSString(format: "%.2f", totalTime*0.6)
        return cash as String
        
    }
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.green.withAlphaComponent(0.9);
            pr.lineWidth = 5;
            return pr;
        }

        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = .green
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        setView(view: infoView, hidden: false)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        infoView.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
               case UISwipeGestureRecognizer.Direction.down:
                setView(view: infoView, hidden: true)
                default:
                break
               }
           }
    }
    func createTestPolyLine() {
        let locations = [
            CLLocation(latitude: 43.238298, longitude: 76.890043),
        CLLocation(latitude:43.239551, longitude: 76.908656)
        
        ]
        let locations1 = [
            CLLocation(latitude: 43.242199, longitude: 76.948411),
            CLLocation(latitude: 43.242883, longitude: 76.956860)
        ]
        let locations2 = [

            CLLocation(latitude: 43.239532, longitude: 76.957362),
            CLLocation(latitude: 43.245290, longitude: 76.956646)

        ]
        let locations3 = [
            CLLocation(latitude: 43.248104, longitude: 76.947561),
            CLLocation(latitude: 43.238443, longitude: 76.948795)
        ]
        let locations4 = [
                   CLLocation(latitude: 43.246396, longitude: 76.947878),
                   CLLocation(latitude: 43.245396, longitude: 76.933679)
               ]
        addPolyLineToMap(locations: locations)
        addPolyLineToMap(locations: locations1)
        addPolyLineToMap(locations: locations2)
        addPolyLineToMap(locations: locations3)
        addPolyLineToMap(locations: locations4)
    }
    func addPolyLineToMap(locations: [CLLocation?]) {
        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })

        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.addOverlay(polyline)
    }
}


extension MapViewController {
    func loadVehicle() {
        db.collection("vehicles").addSnapshotListener { (querySnapshot, error) in
            self.vehicles = []
            
            if let e = error {
                print("there was an issue retrieving the data\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if Auth.auth().currentUser?.email == data["user-email"] as? String{
                            if let vehicleNumber = data["vehicle-number"] as? String {
                                let newVehicle = Vehicles(vehicleNumber: vehicleNumber)
                                self.vehicles.append(newVehicle)
                                print(self.vehicles)
                                self.vehicleNumberButton.setTitle(self.vehicles[0].vehicleNumber, for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    

}
