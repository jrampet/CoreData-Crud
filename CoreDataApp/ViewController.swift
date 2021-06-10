//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Jeyaram on 08/06/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textField : UITextField!
    
    @IBOutlet var age: UITextField!
    
    @IBOutlet var gender: UISwitch!
    let storyBoard = UIStoryboard(name: Storyboard.main, bundle: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        gender.setOn(false, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclick(_ sender: Any) {
        let family = Family(context: self.context)
        family.name = "Family 4"
        
        var selectedGender = "Male"
        if gender.isOn {
            selectedGender = "Female"
        }
        guard let age = age.text else{return }
        let person = Person(context: self.context)
        person.name = textField.text
        person.gender = selectedGender
        person.age =  Int64(age)!
        family.addToMember(person)
                do{
                    try context.save()
                }catch{
                    print("Error in saving")
                }
    }
    
    @IBAction func onClickFetch(_ sender: Any) {
        let familyController:FamilyController = self.storyBoard.instantiateViewController(identifier: Controllers.family)
        self.pushController(familyController, with: "Families")
    }
}

struct Storyboard{
    static let main = "Main"
}
struct Controllers{
    static let family = "FamilyController"
    static let person = "DataController"
}
extension UIViewController{
    func pushController(_ newController: UIViewController,with title:String){
        newController.title = title
        guard let controller = self.navigationController else { return }
        controller.pushViewController(newController, animated: true)
    }
}
