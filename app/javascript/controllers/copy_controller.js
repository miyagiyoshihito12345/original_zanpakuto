import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["text"]
	copy_text() {
		//this.loadingTarget.classList.remove("disvisible");
		//this.loadingTarget.classList.add("modal_ai");
		this.textTarget.select();
		document.execCommand("Copy");
		alert("コピーしました。")
	}   
}
