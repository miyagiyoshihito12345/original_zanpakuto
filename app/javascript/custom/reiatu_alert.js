'use strict';

	const buttons = document.querySelectorAll('.button');

	buttons.forEach(button => {
		button.addEventListener('click', () => {
			alert("ログイン後にいいね機能が使えます");          
		});    
	}); 
