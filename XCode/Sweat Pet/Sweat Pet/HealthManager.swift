import Foundation
import HealthKit

class HealthManager
{
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = NSSet(array:[
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
//            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
//            HKObjectType.workoutType()
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
            ])
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = NSSet(array:[
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning),
//            HKQuantityType.workoutType()
            ])
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite as! Set<NSObject>, readTypes: healthKitTypesToRead as! Set<NSObject>) { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
    }
    
    func readEnergy ()
    {
//        var activeEnergyBurned: AnyObject? = healthKitStore.valueForKey(HKQuantityTypeIdentifierActiveEnergyBurned)
//        println(activeEnergyBurned)
        
    }
    
    func readProfile() -> ( age:Int?,  biologicalsex:HKBiologicalSexObject?, bloodtype:HKBloodTypeObject?)
    {
        var error:NSError?
        var age:Int?
        
        // 1. Request birthday and calculate age
        if let birthDay = healthKitStore.dateOfBirthWithError(&error)
        {
            let today = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let differenceComponents = NSCalendar.currentCalendar().components(.YearCalendarUnit, fromDate: birthDay, toDate: today, options: NSCalendarOptions(0) )
            age = differenceComponents.year
        }
        if error != nil {
            println("Error reading Birthday: \(error)")
        }
        
        // 2. Read biological sex
        var biologicalSex:HKBiologicalSexObject? = healthKitStore.biologicalSexWithError(&error);
        if error != nil {
            println("Error reading Biological Sex: \(error)")
        }
        // 3. Read blood type
        var bloodType:HKBloodTypeObject? = healthKitStore.bloodTypeWithError(&error);
        if error != nil {
            println("Error reading Blood Type: \(error)")
        }
        
        // 4. Return the information read in a tuple
        return (age, biologicalSex, bloodType)
    }
    
}