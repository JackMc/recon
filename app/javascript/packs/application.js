// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.addEventListener("load", () => {
  document.querySelectorAll("span[data-time]").forEach((span) => {
    let utcTime = span.dataset.time;
    // Parse the date into our timezone, add it to innerText. For now, we just add the time unmodified.
    span.innerText = utcTime;
  });
});
