import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["text"]
	copy_text() {
		navigator.clipboard.writeText(this.textTarget.value).then(
			() => {
				alert("コピーしました。")
			},
			() => {
				alert("クリップボードにコピー出来ませんでした。")
			}
		)
	}   
}
