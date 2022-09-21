//
//  EventViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 15/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit


class EventViewController: UIViewController {

    let scrollView = UIScrollView(frame: .zero)
    
   
    
    let timerLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            
        ])
        
        scrollView.isDirectionalLockEnabled = true
        
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true 
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Event"
        
    
        scrollView.contentSize = .init(width: scrollView.bounds.width, height: 5000)
        
        
        
        view.backgroundColor = .systemGroupedBackground
        
        
       
        
      /*  view.addSubview(progressRing)
        
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        
        
        progressRing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressRing.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
      //  progressRing.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
                // Make sure to set the view size
        
        NSLayoutConstraint.activate([
        
            
            
          
            
            progressRing.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            progressRing.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            
        ])
        
       
        progressRing.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        progressRing.lineWidth = 20
        
        
        progressRing.setProgress(0.8, animated: false)
        
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textColor = .label
        timerLabel.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        
        
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        
        progressRing.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
        
            timerLabel.centerYAnchor.constraint(equalTo: progressRing.centerYAnchor),
            timerLabel.centerXAnchor.constraint(equalTo: progressRing.centerXAnchor),
        
        ])
        
       
        timerLabel.text = "00:00" */
        
        
        // Do any additional setup after loading the view.
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
