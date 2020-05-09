import { safelyGetLocalStorage } from "./js/localStorageWrapper";
import { selectIds } from "./js/constants";
import "./main.scss";

const storage = safelyGetLocalStorage();

window.addEventListener("DOMContentLoaded", () => {
  selectIds.forEach((selectId) => {
    const selectInput = document.getElementById(selectId);
    const value = storage?.getItem(selectId) || selectInput.options[1].value;
    selectInput.value = value;
    selectInput.remove(0);

    if (storage) {
      // TODO chceck
      selectInput.addEventListener("change", (event) => {
        console.log("saving...");
        storage.setItem(selectId, event.target.value);
      });
    }
  });
});
