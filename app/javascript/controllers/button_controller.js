import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["new", "edit", "reiatu"]
	new_button() {
		this.editTarget.classList.remove("active");
		this.reiatuTarget.classList.remove("active");
		this.newTarget.classList.add("active");
	}   
	edit_button() {
		this.editTarget.classList.add("active");
		this.reiatuTarget.classList.remove("active");
		this.newTarget.classList.remove("active");
	}   
	reiatu_button() {
		this.editTarget.classList.remove("active");
		this.reiatuTarget.classList.add("active");
		this.newTarget.classList.remove("active");
	}   
	before_reiatu_button() {
		alert("ログイン後にいいね機能が使えます");                  
	}   
}

