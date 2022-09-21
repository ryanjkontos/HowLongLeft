//
//  IntentViewController.swift
//  How Long Left Siri ExtensionUI
//
//  Created by Ryan Kontos on 28/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import IntentsUI


class IntentViewController: UIViewController, INUIHostedViewControlling, EventPoolUpdateObserver {
    
    @IBOutlet weak var colourBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    var timer: Timer!
    var event: HLLEvent?
    
    let countdownStringGenerator = CountdownStringGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        self.colourBar.layer.cornerRadius = 2.0
        self.colourBar.layer.masksToBounds = true
        
        self.colourBar.isHidden = true
        self.titleLabel.isHidden = true
        self.timerLabel.isHidden = true
        self.noEventsLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
    
        
        HLLEventSource.shared.addEventPoolObserver(self)
        HLLEventSource.shared.updateEventPool()
        setup()
        
        completion(true, parameters, self.desiredSize)
    }
    
    func setup() {
        
        self.event = HLLEventSource.shared.getTimeline().first
        updateView()
        
    }
    
    @objc func updateView() {
        
        if let unwrappedEvent = self.event {
            
            self.colourBar.isHidden = false
            self.titleLabel.isHidden = false
            self.timerLabel.isHidden = false
            self.noEventsLabel.isHidden = true
                
            self.titleLabel.text = "\(unwrappedEvent.title) \(unwrappedEvent.countdownTypeString)"
            
            let countdownString = self.countdownStringGenerator.generatePositionalCountdown(event: unwrappedEvent)
                self.timerLabel.text = countdownString
            
            if let calendar = unwrappedEvent.associatedCalendar {
                
                self.colourBar.backgroundColor = UIColor(cgColor: calendar.cgColor)
                
            }
            
            
        } else {
            
            self.colourBar.isHidden = true
            self.titleLabel.isHidden = true
            self.timerLabel.isHidden = true
            self.noEventsLabel.isHidden = false
            
            
        }
        
    }
    
    func eventPoolUpdated() {
        DispatchQueue.main.async {
            self.setup()
        }
    }
    
    var desiredSize: CGSize {
        return CGSize(width: 282, height: 105)
    }
    
}
