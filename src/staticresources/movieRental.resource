// Class to represent a row in the seat reservations grid
function Title(name, genre, featured) {
    var self = this;
    self.name = name;
    self.genre = genre;
    self.featured = featured;
}

// Overall viewmodel for this screen, along with initial state
function MoviesModel() {
    var self = this;

    // data from server
    self.allTitles = ko.observableArray();
	var json = {!titlesJSON};
	for(let title of json){
		self.allTitles.push(new Title(title.Name, title.Genre__c, title.Featured__c))
	}

	self.addTitle = function(){
		this.movieTitles.push(new Title("","", false));
	};
}
ko.applyBindings(new MoviesModel());