import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = [ "link" ]
	fight() {
		//window.open(this.linkTarget.textContent);
		event.preventDefault(); 
		window.location.href = this.linkTarget.textContent
	}   
}

