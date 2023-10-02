//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
Turbo.session.drive = false
import "@hotwired/turbo-rails"
import "controllers"
'use strict';

const buttons = document.querySelectorAll('.button');

buttons.forEach(button => {
	button.addEventListener('click', () => {
		alert("ログイン後にいいね機能が使えます");              
	});    
});
