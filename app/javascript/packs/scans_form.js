window.onload = (event) => {
    var radio_buttons = document.querySelectorAll("[id^='scan_type_']");
    var scan_types = [...radio_buttons].map(function (radio_button) {
        return radio_button.id.replace('scan_type_', '');
    });

    radio_buttons.forEach(function (button) {
       button.addEventListener('click', function () {
	       console.log('Click!');
	       var current_scan_form = document.querySelector('.current_scan_form');
	       if (current_scan_form) {
			current_scan_form.classList.remove('current_scan_form');
			current_scan_form.classList.add('hidden');
	       }
	       var scan_form = document.querySelector(`#scan_form_${button.value}`);
	       scan_form.classList.remove('hidden');
	       scan_form.classList.add('current_scan_form');
       });
    });
};
