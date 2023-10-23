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
