import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = [ "link" ]
	twitter() {
		event.preventDefault();
		window.open(this.linkTarget.textContent, '_blank');
	}   
}

