import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["loading", "placeholder", "buttom", "bankaibuttom", "bankai"]
	load() {
		this.loadingTarget.classList.remove("disvisible");
		this.loadingTarget.classList.add("modal_ai");
		setTimeout(() => {
			form.submit();
		}, 100); // 0.1秒後にフォームを実際に送信
	}
	placeholder() {
		this.placeholderTarget.classList.add("placeholder-loading");
		this.buttomTarget.classList.add("disabled");
	}
	bankai() {
		this.bankaiTarget.classList.add("placeholder-loading");
		this.bankaibuttomTarget.classList.add("disabled");
	}
}

