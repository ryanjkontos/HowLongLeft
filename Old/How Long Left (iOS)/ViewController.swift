//
//  ViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 15/10/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import UIKit
import WatchKit
#if canImport(Intents)
import Intents
import IntentsUI
#endif

class ViewController: UIViewController, HLLCountdownController, DataSourceChangedDelegate {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var endsInLabel: UILabel!
    @IBOutlet weak var upcomingLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var upcomingLocationLabel: UILabel!
    @IBOutlet weak var noEventOnInfo: UILabel!
    let defaults = HLLDefaults.defaults
    let percentageGen = PercentageCalculator()
    let notoScheduler = MilestoneNotificationScheduler()
    let backgroundImageView = UIImageView()
    let darkView = UIView()
    let gradient = CAGradientLayer()
    let calData = EventDataSource()
    var timer: Timer!
    var FastTimer: Timer!
    let timerStringGenerator = EventCountdownTimerStringGenerator()
    let upcomingStringGenerator = UpcomingEventStringGenerator()
    let schoolChecker = SchoolAnalyser()
    lazy var eventMonitor = EventTimeRemainingMonitor(delegate: self)
    static var launchedWithSettingsShortcut = false
    
    var hideTapToDismiss = false
    
    override var shouldAutorotate: Bool {
        
        return false
        
    }
    
    var countdownEvent: HLLEvent? {
        
        get {
            
            var currentArray = [HLLEvent]()
            
            if let current = CurrentEventsTableViewController.selectedEvent {
                
                currentArray.append(current)
                
            }
            
            eventMonitor.setCurrentEvents(events: currentArray)
            
            return CurrentEventsTableViewController.selectedEvent
            
        }
        
       
        
    }
    

 
    
let sync = DefaultsSync()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sync.syncDefaultsToWatch()
        
        setBackgroundImage()
        //shift.startTimedAnimation()
        run()
        updateTimer()
        DispatchQueue.main.async {
        
        
        }
        
        SchoolAnalyser.shared.analyseCalendar()
        
            
            
