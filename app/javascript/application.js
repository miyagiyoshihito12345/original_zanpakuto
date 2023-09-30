//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('DOMContentLoaded', () => {
	console.log('DOMContentLoaded');

	const buttons = document.querySelectorAll('.button');

	buttons.forEach(button => {
		button.addEventListener('click', () => {
			alert("ログイン後にいいね機能が使えます");
		});
	});
});
