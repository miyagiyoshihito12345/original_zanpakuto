//= require jquery3
//= require popper
//= require bootstrap-sprockets

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
Turbo.session.drive = false
import "@hotwired/turbo-rails"
import "controllers"
'use strict';

const buttons = document.querySelectorAll('.before-button');

buttons.forEach(button => {
	button.addEventListener('click', () => {
		alert("ログイン後にいいね機能が使えます");              
	});    
});

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