            self.notoScheduler.getAccess()
            self.notoScheduler.scheduleNotificationsForUpcomingEvents()
            
        
        
       
        
    }
    
    override func viewDidLoad() {
        
        //swipeToDismissLabel.isHidden = self.hideTapToDismiss
        
        IAPHandler.shared.fetchAvailableProducts()
        
        countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: countdownLabel.font.pointSize, weight: .regular)

        //let notoS = MilestoneNotificationScheduler()
       // notoS.scheduleTestNotification()
        
        run()
        
    setBackgroundImage()
        
        countdownLabel.layer.shadowColor = UIColor.black.cgColor
        countdownLabel.layer.shadowRadius = 3.0
        countdownLabel.layer.shadowOpacity = 0.3
        countdownLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        countdownLabel.layer.masksToBounds = false
        
        eventTitleLabel.layer.shadowColor = UIColor.black.cgColor
        eventTitleLabel.layer.shadowRadius = 3.0
        eventTitleLabel.layer.shadowOpacity = 0.3
        eventTitleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        eventTitleLabel.layer.masksToBounds = false
        
        endsInLabel.layer.shadowColor = UIColor.black.cgColor
        endsInLabel.layer.shadowRadius = 3.0
        endsInLabel.layer.shadowOpacity = 0.3
        endsInLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        endsInLabel.layer.masksToBounds = false
        
        noEventOnInfo.layer.shadowColor = UIColor.black.cgColor
        noEventOnInfo.layer.shadowRadius = 3.0
        noEventOnInfo.layer.shadowOpacity = 0.3
        noEventOnInfo.layer.shadowOffset = CGSize(width: 2, height: 2)
        noEventOnInfo.layer.masksToBounds = false
        
        progressLabel.layer.shadowColor = UIColor.black.cgColor
        progressLabel.layer.shadowRadius = 3.0
        progressLabel.layer.shadowOpacity = 0.3
        progressLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        progressLabel.layer.masksToBounds = false
        
        
        upcomingLabel.layer.shadowColor = UIColor.black.cgColor
        upcomingLabel.layer.shadowRadius = 3.0
        upcomingLabel.layer.shadowOpacity = 0.3
        upcomingLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        upcomingLabel.layer.masksToBounds = false
        
        upcomingLocationLabel.layer.shadowColor = UIColor.black.cgColor
        upcomingLocationLabel.layer.shadowRadius = 3.0
        upcomingLocationLabel.layer.shadowOpacity = 0.3
        upcomingLocationLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        upcomingLocationLabel.layer.masksToBounds = false
        
        
        
        
        super.viewDidLoad()
        
         // let animation = AnimationType.zoom(scale: 2.1)
        
      //  view.animate(animations: [animation], reversed: false, initialAlpha: 0.0, finalAlpha: 1.0, delay: 0, duration: 0.6, options: .allowAnimatedContent, completion: nil)
        
            
        
        
        timer = Timer(fire: Date(), interval: 3, repeats: true, block: {_ in
            
           self.run()
            
        })
        
        FastTimer = Timer(fire: Date(), interval: 0.2, repeats: true, block: {_ in
            
            self.updateTimer()
            
        })
        
        RunLoop.main.add(timer, forMode: .common)
        RunLoop.main.add(FastTimer, forMode: .common)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
       // updateBackgroundGradient()
        setBackgroundImage()
        
        SchoolAnalyser.shared.analyseCalendar()
        
        
    }
    
    func updateTimer() {
        
        DispatchQueue.main.async {
            
            if let event = self.countdownEvent {
                
                if event.endDate.timeIntervalSinceNow < 0 {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
                
                let string = self.timerStringGenerator.generateStringFor(event: event)
                
                self.countdownLabel.text = string
                
                if let percentage = self.percentageGen.calculatePercentageDone(event: event, ignoreDefaults: false) {
                self.progressLabel.text = "(\(percentage) Done)"
                    
                }
                
    
            } else {
                
                self.navigationController?.popToRootViewController(animated: true)
                
                
            }
            
            
        }
        
        
    }
    
    var currentEvents = [HLLEvent]()
    var upcomingEvents = [HLLEvent]()
    
    func run() {
        
            
        
        self.calData.updateEventStore()
        SchoolAnalyser.shared.analyseCalendar()
        
        if let current = countdownEvent {
            

            
            
            DispatchQueue.main.async {
                
                self.eventTitleLabel.text = "\(current.title) \(current.endsInString) in"
                self.countdownLabel.text = self.timerStringGenerator.generateStringFor(event: current)
                self.countdownLabel.isHidden = false
                self.eventTitleLabel.isHidden = false
                self.progressLabel.isHidden = false
                self.endsInLabel.isHidden = true
                self.noEventOnInfo.isHidden = true
                
                
                
            }
            
            
            
        } else {
            

            
            DispatchQueue.main.async {
                self.progressLabel.isHidden = true
                self.eventTitleLabel.isHidden = false
                if EventDataSource.accessToCalendar == .Granted {
                    
                    self.eventTitleLabel.text = "No events are on"
                    self.noEventOnInfo.text = "When an event starts, How Long Left will count it down."
                    self.noEventOnInfo.isHidden = true
                    self.progressLabel.isHidden = true
                    self.upcomingLabel.isHidden = true
                } else if EventDataSource.accessToCalendar == .Denied {
                    
                    self.eventTitleLabel.text = "Enable calendar access in the Settings app."
                    self.upcomingLabel.isHidden = true
                    self.noEventOnInfo.isHidden = false
                    self.progressLabel.isHidden = true
                    
                    self.noEventOnInfo.isHidden = true
                    
                }
                
                self.progressLabel.isHidden = true
                self.countdownLabel.isHidden = true
                self.endsInLabel.isHidden = true
                
            }
            
            
            
        }
        
        let upcomingTuple = self.upcomingStringGenerator.generateNextEventString(upcomingEvents: upcomingEvents, currentEvents: currentEvents, isForDoneNotification: false)
        
        if let upcomingInfo = upcomingTuple.0, EventDataSource.accessToCalendar == .Granted {
            
            DispatchQueue.main.async {
                
                self.upcomingLabel.text = upcomingInfo
                self.upcomingLabel.isHidden = false
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.upcomingLabel.isHidden = true
                
            }
            
        }
        
        if let upcomingLocation = upcomingTuple.1 {
            
            DispatchQueue.main.async {
                
                self.upcomingLocationLabel.text = upcomingLocation
                self.upcomingLocationLabel.isHidden = false
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                self.upcomingLocationLabel.isHidden = true
                
            }
            
        }
        
        self.eventMonitor.checkCurrentEvents()
        
            
        
        
        
    }
    
    func updateDueToEventEnd(event: HLLEvent, endingNow: Bool) {
        
        if endingNow == true {
        //showAlertBanner(Title: "\(event.title) is done.", Subtitle: "")
        }
    }
    
    func milestoneReached(milestone seconds: Int, event: HLLEvent) {
        print("Milestone reached")
    }
    
    let bArray = [UIImage(named: "Background_Light"), UIImage(named: "Background_Dark"), UIImage(named: "Background_Black")]
   
    let adjustBy: CGFloat = 10.0
    
    func setBackgroundImage() {
              
    //  backgroundImageView.image = bArray[0]
        
     /*   if let col = currentEvents.first?.calendar?.cgColor {
            
            let uiCOL = UIColor(cgColor: col)
            
            let lighter = uiCOL.lighter(by: 18.0)!.cgColor
            let darker = uiCOL.darker(by: 16.0)!.cgColor
            
            
            
            
            gradient.frame = view.bounds
            gradient.colors = [lighter, darker]
            
            view.layer.insertSublayer(gradient, at: 0)
            
        }
        
        */
        
        
        
        
   /* if defaults.bool(forKey: "useDarkBackground") == true {
            backgroundImageView.image = bArray[1]
            /*darkView.backgroundColor = UIColor.black
            darkView.alpha = 0.75
            view.addSubview(darkView)
            view.sendSubviewToBack(darkView)
            darkView.translatesAutoresizingMaskIntoConstraints = false
            darkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            darkView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            darkView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            darkView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true*/
            
        } else {
         
            
        } */
        
        backgroundImageView.image = bArray[0]
        darkView.removeFromSuperview()
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        
    }
    
    var HLLYellow = #colorLiteral(red: 0.7659620876, green: 0.569952517, blue: 0.02249037123, alpha: 1)
    var HLLMiddle = #colorLiteral(red: 1, green: 0.6172748902, blue: 0.01708748773, alpha: 1)
    var HLLOrange = #colorLiteral(red: 0.9627912974, green: 0.3692123313, blue: 0, alpha: 1)
    
    var colourArray = [#colorLiteral(red: 1, green: 0.7437175817, blue: 0.02428589218, alpha: 1), #colorLiteral(red: 1, green: 0.6172748902, blue: 0.01708748773, alpha: 1), #colorLiteral(red: 0.9627912974, green: 0.3692123313, blue: 0, alpha: 1)]
    
    func donateInteraction() {
        if #available(iOS 12.0, *) {
            let intent = HowLongLeftIntent()
        
        intent.suggestedInvocationPhrase = "How long left"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Failed to donate because \(error)")
                } else {
                    print("Successfully donated")
                }
            }
        }
    }
    
    }
    
    var interactor:Interactor! = nil
    
    func percentageMilestoneReached(milestone percentage: Int, event: HLLEvent) {
        
    }
    
    func eventStarted(event: HLLEvent) {
        
    }
    
    
    func eventHalfDone(event: HLLEvent) {
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    func userInfoChanged(date: Date) {
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        
    }
    
    

    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        
        if .Down == sender.verticalDirection(target: self.view) {
            
            let percentThreshold:CGFloat = 1
            
            // convert y-position to downward pull progress (percentage)
            let translation = sender.translation(in: view)
            let verticalMovement = translation.y / view.bounds.height
            let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
            let downwardMovementPercent = fminf(downwardMovement, 1.0)
            let progress = CGFloat(downwardMovementPercent)
            
            interactor = Interactor()
            
            switch sender.state {
            case .began:
                interactor.hasStarted = true
                dismiss(animated: true, completion: nil)
            case .changed:
                interactor.shouldFinish = progress > percentThreshold
                interactor.update(progress)
            case .cancelled:
                interactor.hasStarted = false
                interactor.cancel()
            case .ended:
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finish()
                    : interactor.cancel()
            default:
                break
            }
            
        }
    }
    

}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}


extension CurrentEventsTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

class DismissAnimator : NSObject {
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            fromVC!.view.frame = finalFrame
            
        }, completion: { item in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            
        })
        
    }
}

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }
    
}
