import UIKit
import Firebase

class DetailsViewController: UIViewController {

    @IBOutlet weak var projectTitleTextField: UITextField!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectTitleTextField.text = self.project.title
        projectTitleTextField.addTarget(self, action: #selector(DetailsViewController.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange(sender: UITextField) {
        project.title = sender.text!
        self.parent?.title = sender.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
