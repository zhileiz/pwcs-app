//
//  EventVC.swift
//  pwcs
//
//  Created by Zhilei Zheng on 2018/1/15.
//  Copyright © 2018年 Zhilei Zheng. All rights reserved.
//

import UIKit
import MapKit

class EventVC: UIViewController {
    
    var event : Event?
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setEvent(_ event: Event) {
        self.event = event
        setUpDefaults()
        setUpTableView()
        tableView.allowsSelection = false;
    }
    
    
    func setUpDefaults() {
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("events", comment: "")
        self.navigationController?.navigationBar.tintColor = .red
        self.title = event!.name
        
        let rightButton = UIBarButtonItem()
        rightButton.setIcon(icon: .ionicons(.map), iconSize: 25, color: .red, cgRect: CGRect(x: 10, y: 5, width: 25, height: 25), target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        
        let leftButton = UIBarButtonItem()
        leftButton.setIcon(icon: .ionicons(.iosArrowBack), iconSize: 29, color: .red, cgRect: CGRect(x: 0, y: 3, width: 29, height: 29), target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addTapped() {
        let location = event!.location.translateCoordinates()
        let coordinates = location.coordinate
        let regionDistance:CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event!.location.translateLocation()
        mapItem.openInMaps(launchOptions: options)
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventMapCell.self, forCellReuseIdentifier: "eventMap")
        tableView.register(EventTitleCell.self, forCellReuseIdentifier: "eventTitle")
    }

}

extension EventVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventTitle") as? EventTitleCell {
                cell.setUpView(with: event!)
                return cell
            }
        } else if (indexPath.section == 1) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "eventMap") as? EventMapCell {
                cell.setUpView(with: event!)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 400 + (event?.desc.dynamicHeight(font: UIFont(font: .avenirNextRegular, size: 15)!, width: UIScreen.main.bounds.width - 40))!
        } else if (indexPath.section == 1) {
            return 200
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            addTapped()
        }
    }
}
