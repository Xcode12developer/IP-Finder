//
//  ViewController.swift
//  IP Address Finder
//
//

import UIKit
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Title.frame = CGRect(x: view.frame.size.width / 2 - 125, y: 30, width: 250, height: 60)
        hostNameLabel.frame = CGRect(x: 20, y: 170, width: view.frame.size.width - 30, height: 60)
        orgLabel.frame = CGRect(x: 20, y: 210, width: view.frame.size.width - 30, height: 60)
        cityLabel.frame = CGRect(x: 20, y: 260, width: view.frame.size.width - 30, height: 60)
        regionLabel.frame = CGRect(x: 20, y: 290, width: view.frame.size.width - 30, height: 60)
        countryLabel.frame = CGRect(x: 20, y: 320, width: view.frame.size.width - 30, height: 60)
        button.frame = CGRect(x: textField.frame.midX + 175, y: 110, width: 60, height: 60)


        view.addSubview(Title)
        view.addSubview(hostNameLabel)
        view.addSubview(orgLabel)
        view.addSubview(cityLabel)
        view.addSubview(regionLabel)
        view.addSubview(countryLabel)
        view.addSubview(textField)
        view.addSubview(button)

    }
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("✅", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArialMT", size: 50)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private var textField: UITextField = {
        var field = UITextField()
        field.frame = CGRect(x: 20, y: 110, width: 350, height: 60)
        field.layer.cornerRadius = 12
        field.backgroundColor = .secondarySystemBackground
        field.returnKeyType = .done
        field.placeholder = "Your IP Here"
        field.autocapitalizationType = .sentences
        field.autocorrectionType = .yes
        field.returnKeyType = .continue
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftViewMode = .always
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
        return field
    }()
    
    private var Title: UILabel = {
        let label = UILabel()
        label.text = "IP Finder"
        label.textAlignment = .center
        label.font = UIFont(name: "ArialMT", size: 50)
        label.numberOfLines = 0
        return label
    }()
    
   
    private var hostNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 60)
        label.layer.cornerRadius = 12
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 60)
        label.layer.cornerRadius = 12
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
   
    private var regionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 60)
        label.layer.cornerRadius = 12
        return label
    }()

    private var countryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 60)
        label.layer.cornerRadius = 12
        return label
    }()
    
    private var orgLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.frame = CGRect(x: 50, y: 200, width: 250, height: 60)
        label.layer.cornerRadius = 12
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    @objc func buttonTapped() {
        textField.resignFirstResponder()
        API(IP: textField.text ?? "72.229.28.185")
    }
    
    func API(IP: String) {
        let url = URL(string: "https://ipinfo.io/\(IP)/json")
        let task = URLSession.shared.dataTask(with: ((url ?? URL(string: "https://ipinfo.io/81.169.181.179/json"))!)) { [self] (data, response, error) in
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: [])
                print(jsonResponse)
                guard let newValue = jsonResponse as? [String:Any] else {
                    print("invalid format")
                    return
                }
                
                
                let hostName = newValue["hostname"]
                let city = newValue["city"]
                let region = newValue["region"]
                let country = newValue["country"]
                let location = newValue["loc"]
                let org = newValue["org"]
                let StringLoc = location as? String
                let cord = StringLoc?.components(separatedBy: ",")
                let arrayInt = cord?.map{ Double($0) }
              
                DispatchQueue.main.async {
                    hostNameLabel.text = "Host Name: \(hostName ?? "")"
                    orgLabel.text = "Organization: \(org ?? "")"
                    cityLabel.text = "City: \(city ?? "")"
                    regionLabel.text = "Region: \(region ?? "")"
                    countryLabel.text = "Country: \(country ?? "")"

                }
                    
                
                
                
                let appleParkWayCoordinates = CLLocationCoordinate2DMake(CLLocationDegrees(arrayInt?[0] ?? 0), CLLocationDegrees(arrayInt?[1] ?? 0))

                // Now let's create a MKMapView
                DispatchQueue.main.async {
                    let mapView = MKMapView(frame: CGRect(x: 0, y: 400, width: view.frame.size.width, height: view.frame.size.height - 400))
                
            
                // Define a region for our map view
                var mapRegion = MKCoordinateRegion()

                let mapRegionSpan = 0.02
                mapRegion.center = appleParkWayCoordinates
                mapRegion.span.latitudeDelta = mapRegionSpan
                mapRegion.span.longitudeDelta = mapRegionSpan

                mapView.setRegion(mapRegion, animated: true)

                // Create a map annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = appleParkWayCoordinates
                annotation.title = ""
                annotation.subtitle = ""

                mapView.addAnnotation(annotation)
                view.addSubview(mapView)
                }
            }
            
            catch let error {
                print("Error: \(error)")
            }
            
        }
        task.resume()
    }
    
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textField {
            textField.becomeFirstResponder()
            buttonTapped()
        }
        
        return true
    }}
