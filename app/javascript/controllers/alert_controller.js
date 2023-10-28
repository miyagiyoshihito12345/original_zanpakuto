import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["loading"]
	load() {
		this.loadingTarget.classList.remove("disvisible");
		this.loadingTarget.classList.add("modal_ai");
		setTimeout(() => {
			form.submit();
		}, 100); // 0.1秒後にフォームを実際に送信
	}
}

