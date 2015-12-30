//
//  ViewController.swift
//  techHealth
//
//  Created by Anatoly Konkin on 11/5/15.
//  Copyright © 2015 Anatoly Konkin. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet var techHealth: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    // HealthKitStore initialization
    let healthKitStore = HKHealthStore()
    
    func readProfile() -> (age:NSDate?, bioSex:HKBiologicalSexObject?)
    {
        // Reading Characteristics
        var bioSex : HKBiologicalSexObject?
        var dateOfBirth : NSDate?
        
        do {
            dateOfBirth = try healthKitStore.dateOfBirth()
            bioSex = try healthKitStore.biologicalSex()
        }
        catch {
            print(error)
        }
        return (dateOfBirth, bioSex)
    }
    
    func  authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
        
        let healthKitTypesToRead = Set(arrayLiteral:
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!
        )
        
        let healthKitTypesToWrite = Set(arrayLiteral:
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
        )
        
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "ru.techmas.techmasHealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) {
            (success, error) -> Void in
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
        
        let profile = readProfile()
        print(profile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization received.")
            }
            else
            {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
        
    @IBAction func buttonPressed(sender: UIButton) {
        mainLabel.text = "buttonPressed"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

