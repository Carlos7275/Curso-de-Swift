//
//  ViewController.swift
//  Maps
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 11/11/25.
//

import MapKit
import SwiftUI
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate,
    UISearchBarDelegate
{

    @IBOutlet weak var mapa: MKMapView!

    @IBOutlet weak var txtBusqueda: UISearchBar!
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtBusqueda.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Le decimos al manejador de la localizacion que obtenga la mejor localización posible
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            renderMap(location: location)
        }
    }

    func renderMap(location: CLLocation) {
        let coordenadas = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )

        let region = MKCoordinateRegion(
            center: coordenadas,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )

        mapa.setRegion(region, animated: true)

        let pin = MKPointAnnotation()
        pin.coordinate = coordenadas

        pin.title = "Tu ubicación"
        pin.subtitle =
            "Lat:\(location.coordinate.latitude) , Longitud: \(location.coordinate.longitude)"

        mapa.addAnnotation(pin)
    }

    @IBSegueAction func segueSwiftUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: Home())
    }

    //Busqueda cuando presionas el boton de busqueda
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        txtBusqueda.resignFirstResponder()
        guard let buscador = txtBusqueda.text else { return }

        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(buscador) {
            (lugares: [CLPlacemark]?, error) in

            if error == nil {
                let lugar = lugares?.first
                let pin = MKPointAnnotation()
                pin.coordinate = (lugar?.location?.coordinate)!
                pin.title = lugar?.name

                let region = MKCoordinateRegion(
                    center: pin.coordinate,
                    latitudinalMeters: 2000,
                    longitudinalMeters: 2000
                )
                self.mapa.setRegion(region, animated: true)
                self.mapa.addAnnotation(pin)
            } else {
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: .alert
                )
               

                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
