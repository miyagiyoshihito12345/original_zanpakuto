import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["loading", "submit"]
	load() {
		this.loadingTarget.classList.remove("disvisible");
		this.submitTarget.classList.add("disvisible");
		setTimeout(() => {
			form.submit();
		}, 100); // 0.1秒後にフォームを実際に送信
	}
}

document.getElementById('js-active-new').addEventListener('click', function() {
	        document.getElementById('js-active-edit').classList.remove('active');
	        document.getElementById('js-active-reiatu').classList.remove('active');
	        this.classList.add('active');
});

document.getElementById('js-active-edit').addEventListener('click', function() {
	        document.getElementById('js-active-new').classList.remove('active');
	        document.getElementById('js-active-reiatu').classList.remove('active');
	        this.classList.add('active');
});

document.getElementById('js-active-reiatu').addEventListener('click', function() {
	        document.getElementById('js-active-new').classList.remove('active');
	        document.getElementById('js-active-edit').classList.remove('active');
	        this.classList.add('active');
});

