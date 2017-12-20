//
//  inMissionViewController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 26/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class inMissionViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var objectiveStackView: UIStackView!
    @IBOutlet weak var distanceImageView: UIImageView!
    @IBOutlet weak var speedImageView: UIImageView!
    @IBOutlet weak var timeImageVIew: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quitMissionButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var challengeObjectiveLabel: UILabel!
    @IBOutlet weak var mainObjectiveLabel: UILabel!
    @IBOutlet weak var missionTitle: UILabel!
    @IBOutlet weak var missionMKMapView: MKMapView!
    
    var data = Selection()
    
    var timer = Timer()
    var counter = 0
    //var locationHelper = LocationHelper()
    
    var distance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setData()
        
        hideNavBar()
        setBackgroundImage()
        setUIComponents()
        
        self.setTimer(speed: 1.0)
        
        self.initalizCoreLocationDelegeate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitMission(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func setUIComponents() {
        
        missionTitle.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1)		
        quitMissionButton.layer.cornerRadius = 5
        timeImageVIew.tintColor = UIColor.green
        distanceImageView.tintColor = UIColor.green
        speedImageView.tintColor = UIColor.green
    }
    
    private func setBackgroundImage(){
        
        backgroundImageView.image = UIImage(named: "zombieApocalypse")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.85
            
            backgroundImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
    }
    
    private func hideNavBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setTimer(speed:Double) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    public func timerAction() {
        if(counter >= 0){
            let minutes = String(counter / 60)
            let seconds = String(counter % 60)
            timeLabel.text = minutes + ":" + seconds
            counter -= 1
        }
    }

}

extension inMissionViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    //MARK: - Create a custom map view of the project
    
    public func setData() {
        
        let index = self.data.missionTime?.index((self.data.missionTime?.startIndex)!, offsetBy: 2)
        let missionTime = self.data.missionTime?.substring(to: index!)
        
        counter = Int(missionTime!)! * 60
        
        mainObjectiveLabel.text = data.missionObjective
        challengeObjectiveLabel.text = data.missionChallenge
    }
    
    //MARK:- Map Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude , location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: missionMKMapView.region.span.latitudeDelta, longitudeDelta: missionMKMapView.region.span.longitudeDelta)
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.missionMKMapView.setRegion(region, animated: true)
        
        self.missionMKMapView.showsUserLocation = true
        
        speedLabel.text = "\(location.speed)" + "km/h"
       
        var startLocation:CLLocation!
        var lastLocation: CLLocation!
        var traveledDistance:Double = 0
        
        if startLocation == nil {
            startLocation = locations.first
        } else {
            if let lastLocation = locations.last {
                let distance = startLocation.distance(from: lastLocation)
                let lastDistance = lastLocation.distance(from: lastLocation)
                traveledDistance += lastDistance
                print( "\(startLocation)")
                print( "\(lastLocation)")
                print("FULL DISTANCE: \(traveledDistance)")
                print("STRAIGHT DISTANCE: \(distance)")
                
                distanceLabel.text = "\(traveledDistance)" + " KM"
            }
        }
        lastLocation = locations.last
    }
    
    public func getLatLong() -> Location {
        let locationModel = Location()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = self.locationManager.location
        locationModel.latitude = location?.coordinate.latitude
        locationModel.longtitude = location?.coordinate.longitude
        
        return locationModel
    }
    
    public func setPin(location: Location) {
        let annotion: MKPointAnnotation = MKPointAnnotation()
        annotion.coordinate = CLLocationCoordinate2DMake(location.latitude!, location.longtitude!)
        annotion.title = "You are here"
        self.missionMKMapView.addAnnotation(annotion)
        
        //Second annotation
        let secondLoc = CLLocation(latitude: location.latitude! + 0.1, longitude: location.longtitude! + 0.1)
        
        let goal:MKPointAnnotation = MKPointAnnotation()
        goal.coordinate = CLLocationCoordinate2DMake(secondLoc.coordinate.latitude, secondLoc.coordinate.longitude)
        goal.title = "Reach here"
        self.missionMKMapView.addAnnotation(goal)
    }
    
    public func setPolyLine(location: Location) {
        let point1 = CLLocation(latitude:location.latitude!, longitude: location.longtitude!)
        let point2 = CLLocation(latitude:location.latitude! + 0.1, longitude: location.longtitude! + 0.1)
        
        let coordinates = [point1.coordinate, point2.coordinate]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: coordinates, count: 2)
        
        self.missionMKMapView.add(geodesicPolyline)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
            print("Access denied")
        } else {
            print("Access is Granted")
        }
    }
    
    func initalizCoreLocationDelegeate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = .fitness
        locationManager.startUpdatingLocation()
        
        self.missionMKMapView.isZoomEnabled = true
        self.missionMKMapView.mapType = .standard
        self.missionMKMapView.isScrollEnabled = true
        self.missionMKMapView.isUserInteractionEnabled = true
        self.missionMKMapView.delegate = self
        
        setPin(location: getLatLong())
        setPolyLine(location: getLatLong())
    }
    
    //MARK: - Map View Deleagates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blue
        
        return renderer
    }
}

extension String {
    var length: Int {
        return self.characters.count
    }
}
