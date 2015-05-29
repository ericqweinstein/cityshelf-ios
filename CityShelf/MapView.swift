//
//  MapView.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import AddressBook
import MapKit

/// Extends the BookViewController in order to enable map annotations.
extension BookViewController: MKMapViewDelegate {
    /**
        Allows us to annotate our map view with pins.

        :param: mapView The map view.
        :param: annotation The map annotation.
        :returns: A MapKit annotation view (a map that can hae pins placed on it).
    */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Store {
            let identifier = "pin"
            var view: MKPinAnnotationView

            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)

                if annotation.availability > 0 {
                    view.pinColor = MKPinAnnotationColor.Green
                } else {
                    view.pinColor = MKPinAnnotationColor.Red
                }

                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIView
            }

            return view
        }

        return nil
    }

    /**
        Opens Apple Maps if the user clicks into the callout
        on the map annotation.

        :param: mapView The map view instance.
        :annotationView The annotation view.
    */
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {

            let location = view.annotation as Store
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}