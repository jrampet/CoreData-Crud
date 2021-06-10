//
//  Cell.swift
//  CoreDataApp
//
//  Created by Jeyaram on 08/06/21.
//

import UIKit

class Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var age: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UIImageView!
   
    func configure(with data: Person){
     
        age.text = "\(data.age)"
        name.text = data.name
        gender.setGender(with: data.gender!)
        selectionStyle = .none
    }
    
}
extension UIImageView{
    func setGender(with gender:String){
        if(gender == "Male"){
            self.image = UIImage(named: "maleface")
        }else{
            self.image = UIImage(named: "femaleface")
        }
    }
}
