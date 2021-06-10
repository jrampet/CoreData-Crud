//
//  DataController.swift
//  CoreDataApp
//
//  Created by Jeyaram on 08/06/21.
//

import UIKit
import CoreData
class DataController: UIViewController {
    @IBOutlet var table : UITableView!
    let identifier = "Cell"
    var personData = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentFamily : Family?
//    var families = [Family]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        table.delegate = self
        table.dataSource  = self
        table.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        showAll()
//        let familyA = Family(context: context)
//        familyA.name = "Family1"
//        let familyB = Family(context: context)
//        familyB.name = "Family2"
//        let familyC = Family(context: context)
//        familyC.name = "Family3"
//        families = [familyA,familyB,familyC]
        reload()
//        assignFamily()
        // Do any additional setup after loading the view.
    }
    
    
    /*func assignFamily(){
        do{
            let personDatawithFamily:[Person] = try context.fetch(Person.fetchRequest())
            for person in personDatawithFamily{
                person.family = families.randomElement()
//                print(person.family?.name,person.name)
            }
            save()
        }catch{
            print("Error in fetch")
        }
       
    }*/
    func reload(){
        guard let currentFamily = currentFamily else{return}
        do{
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let namePredicate   = NSPredicate(format: "family == %@",currentFamily)
//            let agePredicate = NSPredicate(format: "age>15")
            
//            let predicate = NSCompoundPredicate(type: .or, subpredicates: [namePredicate,agePredicate])
            request.predicate = namePredicate
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
            let dataItems:[Person] = try context.fetch(request)
            personData = dataItems
            
            
        }catch{
            print("Error")
        }
        self.table.reloadData()
    }
    func save(){
        do{
            try context.save()
        }catch{
            print("Errors in saving")
        }
    }
    func showAll(){
        
        let dataItems:[Person] = try! context.fetch(Person.fetchRequest())
        for person in dataItems{
            print(person.family?.name,person.name)
        }
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
extension DataController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier,for: indexPath) as! Cell
        cell.configure(with: personData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete", handler: {[weak self]
            (contextualAction, view, boolValue) in
            guard let self = self else{return}
            let remove = self.personData[indexPath.row]
            self.context.delete(remove)
            self.save()
            self.reload()
            
        })
        return UISwipeActionsConfiguration(actions: [contextItem])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = self.personData[indexPath.row]
        let alertController = UIAlertController(title: "Edit", message: "Edit Name", preferredStyle: .alert)
        alertController.addTextField()
        let field = alertController.textFields![0]
        field.text = selectedPerson.name
        let save = UIAlertAction(title: "Save", style: .default, handler: {
            (action) in
            selectedPerson.name = field.text
            self.save()
            self.reload()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
