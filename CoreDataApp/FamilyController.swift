//
//  FamilyController.swift
//  CoreDataApp
//
//  Created by Jeyaram on 09/06/21.
//

import UIKit
import CoreData
class FamilyController: UIViewController {
    let cellId = "cell"
    var families = [Family]()
    @IBOutlet var table : UITableView!
    let mainStoryboard = UIStoryboard(name: Storyboard.main, bundle: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        table.delegate = self
        table.dataSource = self
        reload()
        // Do any additional setup after loading the view.
    }
    func reload(){
        do{
            let dataItems:[Family] = try context.fetch(Family.fetchRequest())
            families = dataItems
            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FamilyController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        families.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath)
        cell.textLabel?.text = families[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete", handler: {[weak self]
            (contextualAction, view, boolValue) in
            guard let self = self else{return}
            let remove = self.families[indexPath.row]
//            let familyMembers = self.families[indexPath.row].member
        
            self.context.delete(remove)
            self.save()
            self.reload()
        })
        return UISwipeActionsConfiguration(actions: [contextItem])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = self.mainStoryboard.instantiateViewController(identifier: Controllers.person) as DataController
        newController.currentFamily = families[indexPath.row]
        self.pushController(newController, with: families[indexPath.row].name!)
    }
    
    
}
