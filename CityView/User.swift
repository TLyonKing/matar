
import Foundation

class User{
    var id: String
    var bio: String
    var display: String
    var email: String
    var photo: String
    var username: String
    
    init(id: String, bio: String, display: String, email: String, photo: String, username:String){
        self.id = id
        self.bio = bio
        self.display = display
        self.email = email
        self.photo = photo
        self.username = username
    
    }
    func getUserAsDictionary()->Dictionary<String, String>{
        let newUserDictionary = ["id":self.id,
                                 "bio":self.bio,
                                 "display":self.display,
                                 "email": self.email,
                                 "photo":self.photo,
                                 "username": self.username]
        return newUserDictionary
        
    }

    
}
