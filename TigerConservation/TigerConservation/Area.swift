/*
 Name : Ziang Xu
 COMP90055 Computing Project
 An IOS app for tiger conservation
 Login Name : ziangx
 Student ID : 748159
 */

//a struct of area
struct Area {
    var name : String
    var image : String
    var rating = ""

    //initial function
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

