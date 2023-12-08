import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = [ "link" ]
	tag() {
		event.preventDefault(); 
		window.location.href = this.linkTarget.textContent
	}   
}

