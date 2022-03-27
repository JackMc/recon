window.onload = () => {
  document.querySelector("#only_up").addEventListener("click", (event) => {
    let button = event.target;
    let downProbes = document.querySelectorAll(".probe-down");

    if (button.checked) {
      downProbes.forEach((probe) => probe.classList.add("hidden"));
    }
    else {
      downProbes.forEach((probe) => probe.classList.remove("hidden"));
    }
  });
}
