import Foundation
import SwiftUI

class PicsViewModel : ObservableObject{
    
    @Published var picsModel = [PicsModel]()
    
    func lodData(){
        guard let url  = URL(string: "https://picsum.photos/v2/list")
        else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let modelData  = try? JSONDecoder().decode([PicsModel].self, from: data!)
            
            DispatchQueue.main.async{
                if let model = modelData{
                    self.picsModel = model
                }
            }
        }.resume()
    }
    
    
}
